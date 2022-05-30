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
	<link rel="stylesheet" type="text/css" href="css/devices.css"/>
</head>
<body>
<?php include'header.php';?>
<main>
	<h1 class="slideInDown animated">Scan your car plate</h1>

	<section class="container py-lg-5">
	<iframe src="http://pbl05-env-1.eba-2v9ijhcy.us-east-1.elasticbeanstalk.com/" scrolling="yes" width=100% height=100%></iframe>
	</section>
</main>
</body>
</html>