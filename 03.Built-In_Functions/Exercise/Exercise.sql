use soft_uni;

-- 01. Find Names of All Employees by First Name
select first_name, last_name from employees
where substring(first_name, 1, 2) = 'Sa'
order by employee_id;

-- 02. Find Names of All Employees by Last Name
select first_name, last_name from employees
where locate('ei', last_name)
order by employee_id;

-- 03. Find First Names of All Employess
select first_name from employees
where department_id in (3, 10) and -- not between 3 and 7 but the in(3, 10)
year(hire_date) between 1995 and 2005 
order by employee_id;

-- 04. Find All Employees Except Engineers
select first_name, last_name from employees
where lower(job_title) not like '%engineer%'
order by employee_id asc;


-- 05. Find Towns with Name Length
select name from towns
where char_length(name) in(5,6)
order by name asc;

-- 06. Find Towns Starting With
select town_id, name from towns
where lower(name) regexp '^[m,k,b,e]'
order by name;

-- 07. Find Towns Not Starting With
select town_id, name from towns
where lower(name) not regexp '^[r,b,d]'
order by name;

-- 08. Create View Employees Hired After
create view v_employees_hired_after_2000 as
select first_name, last_name from employees
where year(hire_date) > 2000;

drop view v_employees_hired_after_2000;

select * from employees;

select first_name, last_name from employees
where extract(year from hire_date) > 2000;

create view v_employees_hired_after_2000 as
select first_name, last_name from employees
where extract(year from hire_date) > 2000;

-- 09. Length of Last Name
select first_name, last_name from employees
where length(last_name) = 5;

-- 10. Countries Holding 'A'
use geography;
-- solution 1 complex, but interesting
select country_name, iso_code from countries
where (char_length(country_name) -
char_length(replace(lower(country_name), 'a', ''))) >= 3
order by iso_code;

-- solution 2 simpler
select country_name, iso_code from countries
where lower(country_name) like '%a%a%a%'
order by iso_code;

-- 11. Mix of Peak and River Names
select p.peak_name, r.river_name, 
lower(concat(left(p.peak_name, length(p.peak_name) - 1), r.river_name)) as mix
from rivers as r, peaks as p
where upper(right(p.peak_name, 1)) = upper(left(r.river_name, 1))
order by mix;
-- EXPLANATION: We make all of the characters lowercase, then we concatenate peak_name
-- and river_name, then we take all of the characters from the left, minus 1, and combine it
-- with the river name,
-- we compare and select the names where the last letter of peak is the same first letter of river
-- then we alphabetically order them by mix. 


-- 12. Games From 2011 and 2012 Year
use diablo;

select name, date_format(start,'%Y%-%m%-%d') from games -- google on how to format date
where year(start) in(2011,2012)
order by start,
name
limit 50;

-- 13. User Email Providers
select user_name, regexp_replace(email, '^[0-9a-z_.-]+@', '') as email_provider from users
order by email_provider asc, -- '.*@'
user_name;

-- 14. Get Users with IP Address Like Pattern
select user_name, ip_address from users
where ip_address like '___.1%.%.___'
order by user_name;

-- 15. Show All Games with Duration
select name as games,
case 
when hour(start) between 0 and 11 then 'Morning'
when hour(start) between 12 and 17 then 'Afternoon'
else 'Evening' 
end as 'Part of the Day',
case
when duration <= 3 then 'Extra Short'
when duration between 3 and 6 then 'Short'
when duration between 6 and 10 then 'Long'
else 'Extra Long'
end as 'Duration'
from games;

-- 16. Orders Table
select product_name, order_date, 
date_add(order_date, interval 3 day) as  pay_due, 
date_add(order_date, interval 1 month) as deliver_due from orders;


