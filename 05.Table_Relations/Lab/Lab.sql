create database mountains;
use mountains;


-- 1. Mountains and Peaks
CREATE TABLE mountains (
    id INT AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    CONSTRAINT pk_mountains_id PRIMARY KEY (id) 
    -- It is better to define PK with CONSTRAINT, because
    -- we defined the name.
    -- It is very unusual to edit a PK
    -- But this way it is easier to modify/edit for the future when it is necessary
);

insert into mountains(`name`) 
values ('Rila'), ('Pirin');

create table peaks (
	id int auto_increment not null primary key,
    `name` varchar(100) not null,
    mountain_id int not null,
    constraint fk_peaks_mountain_id_mountains_id 
		foreign key (mountain_id)
        references mountains(id)
);

insert into peaks(`name`, mountain_id)
values ('Musala', 1), ('Vihhen', 2);

select * from peaks;

-- Using JOIN
select * from peaks
	join mountains on peaks.mountain_id = mountains.id;
    
-- We can define specific columns from tables by writing 'table_name.column_name'

-- 02. Trip Organization
-- use camp;

select 
	driver_id, 
	vehicle_type,
    concat(first_name, ' ', last_name) as 'driver_name'
from vehicles
	join campers on driver_id = campers.id;


-- 04. Delete Mountains
-- use mountains;

drop table peaks;
drop table mountains;


create table mountains (
	id int auto_increment not null,
    `name` varchar(100) not null,
    constraint pk_mountains_id primary key (id)
);

create table peaks(
	id int auto_increment not null primary key,
    `name` varchar(100) not null,
    mountain_id int not null,
    constraint fk_peaks_id_mountains_id
		foreign key (mountain_id)
        references mountains(id)
        on delete cascade
);

delete from mountains where id = 2; -- this will delete the mountain id and cascade delete the relations associated with it,
-- e.g. peaks from that mountain

-- 05. Project Management DB
create database project_management;
use project_management;

create table clients(
	id int auto_increment not null primary key,
    client_name varchar(100) not null
);

create table projects(
	id int primary key not null auto_increment,
    client_id int not null,
    project_lead_id int not null,
    constraint fk_projects_client_id_clients_id
		foreign key (client_id)
        references clients(id)
);

create table employees(
	id int primary key not null auto_increment,
    first_name varchar(30) not null,
    last_name varchar(30) not null,
    project_id int,
    constraint fk_employees_project_id_projects_id
		foreign key (project_id)
        references project(id)
);

alter table projects
add constraint fk_projects_project_lead_id_employees_id
	foreign key (project_lead_id)
    references employees(id);

