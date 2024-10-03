<?php
header('Content-Type: application/json');

$servername = "127.0.0.1";
$username = "root";  // Update with your MySQL username
$password = "";  // Update with your MySQL password
$dbname = "flutter_database"; // Update with your database name

// Check if 'date' is set in POST request
if (!isset($_POST['date'])) {
    echo json_encode([
        'error' => 'Date not provided'
    ]);
    exit;
}

$date = $_POST['date'];

// Database connection
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo json_encode([
        'error' => 'Connection failed: ' . $conn->connect_error
    ]);
    exit;
}

// Fetch sales data with item price to calculate total
$sql = "SELECT sales.id, sales.article, sales.quantity, items.price, servers.name as server
        FROM sales
        JOIN servers ON sales.server_id = servers.id
        JOIN items ON sales.article = items.name
        WHERE sales.date = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $date);
$stmt->execute();
$result = $stmt->get_result();

$sales = [];
$totalSales = 0;
while ($row = $result->fetch_assoc()) {
    $row['total'] = $row['quantity'] * $row['price'];
    $sales[] = $row;
    $totalSales += $row['total'];
}

$stmt->close();
$conn->close();

echo json_encode([
    'sales' => $sales,
    'totalSales' => $totalSales
]);
?>
