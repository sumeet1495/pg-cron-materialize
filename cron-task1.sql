CREATE SCHEMA IF NOT EXISTS employee;

SET search_path TO employee;

CREATE TABLE employee.details (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    age INT,
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    joining_date DATE
);

select * from employee.details;

INSERT INTO employee.details (first_name, last_name, age, department, salary, joining_date) 
VALUES 
('Alice', 'Smith', 30, 'HR', 55000.00, '2023-01-15'),
('Bob', 'Johnson', 28, 'Engineering', 65000.00, '2022-11-20')

select * from employee.details;

SELECT * FROM pg_extension;

SHOW cron.database_name;

CREATE EXTENSION IF NOT EXISTS pg_cron;

SELECT * FROM pg_available_extensions;

SELECT * FROM pg_available_extensions WHERE name = 'pg_cron';


CREATE OR REPLACE VIEW employee.max_salary_view AS
SELECT department, MAX(salary) AS max_salary
FROM employee.details
GROUP BY department;

SELECT * FROM employee.max_salary_view;

CREATE MATERIALIZED VIEW employee.max_salary_materialized AS
SELECT * FROM employee.max_salary_view;

SELECT cron.schedule(
    'direct_refresh_max_salary',   
    '*/2 * * * *',               
    $$ REFRESH MATERIALIZED VIEW employee.max_salary_materialized; $$
);

SELECT * FROM cron.job; -- get the detail of the cron job

SELECT * FROM cron.job_run_details ORDER BY start_time DESC; -- check the job run schedule 

SELECT * FROM employee.max_salary_materialized;

---- updating to 5 AM every morning
SELECT cron.schedule(
    'direct_refresh_max_salary',  
    '0 5 * * *',  
    $$ REFRESH MATERIALIZED VIEW employee.max_salary_materialized; $$
);

----- manually triggering the job 

SELECT cron.run_job('direct_refresh_max_salary');


---- deleting the Cron Job:
SELECT cron.unschedule('direct_refresh_max_salary');

SELECT * FROM cron.job;

INSERT INTO employee.details (first_name, last_name, age, department, salary, joining_date) 
VALUES 
('Eva', 'Miller', 29, 'Engineering', 75000.00, '2024-04-10');











