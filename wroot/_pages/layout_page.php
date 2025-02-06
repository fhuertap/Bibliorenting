
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
            ?>Dashboard - Bibliorenting
        </h1>
    </header>
        <?php
            if ($username == 'admin') {
                include '_include_layout/admin_layout.php';
            } else{
                include '_include_layout/usuario_layout.php';
            }
            ?>
    <div class="grid-container">
        <div class="grid-item">Data 1</div>
        <div class="grid-item">Data 2</div>
        <div class="grid-item">Data 3</div>
        <div class="grid-item">Data 4</div>
        <div class="grid-item">Data 5</div>
    </div>
</body>
</html>

