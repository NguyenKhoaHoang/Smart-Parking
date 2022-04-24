<?php
session_start();
?>
<div class="table-responsive" style="max-height: 500px;">
  <table class="table">
    <thead class="table-primary">
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Vehicle Plate</th>
        <th>Card UID</th>
        <th>Device Dep</th>
        <th>Date</th>
        <th>Time In</th>
        <th>Time Out</th>
      </tr>
    </thead>
    <tbody class="table-secondary">
      <?php

      //Connect to database
      require 'connectDB.php';
      $searchQueryVehicle = " ";
      $Start_date = " ";
      $End_date = " ";
      $Start_time = " ";
      $End_time = " ";
      $Card_sel = " ";

      if (isset($_POST['log_date'])) {
        //Start date filter
        if ($_POST['date_sel_start'] != 0) {
          $Start_date = $_POST['date_sel_start'];
          $_SESSION['searchQueryVehicle'] = "check_in_date='" . $Start_date . "'";
        } else {
          $Start_date = date("Y-m-d");
          $_SESSION['searchQueryVehicle'] = "check_in_date='" . date("Y-m-d") . "'";
        }
        //End date filter
        if ($_POST['date_sel_end'] != 0) {
          $End_date = $_POST['date_sel_end'];
          $_SESSION['searchQueryVehicle'] = "check_in_date BETWEEN '" . $Start_date . "' AND '" . $End_date . "'";
        }
        //Time-In filter
        if ($_POST['time_sel'] == "Time_in") {
          //Start time filter
          if ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] == 0) {
            $Start_time = $_POST['time_sel_start'];
            $_SESSION['searchQueryVehicle'] .= " AND time_in='" . $Start_time . "'";
          } elseif ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] != 0) {
            $Start_time = $_POST['time_sel_start'];
          }
          //End time filter
          if ($_POST['time_sel_end'] != 0) {
            $End_time = $_POST['time_sel_end'];
            $_SESSION['searchQueryVehicle'] .= " AND time_in BETWEEN '" . $Start_time . "' AND '" . $End_time . "'";
          }
        }
        //Time-out filter
        if ($_POST['time_sel'] == "Time_out") {
          //Start time filter
          if ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] == 0) {
            $Start_time = $_POST['time_sel_start'];
            $_SESSION['searchQueryVehicle'] .= " AND time_out='" . $Start_time . "'";
          } elseif ($_POST['time_sel_start'] != 0 && $_POST['time_sel_end'] != 0) {
            $Start_time = $_POST['time_sel_start'];
          }
          //End time filter
          if ($_POST['time_sel_end'] != 0) {
            $End_time = $_POST['time_sel_end'];
            $_SESSION['searchQueryVehicle'] .= " AND time_out BETWEEN '" . $Start_time . "' AND '" . $End_time . "'";
          }
        }
        //Card filter
        if ($_POST['card_sel'] != 0) {
          $Card_sel = $_POST['card_sel'];
          $_SESSION['searchQueryVehicle'] .= " AND card_uid='" . $Card_sel . "'";
        }
        //Department filter
        if ($_POST['dev_uid'] != 0) {
          $dev_uid = $_POST['dev_uid'];
          $_SESSION['searchQueryVehicle'] .= " AND device_uid='" . $dev_uid . "'";
        }
      }

      if ($_POST['select_date'] == 1) {
        $Start_date = date("Y-m-d");
        $_SESSION['searchQueryVehicle'] = "check_in_date='" . $Start_date . "'";
      }

      // $sql = "SELECT * FROM users_logs WHERE checkindate=? AND pic_date BETWEEN ? AND ? ORDER BY id ASC";
      $sql = "SELECT * FROM parking_logs WHERE " . $_SESSION['searchQueryVehicle'] . " ORDER BY id DESC";
      $result = mysqli_stmt_init($conn);
      if (!mysqli_stmt_prepare($result, $sql)) {
        echo '<p class="error">SQL Error</p>';
      } else {
        mysqli_stmt_execute($result);
        $resultl = mysqli_stmt_get_result($result);
        if (mysqli_num_rows($resultl) > 0) {
          while ($row = mysqli_fetch_assoc($resultl)) {
      ?>
            <TR>
              <TD><?php echo $row['id']; ?></TD>
              <TD><?php echo $row['user_name']; ?></TD>
              <TD><?php echo $row['vehicle_plate']; ?></TD>
              <TD><?php echo $row['card_uid']; ?></TD>
              <TD><?php echo $row['device_dep']; ?></TD>
              <TD><?php echo $row['check_in_date']; ?></TD>
              <TD><?php echo $row['time_in']; ?></TD>
              <TD><?php echo $row['time_out']; ?></TD>
            </TR>
      <?php
          }
        }
      }
      // echo $sql;
      ?>
    </tbody>
  </table>
</div>