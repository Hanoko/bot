var builder = require('botbuilder');
var prompts = require('../prompts');
var mysql = require('../db');
var settings = require('../settings');
var answers = settings.answers;
var tests = [];
var titles= {};
mysql.getAvailableQuizzes(function(test) {
	tests = test;
	for(index = 0; index < tests.length; index++) {
		titles[tests[index].description +" ("+ tests[index].numQuest+ ")"] = tests[index].id;
	}
		
});
var gamer = require('../gamer');
module.exports = {
    addDialogs: addDialogs  
};

function addDialogs(bot) {
    bot.dialog('/test', [
        function (session, args, next) {
            // See if the user specified a valid test to run by name.
            var match;
            var utterance = session.message.text;
            var brk = utterance.indexOf(' ');
            var name = brk > 0 && brk < utterance.length ? utterance.substr(brk + 1).trim() : null;
            if (name) {
				for(index = 0; index < tests.length; index++) {					
					if(tests[index].id==name){
						match = name;
						break;
					}
				}       
            }
            
            // Prompt for test if no valid name specified.
			if(utterance=="quit"){
				session.endDialog(prompts.canceled);
			}else if (!match) {
				//var options = {listStyle: builder.ListStyle.button};
                builder.Prompts.choice(session, prompts.runPrompt, titles);
			}else {
                next({ response: match });
            }
        },
        function (session, results) {
            // Run the test unless the user canceled.
            if (results.response) {
				if(results.response.entity){
					session.dialogData.test = titles[results.response.entity];
				}else{
					session.dialogData.test = results.response;
				}
				var data = {user_id:session.message.user.id, chat_id: session.message.address.conversation.id, quiz: session.dialogData.test,name: session.message.user.name, username: session.message.user.name};
				gamer.findOrCreateGamer(data,function(){
					session.beginDialog("/preguntas",session.dialogData.test);
				});
				
            } else {
                session.endDialog(prompts.canceled);
            }
        },
        function (session) {
            // Test completed execution.
            session.endDialog();
        }
    ]);
	
	bot.dialog('/preguntas', [
    function (session, args) {
        // Ask questions
		if(args){
			session.dialogData.quiz = args;
			gamer.setCurrentQuiz(session.dialogData.quiz, function(){
				gamer.getCurrentQuestion(function(row){
					session.dialogData.question = row[0];
					var question = row[0]["texto"];
					var options = {};
					for(index = 1; index <= answers.length; index++){
						if(row[0]["resp"+index]){
							question += "\n\n"+answers[index-1]+") "+row[0]["resp"+index];
							options[answers[index-1]] = index;
						}else{
							break;
						}
					}
					builder.Prompts.choice(session, question, options);
				});
			});

		}else{
			session.endDialog(prompts.canceled);
		}
    },
    function (session, results) {
		var correct;
		var texto;
		gamer.getCurrentQuestionAnswer(function(answer){
			if(answer==results.response.index+1){
				texto = prompts.right;
				correct = true;
			}else{
				texto = prompts.wrong+answers[answer-1];
				correct = false;
			}
			gamer.saveAnswer(correct, function(){
				var options = {};
				options[prompts.why] = 0;
				options[prompts.whynot] = 1;
				options[prompts.next] = 2;
				options[prompts.quit] = 3;
				builder.Prompts.choice(session, texto, options);
			});
		});

    },
	function (session, results, next){
		var texto;
		var options = {};
		options[prompts.next] = 0;
		options[prompts.quit] = 1;
		if(results.response.index==0){
			if(session.dialogData.question.why){
				texto = session.dialogData.question.why;
			}else{
				texto = prompts.noWhy;
			}
			builder.Prompts.choice(session,texto,options)
		}else if(results.response.index==1){
			if(session.dialogData.question.whynot){
				texto = session.dialogData.question.why;
			}else{
				texto = prompts.noWhyNot;
			}
			builder.Prompts.choice(session,texto,options)
		}else if(results.response.index==2){
			next();
		}else{
			session.endDialog(prompts.canceled);
		}
	},
	function(session,results){
		if(session.message.text==prompts.next){
			quiz = session.dialogData.quiz;
			session.endDialog();
			session.dialogData.quiz = quiz;
			session.beginDialog("/preguntas",session.dialogData.quiz);
		}else{
			session.endDialog(prompts.canceled);
		}
	}
    ]);
}
