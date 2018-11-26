<?php
$databaseHost = 'localhost';
$databaseName = 'tiendita';
$databaseUsername = 'sleiman';
$databasePassword = "s3cretp4ss";

$mysqli = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);


if (!$mysqli) {
    echo "Error: No se pudo conectar a MySQL." . PHP_EOL;
}

?>
