<?php
session_start();
if (!isset($_SESSION['Admin-name'])) {
  header("location: login.php");
}
?>
<!DOCTYPE html>
<html>

<head>
  <title>Users</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/png" href="images/favicon.png">

  <script type="text/javascript" src="js/jquery-2.2.3.min.js"></script>
  <script type="text/javascript" src="js/bootstrap.js"></script>
 <link rel="stylesheet" href="css/reset.css" />
  <link rel="stylesheet" type="text/css" href="css/Users.css">
  <script>
    $(window).on("load resize ", function() {
      var scrollWidth = $('.tbl-content').width() - $('.tbl-content table').width();
      $('.tbl-header').css({
        'padding-right': scrollWidth
      });
    }).resize();
  </script>
</head>

<body>
  <?php include 'header.php'; ?>
  <main>
    <section>
      <h1 class="slideInDown animated">Here are all the Users Vehicle</h1>
      <!--User table-->
      <div class="table-responsive slideInRight animated" style="max-height: 400px;">
        <table class="table">
          <thead class="table-primary">
            <tr>
              <th>ID | Name</th>
              <th>Gender</th>
              <th>Phone</th>
              <th>Vehicle Plate</th>
              <th>Init Date</th>
              <th>Card UID</th>
            </tr>
          </thead>
          <tbody class="table-secondary">
            <?php
            //Connect to database
            require 'connectDB.php';

            $sql = "SELECT * FROM user_vehicle WHERE add_card=1 ORDER BY id DESC";
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
                    <TD><?php echo $row['id'];
                        echo " | ";
                        echo $row['user_name']; ?></TD>
                    <TD><?php echo $row['gender']; ?></TD>
                    <TD><?php echo $row['phone']; ?></TD>
                    <TD><?php echo $row['vehicle_plate']; ?></TD>
                    <TD><?php echo $row['init_date']; ?></TD>
                    <TD><?php echo $row['card_uid']; ?></TD>
                  </TR>
            <?php
                }
              }
            }
            ?>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</body>

</html>