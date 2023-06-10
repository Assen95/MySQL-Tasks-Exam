create database `restaurants`;

use `restaurants`;

create table products(
	id int primary key auto_increment,
    name varchar(30) not null unique,
    type varchar(30) not null,
    price decimal(10,2) not null
);

create table clients(
	id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    birthdate date not null,
    card varchar(50),
    review text
);

create table `tables`(
	id int primary key auto_increment,
    floor int not null,
    reserved tinyint(1),
    capacity int not null
);

create table waiters(
	id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(50) not null,
    phone varchar(50),
    salary decimal(10,2)
);

create table orders(
	id int primary key auto_increment,
    table_id int not null,
    waiter_id int not null,
    order_time time not null,
    payed_status tinyint(1),
    constraint fk_orders_tables
		foreign key (table_id) references `tables`(id),
	constraint fk_orders_waiters
		foreign key (waiter_id) references waiters(id)
);

create table orders_clients(
	order_id int,
    client_id int,
    constraint fk_orders_clients_orders
    foreign key (order_id)
    references orders(id),
    constraint fk_orders_clients_clients
    foreign key (client_id)
    references clients(id)
);

create table orders_products(
	order_id int,
    product_id int,
    constraint fk_orders_products_orders
		foreign key (order_id) references orders(id),
	constraint fk_orders_products_products
		foreign key (product_id) references products(id)
);

-- 02. Insert


insert into products(name, type, price)
(
	select 
	concat(last_name, ' ', 'specialty') as 'name', 
	'Cocktail', 
	ceil(0.01 * salary)
	from waiters where id > 6
);

-- select concat(last_name, ' ', 'specialty') as 'name', 'Cocktail', ceil(0.01 * salary)
-- from waiters where id > 6;

-- 03. Update
select * from `orders` where id between 12 and 23;

update orders
set table_id = table_id - 1
where id between 12 and 23;

-- 04. Delete

select w.id, o.id from waiters as w
	left join orders as o on o.waiter_id = w.id
    where o.id is null;

select w.id, (select count(*) from orders where waiter_id = w.id) as o_count
from waiters as w 
having `o_count` = 0;

-- my solution
delete w from waiters as w
left join orders as o on o.waiter_id = w.id
where o.id is null;

-- teacher's solution
delete from waiters as w
where (select count(*) from orders where waiter_id = w.id) = 0;


-- 05. Clients

select * from clients
order by birthdate desc, id desc;


-- 06. Birthdate
select first_name, last_name, birthdate, review from clients
where card is null and year(birthdate) between 1978 and 1993
order by last_name desc, id asc
limit 5;

-- 07. Accounts
select 
concat(last_name, first_name, char_length(first_name), 'Restaurant') as 'username',
reverse(substring(email, 2, 12)) as 'password'
from waiters
where salary is not null
order by `password` desc;

-- 08. Top from menu
select p.id, p.name, count(op.order_id) as 'count' from products as p
	join orders_products as op on op.product_id = p.id
    group by p.id
    having `count` >= 5
    order by `count`desc, name asc;

-- 09. Availability
select t.id as 'table_id', t.capacity, count(oc.client_id) as 'count_clients',
 (
	case 
		when t.capacity > count(oc.client_id) then 'Free seats'
        when t.capacity = count(oc.client_id) then 'Full'
        else 'Extra seats'
	end
 ) as 'availability'
from `tables` as t
	join orders as o on o.table_id = t.id
    join orders_clients as oc on oc.order_id = o.id
where floor = 1
group by t.id
order by t.id desc;

-- 10. Extract bill

delimiter !
create function udf_client_bill(full_name varchar(50))
returns decimal(19,2)
deterministic
begin
	declare space_index int;
    set space_index := locate(' ', full_name);
    
    return (
		select sum(p.price) as 'bill' from clients as c
			join orders_clients as oc on oc.client_id = c.id
			join orders as o on o.id = oc.order_id
			join orders_products as op on op.order_id = o.id
			join products as p on p.id = op.product_id
		where c.first_name = substring(full_name, 1, space_index - 1) and
		c.last_name = substring(full_name, space_index + 1)
    );
end! 

delimiter ;

select c.first_name, c.last_name, sum(p.price) as 'bill' from clients as c
	join orders_clients as oc on oc.client_id = c.id
    join orders as o on o.id = oc.order_id
    join orders_products as op on op.order_id = o.id
    join products as p on p.id = op.product_id
where c.first_name = 'Silvio' and c.last_name = 'Blyth';

-- 11. Happy hour
delimiter !
create procedure udp_happy_hour(type_product varchar(50))
begin
	update products as p
    set price = price - (price * 0.2)
    where p.`type` = type_product and price >= 10;
end !
delimiter ;
