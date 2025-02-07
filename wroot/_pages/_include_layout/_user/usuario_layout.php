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
    LEFT JOIN Libros ON Prestamos.ISBN = Libros.ISBN WHERE Usuarios.MATRICULA = ?';
$stmt = $mysqli->prepare(query: $query);
$stmt->bind_param('s', $username);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

$stmt->close();
$mysqli?->close();
?>
<div class="button-container">
    <button onclick="location.href='page2.php'">Mis datos</button>
    <button onclick="location.href='page4.php'">Solicitar nuevo préstamo</button>
    <button onclick="location.href='page5.php'">Devolver un libro</button>
</div>
<div class="grid-container">
    <?php foreach ($data as $row): ?>
        <div class="grid-item-container">
            <div class="grid-item">ISBN: <?php echo htmlspecialchars($row['ISBN']); ?> -
                Título: <?php echo htmlspecialchars($row['TITULO']); ?> -
                Autor: <?php echo htmlspecialchars($row['AUTOR']); ?></div>
            <div class="grid-item">
                Estatus: <?php echo htmlspecialchars($row['STATUS']); ?> - Fecha de
                préstamo: <?php echo htmlspecialchars($row['FECHA_DE_EMISION']); ?>
                <p>
                    Fecha a devolver: <?php echo htmlspecialchars($row['FECHA_PROMESA_DE_ENTREGA']); ?> -
                    Estatus: <?php echo htmlspecialchars($row['TIEMPO_DE_ENTREGA']); ?>
                </p>
            </div>
        </div>
    <?php endforeach; ?>
    <?php
    if (count($data) == 0) {
        echo "
        <div class='grid-item-container-n'>
            <div class='grid-item-n'>
                    No hay libros prestados. ¿Buscas alguno? <a href='page4.php'>¡Solicita un nuevo préstamo!</a>
            </div>
        </div>";
    }
    ?>
</div>