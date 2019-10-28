CREATE DATABASE users;
use users;
CREATE TABLE admin (username VARCHAR(255) NOT NULL UNIQUE, password VARCHAR(255) not null);
CREATE TABLE complaints (location VARCHAR(255), message TEXT);
CREATE TABLE doors (name VARCHAR(255) NOT NULL UNIQUE, location VARCHAR(255) NOT NULL, latitude DECIMAL(10, 8) NOT NULL, longitude DECIMAL(11, 8) NOT NULL, key VARCHAR(255) NOT NULL UNIQUE);
CREATE TABLE students (RCSid VARCHAR(255) NOT NULL UNIQUE, Password VARCHAR(255) NOT NULL, Status varchar(255) NOT NULL);
CREATE USER 'developer'@'localhost' IDENTIFIED BY 'developer';
GRANT ALL PRIVELEGES IN *.* TO 'developer'@'localhost' IDENTIFIED BY 'developer';
INSERT INTO admin (username, password) VALUES ("admin1", "$2y$10$CUoclxcmP3gLnRy00N.tdOHAihRx/VYD50u2eGyGbvMp61FYqQG5q"), ("admin2", "$2y$10$XqcO4zlTtB5F9gKYBKbthObqMJwtE48pnV.HIGlA/sDNK4BYtOe1K");
INSERT INTO students (RCSid, Password, Status) VALUES ("user1", "$2y$10$9AxuNZcQhKbjoHIHWFN59OlyvXwyyU5q3BI1b77KtqLiny2Yf2dDa", "Active"), ("user2", "$2y$10$tItI1vGDKH1qJTeh3O3WYegS3FFvLqoLn6p1m0HoBXStgtHjgSEKu", "Request");
INSERT INTO complaints (location, message) VALUES ("loc1", "this is message1"), ("location2", "message the second");