create database universities;

use universities;

-- 01.Table Design

create table countries (
	id int primary key auto_increment,
    name varchar(40) not null unique
);

create table cities (
	id int primary key auto_increment,
    name varchar(40) not null unique,
    population int,
    country_id int not null,
    constraint fk_cities_countries
    foreign key (country_id) references countries(id)
);

create table universities(
	id int primary key auto_increment,
    name varchar(60) not null unique,
    address varchar(80) not null unique,
    tuition_fee decimal(19,2) not null,
    number_of_staff int,
    city_id int,
    constraint fk_universities_cities
    foreign key (city_id) references cities(id)
);

create table students(
	id int primary key auto_increment,
    first_name varchar(40) not null,
    last_name varchar(40) not null,
    age int,
    phone varchar(20) not null unique,
    email varchar(255) not null unique,
    is_graduated tinyint(1) not null,
    city_id int,
    constraint fk_students_cities
    foreign key (city_id) references cities(id)
);

create table courses (
	id int primary key auto_increment,
    name varchar(40) not null unique,
    duration_hours decimal(19,2),
    start_date date,
    teacher_name varchar(60) not null unique,
    description text,
    university_id int,
    constraint fk_courses_universities
    foreign key (university_id) references universities(id)
);

create table students_courses(
	grade decimal(19,2) not null,
    student_id int not null,
    course_id int not null,
    constraint fk_students_courses_students
    foreign key (student_id) references students(id),
    constraint fk_students_courses_courses
    foreign key (course_id) references courses(id)
);

-- 02. Insert
select 
concat(teacher_name, ' ', 'course') as 'name',
(char_length(name) / 10) as 'duration_hours',
date_add(start_date, interval 5 day) as 'start_date',
reverse(teacher_name) as 'teacher_name',
concat('Course', teacher_name, reverse(description)) as 'description',
day(start_date) as 'university_id'
from courses
where id <= 5;

insert into courses(name, duration_hours, start_date, teacher_name, `description`, university_id)
	select 
		concat(teacher_name, ' ', 'course') as 'name',
		(char_length(name) / 10) as 'duration_hours',
		date_add(start_date, interval 5 day) as 'start_date',
		reverse(teacher_name) as 'teacher_name',
		concat('Course ', teacher_name, reverse(description)) as 'description',
		day(start_date) as 'university_id'
	from courses
	where id <= 5;

-- 03. Update
update universities
set tuition_fee = tuition_fee + 300
where id between 5 and 12;

select * from universities
where id between 5 and 12;

-- 04. Delete
select * from universities
where number_of_staff is null;

delete from universities
where number_of_staff is null;


-- 05. Cities
select * from cities
order by population desc;

-- 06. Students age
select first_name, last_name, age, phone, email from students
where age >= 21
order by first_name desc, email asc, id asc
limit 10;

-- 07. New students
select 
concat(s.first_name, ' ', last_name) as 'full_name', 
substring(email, 2, 10) as 'username', 
reverse(phone) as 'password'
from students as s
	left join students_courses as sc on sc.student_id = s.id
    where sc.course_id is null
    order by `password` desc;

-- 08. Students count
select count(sc.student_id) as 'students_count', u.name as 'university_name' from universities as u
	join courses as c on c.university_id = u.id
    join students_courses as sc on sc.course_id = c.id
    group by u.id
    having `students_count` >= 8
    order by `students_count` desc, `university_name` desc;

-- 09. Price rankings
select u.name,
c.name,
u.address,
(
	case
		when u.tuition_fee < 800 then 'cheap'
        when u.tuition_fee >= 800 and u.tuition_fee < 1200 then 'normal'
        when u.tuition_fee >= 1200 and u.tuition_fee< 2500 then 'high'
        else 'expensive'
    end
 ) as 'price_ranking',
u.tuition_fee
from universities as u
	join cities as c on c.id = u.city_id
    order by u.tuition_fee asc;

-- 10. Average grades
delimiter !
create function udf_average_alumni_grade_by_course_name(course_name varchar(60))
returns decimal(19,2)
deterministic
begin
	return (
		select avg(sc.grade) from courses as c
			join students_courses as sc on c.id = sc.course_id
            join students as s on s.id = sc.student_id
            where s.is_graduated = 1 and c.`name` = course_name
    );
end ! 

delimiter ;

select c.name, s.is_graduated, avg(sc.grade) from courses as c
	join students_courses as sc on c.id = sc.course_id
    join students as s on s.id = sc.student_id
    where s.is_graduated = 1 and c.name = 'Quantum Physics';

SELECT c.name, udf_average_alumni_grade_by_course_name('Quantum Physics') as average_alumni_grade FROM courses c 
WHERE c.name = 'Quantum Physics';

-- 11. Graduate students
delimiter !
create procedure udp_graduate_all_students_by_year(year_started int)
begin
	update students as s
		join students_courses as sc on s.id = sc.student_id
        join courses as c on sc.course_id = c.id
        set s.is_graduated = 1
        where year(c.start_date) = year_started;
end !

delimiter ;

select c.name, c.start_date, s.is_graduated, s.first_name from courses as c
	join students_courses as sc on c.id = sc.course_id
    join students as s on sc.student_id = s.id
    where year(c.start_date) = 2017;


