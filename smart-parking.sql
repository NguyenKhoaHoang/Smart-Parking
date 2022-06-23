-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 23, 2022 lúc 07:19 AM
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
(1, 'Nguyen Khoa Hoang ', 'khoahoang144@gmail.com', '$2y$10$/XsN5FzwP9KYktzwN7CX3elpSIL8pxYVg6GZ/MooJ10DssT5xY4Bq'),
(2, 'Le Manh Duy', 'bonvahoang123@gmail.com', '$2y$10$oiE.0LLGKMYQX4RZfwZO7OKOYNeK52z6v.OkQ8RWcPqRFu7S8x1YW');

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
(4, 'ESP8266', 'Bach Khoa Da Nang', '8ceb36c810343326', '2022-06-19', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `number_empty`
--

CREATE TABLE `number_empty` (
  `number` int(1) NOT NULL DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `number_empty`
--

INSERT INTO `number_empty` (`number`) VALUES
(4);

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
  `check_cam_out` tinyint(1) NOT NULL DEFAULT 0,
  `card_out` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `parking_logs`
--

INSERT INTO `parking_logs` (`id`, `user_name`, `vehicle_plate`, `card_uid`, `device_uid`, `device_dep`, `check_in_date`, `time_in`, `time_out`, `check_uid`, `check_cam_out`, `card_out`) VALUES
(75, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-28', '21:00:09', '21:01:01', 1, 1, 1),
(76, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-28', '21:07:00', '21:07:41', 1, 1, 1),
(77, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-28', '21:07:48', '21:08:06', 1, 1, 1),
(78, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-28', '22:51:30', '22:51:48', 1, 1, 1),
(79, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-28', '22:57:16', '22:57:37', 1, 1, 1),
(80, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '10:33:50', '10:34:10', 1, 1, 1),
(81, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '10:34:52', '10:35:26', 1, 1, 1),
(82, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '10:34:58', '10:36:01', 1, 1, 1),
(83, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '12:56:48', '12:59:13', 1, 1, 1),
(84, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '12:57:28', '12:58:57', 1, 1, 1),
(85, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:05:41', '13:14:44', 1, 1, 1),
(86, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:14:55', '13:15:44', 1, 1, 1),
(87, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:29:07', '13:30:27', 1, 1, 1),
(88, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:29:38', '13:30:08', 1, 1, 1),
(89, 'Nguyễn Vis', '60A-88888', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:31:43', '13:33:17', 1, 1, 1),
(90, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:32:07', '13:33:52', 1, 1, 1),
(91, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-05-29', '13:33:32', '13:33:39', 1, 1, 1),
(92, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:13:53', '12:15:23', 1, 1, 1),
(93, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:17:20', '12:18:00', 1, 1, 1),
(94, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:19:57', '12:26:05', 1, 1, 1),
(95, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:28:08', '12:30:29', 1, 1, 1),
(96, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:37:55', '12:41:03', 1, 1, 1),
(97, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:43:34', '12:47:05', 1, 1, 1),
(98, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:47:25', '12:53:13', 1, 1, 1),
(99, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '12:53:47', '13:46:02', 1, 1, 1),
(100, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-05-30', '13:47:10', '13:47:30', 1, 1, 1),
(101, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-06-14', '20:34:05', '20:34:15', 1, 1, 1),
(102, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-06-14', '21:04:30', '21:04:57', 1, 1, 1),
(103, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-06-14', '21:07:41', '21:17:36', 1, 1, 1),
(104, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-06-14', '21:31:59', '21:32:24', 1, 1, 1),
(105, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-06-14', '21:34:37', '21:35:00', 1, 1, 1),
(106, 'Nguyễn Vis', '30A12893', '1340840', '8ceb36c810343326', 'DTVT 20A', '2022-06-19', '00:00:00', '00:00:00', 0, 0, 0),
(107, 'Huấn', '51F97022', '704760', '8ceb36c810343326', 'DTVT 20A', '2022-06-19', '08:45:24', '00:00:00', 1, 0, 0),
(108, 'Mất em rồi', '29T8-2843', '1515010', '8ceb36c810343326', 'DTVT 20A', '2022-06-19', '08:45:40', '00:00:00', 1, 1, 0),
(109, 'Anh Bạn À', '38P1-05694', '1633610', '8ceb36c810343326', 'DTVT 20A', '2022-06-19', '08:44:26', '08:45:06', 1, 1, 1),
(110, 'Khoa Hoang', '30A12893', '1340840', '8ceb36c810343326', 'Bach Khoa Da Nang', '2022-06-21', '00:00:00', '00:00:00', 0, 0, 0),
(111, 'Minh Quan', '51F97022', '704760', '8ceb36c810343326', 'Bach Khoa Da Nang', '2022-06-21', '09:48:22', '09:49:14', 1, 1, 1),
(112, 'Manh Duy', '29T8-2843', '1515010', '8ceb36c810343326', 'Bach Khoa Da Nang', '2022-06-21', '09:49:35', '00:00:00', 1, 1, 0),
(113, 'Van Huan', '38P1-05694', '1633610', '8ceb36c810343326', 'Bach Khoa Da Nang', '2022-06-21', '09:50:17', '00:00:00', 1, 0, 0);

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
(3, 'Minh Quan', '0773412924', 'Male', 'blcm2486@gmail.com', '51F97022', '704760', 1, '2022-05-30', '8ceb36c810343326', 'Bach Khoa Da Nang', 1),
(4, 'Manh Duy', '423423423', 'Female', 'ht10082001@gmail.com', '29T8-2843', '1515010', 0, '2022-04-25', '8ceb36c810343326', 'Bach Khoa Da Nang', 1),
(5, 'Van Huan', '1921681114', 'Female', 'bonvahoang321@gmail.com', '38P1-05694', '1633610', 0, '2022-04-17', '8ceb36c810343326', 'Bach Khoa Da Nang', 1),
(6, 'Khoa Hoang', '65645645', 'Male', 'hoangvabon321@gmail.com', '30A12893', '1340840', 0, '2022-04-17', '8ceb36c810343326', 'Bach Khoa Da Nang', 1);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `parking_logs`
--
ALTER TABLE `parking_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT cho bảng `user_vehicle`
--
ALTER TABLE `user_vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
