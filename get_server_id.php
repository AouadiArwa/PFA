<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$server_name = $_POST['server_name'];

$sql = "SELECT id FROM servers WHERE name = '$server_name'";
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response['server_id'] = $row['id'];
} else {
    $response['server_id'] = null;
}

echo json_encode($response);
$conn->close();
?>
