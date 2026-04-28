<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql"  prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@include file="WEB-INF/header.jspf" %>

<sql:setDataSource
    url="jdbc:mysql://localhost:3306/employeedb?useSSL=false&serverTimezone=UTC"
    driver="com.mysql.cj.jdbc.Driver"
    user="root" password="suvin2006" var="ds"/>

<sql:query dataSource="${ds}" var="stats">
    SELECT COUNT(*) AS total,
           COALESCE(MAX(Bsalary),0) AS maxSal,
           COALESCE(MIN(Bsalary),0) AS minSal,
           COALESCE(AVG(Bsalary),0) AS avgSal
    FROM Employee
</sql:query>
<c:set var="row" value="${stats.rows[0]}"/>

<div class="breadcrumb">🏠 Dashboard</div>

<div class="stats-row">
  <div class="stat-card">
    <div class="stat-label">Total Employees</div>
    <div class="stat-val">${row.total}</div>
  </div>
  <div class="stat-card">
    <div class="stat-label">Highest Salary</div>
    <div class="stat-val">₹<fmt:formatNumber value="${row.maxSal}" maxFractionDigits="0"/></div>
  </div>
  <div class="stat-card">
    <div class="stat-label">Lowest Salary</div>
    <div class="stat-val">₹<fmt:formatNumber value="${row.minSal}" maxFractionDigits="0"/></div>
  </div>
  <div class="stat-card">
    <div class="stat-label">Average Salary</div>
    <div class="stat-val">₹<fmt:formatNumber value="${row.avgSal}" maxFractionDigits="0"/></div>
  </div>
</div>

<div class="card">
  <div class="card-title"><span class="icon">🚀</span> Quick Actions</div>
  <div style="display:flex;gap:1rem;flex-wrap:wrap;">
    <a href="empadd.jsp"            class="btn btn-primary">➕ Add Employee</a>
    <a href="DisplayEmployeeServlet"class="btn btn-outline">👁️ View All</a>
    <a href="empupdate.jsp"         class="btn btn-outline">✏️ Update</a>
    <a href="empdelete.jsp"         class="btn btn-danger">🗑️ Delete</a>
    <a href="ReportServlet"         class="btn btn-success">📊 Reports</a>
  </div>
</div>

<div class="card">
  <div class="card-title"><span class="icon">👥</span> Recent Employees</div>
  <sql:query dataSource="${ds}" var="recent">
    SELECT * FROM Employee ORDER BY Empno DESC LIMIT 5
  </sql:query>
  <c:choose>
    <c:when test="${recent.rowCount == 0}">
      <p style="color:var(--muted);text-align:center;padding:2rem">No employees found. <a href="empadd.jsp">Add one now →</a></p>
    </c:when>
    <c:otherwise>
      <div class="table-wrap">
        <table>
          <thead><tr>
            <th>Emp No</th><th>Name</th><th>Date of Joining</th><th>Gender</th><th>Basic Salary (₹)</th><th>Actions</th>
          </tr></thead>
          <tbody>
          <c:forEach var="e" items="${recent.rows}">
            <tr>
              <td><strong>#${e.Empno}</strong></td>
              <td>${e.EmpName}</td>
              <td>${e.DoJ}</td>
              <td>
                <span class="badge badge-${e.Gender == 'Male' ? 'male' : e.Gender == 'Female' ? 'female' : 'other'}">${e.Gender}</span>
              </td>
              <td><fmt:formatNumber value="${e.Bsalary}" type="currency" currencySymbol="₹"/></td>
              <td>
                <a href="UpdateEmployeeServlet?empno=${e.Empno}" class="btn btn-outline btn-sm">✏️ Edit</a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
      <div style="margin-top:1rem">
        <a href="DisplayEmployeeServlet" class="btn btn-outline">View All Employees →</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<%@include file="WEB-INF/footer.jspf" %>
