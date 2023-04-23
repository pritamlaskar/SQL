-- Question 1
-- Employees whose salary > 9000
select * from employee_hr_data;
select * from employee_hr_data where SALARY > 9000;

-- Return first name, last name and department number and salary
create view question_one_view as select FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALARY from employee_hr_data;
select * from question_one_view;

-- Question 2
-- Employees without department number
select * from employee_hr_data;
select * from employee_hr_data where DEPARTMENT_ID = 0;

-- Return employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary,commission_pct, manager_id and department_id
create view question_two_view as select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID from employee_hr_data;
select * from question_two_view;
drop view if exists question_two_view;
create view question_two_view as select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID 
from employee_hr_data;
select * from question_two_view;

-- Question 3
-- find those employees whose first name does not contain the letter ‘T’. Sort the result-set in ascending order by department ID. 
-- Return full name (first and last name together), hire_date, salary and department_id.
use case_study;
select * from employee_hr_data;
select concat (FIRST_NAME, " ", LAST_NAME) as FULL_NAME, HIRE_DATE, SALARY, DEPARTMENT_ID from employee_hr_data where FIRST_NAME not like '%t%' order by DEPARTMENT_ID;

-- Question 4
-- employees who earn between 9000 and 12000 (Begin and end values are included.) and get some commission. Return all fields
select * from employee_hr_data;
select * from employee_hr_data where SALARY between 9000 and 12000;

-- Question 5
-- employees who do not earn any commission. Return full name (first and last name), and salary
select * from employee_hr_data;
select concat (FIRST_NAME, " ", LAST_NAME) as FULL_NAME, COMMISSION_PCT, SALARY from employee_hr_data;

-- Question 6
-- employees who work under a manager. Return full name (first and last name), salary, and manager ID.
select concat (FIRST_NAME, " ", LAST_NAME) as FULL_NAME, SALARY, MANAGER_ID from employee_hr_data where MANAGER_ID not like 0;

-- Question 7
-- employees whose first names contain the letters F, T, or M. Sort the result-set in descending order by salary. Return all fields
select * from employee_hr_data where FIRST_NAME like '%F%' or FIRST_NAME like '%T%' or FIRST_NAME like '%M' order by SALARY desc;

-- Question 8
-- employees who earn above 12000 or the seventh character in their phone number is 3. 
-- Sort the result-set in descending order by first name. 
-- Return full name (first name and last name), hire date, commission percentage, email, and telephone separated by '-', and salary.
select * from employee_hr_data;
select concat (FIRST_NAME, " ", LAST_NAME) as FULL_NAME, HIRE_DATE, COMMISSION_PCT
EMAIL, replace(PHONE_NUMBER, ".", "-") SALARY from employee_hr_data where SALARY > 12000 or PHONE_NUMBER like "______7%"
order by FIRST_NAME desc;

-- Question 9
-- employees whose first name contains a character 's' in the third position. Return first name, last name and department id.
select FIRST_NAME, LAST_NAME, DEPARTMENT_ID	from employee_hr_data where FIRST_NAME like '___s%';

-- Question 10
-- SQL query to find those employees who worked more than two jobs in the past. Return employee id.
select * from job_history_hr_data;
select EMPLOYEE_ID from job_history_hr_data group by EMPLOYEE_ID having count(*) >=2 ;

-- Question 11
-- count the number of employees, the sum of all salary, and
-- difference between the highest salary and lowest salaries by each job id. Return job_id, count, sum, salary_difference.
select JOB_ID, count(*), sum(SALARY), max(SALARY)-min(SALARY) as SALARY_DIFFERENCE from employee_hr_data group by JOB_ID;

-- Question 12
-- find each job ids where two or more employees worked for more than 300 days. Return job id
select * from job_history_hr_data;
select JOB_ID from job_history_hr_data where datediff(END_DATE, START_DATE)> 300 group by JOB_ID having count(*)>=2;

-- Question 13
-- count the number of employees worked under each manager. Return manager ID and number of employees
select * from employee_hr_data;
select count(EMPLOYEE_ID) as NUMBER_OF_EMPLOYEES, MANAGER_ID from employee_hr_data group by MANAGER_ID;

-- Question 14
-- calculate the average salary of employees who receive a commission percentage for each department. Return department id, average salary.
-- Use Group By where : a) Aggregate Function and b) By Each : is asked
select avg(SALARY) as AVERAGE_SALARY, DEPARTMENT_ID from employee_hr_data group by DEPARTMENT_ID;

-- Question 15
-- find the departments where more than ten employees receive commissions. Return department id
select * from employee_hr_data;
select DEPARTMENT_ID from employee_hr_data where COMMISSION_PCT not like "null" group by DEPARTMENT_ID having count(COMMISSION_PCT)>10;

-- Question 16
-- find those job titles where maximum salary falls between 10000 and 15000 (Begin and end values are included.). 
-- Return job_title, max_salary, min_salary
select * from jobs_hr_data;
select JOB_TITLE, MAX_SALARY-MIN_SALARY as SALARY_DIFFERENCE from jobs_hr_data where MAX_SALARY between 10000 and 15000;

-- Question 17
-- find details of those jobs where the minimum salary exceeds 9000
select * from employee_hr_data;
select * from employee_hr_data where SALARY>9000;
select * from jobs_hr_data;
select * from jobs_hr_data where MIN_SALARY > 9000;

-- Question 18
-- find those employees who work in the same department as ‘Clara’. 
-- Exclude all those records where first name is ‘Clara’. Return first name, last name and hire date.
select * from employee_hr_data;
select * from employee_hr_data where FIRST_NAME like "%Clara%";
select FIRST_NAME, LAST_NAME, HIRE_DATE from employee_hr_data where DEPARTMENT_ID = 80 and FIRST_NAME NOT LIKE "%Clara%";

-- Question 19
-- find those employees who earn more than the average salary 
-- and work in the same department as an employee whose first name contains the letter 'J' 
-- Return employee ID, first name and salary
select avg(SALARY) as AVERAGE_SALARY from employee_hr_data;
select EMPLOYEE_ID, FIRST_NAME, SALARY from employee_hr_data where FIRST_NAME like "%j%" and SALARY>6461;

-- Question 20
-- display the employee id, name ( first name and last name ) and the job id column with a modified title SALESMAN 
-- for those employees whose job title is ST_MAN and DEVELOPER for whose job title is IT_PROG
select * from employee_hr_data;
select concat (FIRST_NAME, " ", LAST_NAME) as FULL_NAME, EMPLOYEE_ID,
replace(replace(JOB_ID,'ST_MAN','SALESMAN'),'IT_PROG','DEVELOPER') as JOB_ID from employee_hr_data;

use case_study;

-- Question 21 (Joins 1)
-- find the first name, last name, department, city, and state province for each employee.
-- from tables: fist & last name (employee), department (department), state province (location)
select * from department_hr_data;
select * from employee_hr_data;
select * from location_hr_data;
select 
employee_hr_data.FIRST_NAME,
employee_hr_data.LAST_NAME,
department_hr_data.DEPARTMENT_NAME,
location_hr_data.STATE_PROVINCE,
location_hr_data.CITY
from employee_hr_data
join department_hr_data
on employee_hr_data.DEPARTMENT_ID = department_hr_data.DEPARTMENT_ID
join location_hr_data
on department_hr_data.LOCATION_ID = location_hr_data.LOCATION_ID;
use case_study;

-- Question 22 (Joins 2)
-- find the first name, last name, salary, and job grade for all employees
-- tables: first & last name, salary (employee) and grade (jobs grade)
select * from job_grades_hr_data;
select * from employee_hr_data;
select * from jobs_hr_data;
select
employee_hr_data.FIRST_NAME,
employee_hr_data.LAST_NAME,
employee_hr_data.SALARY,
job_grades_hr_data.GRADE_LEVEL
from employee_hr_data
join job_grades_hr_data
on employee_hr_data.SALARY between job_grades_hr_data.LOWEST_SAL and job_grades_hr_data.HIGHEST_SAL;

-- Question 23 (Joins 3)
-- find all those employees who work in department ID 80 or 40.
-- Return first name, last name, department number and department name
select * from employee_hr_data;
select * from department_hr_data;
select 
employee_hr_data.FIRST_NAME,
employee_hr_data.LAST_NAME,
employee_hr_data.DEPARTMENT_ID,
department_hr_data.DEPARTMENT_NAME
from employee_hr_data
join department_hr_data
on employee_hr_data.DEPARTMENT_ID = department_hr_data.DEPARTMENT_ID
where employee_hr_data.DEPARTMENT_ID in (80,40) order by employee_hr_data.FIRST_NAME;
-- department id 40 is ignored (or whichever is written after first)

use case_study;

-- Question 24 (Joins 4)
-- find those employees whose first name contains the letter ‘z’. Return first name, last name, department, city, and state province
select * from employee_hr_data;
select * from department_hr_data;
select * from location_hr_data;
select 
employee_hr_data.FIRST_NAME,
employee_hr_data.LAST_NAME,
department_hr_data.DEPARTMENT_NAME,
location_hr_data.CITY,
location_hr_data.STATE_PROVINCE
from employee_hr_data
join department_hr_data
on employee_hr_data.DEPARTMENT_ID = department_hr_data.DEPARTMENT_ID
join location_hr_data
on department_hr_data.LOCATION_ID = location_hr_data.LOCATION_ID
where employee_hr_data.FIRST_NAME like "%Z%";

-- Question 25 (Joins 5)
-- query to find all employees who joined on 1st January 1993 and left on or before 31 August 1997. 
-- Return job title, department name, employee name, and joining date of the job.
-- employment name (employee), joining date (job history), department name (department), job title (jobs)
select * from job_history_hr_data;
select * from department_hr_data;
select * from employee_hr_data;
select * from jobs_hr_data;
select
concat (employee_hr_data.FIRST_NAME, " ", employee_hr_data.LAST_NAME) as EMPLOYEE_NAME,
department_hr_data.DEPARTMENT_NAME,
job_history_hr_data.START_DATE,
jobs_hr_data.JOB_TITLE
from employee_hr_data
join de partment_hr_data
on employee_hr_data.DEPARTMENT_ID = department_hr_data.DEPARTMENT_ID
join job_history_hr_data
on department_hr_data.DEPARTMENT_ID = job_history_hr_data.DEPARTMENT_ID
join jobs_hr_data
on job_history_hr_data.JOB_ID = jobs_hr_data.JOB_ID
where job_history_hr_data.START_DATE >= "1993-01-01" and job_history_hr_data.END_DATE <= "2006-08-31" ;
-- join 5 end date gives no data as no job has end date before 1997-08-31

-- Question 26 (Join 6)
-- calculate the difference between the maximum salary of the job and the employee's salary
-- Return job title, employee name, and salary difference.
select * from employee_hr_data;
select * from jobs_hr_data;
select
CONCAT(employee_hr_data.FIRST_NAME, " ", employee_hr_data.LAST_NAME) AS EMPLOYEE_NAME,
jobs_hr_data.JOB_TITLE,
(jobs_hr_data.MAX_SALARY-employee_hr_data.SALARY) as SALARY_DIFFERENCE
from employee_hr_data
join jobs_hr_data;

-- Question 27 (Join 7)
-- department name and the full name (first and last name) of the manager.
select * from department_hr_data;
select * from employee_hr_data;
select
concat (employee_hr_data.FIRST_NAME," ", employee_hr_data.LAST_NAME) as FULL_NAME,
employee_hr_data.LAST_NAME,
department_hr_data.DEPARTMENT_NAME
from employee_hr_data
join department_hr_data
on employee_hr_data.MANAGER_ID = department_hr_data.MANAGER_ID 
where department_hr_data.MANAGER_ID !=0 order by employee_hr_data.FIRST_NAME;

-- Question 28 (Joins 8)
-- find the department name, full name (first and last name) of the manager and their city
select * from location_hr_data;
select * from employee_hr_data;
select * from department_hr_data;
select
concat (employee_hr_data.FIRST_NAME, " ", employee_hr_data.LAST_NAME) as FULL_NAME,
department_hr_data.DEPARTMENT_NAME,
location_hr_data.CITY
from employee_hr_data
join department_hr_data 
on employee_hr_data.DEPARTMENT_ID = department_hr_data.DEPARTMENT_ID
join location_hr_data
on department_hr_data.LOCATION_ID = location_hr_data.LOCATION_ID;

-- Question 29 (Joins 9)
-- find out the full name (first and last name) of the employee with an ID and the name of the country where he/she is currently employed
-- name (employee), country ID (location), country name (countries)
select * from employee_hr_data;
select * from department_hr_data;
select * from countries_hr_data;
select * from location_hr_data;
select 
concat (employee_hr_data.FIRST_NAME, " ", employee_hr_data.LAST_NAME) as FULL_NAME,
location_hr_data.CITY,
location_hr_data.COUNTRY_ID,
countries_hr_data.COUNTRY_NAME
from employee_hr_data
join department_hr_data
on employee_hr_data.DEPARTMENT_ID = department_hr_data.DEPARTMENT_ID
join location_hr_data
on department_hr_data.LOCATION_ID = location_hr_data.LOCATION_ID
join countries_hr_data
on location_hr_data.COUNTRY_ID = countries_hr_data.COUNTRY_ID;
-- location ID: 1700(US), 1800 (not given), 2400 (not given), 1500(US), 1400(US), 2700(GER)

use case_study;
select * from employee_hr_data;
alter table employee_hr_data rename column EMPLOYEE_NAME to	FIRST_NAME; 



