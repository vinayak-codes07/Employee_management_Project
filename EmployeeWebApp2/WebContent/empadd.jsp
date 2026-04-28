<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="WEB-INF/header.jspf" %>

<div class="breadcrumb">
  <a href="index.jsp">🏠 Dashboard</a> &rsaquo; Add Employee
</div>

<c:if test="${not empty success}">
  <div class="alert alert-success"><span class="alert-icon">✅</span> ${success}</div>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-danger"><span class="alert-icon">❌</span> ${error}</div>
</c:if>

<div class="card">
  <div class="card-title"><span class="icon">➕</span> Add New Employee</div>

  <form id="addForm" action="AddEmployeeServlet" method="post" novalidate>
    <div class="form-grid">

      <div class="form-group">
        <label for="empno">Employee Number *</label>
        <input type="number" id="empno" name="empno" placeholder="e.g. 1001"
               min="1" required oninput="clearErr(this)" value="${prev_empno}">
        <span class="field-error" id="err-empno"></span>
      </div>

      <div class="form-group">
        <label for="empName">Employee Name *</label>
        <input type="text" id="empName" name="empName" placeholder="Full Name"
               maxlength="100" required oninput="clearErr(this)" value="${prev_empName}">
        <span class="field-error" id="err-empName"></span>
      </div>

      <div class="form-group">
        <label for="doj">Date of Joining *</label>
        <input type="date" id="doj" name="doj" required
               oninput="clearErr(this)" value="${prev_doj}">
        <span class="field-error" id="err-doj"></span>
      </div>

      <div class="form-group">
        <label for="gender">Gender *</label>
        <select id="gender" name="gender" required onchange="clearErr(this)">
          <option value="">-- Select Gender --</option>
          <option value="Male"   ${prev_gender == 'Male'   ? 'selected' : ''}>Male</option>
          <option value="Female" ${prev_gender == 'Female' ? 'selected' : ''}>Female</option>
          <option value="Other"  ${prev_gender == 'Other'  ? 'selected' : ''}>Other</option>
        </select>
        <span class="field-error" id="err-gender"></span>
      </div>

      <div class="form-group full">
        <label for="bsalary">Basic Salary (₹) *</label>
        <input type="number" id="bsalary" name="bsalary" placeholder="e.g. 50000"
               min="0" step="0.01" required oninput="clearErr(this)" value="${prev_bsalary}">
        <span class="field-error" id="err-bsalary"></span>
      </div>

    </div><!-- .form-grid -->

    <div style="margin-top:1.5rem; display:flex; gap:1rem;">
      <button type="submit" class="btn btn-primary">➕ Add Employee</button>
      <button type="reset"  class="btn btn-outline">🔄 Reset</button>
    </div>
  </form>
</div>

<script>
  // Set max date to today
  document.getElementById('doj').max = new Date().toISOString().split('T')[0];

  function clearErr(el) {
    const err = document.getElementById('err-' + el.id);
    if (err) err.textContent = '';
    el.classList.remove('error');
  }

  document.getElementById('addForm').addEventListener('submit', function(e) {
    let valid = true;

    const empno   = document.getElementById('empno');
    const empName = document.getElementById('empName');
    const doj     = document.getElementById('doj');
    const gender  = document.getElementById('gender');
    const bsal    = document.getElementById('bsalary');

    if (!empno.value || isNaN(empno.value) || parseInt(empno.value) <= 0) {
      showErr(empno, 'err-empno', 'Please enter a valid positive employee number.');
      valid = false;
    }
    if (!empName.value.trim()) {
      showErr(empName, 'err-empName', 'Employee name is required.');
      valid = false;
    } else if (empName.value.trim().length > 100) {
      showErr(empName, 'err-empName', 'Name cannot exceed 100 characters.');
      valid = false;
    }
    if (!doj.value) {
      showErr(doj, 'err-doj', 'Date of joining is required.');
      valid = false;
    } else if (new Date(doj.value) > new Date()) {
      showErr(doj, 'err-doj', 'Date of joining cannot be in the future.');
      valid = false;
    }
    if (!gender.value) {
      showErr(gender, 'err-gender', 'Please select a gender.');
      valid = false;
    }
    if (bsal.value === '' || isNaN(bsal.value) || parseFloat(bsal.value) < 0) {
      showErr(bsal, 'err-bsalary', 'Please enter a valid non-negative salary.');
      valid = false;
    }

    if (!valid) e.preventDefault();
  });

  function showErr(input, errId, msg) {
    input.classList.add('error');
    document.getElementById(errId).textContent = msg;
    input.focus();
  }
</script>

<%@include file="WEB-INF/footer.jspf" %>
