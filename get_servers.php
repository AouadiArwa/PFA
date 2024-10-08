<?php
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

$sql = "SELECT name FROM servers";
$result = $conn->query($sql);

$servers = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $servers[] = $row;
    }
}
$conn->close();

header('Content-Type: application/json');
echo json_encode($servers);
?>
