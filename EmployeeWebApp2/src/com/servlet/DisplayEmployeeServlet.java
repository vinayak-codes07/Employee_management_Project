package com.servlet;

import com.dao.EmployeeDAO;
import com.model.Employee;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DisplayEmployeeServlet")
public class DisplayEmployeeServlet extends HttpServlet {

    private final EmployeeDAO dao = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Employee> employees = dao.getAllEmployees();
            req.setAttribute("employees", employees);
        } catch (Exception e) {
        	req.setAttribute("employees", new java.util.ArrayList<>());
            req.setAttribute("error", "Failed to fetch employees: " + e.getMessage());
        }
        req.getRequestDispatcher("empdisplay.jsp").forward(req, resp);
    }
}
