package com.servlet;

import com.dao.EmployeeDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteEmployeeServlet")
public class DeleteEmployeeServlet extends HttpServlet {

    private final EmployeeDAO dao = new EmployeeDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String empnoStr = req.getParameter("empno");

        if (empnoStr == null || empnoStr.trim().isEmpty()) {
            req.setAttribute("error", "Employee number is required.");
            req.getRequestDispatcher("empdelete.jsp").forward(req, resp);
            return;
        }

        try {
            int empno = Integer.parseInt(empnoStr.trim());
            if (empno <= 0) {
                req.setAttribute("error", "Employee number must be positive.");
                req.getRequestDispatcher("empdelete.jsp").forward(req, resp);
                return;
            }

            if (!dao.empnoExists(empno)) {
                req.setAttribute("error", "No employee found with Empno: " + empno);
            } else if (dao.deleteEmployee(empno)) {
                req.setAttribute("success", "Employee with Empno " + empno + " deleted successfully!");
            } else {
                req.setAttribute("error", "Delete operation failed. Please try again.");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid employee number format.");
        } catch (Exception e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("empdelete.jsp").forward(req, resp);
    }
}
