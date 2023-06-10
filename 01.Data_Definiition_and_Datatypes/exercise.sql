CREATE TABLE minions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(47),
    age INT
);

CREATE TABLE towns (
    town_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(47)
);

-- 2

alter table minions
add column town_id int; 

alter table minions
add constraint fk_minions_towns
foreign key minions(town_id)
references towns(id);

-- 3
insert into towns(id, name) values 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')
;

insert into minions (id, name, age, town_id) values 
(1,'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3,'Steward', NULL, 2)
;


select * from minions;

-- 4
truncate table minions;

-- 5
drop table minions;
drop table towns;

-- 6
CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(10 , 2 ),
    weight DOUBLE(10 , 2 ),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

insert into people (name, gender, birthdate)
values
('test', 'm', date(now())),
('testa', 'f', date(now())),
('testo', 'm', date(now())),
('teste', 'f', date(now())),
('testi', 'm', date(now()))
;

-- 7

create table users (
	id int primary key auto_increment,
    username varchar(30) not null,
    password varchar(26) not null,
    profile_picture blob,
    last_login_time datetime,
    is_deleted boolean
);

-- insert into users(username, password)
-- values
-- ('pe6o', 'alabala'),
-- ('simo', 'alabala'),
-- ('stoyan', 'alabala'),
-- ('dimo', 'alabala'),
-- ('asen', 'alabala');

-- 8
alter table users
drop primary key,
add constraint pk_users2
primary key users(id, username);

-- 9

alter table users
change column last_login_time 
last_login_time datetime default now();

-- `10
alter table users
drop primary key,
add constraint pk_users
primary key users(id),
change column username
username varchar(30) unique;

-- 11
create database movies;

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(30) NOT NULL,
    notes TEXT
);

insert into directors (director_name) 
values ('test1'),
('test2'),
('test3'),
('test4'),
('test5');


create table genres(
	id int primary key auto_increment,
    genre_name varchar(30) not null,
    notes text
);

insert into genres (genre_name) 
values ('test1'),
('test2'),
('test3'),
('test4'),
('test5');

create table categories(
	id int primary key auto_increment,
    category_name varchar(30) not null,
    notes text
);

insert into categories (category_name) 
values ('test1'),
('test2'),
('test3'),
('test4'),
('test5');

create table movies(
	id int primary key auto_increment,
    title varchar(30) not null,
    director_id int,
    copyright_year year,
    length double(10,2),
    genre_id int,
    category_id int,
    rating double(3,2),
    notes text,
    foreign key fk_movies_directors (director_id)
    references directors(id),
    foreign key fk_movies_genres (genre_id)
    references genres(id),
    foreign key fk_movies_categories (category_id)
    references categories(id)
);

insert into movies (title, director_id, genre_id, category_id) 
values ('test1', 1, 2, 3),
('test2', 1, 2, 5),
('test3', 1, 2, 4),
('test4', 1, 2, 3),
('test5', 1, 2, 3);

-- 12
-- categories (id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
-- • cars (id, plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
-- • employees (id, first_name, last_name, title, notes)
-- • customers (id, driver_licence_number, full_name, address, city, zip_code, notes)
-- • rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)

create database car_rental;
use car_rental;

create table categories (
	id int primary key not null,
    category varchar(30) not null,
    daily_rate double,
    weekly_rate double,
    monthly_rate double,
    weekend_rate double
); 

create table cars (
);




-- 13
create database soft_uni;

create table towns(
	id int primary key auto_increment,
    name varchar(30)
);

create table addresses(
	id int primary key auto_increment,
    address_text text,
    town_id int
);

create table departments(
	id int primary key auto_increment,
    name varchar(30)
);

create table employees(
id int primary key auto_increment,
first_name varchar(30),
middle_name varchar(30),
last_name varchar(30),
job_title varchar(30),
department_id int,
hire_date datetime default now(),
salary double,
address_id int,
foreign key (department_id)
references departments(id),
foreign key (address_id)
references addresses(id)
);


-- 14 
select * from towns;
select * from employees;
select * from departments;
select * from towns;

-- 15
select * from towns order by towns.name asc;
select * from departments order by departments.name asc;
select * from employees order by employees.salary desc;

-- 16
select name from towns order by towns.name asc;
select name from departments order by departments.name asc;
select first_name, last_name, job_title, salary from employees order by employees.salary desc;

 -- 17
update employees
set salary = salary * 1.1;
select salary from employees;