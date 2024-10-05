SELECT * FROM Parks_and_Recreation.employee_demographics;
SELECT * FROM Parks_and_Recreation.employee_salary;

SELECT first_name,
last_name,
birth_date,
age,
age+10 
FROM employee_demographics;
#PEMDAS

SELECT DISTINCT * from employee_demographics;

-- Comparison operators --
SELECT * FROM employee_salary
WHERE salary<=50000;

SELECT * from employee_demographics
WHERE birth_date>'1985-01-01';

-- AND OR NOT Logical operators --
SELECT * from employee_demographics
WHERE birth_date>'1985-01-01'
OR NOT gender="Male";

SELECT * from employee_demographics
WHERE (first_name="Leslie" and age=44)
OR age>55;

-- LIKE --
SELECT * from employee_demographics
WHERE first_name LIKE "a___%";

SELECT * from employee_demographics
WHERE birth_date LIKE '1989%';

-- Group by Order by --

SELECT gender, AVG(age),max(age),min(age),count(*)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation,salary;

SELECT *
FROM employee_demographics
ORDER BY age,gender;

-- HAVING vs WHERE --
SELECT gender,avg(age) FROM
employee_demographics
group by gender
having avg(age)>40;

SELECT occupation,avg(salary) as avg_sal
FROM employee_salary
where occupation Like "%manager%"
Group by occupation
having avg_sal>75000;

-- LIMIT & ALIASING --
SELECT * FROM employee_demographics order by age desc limit 1,2;

-- join --
SELECT t1.employee_id,age,occupation FROM 
employee_demographics t1 inner join
employee_salary t2
ON t1.employee_id=t2.employee_id;

SELECT t1.employee_id,age,occupation FROM 
employee_demographics t1 left join
employee_salary t2
ON t1.employee_id=t2.employee_id;

SELECT t1.employee_id,age,occupation FROM 
employee_demographics t1 right join
employee_salary t2
ON t1.employee_id=t2.employee_id;

SELECT emp1.employee_id,emp1.first_name as santa,emp2.first_name emp FROM employee_salary emp1
join employee_salary emp2
on emp1.employee_id+1=emp2.employee_id;

SELECT first_name,last_name,'Highly Paid' as label FROM employee_salary
where salary>70000
union
SELECT first_name,last_name,'Old Man' as label
FROM employee_demographics
where age>40 and gender='Male'
union
SELECT first_name,last_name,'Old Lady' as label
FROM employee_demographics
where age>40 and gender='Female'
order by first_name,last_name
;

SELECT first_name,last_name from employee_salary
union
Select first_name,last_name from employee_demographics ;



-- case --

SELECT * from parks_departments;

SELECT first_name,last_name,salary,
CASE
   WHEN salary<50000 then (0.05*salary)+salary
   WHEN salary>50000 then (0.07*salary)+salary
END AS Salary_INC,
CASE
   WHEN dept_id=6 then salary+ (salary*0.10)
END AS bonus
FROM employee_salary sal;

-- String functions --

SELECT LENGTH('skyfall');
SELECT first_name,LENGTH(first_name) as len from employee_demographics order by 2 ;

SELECT first_name, UPPER(first_name) from employee_demographics ;

SELECT last_name, LOWER(last_name) from employee_demographics ;

SELECT LTRIM('      sky           ');

SELECT first_name,left(first_name,4),
right(first_name,4),
substring(first_name,2,2),
birth_date,
substring(birth_date,6,2)
from employee_demographics;

SELECT first_name,replace(first_name,'a','x')
from employee_demographics;

SELECT LOCATE('xa','Alexander');

SELECT first_name,last_name,concat(first_name,' ',last_name) as full_name
from employee_demographics;


SELECT first_name,salary,(SELECT avg(salary) from employee_salary) as avg_sal
from employee_salary;

SELECT *
FROM employee_demographics
WHERE employee_id in(
					SELECT employee_id from employee_salary
                    where dept_id=6
);

SELECT avg(maxx) FROM(
SELECT gender,avg(age) as avgg, max(age) as maxx, min(age) as minn, count(*) as countt from
employee_demographics
group by gender) as tab
;

SELECT gender,avg(salary) 
FROM employee_demographics emp join employee_salary sal
on emp.employee_id=sal.employee_id
group by gender;

SELECT emp.first_name,emp.last_name,gender,
avg(salary) over(partition by gender) as avg_salary
FROM employee_demographics emp join employee_salary sal
on emp.employee_id=sal.employee_id;

SELECT emp.first_name,emp.last_name,gender,salary,
sum(salary) over(partition by gender order by emp.employee_id ) as rolling_total
FROM employee_demographics emp join employee_salary sal
on emp.employee_id=sal.employee_id;

SELECT emp.employee_id,emp.first_name,emp.last_name,gender,salary,
row_number() over(partition by gender order by salary desc) as row_num,
rank() over(partition by gender order by salary desc) as rankk,
dense_rank() over(partition by gender order by salary desc) as drank
FROM employee_demographics emp join employee_salary sal
on emp.employee_id=sal.employee_id;


-- CTE --

WITH CTE_example as(
SELECT gender,avg(salary) avg_sal, max(salary) max_sal , min(salary) min_sal , count(salary) count_sal
from
employee_demographics  emp join employee_salary sal
on emp.employee_id=sal.employee_id
group by gender)

SELECT avg(avg_sal) FROM CTE_example
;

SELECT avg(avg_sal) FROM
(SELECT gender,avg(salary) avg_sal, max(salary) max_sal , min(salary) min_sal , count(salary) count_sal
from
employee_demographics  emp join employee_salary sal
on emp.employee_id=sal.employee_id
group by gender) as sall;

with cte_example as(
SELECT employee_id,age
from employee_demographics
where birth_date>'1989-01-01'
),
cte_example2 as(
SElect employee_id,salary
from employee_salary
where salary>=20000
)
SELECT * FROM cte_example c1
join cte_example2 c2 where c1.employee_id=c2.employee_id
;

-- Temp tables --
CREATE TEMPORARY TABLE temp_tab(
first_name varchar(50),
last_name varchar(50),
fav_movie varchar(50)
);

SELECT * FROM temp_tab;

INSERT INTO temp_tab VALUES('Anoosha','Keen','None');

CREATE temporary TABLE SAL_G_50K(
SELECT * FROM employee_salary
WHERE salary>=50000);

select * from SAL_G_50K;

DELIMITER $$
CREATE PROCEDURE sp_large_sal2()
BEGIN
    SELECT * FROM employee_salary where salary>=50000;
	SELECT * FROM employee_salary where salary>=10000;
END $$
DELIMITER ;

CALL sp_large_sal2();


DROP PROCEDURE sp_large_sal3;
DELIMITER $$
CREATE PROCEDURE sp_large_sal3(id_param INT)
BEGIN
    SELECT salary FROM employee_salary where employee_id=id_param;
END $$
DELIMITER ;

CALL sp_large_sal3(1);


DELIMITER $$
CREATE TRIGGER employee_insert
   AFTER INSERT ON employee_salary
   FOR EACH ROW 
BEGIN
    INSERT INTO employee_demographics(employee_id,first_name,last_name)
    values(new.employee_id, new.first_name, new.last_name);
END $$
DELIMITER ;

insert INTO employee_salary values(100,'Anoosha','Keen','Analyst',300000,1);

SELECT * FROM employee_demographics;


DROP EVENT retire;
DELIMITER $$
CREATE EVENT retire
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
DELETE from employee_demographics where age>=60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';

