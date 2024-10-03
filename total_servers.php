<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Construct the query to count the number of servers
$query = "SELECT COUNT(*) AS total_servers FROM servers";

$result = $conn->query($query);

// Check for query errors
if (!$result) {
    die("Query failed: " . $conn->error);
}

$row = $result->fetch_assoc();

// Fetch the total number of servers from the result
$totalServers = isset($row['total_servers']) ? (int)$row['total_servers'] : 0;

echo json_encode([
    'total_servers' => $totalServers
]);

// Close connection
$conn->close();
?>
