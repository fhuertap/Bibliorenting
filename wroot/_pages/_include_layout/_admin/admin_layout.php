<?php
$username = $_GET['username'];
$nombre = "";

$host = "65.99.225.119";
$user = "indust94_sistemas_progweb";
$password = "+]Ec.=D11L(o";
$database = "indust94_PROYECTOS_INTERFACES";
$mysqli = new mysqli($host, $user, $password, $database);

$query = 'SELECT Prestamos.REGIDUUID, Prestamos.MATRICULA, Usuarios.TIPO_DE_USUARIO, Usuarios.NOMBRE, Usuarios.NUMERO_DE_CELULAR, Usuarios.MAIL, Prestamos.ISBN, Libros.TITULO, Libros.AUTOR, Prestamos.STATUS, Prestamos.FECHA_DE_EMISION, Registros.FECHA_PROMESA_DE_ENTREGA, Registros.FECHA_DE_ENTREGA, Registros.EFECTIVO_GENERADO, Registros.STATUS AS TIEMPO_DE_ENTREGA
    FROM Prestamos
    LEFT JOIN Registros ON Prestamos.REGIDUUID = Registros.REGIDUUID
    LEFT JOIN Usuarios ON Prestamos.MATRICULA = Usuarios.MATRICULA
    LEFT JOIN Libros ON Prestamos.ISBN = Libros.ISBN;';
$stmt = $mysqli->prepare(query: $query);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

$stmt->close();
$mysqli?->close();
include '../admin_header.php';
?>
<div class="grid-container">
    <?php foreach ($data as $row): ?>
        <div class="grid-item-container">
            <div class="grid-item">Matrícula: <?php echo htmlspecialchars($row['MATRICULA']); ?></div>
            <div class="grid-item"><?php echo htmlspecialchars($row['TIPO_DE_USUARIO']); ?>
                : <?php echo htmlspecialchars($row['NOMBRE']); ?></div>
            <div class="grid-item">Cel.: <?php echo htmlspecialchars($row['NUMERO_DE_CELULAR']); ?> -
                Mail: <?php echo htmlspecialchars($row['MAIL']); ?></div>
            <div class="grid-item">ISBN: <?php echo htmlspecialchars($row['ISBN']); ?> -
                Título: <?php echo htmlspecialchars($row['TITULO']); ?> -
                Autor: <?php echo htmlspecialchars($row['AUTOR']); ?></div>
            <div class="grid-item">Estatus: <?php echo htmlspecialchars($row['STATUS']); ?> - Fecha de
                préstamo: <?php echo htmlspecialchars($row['FECHA_DE_EMISION']); ?></div>
            <div class="grid-item">Fecha a devolver: <?php echo htmlspecialchars($row['FECHA_PROMESA_DE_ENTREGA']); ?> -
                Estatus: <?php echo htmlspecialchars($row['TIEMPO_DE_ENTREGA']); ?></div>
        </div>
    <?php endforeach; ?>
    <?php
    if (count($data) == 0) {
        echo "
        <div class='grid-item-container-n'>
            <div class='grid-item-n'>
                    No hay libros prestados
            </div>
        </div>";
    }
    ?>
</div>