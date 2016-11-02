<!DOCTYPE html>
<html lang="es">

<head>
<meta charset="utf-8">
<link rel="shortcut icon" href="favicon.png" type="image/x-icon"> 
<title>DAWEB</title>
<link href="master.css" rel="stylesheet"  />
<link rel="stylesheet" type="text/css" href="jquery.datetimepicker.css"/ >
<script src="jquery.js"></script>
<script src="build/jquery.datetimepicker.full.min.js"></script>
</head>

<body>
<?php 
    include('menu.html');
	include('db.php');
?>
<div class="center">
<?php
	$question = $_GET['id'];
	$sql = $conn->prepare("SELECT texto FROM voice_question WHERE question_id=:question");
	$sql->bindParam(':question',$question);
	$sql->execute();
	foreach ($sql->fetchAll() as $row){
		echo "<h3>".$row['texto']."</h3>";
	}
?>
	<div class="left">
	<h4>Respuestas:</h4>
	</div>
	<div class="right">
		<h4>Evaluaciones:</h4>
	</div>
	<div class="users">
		<?php

		$sql = "SELECT voice.voice , voice.voice_id, user.first_name,user.last_name, user.username  FROM voice LEFT JOIN user ON user.id=voice.user_id WHERE question_id='".$question."'";
		foreach ($conn->query($sql) as $voice) {
			echo '<div class="todos" ><div class="evaluados" id="grades">';
			$sql = "SELECT grades.grade, user.first_name,user.last_name, user.username FROM grades LEFT JOIN user ON user.id=grades.user_id WHERE voice_id='".$voice['voice_id']."'";
			foreach ($conn->query($sql) as $grade) {
				if($grade['grade']!=null){
					echo '<p class="evaluator">  '.$grade['first_name'].' '.$grade['last_name'].' ('.$grade['username'].') - '.$grade['grade'].'</p>';
				}else{
					echo '<p class="evaluator">  '.$grade['first_name'].' '.$grade['last_name'].' ('.$grade['username'].') - Sin evaluar</p>';

				}
			}
			if($voice['voice']!=null){
				echo '</div><p>'.$voice['first_name'].' '.$voice['last_name'].' ('.$voice['username'].')</p>  <audio controls><source src="'.$voice['voice'].'" type="audio/ogg">Tu navegador no es compatible. Descarga la <a href="'.$voice['voice'].'"> nota de audio</a></audio> </div><br>';
			}else{
				echo '</div><p>'.$voice['first_name'].' '.$voice['last_name'].' ('.$voice['username'].') aún no ha respondido a esta pregunta</p> </div><br>';

			}
		}
		?>
	</div>
</div>
</form>
<script>
jQuery.datetimepicker.setLocale('es');
jQuery('#datetimepicker').datetimepicker({
	minDate:'-1970/01/02',
	format:'Y-m-d H:i'
});
 function checkAll(ele) {
     var checkboxes = document.getElementsByTagName('input');
     if (ele.checked) {
		 var elems = document.getElementsByClassName('evaluados');
		 for(var i = 0; i < elems.length; i++) {
			elems[i].style.display= 'block';
		}
         for (var i = 0; i < checkboxes.length; i++) {
             if (checkboxes[i].type == 'checkbox') {
                 checkboxes[i].checked = true;
             }
         }
     } else {
		var elems = document.getElementsByClassName('evaluados');
		 for(var i = 0; i < elems.length; i++) {
			elems[i].style.display= 'none';
		}
         for (var i = 0; i < checkboxes.length; i++) {
             console.log(i)
             if (checkboxes[i].type == 'checkbox') {
                 checkboxes[i].checked = false;
             }
         }
     }
 }
 function showHideDiv(div,ele){
	 if (ele.checked) {
		 document.getElementById(div).style.display = 'block';
	 }else{
		 document.getElementById(div).style.display = 'none';
	 }
 }
</script>
</body>
</html>