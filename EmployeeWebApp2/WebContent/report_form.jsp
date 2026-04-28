<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="WEB-INF/header.jspf" %>

<div class="breadcrumb">
  <a href="index.jsp">🏠 Dashboard</a> &rsaquo; Reports
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger"><span class="alert-icon">❌</span> ${error}</div>
</c:if>

<div class="card">
  <div class="card-title"><span class="icon">📊</span> Generate Report</div>

  <form id="reportForm" action="ReportServlet" method="post" novalidate>

    <div class="form-group" style="margin-bottom:1.5rem">
      <label>Report Type *</label>
      <div style="display:flex;flex-direction:column;gap:.75rem;margin-top:.5rem">

        <label style="display:flex;align-items:center;gap:.75rem;font-size:.95rem;font-weight:400;
                      padding:.9rem 1.2rem;border:2px solid var(--border);border-radius:10px;cursor:pointer;
                      transition:border-color .2s" class="radio-card">
          <input type="radio" name="reportType" value="byLetter" id="r1"
                 ${reportType == 'byLetter' ? 'checked' : ''} onchange="showPanel()">
          <div>
            <div style="font-weight:600">🔤 By Name Prefix</div>
            <div style="font-size:.8rem;color:var(--muted)">Employees whose names start with a specific letter</div>
          </div>
        </label>

        <label style="display:flex;align-items:center;gap:.75rem;font-size:.95rem;font-weight:400;
                      padding:.9rem 1.2rem;border:2px solid var(--border);border-radius:10px;cursor:pointer;
                      transition:border-color .2s" class="radio-card">
          <input type="radio" name="reportType" value="byYears" id="r2"
                 ${reportType == 'byYears' ? 'checked' : ''} onchange="showPanel()">
          <div>
            <div style="font-weight:600">📅 By Years of Service</div>
            <div style="font-size:.8rem;color:var(--muted)">Employees with N or more years of service</div>
          </div>
        </label>

        <label style="display:flex;align-items:center;gap:.75rem;font-size:.95rem;font-weight:400;
                      padding:.9rem 1.2rem;border:2px solid var(--border);border-radius:10px;cursor:pointer;
                      transition:border-color .2s" class="radio-card">
          <input type="radio" name="reportType" value="bySalary" id="r3"
                 ${reportType == 'bySalary' ? 'checked' : ''} onchange="showPanel()">
          <div>
            <div style="font-weight:600">💰 By Salary Threshold</div>
            <div style="font-size:.8rem;color:var(--muted)">Employees earning more than a specified amount</div>
          </div>
        </label>

      </div>
      <span class="field-error" id="err-reportType"></span>
    </div>

    <!-- Panel: By Letter -->
    <div id="panel-byLetter" class="form-grid panel" style="display:none">
      <div class="form-group">
        <label for="letter">Starting Letter *</label>
        <input type="text" id="letter" name="letter" maxlength="1" placeholder="e.g. A"
               value="${letter}" style="text-transform:uppercase">
        <span class="field-error" id="err-letter"></span>
      </div>
    </div>

    <!-- Panel: By Years -->
    <div id="panel-byYears" class="form-grid panel" style="display:none">
      <div class="form-group">
        <label for="years">Minimum Years of Service *</label>
        <input type="number" id="years" name="years" min="0" placeholder="e.g. 5" value="${years}">
        <span class="field-error" id="err-years"></span>
      </div>
    </div>

    <!-- Panel: By Salary -->
    <div id="panel-bySalary" class="form-grid panel" style="display:none">
      <div class="form-group">
        <label for="salary">Salary Greater Than (₹) *</label>
        <input type="number" id="salary" name="salary" min="0" step="0.01" placeholder="e.g. 30000" value="${salary}">
        <span class="field-error" id="err-salary"></span>
      </div>
    </div>

    <div style="margin-top:1.5rem;display:flex;gap:1rem">
      <button type="submit" class="btn btn-success">📊 Generate Report</button>
      <button type="reset"  class="btn btn-outline" onclick="hideAll()">🔄 Reset</button>
    </div>

  </form>
</div>

<style>
  .radio-card:has(input:checked) { border-color: var(--primary); background: #eff6ff; }
</style>

<script>
  function showPanel() {
    document.querySelectorAll('.panel').forEach(p => p.style.display = 'none');
    const sel = document.querySelector('input[name="reportType"]:checked');
    if (sel) {
      const panel = document.getElementById('panel-' + sel.value);
      if (panel) panel.style.display = 'grid';
    }
  }
  function hideAll() {
    document.querySelectorAll('.panel').forEach(p => p.style.display = 'none');
  }
  // Init on load
  showPanel();

  document.getElementById('reportForm').addEventListener('submit', function(e) {
    const sel = document.querySelector('input[name="reportType"]:checked');
    if (!sel) {
      document.getElementById('err-reportType').textContent = 'Please select a report type.';
      e.preventDefault(); return;
    }
    let valid = true;
    if (sel.value === 'byLetter') {
      const l = document.getElementById('letter').value.trim();
      if (!l || !/^[A-Za-z]$/.test(l)) {
        document.getElementById('err-letter').textContent = 'Enter a single alphabet letter.';
        valid = false;
      }
    }
    if (sel.value === 'byYears') {
      const y = document.getElementById('years').value;
      if (y === '' || isNaN(y) || parseInt(y) < 0) {
        document.getElementById('err-years').textContent = 'Enter a valid non-negative number.';
        valid = false;
      }
    }
    if (sel.value === 'bySalary') {
      const s = document.getElementById('salary').value;
      if (s === '' || isNaN(s) || parseFloat(s) < 0) {
        document.getElementById('err-salary').textContent = 'Enter a valid non-negative salary.';
        valid = false;
      }
    }
    if (!valid) e.preventDefault();
  });
</script>

<%@include file="WEB-INF/footer.jspf" %>
