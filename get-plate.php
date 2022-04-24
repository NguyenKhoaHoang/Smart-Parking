<?php
require 'connectDB.php';
date_default_timezone_set('Asia/Jakarta');
$d = date("Y-m-d");
$t = date("H:i:sa");
if(isset($_POST["plate"])){
    $plate = $_POST["plate"];
    $sql = "SELECT * FROM user_vehicle WHERE vehicle_plate=?";
    $result = mysqli_stmt_init($conn);
    if (!mysqli_stmt_prepare($result, $sql)) {
        echo "SQL_Error_Select";
        exit();
    }
    else{
        mysqli_stmt_bind_param($result, "s", $plate);
        mysqli_stmt_execute($result);
        $resultl = mysqli_stmt_get_result($result);
        if ($row = mysqli_fetch_assoc($resultl)){
            // co bien so trong db
            if ($row['add_card'] == 1){
                $Name = $row['user_name'];
                $Card_uid = $row['card_uid'];
                $device_uid = $row['device_uid'];
                $device_dep = $row['device_dep'];
                $sql = "SELECT * FROM parking_logs WHERE vehicle_plate=? AND check_in_date=? AND check_uid=1 AND card_out=0";
                $result = mysqli_stmt_init($conn);
                if (!mysqli_stmt_prepare($result, $sql)) {
                    echo "SQL_Error_Select";
                    exit();
                }
                else{
                    mysqli_stmt_bind_param($result, "ss", $plate, $d);
                    mysqli_stmt_execute($result);
                    $resultl = mysqli_stmt_get_result($result);
                    if ($row = mysqli_fetch_assoc($resultl)){
                        // neu da co xe trong nha xe roi ma van nhan dien bien so
                        echo "Xe co bien so ".$plate." da co trong nha xe";
                    }
                    else{
                        $sql = "SELECT * FROM parking_logs WHERE vehicle_plate=? AND check_in_date=? AND check_uid=0 AND card_out=0";
                        $result = mysqli_stmt_init($conn);
                        if (!mysqli_stmt_prepare($result, $sql)) {
                            echo "SQL_Error_Select";
                            exit();
                        }
                        else{
                            mysqli_stmt_bind_param($result, "ss", $plate, $d);
                            mysqli_stmt_execute($result);
                            $resultl = mysqli_stmt_get_result($result);
                            if (!$row = mysqli_fetch_assoc($resultl)){
                                $sql = "INSERT INTO parking_logs (user_name, vehicle_plate, card_uid, device_uid, device_dep, check_in_date, time_in, time_out) VALUES (? ,?, ?, ?, ?, ?, ?, ?)";
                                $result = mysqli_stmt_init($conn);
                                if (!mysqli_stmt_prepare($result, $sql)) {
                                    echo "SQL_Error_Select_login1";
                                    exit();
                                }
                                else{
                                    $timeout = "00:00:00";
                                    $timein = "00:00:00";
                                    mysqli_stmt_bind_param($result, "ssssssss", $Name, $plate, $Card_uid, $device_uid, $device_dep, $d, $timein, $timeout);
                                    mysqli_stmt_execute($result);
                                    echo "Nhan dien bien so: ".$plate.", xin moi quet the";
                                    exit();
                                }  
                            }
                            else{
                                echo "Da nhan dien bien so: ".$plate.", xin moi quet the";
                            }
                        }
                    }
                }
            }
            else if ($row['add_card'] == 0){
                echo "Bien so xe: ".$plate." chua dang ky";
                exit();
            }
            
        }
        else {
            // ko co bien so trong db
            echo "khong co bien so trong db";
        }
        exit();
    }
}
else
    echo "khong nhan duoc bien so";

?>
