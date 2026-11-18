-- Micro-IT Academy database
-- Import this file using phpMyAdmin > Import.
-- Database: microit_academy

CREATE DATABASE IF NOT EXISTS microit_academy
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE microit_academy;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS admin_users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE admin_users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(80) NOT NULL UNIQUE,
  email VARCHAR(190) NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE courses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NULL,
  name VARCHAR(180) NOT NULL UNIQUE,
  fee DECIMAL(12,2) NOT NULL DEFAULT 0,
  duration VARCHAR(80) NOT NULL,
  description TEXT NULL,
  image_path VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_courses_category
    FOREIGN KEY (category_id) REFERENCES categories(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE students (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_code VARCHAR(40) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(190) NOT NULL,
  phone VARCHAR(40) NULL,
  course_id INT UNSIGNED NULL,
  status ENUM('Active','Pending','Inactive') NOT NULL DEFAULT 'Pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_students_name (name),
  INDEX idx_students_email (email),
  CONSTRAINT fk_students_course
    FOREIGN KEY (course_id) REFERENCES courses(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE enrollments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NULL,
  student_name VARCHAR(150) NOT NULL,
  phone VARCHAR(40) NULL,
  course_id INT UNSIGNED NULL,
  course_name VARCHAR(180) NOT NULL,
  enrollment_date DATE NOT NULL,
  status ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_enrollments_status (status),
  CONSTRAINT fk_enrollments_student
    FOREIGN KEY (student_id) REFERENCES students(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_enrollments_course
    FOREIGN KEY (course_id) REFERENCES courses(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE reviews (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_name VARCHAR(150) NOT NULL,
  course_name VARCHAR(180) NOT NULL,
  message TEXT NOT NULL,
  image_path VARCHAR(500) NULL,
  review_date DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE contact_messages (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NULL,
  email VARCHAR(190) NOT NULL,
  message TEXT NOT NULL,
  message_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  INDEX idx_contact_date (message_date)
) ENGINE=InnoDB;

-- Initial categories from the uploaded dashboard.
INSERT INTO categories (id, name) VALUES
(1, 'Networking'),
(2, 'Programming'),
(3, 'Hardware'),
(4, 'General'),
(5, 'Web Development');

-- Initial courses from the uploaded dashboard.
INSERT INTO courses (id, category_id, name, fee, duration, description) VALUES
(1, 5, 'Web Development', 150000, '3 Months', 'Learn to build modern websites.'),
(2, 1, 'Networking', 120000, '2 Months', 'Learn networking fundamentals and configuration.'),
(3, 4, 'Microsoft 365', 80000, '1 Month', 'Learn essential Microsoft 365 applications.'),
(4, 4, 'Content & Marketing', 100000, '2 Months', 'Learn content creation and digital marketing.');

-- Sample students from the uploaded dashboard.
INSERT INTO students (student_code, name, email, phone, course_id, status) VALUES
('MIT-2026-0248', 'Thiri Hlaing', 'thiri@example.com', '', 1, 'Active'),
('MIT-2026-0247', 'Min Khant', 'min@example.com', '', 2, 'Pending'),
('MIT-2026-0246', 'Arkar Soe', 'arkar@example.com', '', 3, 'Active'),
('MIT-2026-0245', 'Nandar Win', 'nandar@example.com', '', 4, 'Inactive');

-- Sample enrollment from the uploaded dashboard.
INSERT INTO enrollments
(student_id, student_name, phone, course_id, course_name, enrollment_date, status)
SELECT s.id, s.name, s.phone, c.id, c.name, '2026-11-02', 'Pending'
FROM students s
JOIN courses c ON c.id = 2
WHERE s.student_code = 'MIT-2026-0247';

-- Sample reviews from the uploaded dashboard.
INSERT INTO reviews (student_name, course_name, message, image_path, review_date) VALUES
('Josephine', 'Web Development', 'Micro-IT Academy provided me with excellent hands-on lab experience. Highly recommended for tech beginners!', NULL, '2026-11-05'),
('Anas Iqbual', 'Networking', 'The instructors are real industry experts. Practical Networking labs helped me improve my skills.', NULL, '2026-11-04'),
('Allina Joel', 'Microsoft 365', 'Great support team and well-structured curriculum. Learning was very engaging!', NULL, '2026-11-03'),
('Albert Chirls', 'Content & Marketing', 'The career guidance and interview preparation helped me improve my professional skills.', NULL, '2026-11-02');

-- For security, create your admin account later through PHP password_hash().
-- Do not insert a plain-text admin password into this database.
