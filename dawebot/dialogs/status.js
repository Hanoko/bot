var builder = require('botbuilder');
var prompts = require('../prompts');
var mysql = require('../db');
module.exports = {
    addDialogs: addDialogs  
};

function addDialogs(bot) {
    bot.dialog('/status', [
        function (session) {
			mysql.getUserAnswers(session.message.user.id, function(rows){
				session.send(prompts.status1 + rows.rightAnswers + '\n\n' + prompts.status2 + rows.wrongAnswers + '\n\n'+ prompts.status3+((rows.rightAnswers/(rows.rightAnswers+rows.wrongAnswers))*100).toFixed(2) +'%' );
				session.endDialog();				
			});
        }
    ]);
}