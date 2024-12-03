
CREATE TABLE EMPLOYEE_INFO (
    EMPLOYEE_ID INT PRIMARY KEY,
    EMPLOYEE_NAME VARCHAR(50) NOT NULL,
    MANAGER_ID INT NULL,
    FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEE_INFO(EMPLOYEE_ID)
);
-- Insert employees and managers into the EMPLOYEE_INFO table
INSERT INTO EMPLOYEE_INFO (EMPLOYEE_ID, EMPLOYEE_NAME, MANAGER_ID)
VALUES 
(1, 'Alice Johnson', NULL),       -- Alice is the CEO and has no manager
(2, 'Bob Smith', 1),              -- Bob reports to Alice
(3, 'Charlie Brown', 1),          -- Charlie also reports to Alice
(4, 'David Wilson', 2),           -- David reports to Bob
(5, 'Eve Davis', 2),              -- Eve reports to Bob
(6, 'Frank Harris', 3),           -- Frank reports to Charlie
(7, 'Grace Lee', 3);              -- Grace reports to Charlie

-- Verify the data
SELECT * FROM EMPLOYEE_INFO;


SELECT 
    e.employee_name AS employee, 
    coalesce(m.employee_name , 'no manager') AS manager
FROM
    employee_info AS e
    LEFT JOIN employee_info AS m ON e.manager_id = m.employee_id;

USE XYZ;
SELECT DISTINCT PLATFORM FROM COURSE;

SELECT 
	SUM(CASE WHEN PLATFORM ='OSTAD' THEN 1 ELSE 0 END) AS OSTAD_COURSES,
    SUM(CASE WHEN PLATFORM = 'BOHUBRIHI' THEN 1 ELSE 0 END) AS BOHUBRIHI_COURSES
FROM COURSE;