-- ============================================================
--  Employee Salary Management System – Database Setup Script
--  Run this in MySQL before starting the application
-- ============================================================

-- 1. Create & select the database
CREATE DATABASE IF NOT EXISTS employeedb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE employeedb;

-- 2. Create the Employee table
CREATE TABLE IF NOT EXISTS Employee (
    Empno    INT           PRIMARY KEY,
    EmpName  VARCHAR(100)  NOT NULL,
    DoJ      DATE          NOT NULL,
    Gender   VARCHAR(10)   NOT NULL,
    Bsalary  DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_gender  CHECK (Gender IN ('Male','Female','Other')),
    CONSTRAINT chk_salary  CHECK (Bsalary >= 0),
    CONSTRAINT chk_empno   CHECK (Empno   >  0)
);

-- 3. Sample data for demo
INSERT INTO Employee (Empno, EmpName, DoJ, Gender, Bsalary) VALUES
(1001, 'Arjun Sharma',      '2018-06-15', 'Male',   75000.00),
(1002, 'Bhavna Patel',      '2020-01-10', 'Female', 62000.00),
(1003, 'Chetan Mehta',      '2015-03-22', 'Male',   95000.00),
(1004, 'Divya Nair',        '2022-07-01', 'Female', 48000.00),
(1005, 'Eshan Rao',         '2017-09-13', 'Male',   82000.00),
(1006, 'Falguni Desai',     '2019-11-05', 'Female', 71000.00),
(1007, 'Ganesh Kumar',      '2016-04-18', 'Male',   58000.00),
(1008, 'Harini Krishnan',   '2021-08-25', 'Female', 53000.00),
(1009, 'Ishan Verma',       '2014-12-01', 'Male',   110000.00),
(1010, 'Jyoti Singh',       '2023-02-14', 'Female', 44000.00),
(1011, 'Karan Malhotra',    '2013-05-30', 'Male',   125000.00),
(1012, 'Lavanya Suresh',    '2020-10-08', 'Female', 66000.00),
(1013, 'Manish Agarwal',    '2018-03-17', 'Male',   78000.00),
(1014, 'Neha Joshi',        '2019-06-22', 'Female', 69000.00),
(1015, 'Om Prakash Tiwari', '2011-01-09', 'Male',   140000.00);

-- 4. Verify
SELECT * FROM Employee ORDER BY Empno;

