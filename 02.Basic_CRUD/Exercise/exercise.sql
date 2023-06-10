-- 1. Find All Information About Departments 
select * from departments as d order by d.department_id;

-- 2. Find all Department Names 
select name from departments as d order by d.department_id;

-- 3. Find salary of Each Employee 
select * from employees;
select first_name, last_name, salary from employees as e order by e.employee_id;

-- 4. Find Full Name of Each Employee
select first_name, middle_name, last_name
from employees as e order by e.employee_id;

-- 5. Find Email Address of Each Employee
select concat(`first_name`, '.', `last_name`, '@softuni.bg') 
as 'full_email_address'
from employees;

-- 6. Find All Different Employee's Salaries
select salary from employees order by employees.salary asc;
-- 7. Find all Information About Employees
select * from employees as e
where job_title = 'Sales Representative'
order by e.employee_id;

-- 8. Find Names of All Employees by salary in Range
select first_name, last_name, job_title from employees as e
WHERE e.salary >= 20000 and e.salary <= 30000;
 
-- 9. Find Names of All Employees
select concat(`first_name`, ' ', `middle_name`, ' ', `last_name`) as 'Full Name'
from employees as e
where salary = 25000 or salary = 14000 or salary = 12500 or salary = 23600;

-- 10. Find All Employees Without Manager
select first_name, last_name from employees as e
where manager_id is null;
-- 11. Find All Employees with salary More Than 50000
select first_name, last_name, salary from employees as e
where salary > 50000
order by e.salary desc;

-- 12. Find 5 Best Paid Employees 
select first_name, last_name from employees as e
order by e.salary desc
limit 5;

-- 13. Find All Employees Except Marketing
select first_name, last_name from employees as e
where not department_id = 4;

-- 14. Sort Employees Table
select * from employees
order by salary desc,
first_name asc,
last_name desc,
middle_name asc;
-- 15. Create View Employees with Salaries
create view v_employees_salaries as
select first_name, last_name, salary from employees;
select * from v_employees_salaries;
-- 16. Create View Employees with Job Titles
create view v_employees_job_titles as
select concat_ws(' ', `first_name`, `middle_name`, `last_name`) as 'full_name',
job_title from employees;

-- 17. Distinct Job Titles
select distinct job_title from employees 
order by employees.job_title asc;
-- 18. Find First 10 Started Projects
select * from projects as p
order by start_date,
name
limit 10;

-- 19. Last 7 Hired Employees
select first_name, last_name, hire_date from employees as e
order by e.hire_date desc
limit 7;

-- 20. Increase Salaries
 update employees as e
 set salary = salary + (salary * 0.12)
 where department_id in (1,2,4,11);
 
 select salary from employees; 
 
-- 21. All Mountain Peaks
select peak_name from peaks as p order by p.peak_name asc;

-- 22. Biggest Countries by Population
select country_name, population from countries as c
order by population desc,
country_name asc
limit 30;

-- 23. Countries and Currency (Euro / Not Euro) 
select * from countries;

select country_name, country_code, if(currency_code = 'EUR', 'Euro', 'Not Euro') from countries as c
order by c.country_name asc;

-- 24. All Diablo Characters  
select name from characters as c order by c.name asc;