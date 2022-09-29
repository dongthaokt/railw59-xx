-- Testing Assignment 5
USE TestingSystemAssignment4;
-- Question 1 :Tạo view có chứa danh sách nhân viên thuộc phòng ban 

DROP VIEW IF EXISTS `list of sales staff`;
CREATE VIEW  `list of sales staff` AS
SELECT     A.AccountID, A.Email, A.Fullname 
FROM        Department D
INNER JOIN `Account` A ON D.Department = A.DepartmentID
WHERE      D.DepartmentName = `sale`;

SELECT  *
FROM `list of sales staff`;

-- Question 2 :Tạo view có chứa thông tin account tham gia vào  group nhiều nhất

WITH  CTE_count_staff AS 
	(SELECT COUNT(GA.account_id) As dem
	FROM Group_Account GA
	GROUP BY GA.account_id
	)
SELECT  Acc.full_name, Acc.user_name,COUNT(GA.account_id) AS count_max_join
FROM Group_Account GA
JOIN `Account` Acc ON GA.account_id = Acc.account_id 
GROUP BY GA.account_id
HAVING COUNT(GA.account_id) IN (SELECT MAX(dem) FROM CTE_count_staff);

-- Question 3 : Tạo view có chứa câu hỏi có những content quá dài (content quá 17 từ được coi là content quá dài) và xóa bỏ nó đi

DROP VIEW IF EXISTS del_content;
CREATE VIEW del_content AS 
	SELECT  *
	FROM Question 
	WHERE length(content) > 17;
SELECT * FROM del_content;
DELETE 
FROM del_content;

-- Question 4 : Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất

DROP VIEW IF EXISTS count_staff;
CREATE VIEW count_staff AS 
	SELECT Acc.department_id, Dep.department_name, COUNT(Acc.department_id)
	FROM `Account` Acc 
	JOIN Department Dep ON Acc.department_id = Dep.department_id 
	GROUP BY Acc.department_id
	HAVING COUNT(Acc.department_id) IN (SELECT MAX(dem) AS count_max
										FROM (SELECT COUNT(Acc.department_id) AS dem
												FROM `Account` Acc
												GROUP BY Acc.department_id) AS SL
										);
SELECT * FROM count_staff;

-- Cách 2: Dùng CTE 
WITH count_staff AS 
	(SELECT COUNT(department_id) As dem
	FROM `Account` 
	GROUP BY department_id),
	
	count_max AS (
	SELECT MAX(dem)
	FROM count_staff
	)
    
SELECT Dep.department_name, Dep.department_id, COUNT(Acc.department_id) 
FROM `Account` Acc
JOIN Department Dep ON Acc.department_id = Dep.department_id
GROUP BY Acc.department_id
HAVING COUNT(Acc.department_id) IN (SELECT * FROM count_max);

-- Question 5 : Tạo view có chứa tất cả các câu hỏi do  user họ Nguyễn tạo 

WITH Get_nv_cre_ques AS 
	(
	SELECT account_id
	FROM `Account`
	WHERE full_name LIKE ('Nguyễn%')
	)

SELECT Acc.full_name
FROM Question Que
JOIN `Account` Acc ON Que.creator_id = Acc.account_id
WHERE Que.creator_id IN  (SELECT * FROM Get_nv_cre_ques);






