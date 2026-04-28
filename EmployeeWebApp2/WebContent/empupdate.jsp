<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="WEB-INF/header.jspf" %>

<div class="breadcrumb">
  <a href="index.jsp">🏠 Dashboard</a> &rsaquo; Update Employee
</div>

<c:if test="${not empty success}">
  <div class="alert alert-success"><span class="alert-icon">✅</span> ${success}</div>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-danger"><span class="alert-icon">❌</span> ${error}</div>
</c:if>

<%-- Step 1: Search by Empno --%>
<div class="card">
  <div class="card-title"><span class="icon">🔍</span> Search Employee to Update</div>
  <form action="UpdateEmployeeServlet" method="get" id="searchForm">
    <div class="form-grid">
      <div class="form-group">
        <label for="searchEmpno">Employee Number *</label>
        <input type="number" id="searchEmpno" name="empno" placeholder="Enter Empno to search" min="1" required>
        <span class="field-error" id="err-search"></span>
      </div>
    </div>
    <div style="margin-top:1rem">
      <button type="submit" class="btn btn-primary">🔍 Find Employee</button>
    </div>
  </form>
</div>

<%-- Step 2: Edit form (shown only when employee is found) --%>
<c:if test="${not empty employee}">
<div class="card" style="border-left:4px solid var(--primary)">
  <div class="card-title"><span class="icon">✏️</span> Edit Employee #${employee.empno}</div>

  <form id="updateForm" action="UpdateEmployeeServlet" method="post" novalidate>
    <input type="hidden" name="empno" value="${employee.empno}">
    <div class="form-grid">

      <div class="form-group">
        <label>Employee Number</label>
        <input type="text" value="${employee.empno}" disabled style="background:#e2e8f0;cursor:not-allowed">
        <span style="font-size:.78rem;color:var(--muted)">Primary key – cannot be changed</span>
      </div>

      <div class="form-group">
        <label for="empName">Employee Name *</label>
        <input type="text" id="empName" name="empName" value="${employee.empName}"
               maxlength="100" required oninput="clearErr(this)">
        <span class="field-error" id="err-empName"></span>
      </div>

      <div class="form-group">
        <label for="doj">Date of Joining *</label>
        <input type="date" id="doj" name="doj" value="${employee.doj}" required oninput="clearErr(this)">
        <span class="field-error" id="err-doj"></span>
      </div>

      <div class="form-group">
        <label for="gender">Gender *</label>
        <select id="gender" name="gender" required onchange="clearErr(this)">
          <option value="">-- Select --</option>
          <option value="Male"   ${employee.gender == 'Male'   ? 'selected' : ''}>Male</option>
          <option value="Female" ${employee.gender == 'Female' ? 'selected' : ''}>Female</option>
          <option value="Other"  ${employee.gender == 'Other'  ? 'selected' : ''}>Other</option>
        </select>
        <span class="field-error" id="err-gender"></span>
      </div>

      <div class="form-group full">
        <label for="bsalary">Basic Salary (₹) *</label>
        <input type="number" id="bsalary" name="bsalary" value="${employee.bsalary}"
               min="0" step="0.01" required oninput="clearErr(this)">
        <span class="field-error" id="err-bsalary"></span>
      </div>

    </div>
    <div style="margin-top:1.5rem;display:flex;gap:1rem">
      <button type="submit" class="btn btn-primary">💾 Save Changes</button>
      <a href="DisplayEmployeeServlet" class="btn btn-outline">Cancel</a>
    </div>
  </form>
</div>
</c:if>

<script>
  document.getElementById('doj') && (document.getElementById('doj').max = new Date().toISOString().split('T')[0]);

  function clearErr(el) {
    const e = document.getElementById('err-' + el.id);
    if (e) e.textContent = '';
    el.classList.remove('error');
  }

  const form = document.getElementById('updateForm');
  if (form) {
    form.addEventListener('submit', function(e) {
      let valid = true;
      const empName = document.getElementById('empName');
      const doj     = document.getElementById('doj');
      const gender  = document.getElementById('gender');
      const bsal    = document.getElementById('bsalary');

      if (!empName.value.trim()) { showErr(empName,'err-empName','Name is required.'); valid=false; }
      if (!doj.value) { showErr(doj,'err-doj','Date of joining is required.'); valid=false; }
      else if (new Date(doj.value) > new Date()) { showErr(doj,'err-doj','Date cannot be in the future.'); valid=false; }
      if (!gender.value) { showErr(gender,'err-gender','Please select a gender.'); valid=false; }
      if (bsal.value===''||isNaN(bsal.value)||parseFloat(bsal.value)<0) { showErr(bsal,'err-bsalary','Enter a valid salary.'); valid=false; }
      if (!valid) e.preventDefault();
    });
  }

  function showErr(input, errId, msg) {
    input.classList.add('error');
    document.getElementById(errId).textContent = msg;
  }
</script>

<%@include file="WEB-INF/footer.jspf" %>
