DROP DATABASE IF EXISTS `${aws_db_wp}`;
GRANT USAGE ON *.* TO '${aws_db_wp_username}'@'%';
DROP USER '${aws_db_wp_username}'@'%';
CREATE USER '${aws_db_wp_username}'@'%' IDENTIFIED BY '${aws_db_wp}';
CREATE DATABASE `${aws_db_wp}`;
GRANT ALL PRIVILEGES ON `${aws_db_wp}`.*TO'${aws_db_wp_username}'@'%';
FLUSH PRIVILEGES;
