<?php
    $host_db = "127.0.0.1"; // Host de la BD
    $usuario_db = "user"; // Usuario de la BD
    $clave_db = "*******"; // Contraseña de la BD
    $nombre_db = "nombre"; // Nombre de la BD
    
    //conectamos y seleccionamos db
try {
    $conn = new PDO("mysql:host=$host_db;dbname=$nombre_db", $usuario_db, $clave_db);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
}catch(PDOException $e){
    echo "Connection failed: " . $e->getMessage();
}
$conn->query("SET NAMES 'utf8'");
?>