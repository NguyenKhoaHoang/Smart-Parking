-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 25, 2022 lúc 11:20 AM
-- Phiên bản máy phục vụ: 10.4.21-MariaDB
-- Phiên bản PHP: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `smart-parking`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `admin_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `admin_email` varchar(80) NOT NULL,
  `admin_pwd` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `admin`
--

INSERT INTO `admin` (`id`, `admin_name`, `admin_email`, `admin_pwd`) VALUES
(1, 'Nguyễn Khoa Hoàng', 'khoahoang144@gmail.com', '$2y$10$89uX3LBy4mlU/DcBveQ1l.32nSianDP/E1MfUh.Z.6B4Z0ql3y7PK');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `devices`
--

CREATE TABLE `devices` (
  `id` int(11) NOT NULL,
  `device_name` varchar(50) NOT NULL,
  `device_dep` varchar(20) NOT NULL,
  `device_uid` text NOT NULL,
  `device_date` date NOT NULL,
  `device_mode` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `devices`
--

INSERT INTO `devices` (`id`, `device_name`, `device_dep`, `device_uid`, `device_date`, `device_mode`) VALUES
(1, 'ESP32', 'DTVT', '8f19e31055c56b05', '2021-06-21', 1),
(3, 'ESP8266', 'DTVT 20A', '8ceb36c810343326', '2021-06-22', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `parking_logs`
--

CREATE TABLE `parking_logs` (
  `id` int(11) NOT NULL,
  `user_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `vehicle_plate` varchar(50) CHARACTER SET latin1 NOT NULL,
  `card_uid` varchar(30) CHARACTER SET latin1 NOT NULL,
  `device_uid` varchar(20) CHARACTER SET latin1 NOT NULL,
  `device_dep` varchar(20) CHARACTER SET latin1 NOT NULL,
  `check_in_date` date NOT NULL,
  `time_in` time NOT NULL,
  `time_out` time NOT NULL,
  `check_uid` tinyint(1) NOT NULL DEFAULT 0,
  `card_out` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `parking_logs`
--

INSERT INTO `parking_logs` (`id`, `user_name`, `vehicle_plate`, `card_uid`, `device_uid`, `device_dep`, `check_in_date`, `time_in`, `time_out`, `check_uid`, `card_out`) VALUES
(57, 'Anh Bạn À', 'C256236', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-04-23', '21:46:40', '21:47:34', 1, 1),
(58, 'Nguyễn Vis', '65A00450', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-04-23', '21:47:25', '21:47:44', 1, 1),
(59, 'Nguyễn Vis', '65A00450', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-04-23', '21:50:48', '21:51:13', 1, 1),
(60, 'Anh Bạn À', 'C256236', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-04-23', '21:51:09', '21:51:17', 1, 1),
(61, 'Anh Bạn À', 'C256236', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-04-23', '21:52:56', '21:53:28', 1, 1),
(62, 'Anh Bạn À', 'C256236', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-04-23', '21:53:44', '21:54:12', 1, 1),
(63, 'Nguyễn Vis', '65A00450', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-04-25', '16:17:01', '16:17:04', 1, 1),
(64, 'Anh Bạn À', 'C256236', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-04-25', '16:17:50', '16:17:54', 1, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_vehicle`
--

CREATE TABLE `user_vehicle` (
  `id` int(11) NOT NULL,
  `user_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'None',
  `phone` varchar(30) CHARACTER SET latin1 NOT NULL DEFAULT 'None',
  `gender` varchar(10) CHARACTER SET latin1 NOT NULL DEFAULT 'Male',
  `email` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT 'None',
  `vehicle_plate` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT 'None',
  `card_uid` varchar(30) CHARACTER SET latin1 NOT NULL,
  `card_select` tinyint(1) NOT NULL DEFAULT 0,
  `init_date` date NOT NULL,
  `device_uid` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `device_dep` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `add_card` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `user_vehicle`
--

INSERT INTO `user_vehicle` (`id`, `user_name`, `phone`, `gender`, `email`, `vehicle_plate`, `card_uid`, `card_select`, `init_date`, `device_uid`, `device_dep`, `add_card`) VALUES
(3, 'None', 'None', 'Male', 'None', 'None', '704760', 1, '2022-04-17', '8ceb36c810343326', 'DTVT 20A', 0),
(4, 'None', 'None', 'Male', 'None', 'None', '1515010', 0, '2022-04-17', '8ceb36c810343326', 'DTVT 20A', 0),
(5, 'Anh Bạn À', '1921681114', 'Female', 'bonvahoang321@gmail.com', 'C256236', '1633610', 0, '2022-04-17', '8ceb36c810343326', 'DTVT 20A', 1),
(6, 'Nguyễn Vis', '65645645', 'Male', 'hoangvabon321@gmail.com', '65A00450', '1340840', 0, '2022-04-17', '8ceb36c810343326', 'DTVT 20A', 1);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `parking_logs`
--
ALTER TABLE `parking_logs`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `user_vehicle`
--
ALTER TABLE `user_vehicle`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `parking_logs`
--
ALTER TABLE `parking_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT cho bảng `user_vehicle`
--
ALTER TABLE `user_vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
