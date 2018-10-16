DROP DATABASE IF EXISTS `ldshev2`;
DROP USER IF EXISTS 'ldshedbo'@'localhost';
DROP USER IF EXISTS 'ldshedbo'@'%';
CREATE DATABASE `ldshev2` CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'ldshedbo'@'localhost' IDENTIFIED BY 'ldshedbo';
CREATE USER 'ldshedbo'@'%' IDENTIFIED BY 'ldshedbo';
GRANT ALL PRIVILEGES ON ldshev2.* TO 'ldshedbo'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ldshev2.* TO 'ldshedbo'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
