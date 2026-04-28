<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="WEB-INF/header.jspf" %>

<div class="breadcrumb">
  <a href="index.jsp">🏠 Dashboard</a> &rsaquo; Delete Employee
</div>

<c:if test="${not empty success}">
  <div class="alert alert-success"><span class="alert-icon">✅</span> ${success}</div>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-danger"><span class="alert-icon">❌</span> ${error}</div>
</c:if>

<div class="card" style="border-left:4px solid var(--danger)">
  <div class="card-title"><span class="icon">🗑️</span> Delete Employee</div>

  <div class="alert alert-danger" style="margin-bottom:1.5rem">
    <span class="alert-icon">⚠️</span>
    <span>This action is <strong>irreversible</strong>. Please make sure you have entered the correct Employee Number before proceeding.</span>
  </div>

  <form id="deleteForm" action="DeleteEmployeeServlet" method="post" novalidate>
    <div class="form-grid">
      <div class="form-group">
        <label for="empno">Employee Number *</label>
        <input type="number" id="empno" name="empno" placeholder="Enter Empno to delete" min="1" required>
        <span class="field-error" id="err-empno"></span>
      </div>
    </div>
    <div style="margin-top:1.5rem;display:flex;gap:1rem">
      <button type="submit" class="btn btn-danger">🗑️ Delete Employee</button>
      <a href="DisplayEmployeeServlet" class="btn btn-outline">Cancel</a>
    </div>
  </form>
</div>

<script>
  document.getElementById('deleteForm').addEventListener('submit', function(e) {
    const empno = document.getElementById('empno');
    if (!empno.value || isNaN(empno.value) || parseInt(empno.value) <= 0) {
      empno.classList.add('error');
      document.getElementById('err-empno').textContent = 'Please enter a valid positive employee number.';
      e.preventDefault();
      return;
    }
    if (!confirm('Are you sure you want to permanently delete Employee #' + empno.value + '?')) {
      e.preventDefault();
    }
  });
</script>

<%@include file="WEB-INF/footer.jspf" %>
