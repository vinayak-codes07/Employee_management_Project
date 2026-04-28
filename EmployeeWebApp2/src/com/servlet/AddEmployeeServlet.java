package com.servlet;

import com.dao.EmployeeDAO;
import com.model.Employee;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet {

    private final EmployeeDAO dao = new EmployeeDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ── Collect & validate ───────────────────────────────────────────────
        String empnoStr   = req.getParameter("empno").trim();
        String empName    = req.getParameter("empName").trim();
        String dojStr     = req.getParameter("doj").trim();
        String gender     = req.getParameter("gender").trim();
        String salaryStr  = req.getParameter("bsalary").trim();

        StringBuilder error = new StringBuilder();

        int    empno   = 0;
        double bsalary = 0;
        Date   doj     = null;

        if (empnoStr.isEmpty())  error.append("Employee number is required. ");
        else {
            try { empno = Integer.parseInt(empnoStr);
                  if (empno <= 0) error.append("Employee number must be positive. ");
            } catch (NumberFormatException e) { error.append("Employee number must be a valid integer. "); }
        }

        if (empName.isEmpty())   error.append("Employee name is required. ");
        else if (empName.length() > 100) error.append("Name cannot exceed 100 characters. ");

        if (dojStr.isEmpty())    error.append("Date of joining is required. ");
        else {
            try { doj = Date.valueOf(dojStr);
                  if (doj.after(new Date(System.currentTimeMillis()))) error.append("Date of joining cannot be in the future. ");
            } catch (IllegalArgumentException e) { error.append("Invalid date format (use YYYY-MM-DD). "); }
        }

        if (gender.isEmpty())    error.append("Gender is required. ");

        if (salaryStr.isEmpty()) error.append("Basic salary is required. ");
        else {
            try { bsalary = Double.parseDouble(salaryStr);
                  if (bsalary < 0) error.append("Salary cannot be negative. ");
            } catch (NumberFormatException e) { error.append("Salary must be a valid number. "); }
        }

        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            req.setAttribute("prev_empno",   empnoStr);
            req.setAttribute("prev_empName", empName);
            req.setAttribute("prev_doj",     dojStr);
            req.setAttribute("prev_gender",  gender);
            req.setAttribute("prev_bsalary", salaryStr);
            req.getRequestDispatcher("empadd.jsp").forward(req, resp);
            return;
        }

        // ── Duplicate check ───────────────────────────────────────────────────
        try {
            if (dao.empnoExists(empno)) {
                req.setAttribute("error", "Employee with Empno " + empno + " already exists.");
                req.setAttribute("prev_empno",   empnoStr);
                req.setAttribute("prev_empName", empName);
                req.setAttribute("prev_doj",     dojStr);
                req.setAttribute("prev_gender",  gender);
                req.setAttribute("prev_bsalary", salaryStr);
                req.getRequestDispatcher("empadd.jsp").forward(req, resp);
                return;
            }

            Employee emp = new Employee(empno, empName, doj, gender, bsalary);
            if (dao.addEmployee(emp)) {
                req.setAttribute("success", "Employee added successfully!");
            } else {
                req.setAttribute("error", "Failed to add employee. Please try again.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("empadd.jsp").forward(req, resp);
    }
}
