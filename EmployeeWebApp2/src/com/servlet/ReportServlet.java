package com.servlet;

import com.dao.EmployeeDAO;
import com.model.Employee;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {

    private final EmployeeDAO dao = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("report_form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String reportType = req.getParameter("reportType");

        if (reportType == null || reportType.isEmpty()) {
            req.setAttribute("error", "Please select a report type.");
            req.getRequestDispatcher("report_form.jsp").forward(req, resp);
            return;
        }

        List<Employee> results = null;
        String reportTitle = "";
        String reportDesc  = "";
        StringBuilder error = new StringBuilder();

        try {
            switch (reportType) {

                case "byLetter": {
                    String letter = req.getParameter("letter");
                    if (letter == null || letter.trim().isEmpty()) {
                        error.append("Please enter a starting letter.");
                    } else if (!letter.trim().matches("[A-Za-z]")) {
                        error.append("Starting value must be a single alphabet letter.");
                    } else {
                        String l = letter.trim().toUpperCase();
                        results      = dao.getEmployeesByNamePrefix(l);
                        reportTitle  = "Employees whose name starts with '" + l + "'";
                        reportDesc   = "Query: SELECT * FROM Employee WHERE EmpName LIKE '" + l + "%'";
                    }
                    break;
                }

                case "byYears": {
                    String yearsStr = req.getParameter("years");
                    if (yearsStr == null || yearsStr.trim().isEmpty()) {
                        error.append("Please enter number of years.");
                    } else {
                        try {
                            int years = Integer.parseInt(yearsStr.trim());
                            if (years < 0) error.append("Years cannot be negative.");
                            else {
                                results     = dao.getEmployeesByYearsOfService(years);
                                reportTitle = "Employees with " + years + " or more years of service";
                                reportDesc  = "Query: SELECT * FROM Employee WHERE TIMESTAMPDIFF(YEAR, DoJ, CURDATE()) >= " + years;
                            }
                        } catch (NumberFormatException e) {
                            error.append("Years must be a valid whole number.");
                        }
                    }
                    break;
                }

                case "bySalary": {
                    String salStr = req.getParameter("salary");
                    if (salStr == null || salStr.trim().isEmpty()) {
                        error.append("Please enter a salary threshold.");
                    } else {
                        try {
                            double sal = Double.parseDouble(salStr.trim());
                            if (sal < 0) error.append("Salary cannot be negative.");
                            else {
                                results     = dao.getEmployeesBySalaryAbove(sal);
                                reportTitle = "Employees earning more than ₹" + String.format("%,.2f", sal);
                                reportDesc  = "Query: SELECT * FROM Employee WHERE Bsalary > " + sal + " ORDER BY Bsalary DESC";
                            }
                        } catch (NumberFormatException e) {
                            error.append("Salary must be a valid number.");
                        }
                    }
                    break;
                }

                default:
                    error.append("Unknown report type selected.");
            }
        } catch (Exception e) {
            error.append("Database error: ").append(e.getMessage());
        }

        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            req.setAttribute("reportType", reportType);
            req.setAttribute("letter", req.getParameter("letter"));
            req.setAttribute("years",  req.getParameter("years"));
            req.setAttribute("salary", req.getParameter("salary"));
            req.getRequestDispatcher("report_form.jsp").forward(req, resp);
        } else {
            req.setAttribute("results",      results);
            req.setAttribute("reportTitle",  reportTitle);
            req.setAttribute("reportDesc",   reportDesc);
            req.getRequestDispatcher("report_result.jsp").forward(req, resp);
        }
    }
}
