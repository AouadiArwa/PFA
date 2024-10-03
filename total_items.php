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

// Construct the query to count the number of items
$query = "SELECT COUNT(*) AS total_items FROM items";

$result = $conn->query($query);

// Check for query errors
if (!$result) {
    die("Query failed: " . $conn->error);
}

$row = $result->fetch_assoc();

// Fetch the total number of items from the result
$totalItems = isset($row['total_items']) ? (int)$row['total_items'] : 0;

echo json_encode([
    'total_articles' => $totalItems
]);

// Close connection
$conn->close();
?>
