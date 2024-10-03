<?php
$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$id = $_POST['id'];
$name = $_POST['name'];
$price = $_POST['price'];

$sql = "UPDATE items SET name='$name', price=$price WHERE id=$id";

$response = array();
if ($conn->query($sql) === TRUE) {
  $response['success'] = true;
} else {
  $response['success'] = false;
  $response['error'] = $conn->error;
}

echo json_encode($response);

$conn->close();
?>
