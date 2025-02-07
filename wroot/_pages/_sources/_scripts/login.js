// function validateForm(username, password) {
//     if (username === 'admin' && password === 'admin') {
//         return true;
//     } else {
//         alert('Por favor, complete todos los campos.');
//         return false;
//     }
// }

document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent default form submission

    let username = document.getElementById("username").value;
    let password = document.getElementById("password").value;
    if (username === "" || password === "") {
        document.getElementById("message").innerText = "All fields are required!";
        return;
    }

    fetch("login.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}`
    })
        .then(response => response.json()) // Expecting JSON from PHP
        .then(data => {
            if (data.success) {
                if(data.message === 'admin') {
                    window.location.href = "main_dashboard.php?username="+username+"&usertype=admin"; // Redirect on success
                }
                if(data.message === 'user') {
                    window.location.href = "main_dashboard.php?username="+username+"&usertype=user"; // Redirect on success
                }
            }else{
                alert('Credentials are incorrect');
            }
        })
        .catch(error => console.error("Error:", error));
});