<?php
$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM items";
$result = $conn->query($sql);

$items = array();
if ($result->num_rows > 0) {
  while($row = $result->fetch_assoc()) {
    $items[] = $row;
  }
}

echo json_encode($items);

$conn->close();
?>
