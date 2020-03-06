CREATE DATABASE ADC;
USE ADC;

CREATE TABLE
	users
	(
		rcsid VARCHAR(255) UNIQUE NOT NULL,
		password VARCHAR(255),
		admin BOOLEAN NOT NULL,
		enabled BOOLEAN NOT NULL
	);

CREATE TABLE
	complaints
	(
		location VARCHAR(255),
		message TEXT
	);

CREATE TABLE
	doors
	(
		name VARCHAR(255) UNIQUE NOT NULL,
		location VARCHAR(255) UNIQUE NOT NULL,
		latitude DECIMAL(10,8) NOT NULL,
		longitude DECIMAL(11,8) NOT NULL,
		key VARCHAR(255) UNIQUE NOT NULL,
		mac VARCHAR(255) UNIQUE NOT NULL
	);

CREATE TABLE
	tokens
	(
		rcsid VARCHAR(255) NOT NULL,
		reason VARCHAR(255) NOT NULL,
		expiration TIMESTAMP,
		value VARCHAR(255) UNIQUE NOT NULL
	);

CREATE USER 'developer'@'localhost' IDENTIFIED BY 'developer';
GRANT ALL PRIVILEGES ON *.* TO 'developer'@'localhost' IDENTIFIED BY 'developer';

INSERT INTO
	users
	(
		rcsid,
		password,
		admin,
		enabled
	)
VALUES
(
	"admin1",
	"$2y$10$CUoclxcmP3gLnRy00N.tdOHAihRx/VYD50u2eGyGbvMp61FYqQG5q",
	TRUE,
	TRUE
),
(
	"admin2",
	"$2y$10$XqcO4zlTtB5F9gKYBKbthObqMJwtE48pnV.HIGlA/sDNK4BYtOe1K",
	TRUE,
	TRUE
),
(
	"user1",
	"$2y$10$9AxuNZcQhKbjoHIHWFN59OlyvXwyyU5q3BI1b77KtqLiny2Yf2dDa",
	FALSE,
	TRUE
),
(
	"user2",
	"$2y$10$tItI1vGDKH1qJTeh3O3WYegS3FFvLqoLn6p1m0HoBXStgtHjgSEKu",
	FALSE,
	FALSE
);

INSERT INTO
	complaints
	(
		location,
		message
	)
VALUES
(
	"loc1",
	"this is message1"
),
(
	"location2",
	"message the second"
);
