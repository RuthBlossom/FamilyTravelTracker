-- Creating a table to store student information
CREATE TABLE student (
                         id SERIAL PRIMARY KEY,     -- Unique identifier for each student
                         first_name TEXT,           -- First name of the student
                         last_name TEXT             -- Last name of the student
);

-- Creating a one-to-one relationship between student and their contact details
CREATE TABLE contact_detail (
                                id INTEGER REFERENCES student(id) UNIQUE, -- Reference to student's id, ensuring uniqueness
                                tel TEXT,                                  -- Telephone number
                                address TEXT                               -- Address of the student
);

-- Inserting data into the student and contact_detail tables
INSERT INTO student (first_name, last_name)
VALUES ('Angela', 'Yu');

INSERT INTO contact_detail (id, tel, address)
VALUES (1, '+123456789', '123 App Brewery Road');

-- Joining student and contact_detail tables to retrieve combined information
SELECT *
FROM student
         JOIN contact_detail
              ON student.id = contact_detail.id;


-- Creating a table to store homework submissions with a many-to-one relationship with students
CREATE TABLE homework_submission (
                                     id SERIAL PRIMARY KEY,         -- Unique identifier for each submission
                                     mark INTEGER,                  -- Mark obtained by the student
                                     student_id INTEGER REFERENCES student(id) -- Reference to student's id
);

-- Inserting data into the homework_submission table
INSERT INTO homework_submission (mark, student_id)
VALUES (98, 1), (87, 1), (88, 1);

-- Joining student and homework_submission tables to retrieve combined information
SELECT *
FROM student
         JOIN homework_submission
              ON student.id = student_id;

-- Another way of joining and selecting specific columns
SELECT student.id, first_name, last_name, mark
FROM student
         JOIN homework_submission
              ON student.id = student_id;


-- Creating tables for a many-to-many relationship between students and classes
CREATE TABLE class (
                       id SERIAL PRIMARY KEY,     -- Unique identifier for each class
                       title VARCHAR(45)          -- Title of the class
);

CREATE TABLE enrollment (
                            student_id INTEGER REFERENCES student(id), -- Reference to student's id
                            class_id INTEGER REFERENCES class(id),     -- Reference to class's id
                            PRIMARY KEY (student_id, class_id)          -- Composite primary key
);

-- Inserting data into the student, class, and enrollment tables
INSERT INTO student (first_name, last_name)
VALUES ('Jack', 'Bauer');

INSERT INTO class (title)
VALUES ('English Literature'), ('Maths'), ('Physics');

INSERT INTO enrollment (student_id, class_id ) VALUES (1, 1), (1, 2);
INSERT INTO enrollment (student_id ,class_id) VALUES (2, 2), (2, 3);

-- Joining tables to retrieve information about students and their enrolled classes
SELECT *
FROM enrollment
         JOIN student ON student.id = enrollment.student_id
         JOIN class ON class.id = enrollment.class_id;

-- Selecting specific columns with aliases
SELECT student.id AS id, first_name, last_name, title
FROM enrollment
         JOIN student ON student.id = enrollment.student_id
         JOIN class ON class.id = enrollment.class_id;

-- Using aliases to simplify the query
SELECT s.id AS id, first_name, last_name, title
FROM enrollment AS e
         JOIN student AS s ON s.id = e.student_id
         JOIN class AS c ON c.id = e.class_id;

-- Another way of using aliases
SELECT s.id AS id, first_name, last_name, title
FROM enrollment e
         JOIN student s ON s.id = e.student_id
         JOIN class c ON c.id = e.class_id;


-- EXERCISE SOLUTION AND SETUP --

-- Dropping existing tables if they exist
DROP TABLE IF EXISTS visited_countries, users;

-- Creating a table to store user information
CREATE TABLE users(
                      id SERIAL PRIMARY KEY,          -- Unique identifier for each user
                      name VARCHAR(15) UNIQUE NOT NULL, -- Name of the user (ensured uniqueness)
                      color VARCHAR(15)               -- Favorite color of the user
);

-- Creating a table to store visited countries with a reference to users
CREATE TABLE visited_countries(
                                  id SERIAL PRIMARY KEY,          -- Unique identifier for each record
                                  country_code CHAR(2) NOT NULL,  -- Country code of the visited country
                                  user_id INTEGER REFERENCES users(id) -- Reference to user's id
);

-- Inserting data into the users and visited_countries tables
INSERT INTO users (name, color)
VALUES ('Ruth', 'teal'), ('Byron', 'powderblue');

INSERT INTO visited_countries (country_code, user_id)
VALUES ('FR', 1), ('GB', 1), ('CA', 2), ('FR', 2 );

-- Joining tables to retrieve combined information about visited countries and users
SELECT *
FROM visited_countries
         JOIN users
              ON users.id = user_id;
