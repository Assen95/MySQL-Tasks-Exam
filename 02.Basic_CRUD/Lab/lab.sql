SELECT 
    CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name',
    job_title AS 'Job Title',
    salary AS 'Salary'
FROM
    employees
WHERE
    salary > 1000
ORDER BY employees.id;

-- task
select id, first_name, department_id
from employees
where department_id = 1 or department_id = 2;

-- task 2
SELECT 
    *
FROM
    employees AS e
WHERE
    e.department_id = 4 AND e.salary >= 1000;
    
-- create a view 
CREATE VIEW `v_hr_result_set` AS
    SELECT 
        CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name',
        `salary`
    FROM
        `employees`
    ORDER BY department_id;

select * from `v_hr_result_set`;

-- problem: top paid employee
CREATE VIEW `top_paid_employee` AS
    SELECT 
        *
    FROM
        employees
    ORDER BY salary DESC
    LIMIT 1;

SELECT 
    *
FROM
    top_paid_employee;
    

-- INSERT INTO introduction
-- general insert
insert into employees values(11, 'First', 'Last', 'Job', 2, 1100);

-- insert with specified fields to insert, they must be allowed to be "null" to be ignored 
insert into employees(first_name, job_title, department_id, salary)
values('George', 'Chef', 3, 2200);

-- insert multiple rows into employees 
insert into employees(first_name, job_title, department_id, salary)
values
	('Person1', 'Job1', 1, 1100),
	('Person2', 'Job2', 2, 1200),
	('Person3', 'Job3', 3, 1300),
	('Person4', 'Job4', 4, 1400);

-- tutorial on UPDATE -- problem Update Employees Salary
update employees
set salary = salary * 1.10
where job_title = 'Manager';

select salary from employees;

-- DELETE Tutorial
-- Its good practice to check what you are going to delete beforehand, in order to make sure not to delete sth important or if the action would be redundant
select * from employees where id > 11;

delete from employees
where id > 11;





