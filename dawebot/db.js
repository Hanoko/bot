var mysql = require('mysql');
var settings = require('./settings');
var TB_TELEGRAM_UPDATE = 'telegram_update';
var TB_MESSAGE = 'message';
var TB_INLINE_QUERY = 'inline_query';
var TB_CALLBACK_QUERY = 'callback_query';
var TB_CHOSEN_INLINE_QUERY = 'chosen_inline_query';
var TB_USER = 'user';
var TB_CHAT = 'chat';
var TB_USER_CHAT = 'user_chat';
var TB_QUESTION = 'question';
var TB_QUIZ = 'quiz';
var TB_QUIZQUESTIONS = 'quizquestions';
var TB_ANSWER_HISTORY = 'answerhistory';
var TB_VOICE = 'voice';
var TB_VOICE_QUESTION = 'voice_question';
var TB_GRADES = 'grades';


var connection = mysql.createConnection({
  host     : settings.host,
  user     : settings.user,
  password : settings.password,
  database : settings.database
});


function run(sql,callback){

connection.query(sql, function(err, rows){
		if(err){
			throw err;
		}else{
			callback(null, rows);
		}
	})
}

   /**
     * Get Available Quizzes
     *
     * @param
     * @return
     */
function getAvailableQuizzes(callback){
	if(settings.logs)
	console.log("db.getAvailableQuizzes() started");
	var sql = "SELECT id, description, count(*) as numQuest FROM "+TB_QUIZQUESTIONS+" qq, "+TB_QUIZ+" q WHERE qq.quizId = q.id GROUP BY qq.quizId";
	connection.query(sql, function(err, rows){
		if(err){
			throw err;
		}else{
			if(settings.logs)
			console.log("db.getAvailableQuizzes() finished");
			callback(rows);
		}
	})
	
}

/**
     * Get Number of Questions
     *
     * @param int quiz_id
     * @return int number of questions in this quiz
     */
function getNumQuest(quiz,callback){
	var post= {quizId: quiz};
	var sql = "SELECT COUNT(*) as numQuest FROM '"+TB_QUIZQUESTIONS+"' where quizId=?";
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
		}else{
			callback(rows[0].numQuest);
		}
	})
	
}

  /**
     * Save Gamer
     *
     * @param Gamer the gamer
     *
     * @return null (no hay errores) o el texto del error
     */
function saveGamer(gamer, callback){
	if(!gamer){
		if(settings.logs)
		console.log("Method saveGamer (db.js): gamer not set")
	}else{
		var post = gamer;
		var sql = "UPDATE "+TB_USER_CHAT+" SET currentQuestion=? , rightAnswers=? , wrongAnswers=? , currentQuiz=? WHERE "+TB_USER_CHAT+".chat_id=? AND "+TB_USER_CHAT+".user_id=?"; // AND '. TB_USERS_CHATS .'.'currentQuestion'=:currentQuestion';
		connection.query(sql, post, function(err, result){
			if(err){
				if(settings.logs)
				console.log(err);
				throw err;
			}else{
				//Gamer saved correctly
				if(settings.logs)
				console.log("db.saveGamer() finished");
				callback(result);
			}
		});
	}
}

/**
     * Save Answer
     *
     * @param array question, user, result (right, wrong)
     *
     * @return null (no hay errores) o el texto del error
     */
function saveAnswer(params, callback){
	if(!params){
		if(settings.logs)
		console.log("Method saveAnswer (db.js): params not set")
	}else{
		var post = params;
		var sql = "INSERT INTO "+TB_ANSWER_HISTORY+" SET question=? ,quiz=? ,user=? ,result=?,data=NOW()";
		connection.query(sql, post, function(err, result){
			if(err){
				throw err;
				if(settings.logs)
				console.log(err);
			}else{
				//Answer saved correctly
				if(settings.logs)
				console.log("db.saveAnswer() finished");
				callback(result);
			}
		})
	}
}

 /**
     * Find Gamer
     *
     * @param int chat_id
     *
     * @return Gamer the gamer
     */
function findGamer(chat_id,callback){
	var post= [chat_id];
	var sql = "SELECT * ,"+TB_USER_CHAT+".chat_id AS chat_id,"+TB_USER+".username AS user_name FROM "+TB_USER_CHAT+" LEFT JOIN "+TB_USER+" ON "+TB_USER_CHAT+".user_id="+TB_USER+".id WHERE "+TB_USER_CHAT+".user_id=?";
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
		}else{
			if(settings.logs)
			console.log("db.findGamer() finished");
			callback(rows);
		}
	});	
}


   /**
     * Get Current Question
     *
     * @param int question_id
     * @param int quiz_id
     * @param int user_id
     * @return Gamer the gamer
     */

function getCurrentQuestion(question_pos, user_id, quiz_id, callback){
	if(!question_pos || !user_id){
		if(settings.logs)
		console.log("Method getCurrentQuestion (db.js): params not set");
	}else{
		var post= [user_id,quiz_id,question_pos,quiz_id];
		var sql = "SELECT * ,"+
				TB_QUIZQUESTIONS+".questionId AS current_question_id,"+
                TB_USER+".username AS user_name "+
                "FROM "+TB_USER_CHAT+", "+TB_USER+","+TB_QUIZQUESTIONS+","+TB_QUESTION+
                " WHERE "+TB_USER_CHAT+".user_id="+TB_USER+".id AND "+
                      TB_USER_CHAT+".user_id=? AND "+
                      TB_USER_CHAT+".currentQuiz=?  AND "+
                      TB_USER_CHAT+".currentQuestion=?  AND "+
                      TB_USER_CHAT+".currentQuestion="+TB_QUIZQUESTIONS+".questionPos AND "+
                      TB_QUESTION+".id="+TB_QUIZQUESTIONS+".questionId AND "+
                      TB_QUIZQUESTIONS+".quizId=?";
		connection.query(sql, post, function(err, rows){
			if(err){
				if(settings.logs)
				console.log(err);
				throw err;
			}else{
				callback(rows);
			}
		});
	}
	
}

   /**
     * Get Question
     *
     * @param int question_id
     * @param int quiz_id
     * @return Question Text, Posible Resp, Resp OK
     */
/*function getQuestion(question_id){
	if(!question_id){
		if(settings.logs)
		console.log("Method getQuestion (db.js): question_id not set");
	}else{
		var post= {questionId: question_id};
		var sql = "SELECT * "+
                "FROM '"+TB_QUESTION+
                "' WHERE '"+TB_QUESTION6+"'.'id'=?";
		connection.query(sql, post, function(err, rows){
			if(err){
				throw err;
			}else{
				callback(rows);
			}
		})
	}
		
}*/

function createGamer(post, chat_id, channel_id, callback){
	if(settings.logs)
	console.log("db.createGamer() started");
	if(!post){
		if(settings.logs)
		console.log("Method creategamer (db.js): post not set")
	}else{
		var sql = "INSERT INTO "+TB_USER+
                "("+
                "id, username, first_name, last_name, created_at, updated_at"+
                ")"+
                "VALUES ("+
                "?, ?, ?, ?, NOW(), NOW()"+
                ")"+
                "ON DUPLICATE KEY UPDATE username =?, first_name=?,"+
                "last_name=?, updated_at=NOW()";
		connection.query(sql, post, function(err, done){
			if(err){
				if(settings.logs)
				console.log(err);
				throw err;
			}else{
				//Gamer saved correctly
				createUserChat(post[0], chat_id, channel_id, function(result){
					if(settings.logs)
					console.log("db.createGamer() finished");
					callback(done);
				});
				
			}
		});
	}
}

function createUserChat(user_id, chat_id, channel_id, callback){
	if(settings.logs)
	console.log("db.createUserChat() started");
	var post = [user_id, chat_id, channel_id];
	var sql= "INSERT IGNORE INTO "+TB_USER_CHAT+
                    "("+
                    " user_id, chat_id, channel_id "+
                    ")"+
                    "VALUES ("+
                    "?, ?, ?"+
                    ")";
					
					
	connection.query(sql, post, function(err, result){
		if(err){
			if(settings.logs)
			console.log(err);
			throw err;
		}else{
			//Gamer saved correctly
			if(settings.logs)
			console.log("db.createUserChat() finished");
			callback(result);
		}
	});
}

function insertMessage(message,callback){
	if(settings.logs)
	console.log("db.insertMessage() started");
	//First create chat and then insert the message.
	createChat(message, function(result){
		var post;
		if(message.timestamp){			
			post = [message.address.user.id, message.address.conversation.id, message.text];
			//If timestamp exist is the user who send the message
		}else{
			//If not is the bot
			post = [message.address.bot.id, message.address.conversation.id, message.text];
		}
		var sql="INSERT INTO "+TB_MESSAGE+
            " ("+
            " user_id, date, chat_id,text "+
            ") "+
            "VALUES ("+
            "?,NOW(),?,?)";
		connection.query(sql, post, function(err, done){
			if(err){
				if(settings.logs)
				console.log(err);
				throw err;
			}else{
				//Inserted message
				if(settings.logs)
				console.log("db.insertMessage() finished");
				callback(done);
			}
		});
	});         
 }

function createChat(message,callback){
	if(settings.logs)
	console.log("db.createChat() started");	
	var sql = "INSERT INTO "+TB_CHAT+
                " ("+
                "id, type, title, created_at ,updated_at, old_id"+
                ") "+
                "VALUES ("+
                "?, ?, null ,NOW(), NOW(), null"+
                ")"+
                "ON DUPLICATE KEY UPDATE type=?, updated_at=NOW()";
	var post;
	if(message.address.conversation.isGroup){
		post = [message.address.conversation.id, "supergroup", "supergroup"]; 
	}else{
		post = [message.address.conversation.id, "private", "private"]; 
	}
	connection.query(sql, post, function(err, done){
			if(err){
				if(settings.logs)
				console.log(err);
				throw err;
			}else{
				//Created chat
				if(message.timestamp){
					var name;
					
					
					if(message.source=="telegram"){
						if(message.sourceEvent.message){
							name = message.sourceEvent.message.chat.first_name;
						}else{
							name = message.sourceEvent.callback_query.message.chat.first_name;
						}
					}else{
						name = message.address.user.name;
					}
					var data = [message.address.user.id, name,name, null,name,name,null];				
					createGamer(data, message.address.conversation.id, message.address.channelId,  function(result){
						if(settings.logs)
						console.log("db.createChat(user) finished");
						callback(done);		
					});		
				}else{
					var data = [message.address.bot.id, message.address.bot.name,message.address.bot.name, null,message.address.bot.name,message.address.bot.name,null];				
					createGamer(data, message.address.conversation.id, message.address.channelId, function(result){
						if(settings.logs)
						console.log("db.createChat(bot) finished");
						callback(done);		
					});	
				}					
			}
		});
	
}

function getNumQuest(quiz, callback){
	if(settings.logs)
	console.log("db.getNumQuest() started");
	var post = [quiz];
	var sql = "SELECT COUNT(*) as numQuest "+
				"FROM "+TB_QUIZQUESTIONS+" where quizId=?";
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getNumQuest() finished");
			callback(rows[0].numQuest);
		}
	})
	
}

function checkVoice(callback){
	if(settings.logs)
	console.log("db.checkVoice() started");
	var sql = "SELECT *"+
				"FROM "+TB_VOICE+" where sent=0";
	connection.query(sql, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.checkVoice() finished");
			callback(rows);
		}
	})
}

function checkGrades(callback){
	if(settings.logs)
	console.log("db.checkGrades() started");
	var sql = "SELECT grades.user_id, grades.voice_id FROM "+TB_GRADES+" LEFT JOIN "+TB_VOICE+" ON "+TB_GRADES+".voice_id="+TB_VOICE+".voice_id where "+TB_GRADES+".sent=0 and "+TB_VOICE+".voice IS NOT null;";
	connection.query(sql, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.checkGrades() finished");
			callback(rows);
		}
	})
}

function getAddress(user_id,callback){
	if(settings.logs)
	console.log("db.getAddress() started");
	var sql = "SELECT chat_id, channel_id "+
				"FROM "+TB_USER_CHAT+" WHERE user_id=?";
	var post = [user_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			var address= {	channelId: rows[0].channel_id,
							user: { id: user_id },
							conversation: {id: rows[0].chat_id }
						 }
			if (channel_id='telegram'){
				address.bot = settings.botTelegram.bot;
				address.serviceUrl = settings.botTelegram.serviceUrl;
				address.useAuth = settings.botTelegram.useAuth;
			}
			if(settings.logs)
			console.log("db.getAddress() finished");
			callback(address);
		}
	})
}

function voiceNotificationSent(voice_id,callback){
	if(settings.logs)
	console.log("db.voiceNotificationSent() started");
	var post = [voice_id];
	var sql = "UPDATE "+TB_VOICE+" SET sent=1 WHERE voice_id=?";
	connection.query(sql, post, function(err, result){
		if(err){
			if(settings.logs)
			console.log(err);
			throw err;
		}else{
			if(settings.logs)
			console.log("db.voiceNotificationSent() finished");
			callback();
		}
	});
}
function gradeNotificationSent(voice_id, user_id, callback){
	if(settings.logs)
	console.log("db.gradeNotificationSent() started");
	var post = [voice_id,user_id];
	var sql = "UPDATE "+TB_GRADES+" SET sent=1 WHERE voice_id=? AND user_id=?";
	connection.query(sql, post, function(err, result){
		if(err){
			if(settings.logs)
			console.log(err);
			throw err;
		}else{
			if(settings.logs)
			console.log("db.gradeNotificationSent() finished");
			callback();
		}
	});
}

/*function getVoiceQuestion(user_id, callback){
	if(settings.logs)
	console.log("db.getVoiceQuestion started");
	var sql = "SELECT * "+
				"FROM "+TB_VOICE_QUESTION+" WHERE question_id=(SELECT question_id FROM "+TB_VOICE+" WHERE user_id=? AND voice IS null LIMIT 1)";
	var post = [user_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getVoiceQuestion() finished");
			callback(rows[0]);
		}
	})
}

function getGradeQuestion(user_id, callback){
	if(settings.logs)
	console.log("db.getGradeQuestion started");
	var sql = "SELECT * "+
				"FROM "+TB_VOICE_QUESTION+" WHERE question_id=(SELECT question_id FROM "+TB_VOICE+" WHERE voice_id=(SELECT voice_id FROM "+TB_GRADES+" user_id=? AND grade IS null LIMIT 1) AND voice IS NOT null)";
	var post = [user_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getGradeQuestion() finished");
			callback(rows[0]);
		}
	});
}*/

function saveVoice(voice_id, audio, callback){
	if(settings.logs)
	console.log("db.saveVoice started");
	var sql = "UPDATE "+ TB_VOICE+
				" SET voice=? WHERE voice_id=?";
	var post = [audio, voice_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			/*var post2 = [voice_id];
			var sql2 = "UPDATE "+TB_GRADES+" SET answered=1 WHERE voice_id=?";
			connection.query(sql2, post2, function(err, result){
			if(err){
				if(settings.logs)
				console.log(err);
				throw err;
			}else{*/
				if(settings.logs)
				console.log("db.saveVoice() finished");
				callback();
			/*}
			});*/
		}
	});
}

function getQuestions(user_id, callback){
	if(settings.logs)
	console.log("db.getQuestions started");
	var sql = "SELECT *,(SELECT COUNT(*) FROM "+TB_VOICE+" WHERE voice IS null AND user_id=?) AS count FROM "+TB_VOICE+" LEFT JOIN "+TB_VOICE_QUESTION+" ON "+TB_VOICE+".question_id="+TB_VOICE_QUESTION+".question_id WHERE "+TB_VOICE+".voice is null AND "+TB_VOICE+".user_id=?";
	var post = [user_id, user_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getQuestions() finished");
			callback(rows);
		}
	});
}

function getGradeQuestions(user_id, callback){
	if(settings.logs)
	console.log("db.getGradeQuestions started");
	var sql = "SELECT "+TB_GRADES+".voice_id, texto, (SELECT COUNT(*) FROM "+TB_GRADES+" WHERE grade IS null AND user_id=?) AS count FROM "+TB_GRADES+" LEFT JOIN "+TB_VOICE+" ON "+TB_VOICE+".voice_id="+TB_GRADES+".voice_id LEFT JOIN "+TB_VOICE_QUESTION+" ON "+TB_VOICE+".question_id="+TB_VOICE_QUESTION+".question_id WHERE "+TB_GRADES+".grade IS null AND "+TB_GRADES+".user_id=? AND "+TB_VOICE+".voice IS NOT NULL";
	var post = [user_id, user_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getGradeQuestions() finished");
			callback(rows);
		}
	});
}

function getVoice(voice_id, callback){
	if(settings.logs)
	console.log("db.getVoice started");
	var sql = "SELECT voice FROM "+TB_VOICE+" WHERE voice_id=?";
	var post = [voice_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getVoice() finished");
			callback(rows[0]);
		}
	});	
}

function saveGrade(grade, voice_id, user_id, callback){
	if(settings.logs)
	console.log("db.saveGrade() started");
	var post = [grade,voice_id,user_id];
	var sql = "UPDATE "+TB_GRADES+" SET grade=? WHERE voice_id=? AND user_id=?";
	connection.query(sql, post, function(err, result){
		if(err){
			if(settings.logs)
			console.log(err);
			throw err;
		}else{
			if(settings.logs)
			console.log("db.saveGrade() finished");
			callback();
		}
	});
}

function getUserAnswers(user_id, callback){
	if(settings.logs)
	console.log("db.getUserAnswers started");
	var sql = "SELECT rightAnswers, wrongAnswers  FROM "+TB_USER_CHAT+" WHERE user_id=?";
	var post = [user_id];
	connection.query(sql, post, function(err, rows){
		if(err){
			throw err;
			if(settings.logs)
			console.log(err);
		}else{
			if(settings.logs)
			console.log("db.getUserAnswers() finished");
			callback(rows[0]);
		}
	});		
}
// Export list of functions
module.exports = {
	run: run,
	getAvailableQuizzes: getAvailableQuizzes,
	getNumQuest: getNumQuest,
	saveGamer: saveGamer,
	findGamer: findGamer,
	getCurrentQuestion: getCurrentQuestion,
	createChat: createChat,
	insertMessage: insertMessage,
	getNumQuest: getNumQuest,
	saveAnswer: saveAnswer,
	checkVoice: checkVoice,
	checkGrades: checkGrades,
	getAddress: getAddress,
	voiceNotificationSent: voiceNotificationSent,
	gradeNotificationSent: gradeNotificationSent,
	saveVoice: saveVoice,
	getQuestions: getQuestions,
	getGradeQuestions: getGradeQuestions,
	getVoice: getVoice,
	saveGrade: saveGrade,
	getUserAnswers: getUserAnswers
};
