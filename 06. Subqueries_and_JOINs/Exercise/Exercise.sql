use soft_uni;

-- 01. Employee Address
select e.employee_id, e.job_title, a.address_id, a.address_text from employees as e
	inner join addresses as a on e.address_id = a.address_id
    order by address_id
    limit 5;


-- 02. Addresses with Towns
select e.first_name, e.last_name, t.name as 'town', address_text from employees as e
	join addresses as a on e.address_id = a.address_id
    join towns as t on a.town_id = t.town_id
    order by e.first_name asc, e.last_name asc
    limit 5;

-- 03. Sales Employee
select e.employee_id, e.first_name, e.last_name, d.name as 'department_name' from employees as e
	join departments as d on e.department_id = d.department_id
    where d.name = 'Sales'
    order by e.employee_id desc;

-- 04. Employee Departments
select e.employee_id, e.first_name, e.salary, d.name as 'department_name' from employees as e
	join departments as d on e.department_id = d.department_id
    where e.salary > 15000
    order by e.department_id desc;

-- 05. Employees Without Project
select e.employee_id, e.first_name from employees as e
	left join employees_projects as ep on e.employee_id = ep.employee_id
    where ep.project_id is null
    order by e.employee_id desc
    limit 3;
-- The trick with this exercise is to identify the necessity for the left join
-- and also remember that left join pulls out all of the rows even if they are NULL
-- with this information we can make a simple WHERE to pull all of the rows who had
-- the NULL keyword (I can't call it value, since NULL is no value aka. 'no data')

-- 06. Employees Hired After
select e.first_name, e.last_name, e.hire_date, d.name as 'dept_name' from employees as e
	join departments as d on e.department_id = d.department_id
    where e.hire_date > '1999-01-01' and d.name in ('Sales', 'Finance')
    order by e.hire_date asc;

-- 07. Employees with Project
select e.employee_id, e.first_name, p.name as 'project_name' from employees as e
	join employees_projects as ep on e.employee_id = ep.employee_id
	left join projects as p on p.project_id = ep.project_id
    where date(p.start_date) > '2002-08-13' and p.end_date is null
    -- It wont work if you dont add the date function
    order by e.first_name asc, p.name asc
    limit 5;

-- 08. Employee 24
select e.employee_id, e.first_name, if(year(p.start_date) >= 2005, null, p.name) as 'project_name' from employees as e
	join employees_projects as ep on e.employee_id = ep.employee_id
    join projects as p on p.project_id = ep.project_id
    where e.employee_id = 24
    order by p.name;

-- 09. Employee Manager
select e.employee_id, e.first_name, e.manager_id, em.first_name as 'manager_name'
from employees as e
join employees as em on e.manager_id = em.employee_id
where e.manager_id in(3, 7)
order by e.first_name asc;

-- 10. Employee Summary
select e.employee_id, concat(e.first_name, ' ', e.last_name) as 'employee_name', concat(em.first_name, ' ', em.last_name) as 'manager_name', d.name as 'department_name'
from employees as e
join employees as em on e.manager_id = em.employee_id
join departments as d on e.department_id = d.department_id
order by e.employee_id asc
limit 5;

-- 11. Min Average Salary
select avg(salary) as 'min average salary' from employees 
group by department_id
order by avg(salary) asc
limit 1;

-- 12. Highest Peaks in Bulgaria
-- use geography;

select c.country_code, m.mountain_range, p.peak_name, p.elevation from countries as c
	join mountains_countries as mc on c.country_code = mc.country_code
    join mountains as m on m.id = mc.mountain_id
    join peaks as p on p.mountain_id = m.id
where p.elevation > 2835 and c.country_code = 'BG'
order by p.elevation desc;

-- 13. Count Mountain Ranges
select c.country_code, count(m.mountain_range) as 'mountain_range' from countries as c
	join mountains_countries as mc on c.country_code = mc.country_code
    join mountains as m on m.id = mc.mountain_id
    where c.country_code in ('BG', 'RU', 'US')
    group by c.country_code
    order by count(m.mountain_range) desc;

-- 14. Countries with Rivers
select c.country_name, r.river_name from countries as c
	left join countries_rivers as cr on c.country_code = cr.country_code
    left join rivers as r on r.id = cr.river_id
    join continents as con on c.continent_code = con.continent_code
    where con.continent_name = 'Africa'
    order by c.country_name asc
    limit 5;
-- i dont get it, but it works
-- 15. Continents and Currencies

-- 16. Countries without any Mountains
select count(*) from countries as c
	left join mountains_countries as mc on c.country_code = mc.country_code
    where mc.mountain_id is null; 

-- 17. Highest Peak and Longest River by Country
select c.country_name, max(p.elevation) as 'highest_peak_elevation', max(r.length) as 'longest_river_length' 
from countries as c
	join mountains_countries as mc on c.country_code = mc.country_code
    join mountains as m on mc.mountain_id = m.id
    join peaks as p on m.id = p.mountain_id
    join countries_rivers as cr on c.country_code = cr.country_code
    join rivers as r on cr.river_id = r.id
    group by c.country_name
    order by max(p.elevation) desc, max(r.length) desc, c.country_name asc
    limit 5;

-- This doenst require to show NULL, but if Judge does want it, you can add IF to both
-- "highest_peak_elevation" and "longest_river_length" and give them NULL as the else

