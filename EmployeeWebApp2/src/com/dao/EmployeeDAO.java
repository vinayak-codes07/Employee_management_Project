package com.dao;

import com.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    // ─── CREATE ──────────────────────────────────────────────────────────────
    public boolean addEmployee(Employee emp) throws SQLException {
        String sql = "INSERT INTO Employee (Empno, EmpName, DoJ, Gender, Bsalary) VALUES (?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, emp.getEmpno());
            ps.setString(2, emp.getEmpName());
            ps.setDate(3, emp.getDoj());
            ps.setString(4, emp.getGender());
            ps.setDouble(5, emp.getBsalary());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── READ ALL ─────────────────────────────────────────────────────────────
    public List<Employee> getAllEmployees() throws SQLException {
        String sql = "SELECT * FROM Employee ORDER BY Empno";
        List<Employee> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ─── READ ONE ─────────────────────────────────────────────────────────────
    public Employee getEmployeeById(int empno) throws SQLException {
        String sql = "SELECT * FROM Employee WHERE Empno = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, empno);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────
    public boolean updateEmployee(Employee emp) throws SQLException {
        String sql = "UPDATE Employee SET EmpName=?, DoJ=?, Gender=?, Bsalary=? WHERE Empno=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, emp.getEmpName());
            ps.setDate(2, emp.getDoj());
            ps.setString(3, emp.getGender());
            ps.setDouble(4, emp.getBsalary());
            ps.setInt(5, emp.getEmpno());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────
    public boolean deleteEmployee(int empno) throws SQLException {
        String sql = "DELETE FROM Employee WHERE Empno = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, empno);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── CHECK DUPLICATE EMPNO ───────────────────────────────────────────────
    public boolean empnoExists(int empno) throws SQLException {
        String sql = "SELECT 1 FROM Employee WHERE Empno = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, empno);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ─── REPORT 1 : Names starting with a letter ─────────────────────────────
    public List<Employee> getEmployeesByNamePrefix(String prefix) throws SQLException {
        String sql = "SELECT * FROM Employee WHERE EmpName LIKE ? ORDER BY EmpName";
        List<Employee> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ─── REPORT 2 : N or more years of service ───────────────────────────────
    public List<Employee> getEmployeesByYearsOfService(int years) throws SQLException {
        String sql = "SELECT * FROM Employee WHERE TIMESTAMPDIFF(YEAR, DoJ, CURDATE()) >= ? ORDER BY DoJ";
        List<Employee> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, years);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ─── REPORT 3 : Salary greater than threshold ────────────────────────────
    public List<Employee> getEmployeesBySalaryAbove(double salary) throws SQLException {
        String sql = "SELECT * FROM Employee WHERE Bsalary > ? ORDER BY Bsalary DESC";
        List<Employee> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, salary);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ─── HELPER ──────────────────────────────────────────────────────────────
    private Employee mapRow(ResultSet rs) throws SQLException {
        return new Employee(
            rs.getInt("Empno"),
            rs.getString("EmpName"),
            rs.getDate("DoJ"),
            rs.getString("Gender"),
            rs.getDouble("Bsalary")
        );
    }
}
