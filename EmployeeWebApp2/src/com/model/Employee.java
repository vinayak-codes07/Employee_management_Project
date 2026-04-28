package com.model;

import java.sql.Date;

public class Employee {
    private int empno;
    private String empName;
    private Date doj;
    private String gender;
    private double bsalary;

    public Employee() {}

    public Employee(int empno, String empName, Date doj, String gender, double bsalary) {
        this.empno = empno;
        this.empName = empName;
        this.doj = doj;
        this.gender = gender;
        this.bsalary = bsalary;
    }

    public int getEmpno() { return empno; }
    public void setEmpno(int empno) { this.empno = empno; }

    public String getEmpName() { return empName; }
    public void setEmpName(String empName) { this.empName = empName; }

    public Date getDoj() { return doj; }
    public void setDoj(Date doj) { this.doj = doj; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public double getBsalary() { return bsalary; }
    public void setBsalary(double bsalary) { this.bsalary = bsalary; }

    public int getYearsOfService() {
        java.util.Date now = new java.util.Date();
        long diff = now.getTime() - doj.getTime();
        return (int)(diff / (1000L * 60 * 60 * 24 * 365));
    }


    @Override
    public String toString() {
        return "Employee [empno=" + empno + ", empName=" + empName +
               ", doj=" + doj + ", gender=" + gender + ", bsalary=" + bsalary + "]";
    }
}
