create database human_resources;

use human_resources;


-- Create 'departments' table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

-- Create 'employees' table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT REFERENCES departments(id)
);

-- Create 'projects' table
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    department_id INT REFERENCES departments(id)
);

-- Insert data into 'departments'
INSERT INTO departments (name, manager_id)
VALUES ('HR', 1), ('IT', 2), ('Sales', 3);

-- Insert data into 'employees'
INSERT INTO employees (name, hire_date, job_title, department_id)
VALUES ('John Doe', '2018-06-20', 'HR Manager', 1),
       ('Jane Smith', '2019-07-15', 'IT Manager', 2),
       ('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
       ('Bob Miller', '2021-04-30', 'HR Associate', 1),
       ('Charlie Brown', '2022-10-01', 'IT Associate', 2),
       ('Dave Davis', '2023-03-15', 'Sales Associate', 3);

-- Insert data into 'projects'
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES ('HR Project 1', '2023-01-01', '2023-06-30', 1),
       ('IT Project 1', '2023-02-01', '2023-07-31', 2),
       ('Sales Project 1', '2023-03-01', '2023-08-31', 3);
       
       UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'John Doe')
WHERE name = 'HR';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Jane Smith')
WHERE name = 'IT';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Alice Johnson')
WHERE name = 'Sales';

-- CASE STUDY QUESTIONS--
select * from projects;

-- 1. Find the longest ongoing project for each department--
select b.department_id,a.name,DATEDIFF(a.end_date,a.start_date) as Project_Days from projects a
join employees b on b.department_id=a.department_id
group by name
order by Project_Days desc;

-- 2. Find all employees who are not managers.--
select a.name, a.job_title, a.department_id from departments b
right join employees a on a.id=b.id
where manager_id is null;

-- OR--
select e.name, e.job_title
from departments d
join employees e on d.id=e.department_id
join projects p on e.department_id=p.department_id
where e.job_title not like '%Manager%';

-- OR--
select id, name, job_title from employees
where id NOT IN (select id from departments);


-- 3. Find all employees who have been hired after the start of a project in the department--
select name, hire_date from employees e
where 
hire_date > 
(select start_date 
from projects p 
where 
p.department_id=e.department_id);

                                
-- 4. Rank employees within each department based on their hire date (earliest hire gets the highest rank--
	select p.name, q.name, p.hire_date, rank() over(partition by p.department_id order by p.hire_date) as ranking_per_department
    from departments q
    join employees p on q.id = p.department_id
    join projects r on p.department_id=r.department_id;
	

-- 5. Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department --
select d.name, hire_duration_days
from (select department_id, DATEDIFF(max(hire_date), min(hire_date)) as hire_duration_days from employees
group by department_id) as e
inner join departments as d on e. department_id=d.id;

