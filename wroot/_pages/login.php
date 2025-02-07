
<?php
header("Content-Type: application/json");

$host = "65.99.225.119";
$user = "indust94_sistemas_progweb";
$password = "+]Ec.=D11L(o";
$database = "PROYECTOS_INTERFACES";
$mysqli = new mysqli($host, $user, $password, $database);

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed."]));
}


$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

$stmt = $mysqli->prepare(query: "CALL Iniciar_Sesion(?,?)");

$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows > 0) {
    foreach ($result->fetch_array(MYSQLI_NUM) as $f)
        {
            if ($f == 1)
            {
                echo json_encode(["success" => true, "message" => "admin"]);
            }
            if ($f == 2 || $f == 3)
            {
                echo json_encode(["success" => true, "message" => "user"]);
            }
        }
} else {
    echo json_encode(["success" => false, "message" => "Invalid password."]);
}
$stmt->close();
if ($mysqli) {
    $mysqli->close();
}