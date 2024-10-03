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

// Check if POST data is received
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // Assuming you sanitize and validate input (not shown here for brevity)
  $currentUsername = $_POST['current_username'];
  $newUsername = $_POST['new_username'];

  // Prepare and execute SQL update statement
  $sql = "UPDATE users SET name = ? WHERE name = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("ss", $newUsername, $currentUsername);

  $response = array();

  if ($stmt->execute()) {
    // Check if update was successful
    if ($stmt->affected_rows > 0) {
      $response['success'] = true;
    } else {
      $response['success'] = false;
      $response['error'] = 'No rows updated';
    }
  } else {
    $response['success'] = false;
    $response['error'] = $stmt->error;
  }

  // Return JSON response to Flutter
  echo json_encode($response);

  $stmt->close();
} else {
  // Return error response for invalid request method
  http_response_code(405);
  echo json_encode(['error' => 'Method Not Allowed']);
}

$conn->close();
?>
