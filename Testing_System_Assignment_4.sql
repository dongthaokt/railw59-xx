 -- Testing Assignment 4
 USE TestingSystemAssignment1;
-- Ex1 : Join 
 -- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
 -- Danh sách nhân viên ==> Select bảng Account
 -- Phòng ban: LEFT  JOIN với bảng phòng ban
 select * from Account;
SELECT 	* A, D.DepartmentName
FROM 	`Account` A LEFT  JOIN Department D
ON 		A.DepartmentID = D.DepartmentID;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT	*
FROM	`Account`
WHERE	CreateDate > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
-- developer: Chức vụ 
-- Account ==> Join bảng Account và bảng Position
SELECT	A.*, P.PositionName
FROM	`Account` A INNER JOIN Position P
ON		A.PositionID = P.PositionID
WHERE	P.PositionName = 'Dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
-- danh sách phòng ban: table Department
-- Nhân viên: table Accout ==> Dùng JOIN (DepartmentID)
-- >, <,.. ==> COUNT  ==> Group BY.
SELECT 		D.DepartmentID, D.DepartmentName, COUNT(A.DepartmentID) AS 'SO LUONG'
FROM 		`Account` A INNER JOIN Department D
ON			D.DepartmentID = A.DepartmentID
GROUP BY 	A.DepartmentID
HAVING 		COUNT(A.DepartmentID)>=1;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT 		Q.QuestionID, Q.Content, Q.CategoryID, Q.TypeID, Q.CreatorID, Q.CreateDate, Count(Q.Content) AS 'SO LUONG'
FROM		Question Q INNER JOIN ExamQuestion EQ
ON			Q.QuestionID = EQ.QuestionID
GROUP BY	Q.Content
HAVING		COUNT(Q.Content) = (SELECT		MAX(CountQ)
								FROM		
										(SELECT 		COUNT(Q.QuestionID) AS CountQ
										FROM			ExamQuestion EQ INNER JOIN Question Q
										ON				EQ.QuestionID = Q.QuestionID
										GROUP BY		Q.QuestionID) AS MaxContent);
-- VP: 
(SELECT		MAX(CountQ)
								FROM		
										(SELECT 		COUNT(Q.QuestionID) AS CountQ
										FROM			ExamQuestion EQ INNER JOIN Question Q
										ON				EQ.QuestionID = Q.QuestionID
										GROUP BY		Q.QuestionID) AS MaxContent);
SELECT 	EQ.*,	COUNT(Q.QuestionID) AS CountQ
										FROM			ExamQuestion EQ INNER JOIN Question Q
										ON				EQ.QuestionID = Q.QuestionID
										GROUP BY		Q.QuestionID;
select * from ExamQuestion;
-- Question 6: Thống kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT		CQ.CategoryID, CQ.CategoryName, COUNT(Q.CategoryID)
FROM		CategoryQuestion CQ LEFT JOIN Question Q
ON			CQ.CategoryID = Q.CategoryID
GROUP BY	CQ.CategoryID
ORDER BY	CQ.CategoryID ASC;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT		Q.Content, COUNT(EQ.QuestionID)
FROM		Question Q LEFT JOIN ExamQuestion EQ
ON			EQ.QuestionID = Q.QuestionID
GROUP BY	Q.QuestionID
ORDER BY 	EQ.ExamID ASC;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT 		Q.QuestionID, Q.Content, COUNT(A.QuestionID) AS 'SO LUONG'
FROM		Question Q INNER JOIN Answer A 
ON			Q.QuestionID = A.QuestionID
GROUP BY	A.QuestionID
HAVING		COUNT(A.QuestionID) =	(SELECT 	MAX(CountQ)
									FROM		(SELECT 		COUNT(A.QuestionID) AS CountQ
												FROM			Answer A RIGHT JOIN  Question Q 
												ON				A.QuestionID = Q.QuestionID 
												GROUP BY		A.QuestionID) AS MaxCountQ);
			
-- Question 9: Thống kê số lượng account trong mỗi group
SELECT		G.GroupID, COUNT(GA.AccountID) AS 'SO LUONG'
FROM		GroupAccount GA RIGHT JOIN `Group` G
ON			GA.GroupID = G.GroupID
GROUP BY	G.GroupID
ORDER BY	G.GroupID ASC;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT 		P.PositionID, P.PositionName, COUNT(A.PositionID) AS 'SO LUONG'
FROM		Position P INNER JOIN `Account` A 
ON			P.PositionID = A.PositionID
GROUP BY 	P.PositionID
HAVING		COUNT(A.PositionID)	=	(SELECT 	MIN(CountP)
									FROM		(SELECT 	COUNT(P.PositionID) AS CountP
												FROM		Position P INNER JOIN `Account` A 
												ON			P.PositionID = A.PositionID		
												GROUP BY	P.PositionID) AS MinCountP);

-- Question 11: thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT 		D.DepartmentID, D.DepartmentName, COUNT(P.PositionID) AS 'SO LUONG'
FROM		Position P INNER JOIN `Account` A 
ON			P.PositionID = A.PositionID
RIGHT JOIN	Department D
ON			A.DepartmentID = D.DepartmentID
GROUP BY	A.DepartmentID
ORDER BY	A.DepartmentID ASC;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT 		T.TypeName AS 'LOAI_CAU_HOI',
            Q.CreatorID AS 'ID_NGUOI_TAO',
			Q.Content AS 'CAU_HOI', 
			A.Content AS 'CAU_TRA_LOI',
			Q.CreateDate AS 'NGAY_TAO'
FROM		Question Q INNER JOIN Answer A
ON			Q.QuestionID = A.QuestionID
INNER JOIN	TypeQuestion T
ON			Q.TypeID = T.TypeID;
-- Question 13: lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT		T.TypeName AS 'LOAI CAU HOI', COUNT(Q.TypeID) AS 'SO LUONG'
FROM		Question Q INNER JOIN TypeQuestion T
ON			Q.TypeID = T.TypeID
GROUP BY	Q.TypeID;
-- Question 14: lấy ra group không có account nào
SELECT		*
FROM		`Group` 
WHERE		GroupID  NOT IN
					(SELECT		GroupID
					FROM		GroupAccount);

-- Question 15: lấy ra group không có account nào
SELECT		*
FROM		`Group` 
WHERE		GroupID  NOT IN
					(SELECT		GroupID
					FROM		GroupAccount);
-- Question 16: lấy ra question không có answer nào 
Select Q.*, Count(A.QuestionID) as sl_answer  from Question Q
LEFT JOIN Answer A ON Q.QuestionID = A.QuestionID
Group By Q.QuestionID
Having Count(A.QuestionID) =0;
--
Select Q.*  from Question Q
LEFT JOIN Answer A ON Q.QuestionID = A.QuestionID
WHERE A.QuestionID is null;
-- Ex2 : Union
-- Question 17 :
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau 
Select A.AccountID , A.Email , A.Username , A.Fullname , G.GroupID from `GroupAccount` AS G
INNER JOIN `Account` AS A
ON G.AccountID = A.AccountID
WHERE G.GroupID = 1
UNION
Select A.AccountID , A.Email , A.Username , A.Fullname , G.GroupID from `GroupAccount` AS G
INNER JOIN `Account` AS A
ON G.AccountID = A.AccountID
WHERE G.GroupID = 2;
-- Question 18 : 
-- a) Lấy các group có lớn hơn 5 thành viên 
-- b) Lấy các group có lớn hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b)
Select G.GroupID , G.GroupName from `Group` AS G
INNER JOIN `GrouoAccount` AS G
ON G.GroupID = GA.GroupID
GROUP BY GA.GroupID
HAVING count (G.AccountID) > 5
UNION ALL
Select G.GroupID , G.GroupName from `Group` AS G
INNER JOIN `GroupAccount` AS G
ON G.GroupID = GA.GroupID
GROUP BY GA.GroupID
HAVING count (G.AccountID) < 7;



                        

 
 
 
 
 
 





