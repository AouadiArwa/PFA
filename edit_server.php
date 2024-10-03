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

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate and sanitize input
    $serverName = isset($_POST['name']) ? $_POST['name'] : '';
    $newServerName = isset($_POST['new_name']) ? $_POST['new_name'] : '';

    // Check if name and new name are provided
    if (empty($serverName) || empty($newServerName)) {
        echo json_encode(["success" => false, "error" => "Server name or new name is empty"]);
        exit;
    }

    // Prepare and execute update query
    $stmt = $conn->prepare("UPDATE servers SET name = ? WHERE name = ?");
    if ($stmt) {
        $stmt->bind_param("ss", $newServerName, $serverName);

        if ($stmt->execute()) {
            echo json_encode(["success" => true]);
        } else {
            echo json_encode(["success" => false, "error" => $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "error" => $conn->error]);
    }
} else {
    echo json_encode(["success" => false, "error" => "Invalid request method"]);
}

$conn->close();
?>
