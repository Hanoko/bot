var builder = require('botbuilder');
var prompts = require('../prompts');
var mysql = require('../db');
var settings = require('../settings');
var request = require('request');
module.exports = {
    addDialogs: addDialogs  
};

function addDialogs(bot) {
    bot.dialog('/evaluate', [
        function (session) {
			var options = {};
			mysql.getGradeQuestions(session.message.user.id,function(rows){
				if(rows.length==0){
					session.endDialog(prompts.noEvaluate);
				}else{
					session.dialogData.optionLength = rows.length;
					session.dialogData.voice_id = [];
					session.dialogData.texto = [];
					var string = prompts.evaluatePrompt1+" "+rows[0].count+" "+prompts.evaluatePrompt2+"\n";
					rows[rows.length] = 1;
					rows.forEach(function(row,index){
						if(index<rows.length-1){
							string += (index+1)+". "+row.texto+"\n";
							options[(index+1)] = row.voice_id;
							session.dialogData.voice_id[index] = row.voice_id;
							session.dialogData.texto[index] = row.texto;
						}else{
							options[prompts.later] = rows.length;	
							builder.Prompts.choice(session, string, options);	
						}					
					});
				}
			});
        },
		function(session, results){
			if(results.response.index<session.dialogData.optionLength){
				session.dialogData.voice_id = session.dialogData.voice_id[results.response.index];
				mysql.getVoice(session.dialogData.voice_id, function(voice){
					var message = {};
					message.address = session.message.address;
					message.type = 'message';
					message.text = prompts.evaluateAnswer+"\n\n"+session.dialogData.texto[results.response.index];
					message.attachments = [{contentUrl: voice.voice, contentType:'audio/ogg'}];
					builder.Prompts.number(session, message);	
				});					
			}else{
				session.endDialog(prompts.evaluateCanceled);
			}
		},
		function(session, results){
			if(results.response>=0 && results.response<=10){
				mysql.saveGrade(results.response, session.dialogData.voice_id, session.message.user.id, function(){
					session.endDialog(prompts.evaluateFinished);
				});
			}else{
				session.endDialog(prompts.evaluateWrong);
			}
			
		}
    ]);
}