<?php
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$name = isset($_POST['name']) ? $_POST['name'] : '';
$price = isset($_POST['price']) ? $_POST['price'] : 0;

$response = array();

if (!empty($name) && is_numeric($price)) {
    $sql = "INSERT INTO items (name, price) VALUES ('$name', $price)";

    if ($conn->query($sql) === TRUE) {
        $response['success'] = true;
    } else {
        $response['success'] = false;
        $response['error'] = $conn->error;
    }
} else {
    $response['success'] = false;
    $response['error'] = "Invalid input";
}

echo json_encode($response);

$conn->close();
?>
