<?php
$username = $_GET['username'];
$nombre = "";

$host = "65.99.225.119";
$user = "indust94_sistemas_progweb";
$password = "+]Ec.=D11L(o";
$database = "indust94_PROYECTOS_INTERFACES";
$mysqli = new mysqli($host, $user, $password, $database);

$query = 'SELECT NOMBRE FROM Usuarios WHERE MATRICULA = ?';
/** @noinspection SqlResolve */
$stmt = $mysqli->prepare(query: $query);

$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows > 0) {
    foreach ($result->fetch_array(MYSQLI_NUM) as $f) {
        $nombre = $f;
        break;
    }
}
$stmt->close();
$mysqli?->close();
?>
    <header>
        <div class="button-container-cs">
            <h1>
                <?php
                $usertype = $_GET['usertype'];
                echo("Bienvenido: " . $nombre . " - ");
                ?>Dashboard - Bibliorenting
                <button id="logoutBtn">Cerrar sesión</button>
            </h1>
            Matrícula: <?php echo htmlspecialchars($username); ?>
        </div>

    </header>
<?php
if ($usertype == 'admin') {
    include '_admin/admin_layout.php';
} else {
    include '_user/usuario_layout.php';
}

