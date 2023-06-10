use restaurant;

-- You know how (INNER) JOIN works from previous chapter

-- LEFT JOIN

select first_name, department_id, departments.name
from employees
	left join departments 
    on departments.id = employees.department_id;
    
-- RIGHT JOIN same as left, but right
-- examples are for nerds

-- Outer/Full JOIN, is not implemented, extremely rare
-- We use UNION LEFT RIGHT JOIN instead

select first_name, departments.name
from employees
left join departments on departments.id = employees.department_id

union

select first_name, departments.name
from employees
right join departments on departments.id = employees.department_id;

-- CROSS JOIN

select first_name, name
from employees
cross join departments;


-- 01. Managers
use soft_uni;

select e.employee_id as 'employee_id', concat(e.first_name, ' ', e.last_name) as 'full_name',
d.department_id as 'department_id',
d.name as 'department_name' from departments as d
	inner join employees as e on d.manager_id = e.employee_id
order by e.employee_id asc
limit 5;

-- 02. Towns Addresses
select * from addresses, towns;

select t.town_id, t.name as 'town_name', a.address_text from towns as t
	join addresses as a on t.town_id = a.town_id
    where t.name in('San Francisco', 'Sofia', 'Carnation')
    order by t.town_id, a.address_id;


-- 03. Employees Without Managers
select * from employees;

select employee_id, first_name, last_name, department_id, round(salary) as 'salary' from employees
where manager_id is null;

-- 04. Higher Salary


-- select round(avg(salary)) as 'average_sal', salary from employees
-- where salary > 'average_sal'
-- group by salary;

select count(*) as 'count' from employees
where salary > (
	select avg(salary) from employees
);


-- demo

select  *  from addresses
where town_id in (
	select town_id from towns where `name` like 'S%'
);

-- EXPLAIN




