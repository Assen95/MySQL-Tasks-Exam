-- 01. One-To-One Relationship
-- CTRL + R Hotkey for Reverse Engineer(E/R Diagram)

create database random_tables;
use random_tables;

create table people(
	person_id int not null auto_increment unique,
    first_name varchar(30),
    salary decimal(10,2) default 0,
    passport_id int unique
);

create table passports(
	passport_id int primary key not null auto_increment,
    passport_number varchar(8) not null
);

alter table people
add constraint pk_person_id
primary key (person_id),
add constraint fk_person_id_passport_id
foreign key (passport_id)
references passports(passport_id);

drop table passports;
drop table people;

insert into passports (passport_number)
values ('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

insert into people (first_name, salary, passport_id)
values ('Roberto', 43300.00, 2),
('Tom', 56100.00, 3),
('Yana', 60200.00, 1);

select * from people 
	join passports on people.passport_id = passports.passport_id;
    
-- The Task requires the exact value, so when necessary add 101, 102....etc. to the values for Judge


-- 02. One-To-Many Relationship

create table manufacturers(
	manufacturer_id int primary key not null auto_increment,
    `name` varchar(30) not null,
    established_on date not null
);

create table models(
	model_id int primary key not null auto_increment,
    `name` varchar(30) not null,
    manufacturer_id int,
    constraint fk_model_id__manufacturer_id
    foreign key (manufacturer_id)
    references manufacturers(manufacturer_id)
);

insert into manufacturers (`name`, established_on)
values ('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

insert into models
values 
	(101, 'X1', 1),
	(102, 'i6', 1),
	(103, 'Model S', 2),
	(104, 'Model X', 2),
	(105, 'Model 3', 2),
	(106, 'Nova', 3)
;

select * from models
	join manufacturers on manufacturers.manufacturer_id = models.manufacturer_id;
    


-- 03. Many-To-Many Relationship
create table students (
	student_id int primary key not null auto_increment,
    `name` varchar(30) not null
);

create table exams (
	exam_id int primary key not null auto_increment,
    `name` varchar(30) not null
);

create table students_exams(
	student_id int,
    exam_id int,
    constraint pk_students_exams
    primary key (student_id, exam_id), -- This is not necessary you could just add the PK at start
    constraint fk_student_exams_students
    foreign key (student_id)
    references students(student_id),
    constraint fk_students_exams_exams
    foreign key (exam_id)
    references exams(exam_id)
);

insert into students(`name`)
values ('Mila'), ('Toni'), ('Ron');

insert into exams(exam_id, `name`)
values 
	(101, 'Spring MVC'),
    (102, 'Neo4j'),
    (103, 'Oracle 11g')
;

insert into students_exams
values 
	(1, 101),
	(1, 102),
    (2, 101),
    (3, 103),
    (2, 102),
    (2, 103)
;
select * from students
	join students_exams on students.student_id = students_exams.student_id;
    
select * from exams
	join students_exams on exams.exam_id = students_exams.exam_id;


-- 04. Self-Referencing
create table teachers(
	teacher_id int primary key,
    `name` varchar(30) not null,
    manager_id int,
    constraint fk_manager_id_teacher_id
    foreign key (manager_id)
    references teachers(teacher_id)
);

insert into teachers(teacher_id, `name`)
values 
	(101, 'John'),
	(102, 'Maya'),
    (103, 'Silvia'),
    (104, 'Ted'),
    (105, 'Mark'),
    (106, 'Greta')
;

-- SET SQL_SAFE_UPDATES = 0; This removes safe update

update teachers set manager_id = 106
where `name` = 'Maya';

update teachers set manager_id = 106
where `name` = 'Silvia';

update teachers set manager_id = 105
where `name` = 'Ted';

update teachers set manager_id = 101
where `name` = 'Mark';

update teachers set manager_id = 101
where `name` = 'Greta';

select * from teachers;


-- 05. Online Store Database
create table item_types(
	item_type_id int primary key not null auto_increment,
    `name` varchar(50)
);

create table cities(
	city_id int primary key not null auto_increment,
	`name` varchar(50)
);

create table items(
	item_id int primary key not null auto_increment,
    `name` varchar(50),
    item_type_id int,
    constraint fk_items_item_type_id__item_types_item_type_id
    foreign key (item_type_id)
    references item_types(item_type_id)
);

create table customers(
	customer_id int primary key not null auto_increment,
    `name` varchar(50),
    birthday date,
    city_id int,
    constraint fk_customers_city_id__cities_city_id
    foreign key (city_id)
    references cities(city_id)
);

create table orders(
	order_id int primary key not null auto_increment,
    customer_id int,
    constraint fk_orders_customer_id__customers_customer_id
    foreign key (customer_id)
    references customers(customer_id)
);

create table order_items(
	order_id int,
    item_id int,
    constraint pk_order_items
    primary key (order_id, item_id),
    constraint fk_order_items_order_id__orders_order_id
    foreign key (order_id)
    references orders(order_id),
    constraint fk_order_items_item_id__items_item_id
    foreign key (item_id)
    references items(item_id)
);



-- 06. University Database

create table subjects(
	subject_id int primary key not null auto_increment,
    subject_name varchar(50)
);

create table majors(
	major_id int primary key not null auto_increment,
    `name` varchar(50)
);


create table students(
	student_id int primary key not null auto_increment,
    student_number varchar(50),
    major_id int,
    constraint fk_students_major_id__majors_major_id
    foreign key (major_id)
    references majors(major_id)
);

create table payments(
	payment_id int primary key not null auto_increment,
    payment_date date,
    payment_amount decimal(8,2),
    student_id int,
    constraint fk_payments_student_id__students_student_id
    foreign key (student_id)
    references students(student_id)
);

create table agenda(
	student_id int,
    subject_id int,
    constraint pk_student_id_subject_id
    primary key (student_id, subject_id),
    constraint fk_agenda_student_id__students_student_id
    foreign key (student_id)
    references students(student_id),
    constraint fk_agenda_subject_id__subjects_subject_id
    foreign key (subject_id)
    references subjects(subject_id)
);

-- 09. Peaks in Rila
-- use geography;
select m.mountain_range, p.peak_name, p.elevation as 'peak_elevation' from peaks as p
	join mountains as m
    on m.id = p.mountain_id
    where m.mountain_range = 'Rila'
    order by p.elevation desc;




