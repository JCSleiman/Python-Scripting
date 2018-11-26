<?php
// including the database connection file
include_once("config.php");
 
if(isset($_POST['update']))
{    
    $id = $_POST['id'];
    
    $nombre=$_POST['nombre'];
    $precio=$_POST['precio'];
    $descr=$_POST['descr'];    
    
    // checking empty fields
    if(empty($nombre) || empty($precio) || empty($descr)) {            
        if(empty($nombre)) {
            echo "<font color='red'>Nombre field is empty.</font><br/>";
        }
        
        if(empty($precio)) {
            echo "<font color='red'>Precio field is empty.</font><br/>";
        }
        
        if(empty($descr)) {
            echo "<font color='red'>Descr field is empty.</font><br/>";
        }        
    } else {    
        //updating the table
        $result = mysqli_query($mysqli, "UPDATE productos SET nombre='$nombre', precio='$precio',descr='$descr' WHERE id=$id");
        
        //redirectig to the display page. In our case, it is index.php
        header("Location: index.php");
    }
}
?>
<?php
//getting id from url
$id = $_GET['id'];
 
//selecting data associated with this particular id
$result = mysqli_query($mysqli, "SELECT * FROM productos WHERE id=$id");
 
while($res = mysqli_fetch_array($result))
{
    $nombre = $res['nombre'];
    $precio = $res['precio'];
    $descr = $res['descr'];
}
?>
<html>
<head>    
    <title>Edit Data</title>
</head>
 
<body>
    <a href="index.php">REGRESAR</a>
    <br/><br/>
    
    <form name="form1" method="post" action="edit.php">
        <table border="0">
            <tr> 
                <td>Nombre</td>
                <td><input type="text" name="nombre" value="<?php echo $nombre;?>"></td>
            </tr>
            <tr> 
                <td>Precio</td>
                <td><input type="text" name="precio" value="<?php echo $precio;?>"></td>
            </tr>
            <tr> 
                <td>Descripcion</td>
                <td><input type="text" name="descr" value="<?php echo $descr;?>"></td>
            </tr>
            <tr>
                <td><input type="hidden" name="id" value=<?php echo $_GET['id'];?>></td>
                <td><input type="submit" name="update" value="Update"></td>
            </tr>
        </table>
    </form>
</body>
</html>
