-- SUBSTRING(STRING, POSITION, LENGTH)
select id, substring(title, 1, 10) from book_library.books;

-- 01. Find Book Titles

select title from books
where substring(title, 1, 3) = 'The'
order by id;

-- REPLACE(STRING, PATTERN, REPLACEMENT)alter
select replace('0123456789', '0123', 'Replaced');

-- censor word murder from books table
select id, replace(title, 'Murder', '****') from books;

-- 02. Replace Titles
select replace(title, 'The', '***') from books
where substring(title, 1, 3) = 'The'
order by books.id;

-- LEFT & RIGHT
select left('01234', 2), substring('01234', 1 , 2);
select right('01234', 2), substring('01234', -2);

-- LOWER & UPPER, tip
select title from books
where lower(substring(title, 1, 3)) = 'the'; -- through this we get all of the 'the's ignoring case


-- REVERSE(String)
SELECT REVERSE('Hello');

-- REPEAT(String, Count)
select repeat('012', 4);

-- LOCATE(Pattern, String, [Position])
select title from books
where locate('the', title, 3) > 0;

-- INSERT(String, Position, Length, Substring)
select insert('01234', 2, 2, 'ab');

-- RAND
select floor(rand() * 11); -- 0;10

-- EXTRACT
select title, extract(year from year_of_release) from books;

-- TIMESTAMPDIFF
select timestampdiff(year, '2023-05-16', '2022-05-15');

-- 03.Days Lived
select concat(`first_name`,' ', `last_name`) as 'Full Name',
timestampdiff(day, born, died) from authors;

-- NOW()
select id, first_name, timestampdiff(year, born, now()) as 'LMAO' from authors;

-- Wildcards
select  * from authors
where first_name like 'a%';

select * from books
where title like 'The%';

-- 04. Harry Potter Books
select title from books
where title regexp '^Harry'; -- or 'Harry Potter% '