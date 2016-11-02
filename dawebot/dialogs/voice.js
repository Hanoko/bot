var builder = require('botbuilder');
var prompts = require('../prompts');
var mysql = require('../db');
var settings = require('../settings');
var request = require('request');
module.exports = {
    addDialogs: addDialogs  
};

function addDialogs(bot) {
    bot.dialog('/voice', [
        function (session) {
			var options = {};
			mysql.getQuestions(session.message.user.id,function(rows){
				if(rows.length==0){
					session.endDialog(prompts.noVoice);
				}else{
					session.dialogData.optionLength = rows.length;
					session.dialogData.rows = rows;
					var string = prompts.voicePrompt1+" "+rows[0].count+" "+prompts.voicePrompt2+"\n";
					rows[rows.length] = 1;
					rows.forEach(function(row,index){
						if(index<rows.length-1){
								var now = new Date();
								if(now<=row.deadline){
									string += (index+1)+". "+row.texto+"\n";
									options[(index+1)] = row.voice_id;
								}
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
				session.dialogData.voice_id = session.dialogData.rows[results.response.index].voice_id;
				var string = prompts.voiceAnswer+"\n\n";
				string += session.dialogData.rows[results.response.index].texto;
				builder.Prompts.attachment(session, string);								
			}else{
				session.endDialog(prompts.voiceCanceled);
			}
		},
		function(session, results){
			mysql.saveVoice(session.dialogData.voice_id, results.response[0].contentUrl, function(){
				session.endDialog(prompts.voiceFinished);
			});
		}
    ]);
}