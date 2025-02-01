<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión</title>
    <link rel="stylesheet" href="_pages/_sources/_styles/login_styles.css">
</head>
<body>
<div class="login-container">
    <h2>Login</h2>
    <form action="_pages/layout_page.php" method="POST">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="login-btn">Login</button>
    </form>
    <div class="extra-links">
        <a href="/forgot-password">Forgot Password?</a><br>
        <a href="/register">Register</a>
    </div>
</div>

</body>
</html>
