<?php
$username = $_GET['username'];
$nombre = "";

$host = "65.99.225.119";
$user = "indust94_sistemas_progweb";
$password = "+]Ec.=D11L(o";
$database = "indust94_PROYECTOS_INTERFACES";
$mysqli = new mysqli($host, $user, $password, $database);

/** @noinspection SqlResolve */
$query = 'SELECT Prestamos.REGIDUUID, Prestamos.MATRICULA, Usuarios.TIPO_DE_USUARIO, Usuarios.NOMBRE, Usuarios.NUMERO_DE_CELULAR, Usuarios.MAIL, Prestamos.ISBN, Libros.TITULO, Libros.AUTOR, Prestamos.STATUS, Prestamos.FECHA_DE_EMISION, Registros.FECHA_PROMESA_DE_ENTREGA, Registros.FECHA_DE_ENTREGA, Registros.EFECTIVO_GENERADO, Registros.STATUS AS TIEMPO_DE_ENTREGA
    FROM Prestamos
    LEFT JOIN Registros ON Prestamos.REGIDUUID = Registros.REGIDUUID
    LEFT JOIN Usuarios ON Prestamos.MATRICULA = Usuarios.MATRICULA
    LEFT JOIN Libros ON Prestamos.ISBN = Libros.ISBN;';
$stmt = $mysqli->prepare(query: $query);
$stmt->execute();
$result = $stmt->get_result();


$stmt->close();
$mysqli?->close();
?>

<div class="button-container">
    <button onclick="location.href='page1.php'">Gestionar Libros</button>
    <button onclick="location.href='page2.php'">Gestión de Alumnos</button>
    <button onclick="location.href='page3.php'">Gestión de Docentes</button>
    <button onclick="location.href='page4.php'">Nuevo préstamo de libro</button>
    <button onclick="location.href='page5.php'">Devolución de libro</button>
</div>
<div class="grid-container">
    <div class="grid-item">Data 1</div>
    <div class="grid-item">Data 2</div>
    <div class="grid-item">Data 3</div>
    <div class="grid-item">Data 4</div>
    <div class="grid-item">Data 5</div>
</div>