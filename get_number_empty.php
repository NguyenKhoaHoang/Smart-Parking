<?php
require 'connectDB.php';
$sql = "SELECT * FROM number_empty";
$result = mysqli_stmt_init($conn);
if (!mysqli_stmt_prepare($result, $sql)) {
    echo "SQL_Error_Select";
    exit();
}
else{
    mysqli_stmt_execute($result);
    $resultl = mysqli_stmt_get_result($result);
    if ($row = mysqli_fetch_assoc($resultl)){
        $number_empty = $row['number'];
        // echo $number_empty;
    }

}
?>