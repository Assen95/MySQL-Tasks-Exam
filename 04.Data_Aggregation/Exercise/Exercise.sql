SET SQL_SAFE_UPDATES = 0;

-- 01. Records’ Count
select count(*) from wizzard_deposits;

-- 02. Longest Magic Wand
select max(magic_wand_size) from wizzard_deposits;

-- 03. Longest Magic Wand per Deposit Groups
select deposit_group, max(magic_wand_size) as longest_magic_wand from wizzard_deposits
group by deposit_group
order by longest_magic_wand,
deposit_group;
-- This was terribly explained 

-- 04. Smallest Deposit Group per Magic Wand Size
select deposit_group from wizzard_deposits
group by deposit_group
having min(magic_wand_size)
limit 1;

-- 05. Deposits Sum
select deposit_group, sum(deposit_amount) as total_sum from wizzard_deposits
group by deposit_group
order by total_sum;

-- 06. Deposits Sum for Ollivander Family
select deposit_group, sum(deposit_amount) as total_sum from wizzard_deposits
where magic_wand_creator = 'Ollivander family'
group by deposit_group
order by deposit_group;

-- 07. Deposits Filter
select deposit_group, sum(deposit_amount) as total_sum from wizzard_deposits
where magic_wand_creator = 'Ollivander family'
group by deposit_group
having `total_sum` < 150000
order by `total_sum` desc;

-- 08. Deposit Charge
select deposit_group, magic_wand_creator, min(deposit_charge) as min_deposit_charge 
from wizzard_deposits
group by deposit_group,
magic_wand_creator
order by magic_wand_creator asc,
deposit_group asc;

-- 09. Age Groups
select case
	when age between 0 and 10 then '[0-10]'
	when age between 11 and 20 then '[11-20]'
	when age between 21 and 30 then '[21-30]'
	when age between 31 and 40 then '[31-40]'
	when age between 41 and 50 then '[41-50]'
	when age between 51 and 60 then '[51-60]'
	else '[61+]'
end as age_group,
count(*) as wizard_count
from wizzard_deposits
group by age_group
order by age_group asc;

-- 10. First Letter
select left(first_name, 1) as first_letter from wizzard_deposits
where deposit_group = 'Troll Chest'
group by first_letter
order by first_letter asc;

-- 11. Average Interest
select deposit_group, is_deposit_expired, avg(deposit_interest) from wizzard_deposits
where deposit_start_date > '1985-01-01'
group by deposit_group, is_deposit_expired
order by deposit_group desc, is_deposit_expired asc;

-- 12. Employees Minimum Salaries
use soft_uni;
select department_id, min(salary) from employees
where department_id in (2, 5, 7) and hire_date > '2000-01-01'
group by department_id
order by department_id asc;

-- 13. Employees Average Salaries

-- Create a new table with the higher-paid employees
create table `employees_salary_over_30000` as 
select * from employees
where salary > 30000;

-- Then delete all employees who have manager_id(42)
delete from `employees_salary_over_30000`
where manager_id = 42;

-- Then increase the salaries of all high paid employees with department_id(1) with 5000
update `employees_salary_over_30000`
set salary = salary + 5000
where department_id = 1;


-- Select the average salaraies in each department, sorted by department_id in asc
select department_id, avg(salary) as 'avg_salary' from `employees_salary_over_30000`
group by department_id
order by department_id;

-- 14. Employees Maximum Salaries
select department_id, max(salary) as max_salary from employees
group by department_id
having max_salary not between 30000 and 70000
order by department_id; 

-- 15. Employees Count Salaries
select count(*) from employees
where manager_id is null;

-- 16. 3rd Highest Salary
select distinct department_id, (
	select distinct salary from employees as e1
	where e1.department_id = e2.department_id
	order by salary desc
	limit 1 offset 2
) as 'third_highest_salary' 
from employees as e2
having `third_highest_salary` is not null
order by department_id asc;

SELECT DISTINCT `department_id`, (
				# третата най-висока заплата
                SELECT DISTINCT `salary` FROM `employees` e1
                WHERE e1.`department_id` = `employees`.`department_id`
                ORDER BY `salary` DESC
                LIMIT 1 OFFSET 2
		) AS 'third_highest_salary' 
FROM `employees`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY `department_id`;
 

-- 17. Salary Challenge
select first_name, last_name, department_id from employees as e1
where salary > (
	select avg(salary) from employees as e2
    where e1.department_id = e2.department_id
)
order by department_id, employee_id
limit 10;

-- 18. Departments Total Salaries
select department_id, sum(salary) as 'total_salary' from employees
group by department_id
order by department_id;