
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Bibliorenting</title>
    <link rel="stylesheet" href="_sources/_styles/layout_page.css">

</head>
<body>
    <header>
        <h1><?php

            $username = $_GET['username'];
                        echo("Bienvenido: " . $username . " -- ");
            ?>Dashboard - Bibliorenting</h1>
    </header>
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
</body>
</html>

