-- use soft_uni;

-- User-defined Functions
-- There is always a divider, which by default is ";", delimiter adds a new custom divider
delimiter $$ 
create function ufn_select_5()
returns int
deterministic
begin
	return 5;
end$$
-- How to drop function
delimiter ;
drop function ufn_select_5;

-- How to call function
select ufn_select_5(); -- Call it like any built-in function like CONCAT

select * from towns where town_id < ufn_select_5();

-- Created Functions will show up in the same database it was created in in a tab called 'Functions'

-- Creating values for function to use
delimiter $$ 
create function ufn_append_before(str varchar(50))
returns varchar(75)
deterministic
begin
	return concat('Function ', str);
end$$
delimiter ;
;

select ufn_append_before('Test');

select ufn_append_before(first_name) from employees;

-- 01.Count Employees by Town

delimiter !
create function ufn_count_employees_by_town(`town_name` varchar(50))
returns int
deterministic
begin
	
    return (
		select count(*) from employees as e
			join addresses as a on e.address_id = a.address_id
			join towns as t on a.town_id = t.town_id
		where t.name = `town_name`
    ); 
end!
delimiter ;
;

select count(*) from employees as e
	join addresses as a on e.address_id = a.address_id
	join towns as t on a.town_id = t.town_id
where t.name = 'Redmond';

select ufn_count_employees_by_town('Redmond') as 'employees from Redmond';

delimiter !
create function ufn_return_var()
returns int
deterministic
begin
	declare result int;
    set result := 10;
    
    return result;
end!

delimiter ;
;
select ufn_return_var();

-- Stored Procedures aka. Stored Logics to execute operations without returning results

delimiter !
create procedure usp_select_employees(max_id int)
begin
	select * from employees where employee_id < max_id;
end !

delimiter ;
;

call usp_select_employees(3);
drop procedure usp_select_employees;

-- If we want a return of values from a procedure, we can use the OUTPUT parameter

-- 02. Employees Promotion

delimiter !
create procedure usp_raise_salaries(percent decimal(3,2), out total_increase decimal(19, 4))
begin
	declare actual_percent decimal(19,4);
	declare local_increase decimal(19,4);
    
    set actual_pecent = 1 + percent;
    set local_increase := (select abs(sum(salary) - sum(salary) * 1.10) from employees);
    set total_increase = local_increase;
    
    update employees set salary = salary * actual_percent;

end !
delimiter ;
;

set @increase = 0;
call usp_raise_salaries(0.1, @increase);
select @increase; 

select abs(sum(salary) - sum(salary) * 1.10) from employees;

-- Presentation Solution:
delimiter !
create procedure usp_raise_salaries(department_name varchar(50))
begin
	update employees as e
		join departments as d
        on e.department_id = d.department_id
        set salary = salary * 1.05
        where d.name = department_name;
end !
delimiter ;
;

-- Transactions
-- 03. Employees Promotion
-- it starts with START TRANSACTION
-- it reminds me of try, except in Python, atleast for me
-- its more familiar/similiar to try, catch, finally from JS

delimiter !
create procedure usp_transaction()
begin
	-- Initial state
	start transaction;
		update employees set first_name = 'Changed';
		update towns set name = 'change';
        update departments set name = 'Dep0';
    rollback; -- Return to initial state
    -- commit; -- Move to new state with changes applied
end !

delimiter ;
;

-- 04. Triggered / Triggers

create table deleted_employees(
	employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    job_title varchar(50),
    department_name varchar(50),
    hire_date timestamp(6),)
);

delimiter !
create trigger tr_after_delete_employees
after delete
on employees
for each row
begin
	
	insert into deleted_employees
    values (
		old.employee_id, 
		old.first_name,
		old.last_name,
		old.job_title,
        (select `name` from departments where id = old.department_id),
		old.hire_date
	);
end !
delimiter ;
;


