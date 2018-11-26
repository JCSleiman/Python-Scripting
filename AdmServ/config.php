<?php
$databaseHost = 'localhost';
$databaseName = 'tiendita';
$databaseUsername = 'sleiman';
$databasePassword = "./Metalhalo1600";

$mysqli = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);


if (!$mysqli) {
    echo "Error: No se pudo conectar a MySQL." . PHP_EOL;
}

?>
