<?php  
//Connect to database
require'connectDB.php';

//Add user
if (isset($_POST['Add'])) {
     
    $ID = $_POST['id'];
    $Name = $_POST['name'];
    $Vehicle_plate = $_POST['vehicle_plate'];
    $Phone = $_POST['phone'];
    $Email = $_POST['email'];
    $dev_uid = $_POST['dev_uid'];
    $Gender = $_POST['gender'];
    
    //check if there any selected user
    $sql = "SELECT add_card FROM user_vehicle WHERE id=?";
    $result = mysqli_stmt_init($conn);
    if (!mysqli_stmt_prepare($result, $sql)) {
      echo "SQL_Error";
      exit();
    }
    else{
        mysqli_stmt_bind_param($result, "i", $ID);
        mysqli_stmt_execute($result);
        $resultl = mysqli_stmt_get_result($result);
        if ($row = mysqli_fetch_assoc($resultl)) {

            if ($row['add_card'] == 0) {

                if (!empty($Name) && !empty($Vehicle_plate) && !empty($Email)) {
                    //check if there any user had already the Serial Number
                    $sql = "SELECT vehicle_plate FROM user_vehicle WHERE vehicle_plate=? AND id NOT like ?";
                    $result = mysqli_stmt_init($conn);
                    if (!mysqli_stmt_prepare($result, $sql)) {
                        echo "SQL_Error";
                        exit();
                    }
                    else{
                        mysqli_stmt_bind_param($result, "si", $Vehicle_plate, $ID);
                        mysqli_stmt_execute($result);
                        $resultl = mysqli_stmt_get_result($result);
                        if (!$row = mysqli_fetch_assoc($resultl)) {
                            $sql = "SELECT device_dep FROM devices WHERE device_uid=?";
                            $result = mysqli_stmt_init($conn);
                            if (!mysqli_stmt_prepare($result, $sql)) {
                                echo "SQL_Error";
                                exit();
                            }
                            else{
                                mysqli_stmt_bind_param($result, "s", $dev_uid);
                                mysqli_stmt_execute($result);
                                $resultl = mysqli_stmt_get_result($result);
                                if ($row = mysqli_fetch_assoc($resultl)) {
                                    $dev_name = $row['device_dep'];
                                }
                                else{
                                    $dev_name = "All";
                                }
                            }
                            $sql="UPDATE user_vehicle SET user_name=?, vehicle_plate=?, gender=?, phone=? ,email=?, init_date=CURDATE(), device_uid=?, device_dep=?, add_card=1 WHERE id=?";
                            $result = mysqli_stmt_init($conn);
                            if (!mysqli_stmt_prepare($result, $sql)) {
                                echo "SQL_Error_select_Fingerprint";
                                exit();
                            }
                            else{
                                mysqli_stmt_bind_param($result, "sssssssi", $Name, $Vehicle_plate, $Gender, $Phone, $Email, $dev_uid, $dev_name, $ID );
                                mysqli_stmt_execute($result);

                                echo 1;
                                exit();
                            }
                        }
                        else {
                            echo "The vehicle plate is already have!";
                            exit();
                        }
                    }
                }
                else{
                    echo "Empty Fields";
                    exit();
                }
            }
            else{
                echo "This User Vehicle is already exist";
                exit();
            }    
        }
        else {
            echo "There's no selected Card!";
            exit();
        }
    }
}
// Update an existance user 
if (isset($_POST['Update'])) {

    $ID = $_POST['id'];
    $Name = $_POST['name'];
    $Vehicle_plate = $_POST['vehicle_plate'];
    $Phone = $_POST['phone'];
    $Email = $_POST['email'];
    $dev_uid = $_POST['dev_uid'];
    $Gender = $_POST['gender'];

    //check if there any selected user
    $sql = "SELECT add_card FROM user_vehicle WHERE id=?";
    $result = mysqli_stmt_init($conn);
    if (!mysqli_stmt_prepare($result, $sql)) {
      echo "SQL_Error";
      exit();
    }
    else{
        mysqli_stmt_bind_param($result, "i", $ID);
        mysqli_stmt_execute($result);
        $resultl = mysqli_stmt_get_result($result);
        if ($row = mysqli_fetch_assoc($resultl)) {

            if ($row['add_card'] == 0) {
                echo "First, You need to add the User Vehicle!";
                exit();
            }
            else{
                if (empty($Name) && empty($Vehicle_plate) && empty($Email)) {
                    echo "Empty Fields";
                    exit();
                }
                else{
                    //check if there any user had already the Vehicle plate
                    $sql = "SELECT vehicle_plate FROM user_vehicle WHERE vehicle_plate=? AND id NOT like ?";
                    $result = mysqli_stmt_init($conn);
                    if (!mysqli_stmt_prepare($result, $sql)) {
                        echo "SQL_Error";
                        exit();
                    }
                    else{
                        mysqli_stmt_bind_param($result, "si", $Vehicle_plate, $ID);
                        mysqli_stmt_execute($result);
                        $resultl = mysqli_stmt_get_result($result);
                        if (!$row = mysqli_fetch_assoc($resultl)) {
                            $sql = "SELECT device_dep FROM devices WHERE device_uid=?";
                            $result = mysqli_stmt_init($conn);
                            if (!mysqli_stmt_prepare($result, $sql)) {
                                echo "SQL_Error";
                                exit();
                            }
                            else{
                                mysqli_stmt_bind_param($result, "s", $dev_uid);
                                mysqli_stmt_execute($result);
                                $resultl = mysqli_stmt_get_result($result);
                                if ($row = mysqli_fetch_assoc($resultl)) {
                                    $dev_name = $row['device_dep'];
                                }
                                else{
                                    $dev_name = "All";
                                }
                            }
                                    
                            if (!empty($Name) && !empty($Email)) {

                                $sql="UPDATE user_vehicle SET user_name=?, vehicle_plate=?, gender=?, phone=? ,email=?, device_uid=?, device_dep=? WHERE id=?";
                                $result = mysqli_stmt_init($conn);
                                if (!mysqli_stmt_prepare($result, $sql)) {
                                    echo "SQL_Error_select_Card";
                                    exit();
                                }
                                else{
                                    mysqli_stmt_bind_param($result, "sssssssi", $Name, $Vehicle_plate, $Gender, $Phone, $Email, $dev_uid, $dev_name, $ID );
                                    mysqli_stmt_execute($result);

                                    echo 1;
                                    exit();
                                }
                            }
                        }
                        else {
                            echo "The Vehicle Plate is already taken!";
                            exit();
                        }
                    }
                }
            }    
        }
        else {
            echo "There's no selected User Vehicle to be updated!";
            exit();
        }
    }
}
// select fingerprint 
if (isset($_GET['select'])) {

    $card_uid = $_GET['card_uid'];

    $sql = "SELECT * FROM user_vehicle WHERE card_uid=?";
    $result = mysqli_stmt_init($conn);
    if (!mysqli_stmt_prepare($result, $sql)) {
        echo "SQL_Error_Select";
        exit();
    }
    else{
        mysqli_stmt_bind_param($result, "s", $card_uid);
        mysqli_stmt_execute($result);
        $resultl = mysqli_stmt_get_result($result);
        // echo "User Fingerprint selected";
        // exit();
        header('Content-Type: application/json');
        $data = array();
        if ($row = mysqli_fetch_assoc($resultl)) {
            foreach ($resultl as $row) {
                $data[] = $row;
            }
        }
        $resultl->close();
        $conn->close();
        print json_encode($data);
    } 
}
// delete user 
if (isset($_POST['delete'])) {

    $ID = $_POST['id'];

    if (empty($ID)) {
        echo "There no selected user vehicle to remove";
        exit();
    } else {
        $sql = "DELETE FROM user_vehicle WHERE id=?";
        $result = mysqli_stmt_init($conn);
        if (!mysqli_stmt_prepare($result, $sql)) {
            echo "SQL_Error_delete";
            exit();
        }
        else{
            mysqli_stmt_bind_param($result, "i", $ID);
            mysqli_stmt_execute($result);
            echo 1;
            exit();
        }
    }
}
?>