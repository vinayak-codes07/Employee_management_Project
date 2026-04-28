<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="WEB-INF/header.jspf" %>

<div class="breadcrumb">
  <a href="index.jsp">🏠 Dashboard</a> &rsaquo;
  <a href="ReportServlet">Reports</a> &rsaquo; Result
</div>

<div class="card">
  <div class="card-title"><span class="icon">📊</span> ${reportTitle}</div>

  <!-- SQL Query box -->
  <div style="background:#1e293b;color:#93c5fd;font-family:monospace;font-size:.85rem;
              padding:1rem 1.2rem;border-radius:8px;margin-bottom:1.5rem;overflow-x:auto;">
    <span style="color:#64748b">-- SQL Query executed</span><br>
    ${reportDesc}
  </div>

  <c:choose>
    <c:when test="${empty results}">
      <div style="text-align:center;padding:3rem;color:var(--muted)">
        <div style="font-size:3rem">🔍</div>
        <p style="margin-top:.5rem">No employees match this criteria.</p>
        <a href="ReportServlet" class="btn btn-outline" style="margin-top:1rem">← Back to Reports</a>
      </div>
    </c:when>
    <c:otherwise>
      <div style="margin-bottom:1rem;display:flex;justify-content:space-between;align-items:center">
        <span style="color:var(--muted);font-size:.9rem">${results.size()} record(s) found</span>
        <a href="ReportServlet" class="btn btn-outline btn-sm">← New Report</a>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>#</th><th>Emp No</th><th>Name</th><th>Date of Joining</th>
              <th>Gender</th><th>Basic Salary (₹)</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="emp" items="${results}" varStatus="st">
              <tr>
                <td style="color:var(--muted)">${st.count}</td>
                <td><strong>#${emp.empno}</strong></td>
                <td>${emp.empName}</td>
                <td><fmt:formatDate value="${emp.doj}" pattern="dd-MMM-yyyy"/></td>
                <td>
                  <span class="badge badge-${emp.gender == 'Male' ? 'male' : emp.gender == 'Female' ? 'female' : 'other'}">
                    ${emp.gender}
                  </span>
                </td>
                <td><fmt:formatNumber value="${emp.bsalary}" type="currency" currencySymbol="₹"/></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<%@include file="WEB-INF/footer.jspf" %>
