<?php
//Connect to database
require'connectDB.php';

$output = '';

if(isset($_POST["To_Excel"])){
  
    $searchQueryVehicle = " ";
    $Start_date = " ";
    $End_date = " ";
    $Start_time = " ";
    $End_time = " ";
    $card_sel = " ";

    //Start date filter
    if ($_POST['date_sel_start'] != 0) {
        $Start_date = $_POST['date_sel_start'];
        $_SESSION['searchQueryVehicle'] = "check_in_date='".$Start_date."'";
    }
    else{
        $Start_date = date("Y-m-d");
        $_SESSION['searchQueryVehicle'] = "check_in_date='".date("Y-m-d")."'";
    }
    //End date filter
    if ($_POST['date_sel_end'] != 0) {
        $End_date = $_POST['date_sel_end'];
        $_SESSION['searchQueryVehicle'] = "check_in_date BETWEEN '".$Start_date."' AND '".$End_date."'";
    }
    //Time-In filter
    if ($_POST['time_sel'] == "Time_in") {
      //Start time filter
      if ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] == 0) {
          $Start_time = $_POST['time_sel_start'];
          $_SESSION['searchQueryVehicle'] .= " AND time_in='".$Start_time."'";
      }
      elseif ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] != 0) {
          $Start_time = $_POST['time_sel_start'];
      }
      //End time filter
      if ($_POST['time_sel_end'] != 0) {
          $End_time = $_POST['time_sel_end'];
          $_SESSION['searchQueryVehicle'] .= " AND time_in BETWEEN '".$Start_time."' AND '".$End_time."'";
      }
    }
    //Time-out filter
    if ($_POST['time_sel'] == "Time_out") {
      //Start time filter
      if ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] == 0) {
          $Start_time = $_POST['time_sel_start'];
          $_SESSION['searchQueryVehicle'] .= " AND time_out='".$Start_time."'";
      }
      elseif ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] != 0) {
          $Start_time = $_POST['time_sel_start'];
      }
      //End time filter
      if ($_POST['time_sel_end'] != 0) {
          $End_time = $_POST['time_sel_end'];
          $_SESSION['searchQueryVehicle'] .= " AND time_out BETWEEN '".$Start_time."' AND '".$End_time."'";
      }
    }
    //Card filter
    if ($_POST['card_sel'] != 0) {
        $card_sel = $_POST['card_sel'];
        $_SESSION['searchQueryVehicle'] .= " AND card_uid='".$card_sel."'";
    }
    //Department filter
    if ($_POST['dev_sel'] != 0) {
        $dev_uid = $_POST['dev_sel'];
        $_SESSION['searchQueryVehicle'] .= " AND device_uid='".$dev_uid."'";
    }

    $sql = "SELECT * FROM parking_logs WHERE ".$_SESSION['searchQueryVehicle']." ORDER BY id DESC";
    $result = mysqli_query($conn, $sql);
    if($result->num_rows > 0){
      $output .= '
                  <table class="table" bordered="1">  
                    <TR>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Vehicle Plate</th>
                        <th>Card UID</th>
                        <th>Device Dep</th>
                        <th>Date</th>
                        <th>Time In</th>
                        <th>Time Out</th>
                    </TR>';
        while($row=$result->fetch_assoc()) {
            $output .= '
                        <TR> 
                            <TD> '.$row['id'].'</TD>
                            <TD> '.$row['user_name'].'</TD>
                            <TD> '.$row['vehicle_plate'].'</TD>
                            <TD> '.$row['card_uid'].'</TD>
                            <TD> '.$row['device_dep'].'</TD>
                            <TD> '.$row['check_in_date'].'</TD>
                            <TD> '.$row['time_in'].'</TD>
                            <TD> '.$row['time_out'].'</TD>
                        </TR>';
        }
        $output .= '</table>';
        header('Content-Type: application/xls');
        header('Content-Disposition: attachment; filename=User_Log'.$Start_date.'.xls');
        
        echo $output;
        exit();
    }
    else{
      header( "location: UsersLog.php" );
      exit();
    }
}
?>