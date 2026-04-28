<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="WEB-INF/header.jspf" %>

<div class="breadcrumb">
  <a href="index.jsp">🏠 Dashboard</a> &rsaquo; View Employees
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger"><span class="alert-icon">❌</span> ${error}</div>
</c:if>

<div class="card">
  <div class="card-title">
    <span class="icon">👥</span> Employee Records
    <span style="margin-left:auto;font-size:.85rem;font-weight:500;color:var(--muted);">
      Total: ${employees.size()} employee(s)
    </span>
  </div>

  <div class="search-bar">
    <input type="text" id="searchInput" placeholder="🔍  Search by name or Empno…" oninput="filterTable()">
    <a href="empadd.jsp" class="btn btn-primary">➕ Add Employee</a>
  </div>

  <c:choose>
    <c:when test="${empty employees}">
      <div style="text-align:center;padding:3rem;color:var(--muted)">
        <div style="font-size:3rem">📭</div>
        <p style="margin-top:.5rem">No employees found.</p>
        <a href="empadd.jsp" class="btn btn-primary" style="margin-top:1rem">Add First Employee</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="table-wrap">
        <table id="empTable">
          <thead>
            <tr>
              <th>Emp No</th>
              <th>Name</th>
              <th>Date of Joining</th>
              <th>Years</th>
              <th>Gender</th>
              <th>Basic Salary (₹)</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="emp" items="${employees}">
              <tr>
                <td><strong>#${emp.empno}</strong></td>
                <td>${emp.empName}</td>
                <td><fmt:formatDate value="${emp.doj}" pattern="dd-MMM-yyyy"/></td>
                <td>${emp.yearsOfService} yr</td>
                <td>
                  <span class="badge badge-${emp.gender == 'Male' ? 'male' : emp.gender == 'Female' ? 'female' : 'other'}">
                    ${emp.gender}
                  </span>
                </td>
                <td><fmt:formatNumber value="${emp.bsalary}" type="currency" currencySymbol="₹"/></td>
                <td style="display:flex;gap:.4rem;flex-wrap:wrap">
                  <a href="UpdateEmployeeServlet?empno=${emp.empno}" class="btn btn-outline btn-sm">✏️</a>
                  <form action="DeleteEmployeeServlet" method="post" style="display:inline"
                        onsubmit="return confirm('Delete employee #${emp.empno} – ${emp.empName}?')">
                    <input type="hidden" name="empno" value="${emp.empno}">
                    <button type="submit" class="btn btn-danger btn-sm">🗑️</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<script>
function filterTable() {
  const q = document.getElementById('searchInput').value.toLowerCase();
  document.querySelectorAll('#empTable tbody tr').forEach(row => {
    row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
}
</script>

<%@include file="WEB-INF/footer.jspf" %>
