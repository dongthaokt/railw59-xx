USE TestingSystemAssignment1;
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DELIMITER $$
	CREATE TRIGGER TriggerCheckGroup
		BEFORE INSERT 
        ON `Group` FOR EACH ROW
		BEGIN 
			DECLARE v_CreateDate DATE;
            SET v_CreateDate = DATE_SUB(NOW(), INTERVAL 1 YEAR);
            IF (NEW.create_date < v_CreateDate) THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can`t add create date more than 1 year ago';
			END IF;
        END$$
DELIMITER ;

INSERT INTO `Group`(group_name, 	creator_id, 	create_date)
		VALUES 		('nhomthuchanh', 		2, 			'2015-03-11');
        SELECT * FROM `Group`;
        
/*Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào 
 department "Sale" nữa, khi thêm thì hiện ra thông báo "Department
 "Sale" cannot add more user"*/
DELIMITER $$
	CREATE TRIGGER TriggerCheckAccountInDepartment
		BEFORE INSERT 
        ON `Account` FOR EACH ROW
		BEGIN 
			DECLARE v_departmentID INT;
            SELECT department_id INTO v_departmentID
            FROM Department
            WHERE department_name = 'Sale';
            IF (NEW.department_id = v_departmentID) THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
			END IF;
        END$$
DELIMITER ;
SELECT * FROM `Account`;
INSERT INTO `Account`	(email,					user_name,				full_name,					department_id,			position_id,			create_date) 
VALUES 				
						('admin@gmail.com', 	'PhucNKK', 				N'Nguyễn Khôi Kim Phúc',			3,						1,				'2018-06-05');

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER TriggerCountUserinGroup;
DELIMITER $$
	CREATE TRIGGER TriggerCountUserinGroup
		AFTER INSERT 
        ON Group_Account FOR EACH ROW
		BEGIN 
			DECLARE v_countID INT;
            SELECT COUNT(group_id) INTO v_countID
            FROM Group_Account
            WHERE group_id = NEW.group_id
            GROUP BY group_id;
            IF v_countID > 5 THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'This group is now full';
			END IF;
        END$$
DELIMITER ;

INSERT INTO Group_Account	(group_id,			account_id,        		join_date	)
VALUES				
							(	1,					4,					'2022-02-25'),
							(	1,					5,					'2023-02-25');


-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER TriggerinQuestion;
DELIMITER $$
	CREATE TRIGGER TriggerinQuestion
		AFTER INSERT 
        ON Exam_Question FOR EACH ROW
		BEGIN 
			DECLARE v_CountQuestionID INT;
            SELECT COUNT(exam_id) INTO v_CountQuestionID
            FROM Exam_Question
            WHERE exam_id = NEW.exam_id
            GROUP BY exam_id;
            IF v_CountQuestionID > 5 THEN -- 10
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'This exam is now full';
			END IF;
        END$$
DELIMITER ;

SELECT * FROM Exam_Question;
INSERT INTO Exam_Question 	(exam_id,				question_id)
VALUES					  
							(	1,						7	),				
                            (	1,						3	),					
                            (	1,						6	),
                            (	1,						4	),
							(	1,						5	);

/*Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là 
 admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), 
 còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông 
 tin liên quan tới user đó*/
DROP TRIGGER TriggercheckEmailAccount;
DELIMITER $$
	CREATE TRIGGER TriggercheckEmailAccount
		BEFORE DELETE 
        ON `Account` FOR EACH ROW
		BEGIN 
			
            IF OLD.email='admin@gmail.com' THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can`t delete this account';
			END IF;
        END$$
DELIMITER ;

DELETE FROM `Account` WHERE email = 'admin@gmail.com';

/*Question 6: Không sử dụng cấu hình default cho field DepartmentID của table 
 Account, hãy tạo trigger cho phép người dùng khi tạo account không điền 
 vào departmentID thì sẽ được phân vào phòng ban "waiting Department"*/
DROP TRIGGER TriggerCheckDepartmenrt;
INSERT INTO Department(department_name)
		VALUES ('waiting Department');
DELIMITER $$
	CREATE TRIGGER TriggerCheckDepartmenrt
		BEFORE INSERT 
        ON `Account` FOR EACH ROW
		BEGIN 
			DECLARE v_departmentID VARCHAR(30);
            SELECT departmet_id INTO v_departmentID
            FROM Department
            WHERE departmet_name = 'waiting Department';
            
            IF NEW.department_id IS NULL THEN
				SET NEW.department_id = v_departmentID;
			END IF;
        END$$
DELIMITER ;

INSERT INTO `Account`	(email,					user_name,				full_name,								position_id,			create_date) 
VALUES 				
						('admin1@gmail.com', 	'PhucNKK', 				N'Nguyễn Khôi Kim Phúc',						1,				'2018-06-05');
INSERT INTO `Account`	(email,					user_name,				full_name,								position_id,			create_date) 
VALUES 				
						('admin4@gmail.com', 	'PhucUTK', 				'Nguyễn Khôi Kim Phúc',						1,				'2018-06-05');
SELECT * FROM `Account`;

/*Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi 
 question, trong đó có tối đa 2 đáp án đúng.*/
 DROP TRIGGER TriggerCheckDepartmenrt;
 DELIMITER $$
	CREATE TRIGGER TriggerCheckDepartmenrt
		BEFORE INSERT 
        ON Answer FOR EACH ROW
		BEGIN 
			DECLARE v_CountQuestionID INT;
            DECLARE v_CountisCorrect INT;
            
            SELECT COUNT(question_id) INTO v_CountQuestionID
            FROM Answer
            WHERE question_id = NEW.question_id
            GROUP BY question_id;
            SELECT COUNT(isCorrect) INTO v_CountisCorrect
            FROM Answer
            WHERE question_id = NEW.question_id AND isCorrect = NEW.isCorrect
			GROUP BY isCorrect;
            IF v_CountQuestionID > 4 OR v_CountisCorrect >2  THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can`t insert this question';
			END IF;
        END$$
DELIMITER ;
 
 INSERT INTO Answer	(content,			question_id,        isCorrect)
VALUES				
					('Answer Java',			3,					1),
                    ('Answer C++',			8,					0),
                    ('Answer C++',			8,					1),
					('Answer C++',			8,					1);

/*Question 8: Viết trigger sửa lại dữ liệu cho đúng: 
 Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định 
 Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database*/
ALTER TABLE `Account` ADD COLUMN Gender VARCHAR(10);
DROP TRIGGER TriggercheckGenderAccount;
DELIMITER $$
	CREATE TRIGGER TriggercheckGenderAccount
		BEFORE INSERT 
        ON `Account` FOR EACH ROW
		BEGIN 
            IF NEW.Gender='Nam' THEN SET NEW.Gender = 'M';
				ELSEIF NEW.Gender='Nữ' THEN SET NEW.Gender = 'N';
				ELSEIF NEW.Gender='Unknown' THEN SET NEW.Gender = 'U';
			END IF;
        END $$
DELIMITER ;
SELECT * FROM `Account`;
INSERT INTO `Account`	(email,					user_name,				full_name,								position_id,			create_date, 	Gender) 
VALUES 				
						('admin6@gmail.com', 	'PhucUTT', 				'Nguyễn Khôi Kim Phúc',						1,				'2018-06-05',   	'Nam' );
                        
SELECT * FROM `Account`;

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER TriggerdeleteExam;
DELIMITER $$
	CREATE TRIGGER TriggerdeleteExam
		BEFORE DELETE 
        ON Exam FOR EACH ROW
		BEGIN 
		DECLARE v_CreateDate DATE;
           SET v_CreateDate = DATE_SUB(NOW(), INTERVAL 2 DAY);
            IF OLD.create_date < v_CreateDate THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can`t delete exam that created more than 2 day ago';
			END IF;
        END$$
DELIMITER ;

SELECT * FROM Exam;
DELETE 
FROM Exam
WHERE exam_id = 3;

/*Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các 
 question khi question đó chưa nằm trong exam nào*/
DROP TRIGGER CheckUpdateInQuestion;
DELIMITER $$
CREATE TRIGGER CheckUpdateInQuestion
BEFORE UPDATE ON Question FOR EACH ROW 
	BEGIN
		DECLARE v_countquestionID INT;
        SELECT COUNT(question_id) INTO v_countquestionID
        FROM Exam_Question
        WHERE question_id = NEW.question_id
        GROUP BY question_id;
        IF v_countquestionID > 0 THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can`t update this question';
        END IF;
    END $$
DELIMITER ;
UPDATE Question 
SET content = 'Câu hỏi lạ'
WHERE question_id = 4;

DROP TRIGGER CheckDeleteInQuestion;
DELIMITER $$
CREATE TRIGGER CheckDeleteInQuestion
BEFORE DELETE ON Question FOR EACH ROW 
	BEGIN
		DECLARE v_countquestionID INT;
        SELECT COUNT(question_id) INTO v_countquestionID
        FROM Exam_Question
        WHERE question_id = OLD.question_id
        GROUP BY question_id;
        IF v_countquestionID > 0 THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can`t delete this question';
        END IF;
    END $$
DELIMITER ;

DELETE 
FROM Question
WHERE question_id = 1;

/*Question 12: Lấy ra thông tin exam trong đó:
Duration <= 30 thì sẽ đổi thành giá trị "Short time"
30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
Duration > 60 thì sẽ đổi thành giá trị "Long time"*/

SELECT *,CASE 
			WHEN duration <= 30 THEN 'Short time'
			WHEN duration > 30 AND duration <=60 THEN 'Medium time'
			ELSE 'Long time' 
		END as duration_type
FROM Exam;

/*Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên 
 là the_number_user_amount và mang giá trị được quy định như sau:
Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher*/

CREATE VIEW count_acc AS
SELECT COUNT(group_id) AS SL
FROM Group_Account
GROUP BY group_id;
SELECT SL, CASE
            WHEN SL <= 1 THEN 'few' -- 5
			WHEN SL > 1 AND SL <= 3 THEN 'normal' -- >5 AND <=20
			ELSE 'higher'
            END AS type_sl
FROM count_acc;

/*Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào 
 không có user thì sẽ thay đổi giá trị 0 thành "Không có User"*/
 
SELECT Dep.*, COUNT(Acc.department_id), CASE
            WHEN COUNT(Acc.department_id) = 0  THEN 'Không có User'
            END AS edit_department
FROM Department Dep
LEFT JOIN `Account` Acc ON Dep.department_id = Acc.department_id
GROUP BY Dep.department_id;

-- EX1 Check INSERT create date trên bảng account 
DROP TRIGGER TriggerCheckCreateDateinAccount;
DELIMITER $$
	CREATE TRIGGER TriggerCheckCreateDateinAccount
		BEFORE INSERT 
        ON `Account` FOR EACH ROW
		BEGIN          
            IF NEW.create_date > NOW() THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can`t insert this Account';
			END IF;
        END$$
DELIMITER ;

INSERT INTO `Account`	(email,					user_name,				full_name,				department_id,			position_id,			create_date) 
VALUES 				
						('email1@gmail.com', 	'PhucNK', 				N'Nguyễn Kim Phúc',			1,						1,					'2022-06-05');
                        
 -- EX2 Check UPDATE create date trên bảng account   
DROP TRIGGER TriggerUpdateinAccount;
DELIMITER $$
	CREATE TRIGGER TriggerUpdateinAccount
		BEFORE UPDATE 
        ON `Account` FOR EACH ROW
		BEGIN          
            IF (NEW.position_id = 1) THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can`t update department sale in this Account';
			END IF;
        END$$
DELIMITER ;

UPDATE `Account` SET department_id = 3 WHERE position_id = 1;