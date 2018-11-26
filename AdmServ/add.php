<html>
<head>
    <title>Agregar Info</title>
</head>
 
<body>
<?php
// Incluiremos el archivo de la conexión de la bbase de datos
include_once("config.php");
 
if(isset($_POST['Submit'])) {    
    $nombre = $_POST['nombre'];
    $precio = $_POST['precio'];
    $descr = $_POST['descr'];
        
    // revisar campos vacíos
    if(empty($nombre) || empty($precio) || empty($descr)) {                
	if(empty($nombre)) {
            echo "<font color='blue'>El campo del nombre está vacío.</font><br/>";
        }
        
        if(empty($precio)) {
            echo "<font color='blue'>El campo del precio está vacío.</font><br/>";
        }
        
        if(empty($descr)) {
            echo "<font color='blue'>El campo de la descripción está vacío.</font><br/>";
        }
        
        // regresar a la página anterior
        echo "<br/><a href='javascript:self.history.back();'>Regresar</a>";
    } else { 
        // si todos los campos están llenos (no vacíos)             
        // insertar información a la base de datos
        $result = mysqli_query($mysqli, "INSERT INTO productos(nombre,precio,descr) VALUES('$nombre','$precio','$descr')");
        
	// un mensajito de que salió bien
        echo "<font color='green'>La información de guardó correctamente.";
	echo "<br/><a href='index.php'>Ver resultado</a>";
    }
}
?>
</body>
</html>
