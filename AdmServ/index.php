<?php

include_once "config.php";
 
//$result = mysql_query("SELECT * FROM users ORDER BY id DESC"); // mysql_query is deprecated
$result = mysqli_query($mysqli, "SELECT * FROM productos ORDER BY id DESC"); // using mysqli_query instead
?>
 
<html>
<head>    
    <title>Paginita de inicio</title>
</head>
 
<body>
    <a href="add.html">Agregar nuevos valores</a><br/><br/>
 
    <table width='80%' border=0>
        <tr bgcolor='#CCCCCC'>
            <td>Nombre</td>
            <td>Precio</td>
            <td>Descripcion</td>
            <td>Actualizar</td>
        </tr>
        <?php 
        
        while($res = mysqli_fetch_array($result)) {         
            echo "<tr>";
            echo "<td>".$res['nombre']."</td>";
            echo "<td>".$res['precio']."</td>";
            echo "<td>".$res['descr']."</td>";    
            echo "<td><a href=\"edit.php?id=$res[id]\">Editar</a> | <a href=\"delete.php?id=$res[id]\" onClick=\"return confirm('Seguro que lo quieres eliminar?')\">Eliminar</a></td>";        
        }
        ?>
    </table>
</body>
</html>
