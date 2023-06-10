
-- 01. Employees with Salary Above 35000
delimiter $$
create procedure usp_get_employees_salary_above_35000()
begin
	select first_name, last_name from employees
    where salary > 35000
    order by first_name, last_name, employee_id asc;
end $$
delimiter ;
;

call usp_get_employees_salary_above_35000();
drop procedure usp_get_employees_salary_above_35000;


-- 02. Employees with Salary Above Number
delimiter !
create procedure usp_get_employees_salary_above(salary_limit decimal(19,4))
begin
	select first_name, last_name from employees
    where salary >= salary_limit
    order by first_name, last_name, employee_id;
end !
delimiter ;

call usp_get_employees_salary_above(48100);

-- 03. Town Names Starting With
delimiter !
create procedure usp_get_towns_starting_with(letter varchar(30))
begin
	select `name` from towns
    where `name` like concat(letter, '%')
    order by `name`;
end !

delimiter ;

call usp_get_towns_starting_with('b');
-- select name from towns
-- where name like "b%";

-- 04. Employees from Town
delimiter !
create procedure usp_get_employees_from_town(town_name varchar(30))
begin
	select first_name, last_name from employees as e
    join addresses as a on e.address_id = a.address_id
    join towns as t on a.town_id = t.town_id
    where t.name = town_name
    order by first_name, last_name, employee_id;
end !
delimiter ;

select first_name, last_name from employees as e
    join addresses as a on e.address_id = a.address_id
    join towns as t on a.town_id = t.town_id
    where t.name = 'Sofia'
    order by first_name, last_name, employee_id;

-- 05. Salary Level Function
delimiter !
create function ufn_get_salary_level(salary_amount decimal(19, 4))
returns varchar(30)
deterministic
begin
	return (
		case
			when salary_amount < 30000 then 'Low'
            when salary_amount between 30000 and 50000 then 'Average'
            else 'High'
            end
    );
end !

delimiter ;
;

drop function ufn_get_salary_level;
select ufn_get_salary_level(444000);

-- 06. Employees by Salary Level
delimiter !
create procedure usp_get_employees_by_salary_level(salary_level varchar(30))
begin
	select first_name, last_name from employees
    where salary < 30000 and salary_level = 'Low'
    or salary between 30000 and 50000 and salary_level = 'Average'
    or salary > 50000 and salary_level = 'High'
    order by first_name desc, last_name desc;
end !

delimiter ;

drop procedure usp_get_employees_by_salary_level;
call usp_get_employees_by_salary_level('High');

-- 07. Define Function
delimiter !
create function ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
returns bit
deterministic
begin
	return word regexp(concat('^[', set_of_letters, ']+$'));
end !
delimiter ;

drop function ufn_is_word_comprised;
select ufn_is_word_comprised('oistmiahf', 'Sofia');


-- 08. Find Full Name
delimiter ! 
create procedure usp_get_holders_full_name()
begin
	select concat(first_name, ' ', last_name) as 'full_name' from account_holders
	order by `full_name`, id;
end !
delimiter ;

select concat(first_name, ' ', last_name) as 'full_name' from account_holders
order by `full_name`, id;

-- 09.People with Balance Higher Than (i dont have much time between work and study right now)
-- #TODO
-- 10. Future Value Function
delimiter !
create function ufn_calculate_future_value(initial_sum decimal(19,4), yearly_interest double, number_of_years int)
returns decimal(19,4)
deterministic
begin
	return initial_sum * pow((1 + yearly_interest), number_of_years);
end !
delimiter ;

create function ufn_calculate_future_value(initial_sum decimal(19,4), yearly_interest double, number_of_years int)
	returns decimal(19,4)
	return initial_sum * pow((1 + yearly_interest), number_of_years);

select 1000 * pow((1 + 0.50), 5);
select pow(2, 3);

-- 11. Calculating Interest
delimiter !
create procedure usp_calculate_future_value_for_account(account_id int, interest_rate decimal(19,4))
begin
	select a.id, ah.first_name, ah.last_name, a.balance as 'current_balance',
    ufn_calculate_future_value(a.balance, interest_rate, 5) as 'balance_in_5_years'
    from accounts as a
		join account_holders as ah on a.account_holder_id = ah.id
        where a.id = account_id;
end !

delimiter ;

-- ((truncate(a.balance * pow((1 + interest_rate), 5), 4))) 

select a.id, ah.first_name, ah.last_name, a.balance as 'current_balance', ((truncate(a.balance * pow((1 + 0.1), 5), 4))) as 'balance_in_5_years' from accounts a
	join account_holders as ah on a.account_holder_id = ah.id
    where a.id = 1;

drop procedure sp_calculate_future_value_for_account;
call usp_calculate_future_value_for_account(1, 0.1);

-- 12. Deposit Money
delimiter !
create procedure usp_deposit_money(account_id int, money_amount decimal(19,4))
begin 
	if money_amount > 0 then
    start transaction;
    
    update accounts as a
    set a.balance = a.balance + money_amount;
    
    commit;
    
    end if;
end !
delimiter ;

-- 13. Withdraw Money
delimiter !
create procedure usp_withdraw_money(account_id int, money_amount decimal(19,4))
begin
	if money_amount > 0 then
    start transaction;
    
    update accounts as a
    set a.balance = a.balance - money_amount
    where account_id = a.id;
    
		if (select balance from accounts where account_id = id) < 0
		then
			rollback;
		else
			commit;
		end if;
	end if;
end !

delimiter ;

-- 14. Money Transfer
delimiter !
create procedure usp_transfer_money(from_account_id int, to_account_id int, money_amount decimal(19,4))
begin
	if money_amount > 0
		and(select id from accounts where from_account_id = id) is not null
        and(select id from accounts where to_account_id = id) is not null
        and(select balance from accounts where from_account_id = id) >= money_amount
	then
		start transaction;
		update accounts
			set balance = balance - money_amount
            where id = from_account_id;
		update accounts
			set balance = balance + money_amount
            where id = to_account_id;
        
	end if;
end !
delimiter ;

drop procedure usp_transfer_money;
call usp_transfer_money(1, 2, 50);

select balance from accounts where id in(1,2);





