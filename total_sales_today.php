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

// Construct the query to sum the quantity of all articles for today's date
$query = "SELECT SUM(quantity) AS total_quantity FROM sales WHERE DATE(date) = CURDATE()";

$result = $conn->query($query);

// Check for query errors
if (!$result) {
    die("Query failed: " . $conn->error);
}

$row = $result->fetch_assoc();

// Fetch the total quantity from the result
$totalQuantity = isset($row['total_quantity']) ? (int)$row['total_quantity'] : 0;

echo json_encode([
    'total_sales_today' => $totalQuantity
]);

// Close connection
$conn->close();
?>
