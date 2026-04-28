# Employee Salary Management System
### Java EE | JSP | JDBC | MySQL | MVC Architecture

---

## Project Overview

A full-stack **Dynamic Web Project** for managing employee salary records with:
- Complete **CRUD operations** (Add, View, Update, Delete)
- **3 Report modules** with live SQL queries
- **Input validation** on both client (JavaScript) and server (Servlet)
- **MVC architecture** with Model, DAO, and Servlet layers
- Clean, professional **UI with responsive design**

---

## Tech Stack

| Layer       | Technology                          |
|-------------|-------------------------------------|
| Frontend    | HTML5, CSS3, JavaScript (ES6)       |
| Backend     | Java EE Servlets + JSP              |
| Database    | MySQL 8.x                           |
| Connectivity| JDBC (Prepared Statements)          |
| Server      | Apache Tomcat 9+                    |
| Build       | Eclipse IDE (Dynamic Web Project)   |

---

## Project Structure

```
EmployeeWebApp/
├── WebContent/
│   ├── index.jsp               ← Dashboard with live stats
│   ├── empadd.jsp              ← Add Employee (with validation)
│   ├── empdisplay.jsp          ← View All Employees (searchable table)
│   ├── empupdate.jsp           ← Search & Update Employee
│   ├── empdelete.jsp           ← Delete Employee (with confirmation)
│   ├── report_form.jsp         ← Report criteria selector
│   ├── report_result.jsp       ← Report results with SQL shown
│   └── WEB-INF/
│       ├── web.xml             ← Deployment descriptor
│       ├── header.jspf         ← Shared header + CSS + navbar
│       └── footer.jspf         ← Shared footer
│
├── src/com/
│   ├── model/
│   │   └── Employee.java       ← POJO / Model class
│   ├── dao/
│   │   ├── DBConnection.java   ← Singleton DB connection utility
│   │   └── EmployeeDAO.java    ← All DB operations (Prepared Statements)
│   └── servlet/
│       ├── AddEmployeeServlet.java
│       ├── UpdateEmployeeServlet.java
│       ├── DeleteEmployeeServlet.java
│       ├── DisplayEmployeeServlet.java
│       └── ReportServlet.java
│
└── database_setup.sql          ← DB schema + 15 sample records
```

---

## Setup Instructions

### Step 1 – MySQL Database

```sql
-- Open MySQL Workbench or CLI and run:
source /path/to/database_setup.sql
```

Or manually:
```sql
CREATE DATABASE employeedb;
USE employeedb;

CREATE TABLE Employee (
    Empno    INT           PRIMARY KEY,
    EmpName  VARCHAR(100)  NOT NULL,
    DoJ      DATE          NOT NULL,
    Gender   VARCHAR(10)   NOT NULL,
    Bsalary  DECIMAL(10,2) NOT NULL
);
```

### Step 2 – Configure DB Credentials

Edit `src/com/dao/DBConnection.java`:
```java
private static final String URL      = "jdbc:mysql://localhost:3306/employeedb?useSSL=false&serverTimezone=UTC";
private static final String USER     = "root";
private static final String PASSWORD = "your_password";   // ← change this
```

### Step 3 – Eclipse Setup

1. Open **Eclipse IDE for Enterprise Java Developers**
2. `File → Import → Existing Projects into Workspace`
3. Select the `EmployeeWebApp` folder
4. Add **MySQL JDBC Driver** to the build path:
   - Download `mysql-connector-java-8.x.x.jar` from [MySQL Downloads](https://dev.mysql.com/downloads/connector/j/)
   - Right-click project → `Build Path → Add External Archives…` → select the JAR
   - Also copy the JAR to `WebContent/WEB-INF/lib/`
5. Add **JSTL** JAR to `WEB-INF/lib/`:
   - `jakarta.servlet.jsp.jstl-2.0.0.jar` (or `jstl-1.2.jar` for older Tomcat)
6. Configure **Apache Tomcat 9+** in Eclipse:
   - `Window → Preferences → Server → Runtime Environments → Add → Apache Tomcat v9.0`
7. Right-click project → `Run As → Run on Server`

### Step 4 – Access the Application

Open your browser: **http://localhost:8080/EmployeeWebApp/**

---

## Modules & Features

### 1. Add Employee (`empadd.jsp` → `AddEmployeeServlet`)
- Collects: Empno, EmpName, DoJ, Gender, Bsalary
- **Client-side validation**: empty check, number check, future-date guard, duplicate prevention feedback
- **Server-side validation**: same checks + duplicate Empno check via DB query
- Uses **PreparedStatement** to prevent SQL injection

### 2. View Employees (`DisplayEmployeeServlet` → `empdisplay.jsp`)
- Displays all records in a styled table
- **Live search filter** (JavaScript)
- Shows gender badge, formatted salary, years of service
- Quick Edit / Delete buttons per row

### 3. Update Employee (`UpdateEmployeeServlet` GET + POST → `empupdate.jsp`)
- Two-step: search by Empno → form pre-filled with current data
- Empno shown as read-only (primary key protection)
- Full validation on update fields
- Confirmation on save

### 4. Delete Employee (`empdelete.jsp` → `DeleteEmployeeServlet`)
- Enter Empno → JS `confirm()` dialog before submit
- Server checks existence before deleting
- Clear success / error feedback

### 5. Reports (`ReportServlet` → `report_form.jsp` / `report_result.jsp`)

| Report | Criteria | SQL Pattern |
|--------|----------|-------------|
| By Name Prefix | Starting letter | `WHERE EmpName LIKE 'A%'` |
| By Service Years | N or more years | `WHERE TIMESTAMPDIFF(YEAR, DoJ, CURDATE()) >= N` |
| By Salary | Greater than amount | `WHERE Bsalary > amount ORDER BY Bsalary DESC` |

- SQL query **displayed on result page** for demo transparency
- Results shown in formatted table with record count

---

## Validation Summary

| Field    | Rules |
|----------|-------|
| Empno    | Required, positive integer, no duplicate |
| EmpName  | Required, max 100 chars |
| DoJ      | Required, valid date, not in future |
| Gender   | Required, one of Male/Female/Other |
| Bsalary  | Required, non-negative decimal |

Validation occurs at **two levels**:
- **JavaScript** (instant feedback before form submit)
- **Java Servlet** (server-side guard against bypassed validation)

---

## Demo Queries for Presentation

```sql
-- All employees
SELECT * FROM Employee ORDER BY Empno;

-- Report 1: Names starting with 'A'
SELECT * FROM Employee WHERE EmpName LIKE 'A%';

-- Report 2: 5+ years of service
SELECT * FROM Employee WHERE TIMESTAMPDIFF(YEAR, DoJ, CURDATE()) >= 5;

-- Report 3: Salary above ₹70,000
SELECT * FROM Employee WHERE Bsalary > 70000 ORDER BY Bsalary DESC;

-- Stats
SELECT COUNT(*) AS Total, MAX(Bsalary) AS MaxSal,
       MIN(Bsalary) AS MinSal, AVG(Bsalary) AS AvgSal
FROM Employee;
```

---

## Best Practices Followed

- ✅ **MVC Architecture** – Model, DAO, Servlet, JSP layers fully separated
- ✅ **PreparedStatement** – No string concatenation in SQL (SQL injection safe)
- ✅ **Try-with-resources** – Connection/Statement/ResultSet auto-closed
- ✅ **Exception Handling** – All DB operations wrapped in try-catch
- ✅ **Input Validation** – Both client-side (JS) and server-side (Servlet)
- ✅ **Responsive UI** – CSS Grid layout, sticky sidebar, mobile fallback
- ✅ **User Feedback** – Success/error alerts, confirmation dialogs
- ✅ **JSTL & EL** – No scriptlets in JSP files (clean separation)
