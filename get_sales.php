<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (isset($_POST['date']) && isset($_POST['server_id'])) {
    $date = $_POST['date'];
    $server_id = $_POST['server_id'];

    if (!empty($date) && !empty($server_id)) {
        // Fetch server name from servers table
        $serverSql = "SELECT name FROM servers WHERE id = '$server_id'";
        $serverResult = $conn->query($serverSql);

        if ($serverResult->num_rows > 0) {
            $serverRow = $serverResult->fetch_assoc();
            $serverName = $serverRow['name'];

            // Fetch sales data from sales table
            $salesSql = "SELECT article, quantity, total FROM sales WHERE date = '$date' AND server_id = '$server_id'";
            $salesResult = $conn->query($salesSql);

            if ($salesResult) {
                $sales = array();
                $totalSales = 0.0;

                while ($row = $salesResult->fetch_assoc()) {
                    $row['server'] = $serverName; // Add server name to each sale entry
                    $sales[] = $row;
                    $totalSales += (float)$row['total'];
                }

                $response = array('sales' => $sales, 'totalSales' => $totalSales);
                echo json_encode($response);
            } else {
                echo json_encode(array('error' => 'Query failed: ' . $conn->error));
            }
        } else {
            echo json_encode(array('error' => 'Server not found.'));
        }
    } else {
        echo json_encode(array('error' => 'Invalid input: date and server_id cannot be empty.'));
    }
} else {
    echo json_encode(array('error' => 'Missing required POST variables: date and server_id.'));
}

$conn->close();
?>
