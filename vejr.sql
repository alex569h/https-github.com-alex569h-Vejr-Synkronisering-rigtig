CREATE DATABASE IF NOT EXISTS vejr_database;

USE vejr_database;

CREATE TABLE IF NOT EXISTS vejr (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vejr VARCHAR(50),
    tid INT
);
