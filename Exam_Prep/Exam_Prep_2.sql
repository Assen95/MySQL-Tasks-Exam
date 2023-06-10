create database online_stores;

use online_stores;

-- brands, categories, reviews, products, customers, orders, orders_products
-- 01. Table Design

create table brands(
	id int primary key auto_increment,
    name varchar(40) not null unique
);

create table categories(
	id int primary key auto_increment,
    name varchar(40) not null unique
);

create table reviews(
	id int primary key auto_increment,
    content text,
    rating decimal(10,2) not null,
    picture_url varchar(80) not null,
    published_at datetime not null
);

create table products(
	id int primary key auto_increment,
    name varchar(40) not null,
    price decimal(19,2) not null,
    quantity_in_stock int,
    description text,
    brand_id int not null,
    category_id int not null,
    review_id int,
    constraint fk_products_brands
    foreign key (brand_id) references brands(id),
    constraint fk_products_categories
    foreign key (category_id) references categories(id),
    constraint fk_products_reviews
    foreign key (review_id) references reviews(id)
);

create table customers(
	id int primary key auto_increment,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    phone varchar(30) not null unique,
    address varchar(60) not null,
    discount_card bit(1) not null default 0
);

create table orders(
	id int primary key auto_increment,
    order_datetime datetime not null,
    customer_id int not null,
    constraint fk_orders_customers
    foreign key (customer_id) references customers(id)
);

create table orders_products(
	order_id int,
    product_id int,
    constraint fk_orders_products_orders
    foreign key (order_id) references orders(id),
    constraint fk_orders_products_products
    foreign key (product_id) references products(id)
);

-- 02.Insert
select substring(description, 15), 
reverse(name), 
date('2010/10/10'), 
(price / 8) as 'rating' from products
where id >= 5;

insert into reviews(content, rating, picture_url, published_at)
(
	select left(p.description, 15), p.price / 8,
    reverse(p.name), date('2010/10/10') from products as p
    where p.id >= 5
);

-- 03. Update
update products
set quantity_in_stock = quantity_in_stock - 5
where quantity_in_stock between 60 and 70;


select * from products
where quantity_in_stock between 60 and 70;

-- 04. Delete
delete c from customers as c
left join orders as o on c.id = o.customer_id
where o.customer_id is null;

-- 05. Categories
select * from categories
order by name desc;

-- 06. Quantity
select id, brand_id, name, quantity_in_stock from products
where price > 1000 and quantity_in_stock < 30
order by quantity_in_stock asc, id asc;

-- 07. Review
select * from reviews
where content like 'My%' and char_length(content) > 61
order by rating desc;

-- 08. First customers
select concat(c.first_name, ' ', c.last_name) as 'full_name', c.address, o.order_datetime from customers as c
	join orders as o on o.customer_id = c.id
    where year(order_datetime) <= 2018
    order by `full_name` desc;
    
-- 09. Best categories
select count(p.id) as 'items_count', c.name, sum(quantity_in_stock) as 'total_quantity' from categories as c
	join products as p on p.category_id = c.id
    group by c.name
    order by `items_count` desc, `total_quantity` asc
    limit 5;
    
-- 10. Extract client cards count
delimiter !
create function udf_customer_products_count(`name` varchar(30))
returns int
deterministic
begin
	return(
	select count(`name`) from customers as c
		join orders as o on o.customer_id = c.id
		join orders_products as op on op.order_id = o.id
	where c.first_name = `name`
	group by c.id);
end !

delimiter ;

-- returns the total number of products said customer ordered
select c.first_name, c.last_name, count(op.product_id) as 'total_products' from customers as c
	join orders as o on o.customer_id = c.id
    join orders_products as op on op.order_id = o.id
where c.first_name = 'Shirley'
group by c.id;

SELECT c.first_name,c.last_name, udf_customer_products_count('Shirley') as `total_products` FROM customers c
WHERE c.first_name = 'Shirley';

-- 11. Reduce price
delimiter !
create procedure udp_reduce_price (category_name varchar(50))
begin
	update products as p
    join categories as c on c.id = p.category_id
    join reviews as r on r.id = p.review_id
    set p.price = p.price - (price * 0.3)
    where r.rating < 4 and c.name = category_name;

end !
delimiter ;

select p.name, p.price, c.name, r.rating from products as p
	join categories as c on c.id = p.category_id
    join reviews as r on r.id = p.review_id
where r.rating <= 4 and c.name = 'Phones and tablets'
