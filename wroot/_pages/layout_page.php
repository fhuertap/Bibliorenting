<?php


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $usuario = isset($_POST['username']) ? $_POST['username'] : "ENTRADA INVÁLIDA";
    $contrasena = isset($_POST['password']) ? $_POST['password'] : "ENTRADA INVÁLIDA";
}

echo("Usuario: " . $usuario . "<br>" . "Password: " . $contrasena . "<br>");



echo "layout page";
?>