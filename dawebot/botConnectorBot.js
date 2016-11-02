/*-----------------------------------------------------------------------------
A bot for testing various features of the framework.  See the README.md file 
for usage instructions.
-----------------------------------------------------------------------------*/

var restify = require('restify');
var builder = require('botbuilder');
var mysql = require('./db');
var fs = require('fs')
var cron = require('node-cron');
var test = require('./dialogs/test');
var status = require('./dialogs/status');
var voice = require('./dialogs/voice');
var evaluate = require('./dialogs/evaluate');
var prompts = require('./prompts');
var settings = require('./settings');

var https_options = {
  key: fs.readFileSync(settings.key),
  certificate: fs.readFileSync(settings.certificate)
};

var connector = new builder.ChatConnector({
    appId: process.env.MICROSOFT_APP_ID,
    appPassword: process.env.MICROSOFT_APP_PASSWORD ,
	groupWelcomeMessage: 'Group Welcome Message Works!',
    userWelcomeMessage: 'User Welcome Message Works!',
    goodbyeMessage: 'Goodbye Message Works!'
});

var bot = new builder.UniversalBot(connector);
var intents = new builder.IntentDialog();
bot.dialog('/', intents);
intents.matches(/^hi|hello|help|Hi|Hello|Help|\/hi|\/hello|\/help/, builder.DialogAction.send(prompts.helpMessage));
intents.matches(/^test|Test|\/test/, '/test');
intents.matches(/^status|Status|\/status/, '/status');
intents.matches(/^voice|Voice|\/voice/, '/voice');
intents.matches(/^evaluate|Evaluate|\/evaluate/, '/evaluate');
intents.matches(/^quit|Quit|\/quit/, builder.DialogAction.endDialog(prompts.goodbye));
intents.onDefault(builder.DialogAction.send(prompts.unknown));

test.addDialogs(bot);
status.addDialogs(bot);
voice.addDialogs(bot);
evaluate.addDialogs(bot);

bot.use({
    botbuilder: function (session, next) {

		mysql.insertMessage(session.message, function(result){
			next();
		})	
    },
	send: function(event,next) {
		mysql.insertMessage(event, function(result){
			next();
		})	
	}
});

var voiceAnswer = cron.schedule('0 * * * * *', function(){
	mysql.checkVoice(function(rows){
	rows.forEach(function(row,index){
		var voice = rows[index];
		mysql.getAddress(voice.user_id, function(address){
			var message ={};
			message.address = address;
			message.text = prompts.voicePrompt;
			message.type = 'message';
			bot.send(message, function(){
				mysql.voiceNotificationSent(voice.voice_id,function(){
				if(settings.logs)
				console.log("cronJob finished for user "+ voice.user_id);
				
				});
			});		
		});
	});
	});
});

var voiceGrades = cron.schedule('30 * * * * *', function(){
	mysql.checkGrades(function(rows){
	rows.forEach(function(row,index){
		var grades = rows[index];
		mysql.getAddress(grades.user_id, function(address){
			var message ={};
			message.address = address;
			message.text = prompts.evaluatePrompt;
			message.type = 'message';
			bot.send(message, function(){
				mysql.gradeNotificationSent(grades.voice_id, grades.user_id, function(){
					if(settings.logs)
					console.log("cronJob finished for user "+ grades.user_id+" and voice id "+ grades.voice_id);
				});
			});
		});
	});
	});
});
voiceAnswer.start;
voiceGrades.start;
const https_server = restify.createServer(https_options);
https_server.listen(process.env.PORT || 3978, function () {
   console.log('%s listening to %s', https_server.name, https_server.url); 
});

https_server.post('/api/messages', connector.listen());
