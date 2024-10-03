<?php
$servername = "127.0.0.1";
$username = "root";
$password = "";
$database = "flutter_database";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

function userExists($username, $conn) {
    $username = $conn->real_escape_string($username);
    $sql = "SELECT * FROM users WHERE name = '$username'";
    $result = $conn->query($sql);
    return $result->num_rows > 0;
}

function addUser($name, $email, $password, $conn) {
    $name = $conn->real_escape_string($name);
    $email = $conn->real_escape_string($email);
    $passwordHash = password_hash($password, PASSWORD_DEFAULT); // Hash the password

    $sql = "INSERT INTO users (name, email, password) VALUES ('$name', '$email', '$passwordHash')";
    if ($conn->query($sql) === TRUE) {
        return "register_success";
    } else {
        return "error";
    }
}

function verifyUser($username, $password, $conn) {
    $username = $conn->real_escape_string($username);

    $sql = "SELECT password FROM users WHERE name = '$username'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $storedPasswordHash = $row['password'];

        if (password_verify($password, $storedPasswordHash)) {
            return "login_success";
        } else {
            return "wrong_password";
        }
    } else {
        return "user_not_found";
    }
}

$action = $_POST['action'] ?? '';
$name = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$username = $_POST['username'] ?? '';

if ($action === 'register' && !empty($name) && !empty($email) && !empty($password)) {
    if (userExists($name, $conn)) {
        echo "user_exists";
    } else {
        echo addUser($name, $email, $password, $conn);
    }
} elseif (!empty($username) && !empty($password)) {
    echo verifyUser($username, $password, $conn);
} else {
    echo "error";
}

$conn->close();
?>
