    <header>
        <div class="button-container-cs">
            <h1>
                <?php
                    $username = $_GET['username'];
                    $usertype = $_GET['usertype'];
                        echo("Bienvenido: " . $username . " - ");
                ?>Dashboard - Bibliorenting
                <button id="logoutBtn">Cerrar sesión</button>
            </h1>
        </div>

    </header>
        <?php
            if ($usertype == 'admin') {
                include '_admin/admin_layout.php';
            } else{
                include '_user/usuario_layout.php';
            }
            ?>
    <div class="grid-container">
        <div class="grid-item">Data 1</div>
        <div class="grid-item">Data 2</div>
        <div class="grid-item">Data 3</div>
        <div class="grid-item">Data 4</div>
        <div class="grid-item">Data 5</div>
    </div>

