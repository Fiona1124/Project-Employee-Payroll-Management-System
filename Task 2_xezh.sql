CREATE DATABASE payroll_database;
use payroll_database;
CREATE table employees(EMPLOYEE_ID int primary key, NAME varchar(50), DEPARTMENT varchar(50), EMAIL varchar(50), PHONE_NO numeric(15),JOINING_DATE date, 
SALARY numeric(10,2), BONUS numeric(10,2), TAX_PERCENTAGE numeric(5,2));
 insert into employees(EMPLOYEE_ID, NAME, DEPARTMENT, EMAIL, PHONE_NO, JOINING_DATE, SALARY, BONUS, TAX_PERCENTAGE) 
 values(1, "john", "HR", "123@gmail.com", "123456","2001-01-02",50000.00,10000.00,"10.00"), 
 (2,"Jane", "Finance",  "124@gmail.com", "123457","2002-04-05",60000.00,10000.00,"6.00"), 
 (3,"Jack", "IT",  "125@gmail.com", "123458","2005-09-01",60000.00,10000.00,"6.00"),
 (4,"Bob", "Engineer","126@gmail.com", "123358","2009-06-01",62000.00,12000.00,"6.00"),
 (5,"Emily","HR","127@gmail.com", "123398","2011-03-21",64000.00,11000.00,"6.00"),
 (6,"Davis","Finance","134@gmail.com", "113457","2011-09-05",62000.00,9000.00,"6.00"),
 (7,"Mavis","Engineer","114@gmail.com", "123447","2014-07-05",80000.00,11000.00,"8.00"),
 (8,"Bill", "IT","156@gmail.com", "110358","2021-06-08",92000.00,30000.00,"6.00"),
 (9,"Beber", "Sales","106@gmail.com", "113348","2025-05-01",70000.00,50000.00,"7.00"),
 (10,"Lily", "Sales","1106@gmail.com", "163348","2025-07-01",80000.00,40000.00,"7.00");
select * from employees;
# Payroll Queries:
# a) Retrieve the list of employees sorted by salary in descending order.
select name
from employees
order by salary desc;
# b) Find employees with a total compensation (salary+bonus) greater than $100,000.
select name
from employees
where salary+bonus>100000;
# c) Update the bonus for employees in the "Sales" department by 10%.
update employees set BONUS=BONUS*1.10 where DEPARTMENT="Sales";
# d) Calculate the net salary after deducting tax for all employees.
select EMPLOYEE_ID,NAME, DEPARTMENT, (SALARY+BONUS)*(1-TAX_PERCENTAGE/100) AS NET_SALARY
FROM employees;
# e) Retrieve the avg,min and max salary per department.
select DEPARTMENT,
       avg(SALARY) as avg_salary,
       min(SALARY) as min_salary,
       max(SALARY) as max_salary
from employees
group by DEPARTMENT;
# Advanced Queries:
# a) Retrieve employees who joined in the last 6 months.
select *
from employees
where JOINING_DATE>=DATE_SUB(CURDATE(),INTERVAL 6 MONTH);
# b) Group employees by department and count how many employees each has.
select DEPARTMENT,
       count(name) as EMPLOYEES_CNT
from employees
group by DEPARTMENT;
# c) Find the department with the highest avg salary.
# method 1
select distinct DEPARTMENT,
       avg(SALARY) over(partition by DEPARTMENT) AS MAX_AVG_SALARY
from employees
order by MAX_AVG_SALARY desc
LIMIT 1;
# method 2
select DEPARTMENT, avg(SALARY) as avg_salary
from employees
group by DEPARTMENT
having avg(SALARY)
order by avg_salary desc
LIMIT 1;
# d) Identify employees who have the same salary as at least one other employee.
select a.NAME,a.SALARY
from employees a
where a.SALARY in (select SALARY from employees b where a.SALARY=b.SALARY and a.NAME<>b.NAME);
# CTE
create temporary table employee_salary as(
select SALARY, NAME 
from employees);
select distinct es.NAME,es.SALARY
from employees es
join employee_salary ey on es.SALARY=ey.SALARY and es.NAME<>ey.NAME;