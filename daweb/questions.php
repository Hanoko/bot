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
	<form action="addQuestion.php" method="post" enctype="multipart/form-data">
	<div class="left">
		<p>Pregunta</p>
		<textarea name="question" rows="1" cols="45"  ></textarea>
		<br>
	<h4>Enviar pregunta a:</h4>
  <p><input type="checkbox" onchange="checkAll(this)" name="chk[]" />Marcar/desmarcar todos</p>

	</div>
	<div class="right">
		<p>Fecha límite(Y-m-d H:M):</p>
		<input id="datetimepicker" type="text" name="deadline" ><br><br>
		<h4>Evaluarán la respuesta:</h4>
		<?php

		?>
	</div>
	<div class="users">
		<?php
		$sql = "SELECT id, first_name, last_name, username FROM user WHERE id!='hanokoSDK_bot'";
		foreach ($conn->query($sql) as $evaluated) {
			echo '<div class="todos" ><div class="evaluados" id='.$evaluated['id'].'>';
			$sql = "SELECT id, first_name, last_name, username FROM user WHERE id!='".$evaluated['id']."' AND id!='hanokoSDK_bot'";
			foreach ($conn->query($sql) as $evaluators) {
				echo '<p class="evaluator"><input type="checkbox" name="evaluators'.$evaluated['id'].'[]" value="'.$evaluators['id'].'">  '.$evaluators['first_name'].' '.$evaluators['last_name'].' ('.$evaluators['username'].')</p>';
			}
			echo '</div><p> <input onchange="showHideDiv('.$evaluated['id'].',this)" type="checkbox" name="evaluated[]" value="'.$evaluated['id'].'">  '.$evaluated['first_name'].' '.$evaluated['last_name'].' ('.$evaluated['username'].')</p></div><br>';
		}
		?>
	</div>
	<div class="bottom">
		<br>
		<input type="submit" value="Enviar" >
		<br>
		<br>
		<br>
	</div>
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