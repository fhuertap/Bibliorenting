<?php
$mysqli = new mysqli("localhost", "root", "", "PROYECTO_INTERFACES");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed."]));
}
