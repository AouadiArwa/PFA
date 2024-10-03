<?php
//this code is for fetching data for the graph
$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT article, SUM(quantity) as total_quantity, SUM(total) as total_sales, SUM(total) - SUM(quantity * price) as profit FROM sales GROUP BY article";
$result = $conn->query($sql);

$data = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
} else {
    echo json_encode(["error" => "No data found"]);
    exit();
}

header('Content-Type: application/json');
echo json_encode($data);

$conn->close();
?>
