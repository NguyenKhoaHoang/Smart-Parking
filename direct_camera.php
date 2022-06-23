<?php
session_start();
if (!isset($_SESSION['Admin-name'])) {
  header("location: login.php");
}
?>
<!DOCTYPE html>
<html>
<head>
<title>Camera</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/png" href="images/favicon.ico">
	<link rel="stylesheet" type="text/css" href="css/devices.css" />

	<script type="text/javascript" src="js/jquery-2.2.3.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha1256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous">
	</script>
	<script type="text/javascript" src="js/bootbox.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.js"></script>
</head>
<body>
<?php include 'header.php';?>
<main>
	<h1 class="slideInDown animated">Scan your car plate</h1>

	<section class="container py-lg-5">
	<iframe src="http://pbl05-env.eba-zsyytc7b.us-east-1.elasticbeanstalk.com/" scrolling="yes" width=100% height=700px></iframe>
	</section>
</main>
</body>
</html>