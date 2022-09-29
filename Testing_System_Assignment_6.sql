USE Testing _Assignment_1;

/*Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các 
 account thuộc phòng ban đó*/
 DROP PROCEDURE IF EXISTS Get_acc_infor;
 DELIMITER $$
 CREATE PROCEDURE Get_acc_infor (IN in_department_name VARCHAR(50) )
	BEGIN 
		SELECT Acc.*, Dep.department_name
		FROM `Account` Acc
		JOIN Department Dep ON Acc.department_id = Dep.department_id
		WHERE Dep.department_name = in_department_name;
	END $$
 DELIMITER ;

-- Test Procudure
 CALL Get_acc_infor('Purchase');
 
-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS Get_acc_in_group;
 DELIMITER $$
 CREATE PROCEDURE Get_acc_in_group()
	BEGIN 
		SELECT G.group_id, G.group_name, COUNT(GA.account_id)
		FROM Group_Account GA
		RIGHT JOIN `Group` G ON GA.group_id = G.group_id
		GROUP BY G.group_id;
	END $$
 DELIMITER ;
-- Test Procedure
CALL Get_acc_in_group();

/*Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo 
 trong tháng hiện tại*/
 
DROP PROCEDURE IF EXISTS Get_ques_in_month;
DELIMITER $$
 CREATE PROCEDURE Get_ques_in_month()
	BEGIN
		SELECT TQ.type_name, COUNT(Que.type_id)
		FROM Type_Question TQ
        RIGHT JOIN Question Que ON  Que.type_id = TQ.type_id 
        WHERE 	YEAR(create_date) = YEAR(NOW()) AND 
				MONTH(create_date) = MONTH(NOW())
		GROUP BY Que.type_id;
    END$$
DELIMITER ;

-- Test Procedure
CALL Get_ques_in_month();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS Get_typeques_in_max;
DELIMITER $$
 CREATE PROCEDURE Get_typeques_in_max(OUT result_question_id INT)
	BEGIN
		SELECT Que.type_id INTO result_question_id
		FROM Type_Question TQ
		RIGHT JOIN Question Que ON  Que.type_id = TQ.type_id 
		GROUP BY Que.type_id
		HAVING COUNT(Que.type_id) = (SELECT MAX(dem) AS count_max
										FROM (SELECT COUNT(Que.type_id) AS dem
												FROM  Question Que
												GROUP BY Que.type_id) AS list_count);
    END$$
DELIMITER ;

-- Test Procedure
SET @result_question_id = '';
CALL Get_typeques_in_max(@result_question_id);
SELECT  @result_question_id;

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS Get_typeques_in_name;
DELIMITER $$
 CREATE PROCEDURE Get_typeques_in_name(OUT result_question_id INT)
	BEGIN
		SET result_question_id = (SELECT Que.type_id
									FROM Type_Question TQ
									RIGHT JOIN Question Que ON  Que.type_id = TQ.type_id 
									GROUP BY Que.type_id
									HAVING COUNT(Que.type_id) = (SELECT MAX(dem) AS count_max
																	FROM (SELECT COUNT(Que.type_id) AS dem
																			FROM  Question Que
																			GROUP BY Que.type_id) AS list_count));
    END$$
DELIMITER ;

-- Test Procedure
CALL Get_typeques_in_name(@result_question_id);
SELECT * 
FROM Type_Question 
WHERE type_id = @result_question_id;

/*Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên 
 chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa 
 chuỗi của người dùng nhập vào*/
 DROP PROCEDURE IF EXISTS Get_username_by_text;
DELIMITER $$
CREATE PROCEDURE Get_username_by_text(IN p_text VARCHAR(30), IN checkNumber BIT)
	BEGIN
   IF checkNumber = 1 THEN
			SELECT group_name  FROM `Group` WHERE group_name LIKE CONCAT('%',p_text, '%');
     ELSE 
			SELECT user_name  FROM `Account` WHERE user_name LIKE CONCAT('%',p_text, '%');
	END IF;
	END $$
DELIMITER ;
 -- Test Procudure
CALL Get_username_by_text('uc',0);
 
/*Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và 
 trong store sẽ tự động gán:
username sẽ giống email nhưng bỏ phần @..mail đi
positionID: sẽ có default là developer
departmentID: sẽ được cho vào 1 phòng chờ
 Sau đó in ra kết quả tạo thành công*/
DROP PROCEDURE IF EXISTS Get_info_acc;
DELIMITER $$
CREATE PROCEDURE Get_info_acc(IN p_fullName VARCHAR(50), p_Email VARCHAR(50))
	BEGIN
		DECLARE v_userName VARCHAR(50) DEFAULT SUBSTRING_INDEX(p_Email,'@',1);
        DECLARE v_positionID SMALLINT UNSIGNED DEFAULT 1;
        DECLARE v_departmentID SMALLINT UNSIGNED DEFAULT NULL;
        INSERT INTO `Account`(email,	user_name,		full_name,		department_id,		position_id,		create_date)
        VALUE				(p_Email,	v_userName,		p_fullName,		v_departmentID,		v_positionID,		NOW()		);
	END $$
DELIMITER ;

-- Test Procedure
CALL Get_info_acc('Nicolas', 'nicolasXT@gmail.com');
SELECT * FROM `Account` WHERE full_name = 'Nicolas';
 
/*Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
 để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất*/
 -- Tạo Procedure tìm max 
 -- Tạo Procedure tìm content dài nhất theo loại câu hỏi
DROP PROCEDURE IF EXISTS GET_max;
DELIMITER $$
 CREATE PROCEDURE GET_max (IN p_typeID TINYINT UNSIGNED)
	BEGIN 
		WITH length_type AS (
			SELECT length(content) AS SL
            FROM Question 
            WHERE type_id = p_typeID
        )
        SELECT content FROM Question 
        WHERE type_id = p_typeID AND length(content) = (SELECT MAX(SL) FROM length_type);
    END$$
DELIMITER ;
/*SELECT QUe.type_id,length(content) AS SL, TQ.type_name, Que.content
            FROM Question Que
            JOIN Type_Question TQ ON Que.type_id = TQ.type_id
			WHERE TQ.type_id = 1;*/
/*SELECT QUe.type_id,length(content) AS SL, TQ.type_name, Que.content
            FROM Question Que
            JOIN Type_Question TQ ON Que.type_id = TQ.type_id
			WHERE TQ.type_id = 2;*/
DROP PROCEDURE IF EXISTS Get_MaxLengthContent_byTypeQues;
DELIMITER $$
 CREATE PROCEDURE Get_MaxLengthContent_byTypeQues(IN p_TypeQuestion VARCHAR(20))
	BEGIN	
		DECLARE v_typeID INT UNSIGNED; 
        SELECT Que.type_id INTO v_typeID
        FROM Question Que
        JOIN Type_Question TQ ON Que.type_id = TQ.type_id
		GROUP BY TQ.type_name
        HAVING TQ.type_name = p_TypeQuestion;
        CALL GET_max(v_typeID);
    END$$
DELIMITER ;

CALL Get_MaxLengthContent_byTypeQues('Essay');
CALL Get_MaxLengthContent_byTypeQues('Multiple-Choice');

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS Get_delete_exam_by_ID;
DELIMITER $$
CREATE PROCEDURE Get_delete_exam_by_ID(IN p_examID SMALLINT UNSIGNED)
	BEGIN
		DELETE 
        FROM Exam
        WHERE exam_id = p_examID;
	END $$
DELIMITER ;

-- Test Procedure 
CALL Get_delete_exam_by_ID(2);
SELECT * FROM Exam;


/*Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử 
 dụng store ở câu 9 để xóa)
 Sau đó in số lượng record đã remove từ các table liên quan trong khi 
 removing*/
 
DROP PROCEDURE IF EXISTS Get_delete_examFor3Year;
DELIMITER $$
CREATE PROCEDURE Get_delete_examFor3Year()
	BEGIN
		DELETE 
        FROM Exam
        WHERE YEAR(NOW()) - YEAR(create_date) >2;
	END $$
DELIMITER ;
CALL Get_delete_examFor3Year();
SELECT * FROM Exam;
 
/*Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng 
 nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được 
 chuyển về phòng ban default là phòng ban chờ việc*/
 
DROP PROCEDURE IF EXISTS GetDeleteDepByName;
DELIMITER $$
CREATE PROCEDURE GetDeleteDepByName(IN p_dep_name VARCHAR(50))
	BEGIN
		DECLARE ID INT;
		SELECT department_id INTO ID
        FROM Department 
        WHERE department_name = p_dep_name;
        UPDATE `Account` SET 
        department_id = NULL 
        WHERE department_id = ID;
        DELETE 
        FROM Department
        WHERE department_name = p_dep_name;
	END $$
DELIMITER ;

CALL GetDeleteDepByName('Sale');
SELECT * FROM `Account`;
 
-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
-- B1: Tạo bảng in ra các tháng trong năm 
-- B2: In bảng đã tạo sử dụng Join để lấy thông tin lượng câu hỏi theo từng tháng dựa vào tháng tạo câu hỏi và bảng các tháng vừa tạo

/*Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 
 tháng gần đây nhất
 (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong 
tháng")*/



-- Ex1: Hiển thị thông tin các nhân viên của phòng ban tương ứng nhập từ bàn phím
DROP PROCEDURE IF EXISTS Get_staff_by_department;
DELIMITER $$
CREATE PROCEDURE Get_staff_by_department(IN in_department_name VARCHAR(30))
	BEGIN 
		SELECT Acc.*, Dep.department_name
        FROM `Account` Acc
        JOIN Department Dep ON Acc.department_id = Dep.department_id
        WHERE Dep.department_name = in_department_name;
	END $$
DELIMITER ;

CALL Get_staff_by_department('Purchase');

-- Ex2: Hiển thị fullname của nhân viên khi nhập vào ID của họ
DROP PROCEDURE IF EXISTS Get_fullname_by_ID;
DELIMITER $$
CREATE PROCEDURE Get_fullname_by_ID(IN p_account_id SMALLINT UNSIGNED, OUT p_full_name VARCHAR(50))
	BEGIN 
		SELECT full_name INTO p_full_name
        FROM `Account`
        WHERE account_id = p_account_id;
	END $$
DELIMITER ;
SET @full_name = 0;
CALL Get_fullname_by_ID(2,@full_name);
SELECT @full_name;


-- Ex2: Hiển thị fullname, email của nhân viên khi nhập vào ID của họ
DROP PROCEDURE IF EXISTS Get_fullnameAndEmail_by_ID;
DELIMITER $$
CREATE PROCEDURE Get_fullnameAndEmail_by_ID(IN p_account_id SMALLINT UNSIGNED, OUT p_full_name VARCHAR(50), OUT p_email VARCHAR(50))
	BEGIN 
		SELECT full_name, email INTO p_full_name, p_email
        FROM `Account`
        WHERE account_id = p_account_id;
	END $$
DELIMITER ;
SET @full_name = 0;
SET @email= 0;
CALL Get_fullnameAndEmail_by_ID(2,@full_name,@email);
SELECT @full_name, @email;

-- Ex2: Tạo biến nội bộ , In ra thông tin của nhân viên dựa vào department id
/*DROP PROCEDURE IF EXISTS Get_info_by_ID;
DELIMITER $$
CREATE PROCEDURE Get_info_by_ID(IN p_department_id SMALLINT UNSIGNED)
BEGIN 
		DECLARE v_account_id INT;
		WITH  v_account_id AS (SELECT department_id
							FROM `Account`
							WHERE department_id = p_department_id)
        SELECT * FROM `Account` WHERE department_id IN v_account_id;
END $$
DELIMITER ;

CALL Get_info_by_ID(3);*/