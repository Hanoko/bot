var user_id;
var chat_id;
var currentQuestion;
var currentQuestionAnswer;
var currentQuiz;
var rightAnswers;
var wrongAnswers;
var mysql = require('./db');
var settings = require('./settings');

function setCurrentQuiz(quiz, callback){
	currentQuiz = quiz;
	save(function(){
		if(settings.logs)
		console.log("gamer.setCurrentQuiz() finished");
		callback();
	});
}
function save(callback){
	var post = [currentQuestion, rightAnswers, wrongAnswers, currentQuiz, chat_id, user_id];
	mysql.saveGamer(post,function(result){
			//Gamer saved correctly	
			if(settings.logs)
			console.log("gamer.save() finished");
			callback();
	});
}

function findOrCreateGamer(data,callback){
	mysql.findGamer(data.user_id,function(rows){
		if(rows.length > 0){
			//Gamer already exists in DB
			user_id = data.user_id;
			chat_id = data.chat_id;
			currentQuestion = 1;
			rightAnswers = rows[0].rightAnswers;
			wrongAnswers = rows[0].wrongAnswers;
			currentQuiz = data.quiz;	
			if(settings.logs)
			console.log("gamer.findOrCreateGamer() finished (gamer already existed)");
			callback();			
		}else{
			//Gamer does not exist in DB
			user_id = data.user_id;
			chat_id = data.chat_id;
			currentQuestion = 1;
			rightAnswers = 0;
			wrongAnswers = 0;
			currentQuiz = data.quiz;
			createGamer(data,function(){
				save(function(){
					if(settings.logs)
					console.log("gamer.findOrCreateGamer() finished (gamer didn't exist)");
					callback();
				});
			});
		}
		
	});
	
}

function createGamer(data,callback){
	var post = [user_id, data.username , data.name, null, data.username , data.name, null];
	mysql.createGamer(post,data.chat_id, function(result){
			//Gamer saved correctly	
			if(settings.logs)
			console.log("gamer.createGamer() finished");
			callback();
	});
	
}

function getCurrentQuestion(callback){
	mysql.getCurrentQuestion(currentQuestion,user_id, currentQuiz,function(result){
		currentQuestionAnswer = result[0]["respOK"];
		if(settings.logs)
		console.log("gamer.getCurrentQuestion() finished");
		callback(result);
	});
}

function getCurrentQuestionAnswer(callback){
	if(settings.logs)
	console.log("gamer.getCurrentQuestionAnswer() finished");
	callback(currentQuestionAnswer);
}

function saveAnswer(correct, callback){
	var result;
	if(correct){
		rightAnswers++;
		result = "right";
	}else{
		wrongAnswers++;
		result = "wrong";
	}
	var post = [currentQuestion, currentQuiz,user_id, result];
	mysql.saveAnswer(post, function(){
		mysql.getNumQuest(currentQuiz,function(numQuest){
			if(currentQuestion >= numQuest){
				currentQuestion = 1
			}else{
				currentQuestion++;
			}
			save(function(){
				if(settings.logs)
				console.log("gamer.saveAnswer() finished");
				callback();
			});
		});
	});
}

module.exports = {
	save: save,
	findOrCreateGamer: findOrCreateGamer,
	getCurrentQuestion: getCurrentQuestion,
	setCurrentQuiz: setCurrentQuiz,
	getCurrentQuestionAnswer: getCurrentQuestionAnswer,
	saveAnswer: saveAnswer
}