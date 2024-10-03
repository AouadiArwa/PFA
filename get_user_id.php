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

// Retrieve POST data
$server_name = isset($_POST['server_name']) ? $_POST['server_name'] : '';

// Construct the query
$query = "SELECT id FROM servers WHERE name = '$server_name'";

$result = $conn->query($query);

// Check for query errors
if (!$result) {
    die("Query failed: " . $conn->error);
}

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = ['server_id' => $row['id']];
} else {
    $response = ['server_id' => null];
}

// Set headers for JSON response
header('Content-Type: application/json');

// Echo JSON response
echo json_encode($response);

$conn->close();
?>
