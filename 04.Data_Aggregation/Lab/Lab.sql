-- 04. Data Aggregation Lab



-- GROUP BY
select * from employees as e
order by e.department_id;

select * from employees group by department_id;

-- Problem: Department Total Salaries
select department_id, sum(salary) as 'Total Salaries'
from employees
group by department_id;

-- Aggregate Functions
-- MIN
select department_id, min(salary) as 'MinSalary'
from employees
group by department_id;

-- MAX
select department_id, max(salary) as 'MaxSalary'
from employees
group by department_id;

-- AVG
select department_id, avg(salary) as 'AverageSalary'
from employees
group by department_id;

-- COUNT
select count(id)
from employees;

alter table employees
change column salary salary double;

update employees
set last_name = NULL
where id in (2,4,6,8);

select department_id, count(id)
from employees
group by department_id;

-- SUM
select department_id, sum(salary) from employees
group by department_id;

select 
	sum(salary) as 'TotalSalary',
    count(*) as 'TotalEmployees',
    sum(salary) / count(*) as 'Total/Total',
    avg(salary) as  'Average',
    sum(salary) / count(salary) as 'Total / Salary'
from employees;

-- 01. Departments Info
select department_id, count(*) as 'Number of employees'
from employees
group by department_id;

-- 02. Average Salary
select department_id, round(avg(salary), 2) as 'Average Salary'
from employees
group by department_id;

-- 03. Min Salary
select department_id, round(min(salary)) from employees
where salary > 800
group by department_id;

-- This is the actual solution
select department_id, min(salary) from employees
group by department_id
having min(salary) > 800;

select department_id, min(salary) as 'Min Salary' from employees
group by department_id
having `Min Salary` > 800;

-- 04. Appetizers Count
select count(*) from products
where category_id = 2 and price > 8;

-- 05. Menu Prices
select category_id, 
round(avg(price), 2) as 'Average Price',
min(price) as 'Cheapest Product',
max(price) as 'Most Expensive Product'
from products
group by category_id;