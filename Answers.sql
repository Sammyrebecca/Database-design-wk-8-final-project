-- clinic_booking_system.sql

CREATE DATABASE IF NOT EXISTS clinic_booking_system;
USE clinic_booking_system;

-- Table: patients
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table: departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: doctors
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    specialization VARCHAR(100),
    department_id INT,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Table: appointments
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled', 'no-show') DEFAULT 'scheduled',
    reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    UNIQUE KEY unique_doctor_timeslot (doctor_id, appointment_date, appointment_time)
);

-- Table: users (for authentication)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'doctor', 'staff') NOT NULL,
    doctor_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO departments (name, description) VALUES
('Cardiology', 'Heart and cardiovascular system care'),
('Dermatology', 'Skin, hair, and nail conditions'),
('Pediatrics', 'Medical care for infants, children, and adolescents'),
('Orthopedics', 'Musculoskeletal system injuries and disorders');

INSERT INTO doctors (first_name, last_name, email, phone, specialization, department_id, license_number) VALUES
('John', 'Smith', 'john.smith@clinic.com', '555-0101', 'Cardiologist', 1, 'LIC001'),
('Sarah', 'Johnson', 'sarah.j@clinic.com', '555-0102', 'Pediatrician', 3, 'LIC002'),
('Mike', 'Chen', 'mike.chen@clinic.com', '555-0103', 'Dermatologist', 2, 'LIC003'),
('Lisa', 'Wang', 'lisa.wang@clinic.com', '555-0104', 'Orthopedic Surgeon', 4, 'LIC004');

INSERT INTO patients (first_name, last_name, email, phone, date_of_birth, address) VALUES
('Alice', 'Brown', 'alice@email.com', '555-0201', '1985-03-15', '123 Main St, Cityville'),
('Bob', 'Wilson', 'bob@email.com', '555-0202', '1990-07-22', '456 Oak Ave, Townsville'),
('Carol', 'Davis', 'carol@email.com', '555-0203', '1978-12-05', '789 Pine Rd, Villageton');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES
(1, 1, '2024-01-15', '09:00:00', 'scheduled', 'Routine heart checkup'),
(2, 3, '2024-01-15', '10:30:00', 'scheduled', 'Skin rash consultation'),
(3, 2, '2024-01-16', '11:00:00', 'scheduled', 'Child vaccination');

INSERT INTO users (username, email, password_hash, role, doctor_id) VALUES
('admin', 'admin@clinic.com', '$2b$10$examplehash', 'admin', NULL),
('dr_smith', 'john.smith@clinic.com', '$2b$10$examplehash', 'doctor', 1),
('staff1', 'staff@clinic.com', '$2b$10$examplehash', 'staff', NULL);