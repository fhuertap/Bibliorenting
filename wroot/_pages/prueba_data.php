
<?php
$serverName = "192.168.2.51"; // e.g., "localhost" or "127.0.0.1"
$connectionOptions = array(
    "Database" => "your_database_name",
    "Uid" => "your_username",
    "PWD" => "your_password"
);

// Establishes the connection
$conn = sqlsrv_connect($serverName, $connectionOptions);

// Checks if the connection was successful
if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
} else {
    echo "Connection established.";
}

// Close the connection when done
sqlsrv_close($conn);
