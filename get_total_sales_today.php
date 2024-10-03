<?php
header('Content-Type: application/json');

// Database connection details
$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['error' => $conn->connect_error]));
}

// Get today's date
$date = date('Y-m-d');

// Debug: Output the date to check
error_log("Today's date: $date");

// Fetch total sales for today
$sql = "SELECT SUM(total) AS today_sales FROM sales WHERE DATE(`date`) = '$date'";
$result = $conn->query($sql);

// Debug: Output the SQL query to check
error_log("SQL Query: $sql");

if ($result === false) {
    die(json_encode(['error' => $conn->error]));
}

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode(['today_sales' => (int)$row['today_sales']]);
} else {
    echo json_encode(['today_sales' => 0]);
}

$conn->close();
?>
