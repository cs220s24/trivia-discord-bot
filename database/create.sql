DROP DATABASE IF EXISTS trivia_db;
CREATE DATABASE trivia_db;
USE trivia_db;

CREATE TABLE trivia_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    answer VARCHAR(255) NOT NULL
);
