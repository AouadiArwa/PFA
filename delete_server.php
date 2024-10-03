<?php
// Enable error reporting
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "flutter_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    echo json_encode([
        "success" => false,
        "error" => "Connection failed: " . $conn->connect_error,
        "message" => "Failed to connect to the database."
    ]);
    exit;
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate and sanitize input
    $serverName = isset($_POST['name']) ? $conn->real_escape_string($_POST['name']) : '';

    // Check if name is provided
    if (empty($serverName)) {
        echo json_encode(["success" => false, "error" => "Server name is empty", "message" => "Server name is empty"]);
        exit;
    }

    // Prepare and execute delete query
    $stmt = $conn->prepare("DELETE FROM servers WHERE name = ?");
    if ($stmt) {
        $stmt->bind_param("s", $serverName);

        if ($stmt->execute()) {
            echo json_encode([
                "success" => true,
                "message" => "Server deleted successfully."
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "error" => "Execute failed: " . $stmt->error,
                "message" => "Failed to delete server."
            ]);
            error_log("Execute failed: " . $stmt->error); // Log the error
        }

        $stmt->close();
    } else {
        echo json_encode([
            "success" => false,
            "error" => "Prepare failed: " . $conn->error,
            "message" => "Failed to prepare statement."
        ]);
        error_log("Prepare failed: " . $conn->error); // Log the error
    }
} else {
    echo json_encode(["success" => false, "error" => "Invalid request method", "message" => "Invalid request method"]);
}

$conn->close();
?>
