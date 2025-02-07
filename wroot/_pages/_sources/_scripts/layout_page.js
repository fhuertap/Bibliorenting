
document.getElementById('logoutBtn').addEventListener('click',
    function (e) {
        // Prevent default behavior
        e.preventDefault();
        // Execute the logout logic
        alert('Logging out'); // Replace this with actual logic
        location.href = 'login.html';
    });
