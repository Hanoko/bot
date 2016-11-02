<!DOCTYPE html>
<html lang="es">

<head>
<meta charset="utf-8">
<link rel="shortcut icon" href="favicon.png" type="image/x-icon"> 
<title>DAWEB</title>
<link href="master.css" rel="stylesheet"  />
</head>

<body>
<?php 
    include('menu.html');
	include('db.php');
	$question = $_POST['question'];
	$evaluated = $_POST['evaluated'];
	$deadline = $_POST['deadline'];
	$sql = $conn->prepare("INSERT INTO voice_question (texto,deadline) VALUES (:question, :deadline)");
	$sql->bindParam(':question', $question);
	$sql->bindParam(':deadline', $deadline);
	$sql->execute();
	$question_id = $conn->lastInsertId();
	$voice = $conn->prepare("INSERT INTO voice (user_id, question_id) VALUES(:user, :question)");
	$voice->bindParam(':user', $user);
	$voice->bindParam(':question', $question_id);
	$grade = $conn->prepare("INSERT INTO grades (voice_id, user_id) VALUES(:voiceId, :evaluator)");
	$grade->bindParam(':voiceId', $voice_id);
	$grade->bindParam(':evaluator', $evaluator);
	foreach ($evaluated as $user) {
		$voice->execute();
		$voice_id = $conn->lastInsertId();
		$evaluators = $_POST['evaluators'.$user];
		foreach($evaluators as $evaluator){
			$grade->execute();
		}
	}
?>
<p>Pregunta añadida</p>
</body>
</html>