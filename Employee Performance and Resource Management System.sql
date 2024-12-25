-- Making Tables and insert data
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    project_id INT NOT NULL,
    hours_worked INT NOT NULL,
    contribution DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

INSERT INTO Employees (name, department, hire_date, salary) VALUES
('Employee_1', 'Operations', '2017-02-09', 110708),
('Employee_2', 'Finance', '2021-02-09', 64367),
('Employee_3', 'Operations', '2019-07-16', 81553),
('Employee_4', 'HR', '2016-07-14', 41615),
('Employee_5', 'Marketing', '2019-08-16', 40456),
('Employee_6', 'Operations', '2017-06-08', 72039),
('Employee_7', 'HR', '2017-03-26', 71531),
('Employee_8', 'Marketing', '2019-12-30', 46949),
('Employee_9', 'Marketing', '2018-08-13', 51867),
('Employee_10', 'Marketing', '2018-06-25', 90796),
('Employee_11', 'Finance', '2020-10-29', 56639),
('Employee_12', 'HR', '2020-07-18', 60213),
('Employee_13', 'Marketing', '2019-11-25', 111404),
('Employee_14', 'Engineering', '2021-11-01', 90888),
('Employee_15', 'HR', '2015-03-11', 112496),
('Employee_16', 'Engineering', '2021-02-09', 44575),
('Employee_17', 'Finance', '2015-05-06', 68861),
('Employee_18', 'Engineering', '2018-05-08', 89896),
('Employee_19', 'Operations', '2018-08-14', 63489),
('Employee_20', 'Marketing', '2021-05-19', 50368);

INSERT INTO Projects (project_name, start_date, end_date, budget) VALUES
('Project_1', '2022-11-03', '2025-04-14', 393074),
('Project_2', '2023-05-02', '2024-02-07', 196469),
('Project_3', '2022-01-14', '2025-08-30', 405983),
('Project_4', '2023-11-19', '2025-12-23', 160918),
('Project_5', '2023-06-01', '2024-03-19', 320099),
('Project_6', '2022-12-21', '2025-06-22', 141259),
('Project_7', '2023-03-28', '2024-10-08', 172374),
('Project_8', '2023-01-17', '2024-08-20', 184920),
('Project_9', '2022-02-27', '2025-01-16', 486473),
('Project_10', '2022-09-15', '2024-12-31', 495381);

INSERT INTO Assignments (employee_id, project_id, hours_worked, contribution) VALUES
(1, 1, 152, 56.12),
(2, 2, 210, 62.73),
(3, 3, 138, 49.32),
(4, 4, 195, 75.45),
(5, 5, 140, 88.67),
(6, 6, 180, 47.34),
(7, 7, 200, 72.89),
(8, 8, 190, 56.78),
(9, 9, 170, 45.89),
(10, 10, 220, 81.23),
(11, 1, 115, 44.12),
(12, 2, 130, 63.45),
(13, 3, 190, 59.76),
(14, 4, 175, 82.34),
(15, 5, 160, 78.90),
(16, 6, 220, 56.44),
(17, 7, 180, 67.22),
(18, 8, 190, 74.56),
(19, 9, 200, 88.89),
(20, 10, 150, 45.67),
(1, 2, 100, 23.45),
(2, 3, 120, 45.78),
(3, 4, 140, 38.90),
(4, 5, 170, 72.67),
(5, 6, 110, 43.21),
(6, 7, 150, 58.99),
(7, 8, 190, 62.45),
(8, 9, 130, 49.76),
(9, 10, 140, 57.34),
(10, 1, 180, 88.22),
(11, 3, 150, 54.11),
(12, 4, 170, 62.77),
(13, 5, 190, 76.54),
(14, 6, 130, 45.32),
(15, 7, 160, 89.90),
(16, 8, 180, 71.11),
(17, 9, 120, 66.54),
(18, 10, 200, 78.12),
(19, 1, 140, 54.67),
(20, 2, 180, 49.78),
(1, 3, 150, 61.45),
(2, 4, 190, 59.67),
(3, 5, 170, 66.34),
(4, 6, 140, 52.44),
(5, 7, 180, 70.78),
(6, 8, 190, 84.23),
(7, 9, 150, 75.89),
(8, 10, 130, 42.67);

-- Data Analysis
-- 1.List all employees and their departments.
select name, department from employees;

-- 2.Find the total number of employees in each department.
select  department, count(distinct name) as Total_numbers_Of_Employees
from employees
group by 1;

-- or

SELECT department, COUNT(*) AS total_employees
FROM Employees
GROUP BY department;

-- 3.Retrieve details of all projects with a budget greater than 200,000.
select 
* from projects
where budget>200000;

-- 4.Get the names of employees who are working on Project_1.
select e.name as Employees_Name ,project_name from assignments as a
join employees as e
on e.employee_id=a.employee_id
join projects as p on 
p.project_id=a.project_id
where p.project_name= 'Project_1';

-- 5.Calculate the total hours worked by each employee.
select e.name as Employee_Name ,sum(hours_worked) as total_Hours_Worked
from assignments as a
join employees as e
on e.employee_id=a.employee_id
group by 1;

-- 6.Find the top 3 highest-paid employees.
select name, salary
from employees
order by 2 desc
limit 3;

-- 7.Get the total budget for all projects per department.
select department, round(sum(budget),1) as Total_budgets from 
projects as p
left join assignments as a
on a.project_id=p.project_id
left join employees as e
on a.employee_id=e.employee_id
group by 1;

-- 8.Retrieve projects that are scheduled to end in 2024.
select project_name,
extract(Year from (end_date)) as End_years
from projects
where extract(Year from (end_date))= '2024';

SELECT project_name, end_date
FROM Projects
WHERE YEAR(end_date) = 2024;

-- 9.Find employees whose total contribution across all projects exceeds 100%.
SELECT e.name, SUM(a.contribution) AS total_contribution
FROM Employees e
JOIN Assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id
HAVING SUM(a.contribution) > 100;

-- 10.Identify employees who have not been assigned to any projects.
SELECT 
    e.name
FROM
    employees AS e
WHERE
    e.employee_id NOT IN (SELECT DISTINCT
            employee_id
        FROM
            assignments);

-- 11.Rank employees by their total hours worked using a window function.

select e.name,
	sum(a.hours_worked) as total_Hours_worked,
	rank() over (order by sum(a.hours_worked) desc) As ranking
from  assignments as a
left join employees as e
on a.employee_id=e.employee_id
group by 1;

-- 12.Find the average performance score per department.
SELECT e.department, AVG(p.performance_score) AS avg_score
FROM Employees e
JOIN Performance p ON e.employee_id = p.employee_id
GROUP BY e.department;

-- 13.Calculate the percentage of the project budget spent on hours worked by each employee.

with cte as 
		(select e.name, sum(hours_worked) as total_hours, sum(budget) as budget_spent
    from  employees as e
	left join assignments as a
	on e.employee_id=a.employee_id
	left join projects p 
	on p.project_id=a.project_id
	group by 1)
select name, round((budget_spent/total_hours),1) as  budgetperhour
from cte; -- budget/hourworking

-- solution
SELECT  e.name, p.project_name,
      round( (a.hours_worked * e.salary / 2080) / p.budget * 100,1) AS budget_percentage
FROM Employees e
JOIN Assignments a ON e.employee_id = a.employee_id
JOIN Projects p ON a.project_id = p.project_id;

-- 14.Identify employees who contributed to more than 2 projects.

SELECT 
    e.name, COUNT(p.project_id) AS total_projects
FROM
    employees AS e
        LEFT JOIN
    assignments AS a ON e.employee_id = a.employee_id
        LEFT JOIN
    projects p ON p.project_id = a.project_id
GROUP BY 1
having total_projects>2;

-- 15.List all projects and their total contributions, showing projects with less than 100% contribution.

SELECT 
    p.project_name, sum(contribution) as total_contribution
FROM
    employees AS e
        LEFT JOIN
    assignments AS a ON e.employee_id = a.employee_id
        LEFT JOIN
    projects p ON p.project_id = a.project_id
    group by 1
	having total_contribution<100;
    
-- 16.Create a stored procedure to calculate and update bonuses based on performance.
select max(hours_worked) from assignments ;-- 220
select min(hours_worked) from assignments ;-- 100

select max(contribution) from assignments ;-- '89.90'
select min(contribution) from assignments ; -- '23.45'

select max(salary) from employees; -- '112496.00'
select min(salary) from employees; -- '40456.00'

DELIMITER //
CREATE PROCEDURE CalculateBonuses()
BEGIN
    UPDATE Employees e
    JOIN Performance p ON e.employee_id = p.employee_id
    SET e.salary = e.salary + (e.salary * (p.performance_score / 100))
    WHERE p.year = YEAR(CURDATE());
END //
DELIMITER ;

-- 17.salary range by departments

select department, max(salary), min(salary) from employees
group by department;

with cte2 as(
select department, max(salary) as Max_salary , min(salary) as Min_salary from employees
group by department)

select department , concat(Max_salary,'-',Min_salary) as Salary_range,
(Max_salary-Min_salary) as gap
from cte2;

-- 18.Use a recursive query to find all employees working indirectly on a project via dependencies. 
WITH RECURSIVE EmployeeProjects AS (
    SELECT e.employee_id, p.project_id
    FROM Employees e
    JOIN Assignments a ON e.employee_id = a.employee_id
    JOIN Projects p ON a.project_id = p.project_id
    UNION ALL
    SELECT ep.employee_id, pd.depends_on_project_id
    FROM EmployeeProjects ep
    JOIN ProjectDependencies pd ON ep.project_id = pd.project_id
)
SELECT * FROM EmployeeProjects;

-- 19.Generate a report of projects and employees who contributed the most hours.
SELECT 
    p.project_name as Project_Name, e.name as Employee_Name, max(a.hours_worked) as most_hours_worked
FROM
    employees AS e
        LEFT JOIN
    assignments AS a ON e.employee_id = a.employee_id
        LEFT JOIN
    projects p ON p.project_id = a.project_id
    group by 1,2;
   
-- 20.Find departments that are working on projects with an average contribution of over 70%.
SELECT 
    e.department, AVG(a.contribution) AS avg_contribution
FROM
    Employees e
        JOIN
    Assignments a ON e.employee_id = a.employee_id
GROUP BY e.department
HAVING AVG(a.contribution) > 70;

-- 21.Trigger to prevent assignment contributions exceeding 100%.

DELIMITER $$

CREATE TRIGGER PreventOverContribution
BEFORE INSERT ON Assignments
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(5, 2) DEFAULT 0;
    
    -- Calculate current contribution using a subquery
    SET total = (
        SELECT COALESCE(SUM(contribution), 0)
        FROM Assignments
        WHERE employee_id = NEW.employee_id AND project_id = NEW.project_id
    );

    -- Check if the new contribution exceeds the limit
    IF (total + NEW.contribution) > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contribution exceeds 100%';
    END IF;
END$$

DELIMITER ;

