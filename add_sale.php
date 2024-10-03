
<?php
header("Content-Type: application/json");
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    echo json_encode(['success' => false, 'error' => 'Connection failed: ' . $conn->connect_error]);
    exit();
}

// Retrieve POST parameters
$article = $_POST['article'];
$quantity = $_POST['quantity'];
$server_name = $_POST['server_name'];
$date = $_POST['date'];

// Fetch server ID
$serverIdQuery = "SELECT id FROM servers WHERE name = ?";
$stmt = $conn->prepare($serverIdQuery);
$stmt->bind_param("s", $server_name);
$stmt->execute();
$result = $stmt->get_result();
$server = $result->fetch_assoc();
$server_id = $server ? $server['id'] : null;
$stmt->close();

if (!$server_id) {
    echo json_encode(['success' => false, 'error' => 'Server not found']);
    exit();
}

// Fetch price for the article
$priceQuery = "SELECT price FROM items WHERE name = ?";
$stmt = $conn->prepare($priceQuery);
$stmt->bind_param("s", $article);
$stmt->execute();
$result = $stmt->get_result();
$item = $result->fetch_assoc();
$price = $item ? $item['price'] : null;
$stmt->close();

if (!$price) {
    echo json_encode(['success' => false, 'error' => 'Article not found']);
    exit();
}

// Calculate total
$total = $quantity * $price;

// Insert sale into database
$insertSaleQuery = "INSERT INTO sales (article, quantity, price, total, date, server_id) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($insertSaleQuery);
$stmt->bind_param("siddsi", $article, $quantity, $price, $total, $date, $server_id);
$success = $stmt->execute();
$stmt->close();
$conn->close();

// Return response
if ($success) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'error' => 'Failed to add sale']);
}
?>
