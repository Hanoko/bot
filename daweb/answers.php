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
?>
<div class="center">
<table id="preguntas">
  <tr>
    <th id="tableTitle">Pregunta</th>
    <th>Fecha límite</th>
  </tr>
  <?php
	$sql = "SELECT * FROM voice_question";
	$color = "white";
	foreach ($conn->query($sql) as $question) {
		if($color =="white"){
			$color ="grey";
		}else{
			$color ="white";
		}
		echo '<tr class="clickable '.$color.'" onclick="document.location=\'voice.php?id='.$question['question_id'].'\'"><td >'.$question['texto'].'</td><td class="deadline">'.$question['deadline'].'</td></tr>';

	}
	?>
</table>
</div>
</body>
</html>