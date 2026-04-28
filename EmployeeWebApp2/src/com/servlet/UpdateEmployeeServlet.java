package com.servlet;

import com.dao.EmployeeDAO;
import com.model.Employee;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/UpdateEmployeeServlet")
public class UpdateEmployeeServlet extends HttpServlet {

    private final EmployeeDAO dao = new EmployeeDAO();

    /** GET: load employee data for editing */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String empnoStr = req.getParameter("empno");
        if (empnoStr == null || empnoStr.trim().isEmpty()) {
            req.setAttribute("error", "Employee number is required for search.");
            req.getRequestDispatcher("empupdate.jsp").forward(req, resp);
            return;
        }

        try {
            int empno = Integer.parseInt(empnoStr.trim());
            Employee emp = dao.getEmployeeById(empno);
            if (emp == null) {
                req.setAttribute("error", "No employee found with Empno: " + empno);
            } else {
                req.setAttribute("employee", emp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid employee number.");
        } catch (Exception e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("empupdate.jsp").forward(req, resp);
    }

    /** POST: persist the update */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String empnoStr  = req.getParameter("empno").trim();
        String empName   = req.getParameter("empName").trim();
        String dojStr    = req.getParameter("doj").trim();
        String gender    = req.getParameter("gender").trim();
        String salaryStr = req.getParameter("bsalary").trim();

        StringBuilder error = new StringBuilder();
        int    empno   = 0;
        double bsalary = 0;
        Date   doj     = null;

        try { empno = Integer.parseInt(empnoStr); } catch (NumberFormatException e) { error.append("Invalid employee number. "); }

        if (empName.isEmpty()) error.append("Name is required. ");
        else if (empName.length() > 100) error.append("Name cannot exceed 100 characters. ");

        if (dojStr.isEmpty()) error.append("Date of joining is required. ");
        else {
            try { doj = Date.valueOf(dojStr);
                  if (doj.after(new Date(System.currentTimeMillis()))) error.append("Date cannot be in future. ");
            } catch (IllegalArgumentException e) { error.append("Invalid date format. "); }
        }

        if (gender.isEmpty()) error.append("Gender is required. ");

        try { bsalary = Double.parseDouble(salaryStr);
              if (bsalary < 0) error.append("Salary cannot be negative. ");
        } catch (NumberFormatException e) { error.append("Salary must be a valid number. "); }

        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            // Re-populate employee so the edit form stays visible
            Employee emp = new Employee(empno, empName, doj, gender, bsalary);
            req.setAttribute("employee", emp);
            req.getRequestDispatcher("empupdate.jsp").forward(req, resp);
            return;
        }

        try {
            Employee emp = new Employee(empno, empName, doj, gender, bsalary);
            if (dao.updateEmployee(emp)) {
                req.setAttribute("success", "Employee updated successfully!");
                req.setAttribute("employee", emp);
            } else {
                req.setAttribute("error", "Update failed – employee may not exist.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("empupdate.jsp").forward(req, resp);
    }
}
