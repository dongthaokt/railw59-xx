DROP DATABASE IF EXISTS Testing_System_Assignment_bai1;
CREATE DATABASE Testing_System_Assignment_bai1; ;

use Testing_System_Assignment_bai1;


CREATE TABLE Department (
    DepartmentID INT primary key auto_increment,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Position (
    PositionID INT PRIMARY KEY AUTO_INCREMENT,
    PositionName VARCHAR(50)
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(100),
    Username VARCHAR(100),
    Fullname VARCHAR(100),
    DepartmentID INT,
    PositionID INT,
    CreateDate DATETIME
);
DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group` (
    GroupID INT PRIMARY KEY AUTO_INCREMENT,
    Groupname VARCHAR(100),
    CreatorID INT,
    CreateDate DATETIME
);

CREATE TABLE GroupAccount (
    GroupID INT,
    AccountID INT,
    JoinDate DATETIME
);

CREATE TABLE TypeQuestion (
    TypeID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(50)
);

CREATE TABLE CategoryQuestion (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50)
);

CREATE TABLE Question (
    QuestionID INT PRIMARY KEY AUTO_INCREMENT,
    Content VARCHAR(100),
    CategoryID INT,
    TypeID INT,
    CreatorID INT,
    CreatorDate DATETIME
);

CREATE TABLE Answer (
    AnswerID INT PRIMARY KEY AUTO_INCREMENT,
    Content VARCHAR(100),
    QuestionID INT,
    isCorrect BOOLEAN
);

CREATE TABLE Exam (
    ExamID INT PRIMARY KEY  AUTO_INCREMENT,
    Code INT,
    Title VARCHAR(50),
    CategoryID INT,
    Duration INT,
    CreatorID INT,
    CreateDate DATETIME
);

CREATE TABLE ExamQuestion (
    ExamID INT,
    QuestionID INT
);

--       Testing System Assignment 2:



CREATE DATABASE Testing_System_Assignment_2;

use Testing_System_Assignment_bai1;

ALTER TABLE Account ADD CONSTRAINT LK_1 FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);
ALTER TABLE Account ADD CONSTRAINT LK_2 FOREIGN KEY (PositionID) REFERENCES `Position`(PositionID);

ALTER TABLE GroupAccount ADD CONSTRAINT LK_3 FOREIGN KEY (GroupID) REFERENCES `Group`(GroupID);
-- B??? sung th??m
ALTER TABLE GroupAccount ADD CONSTRAINT LK_8 FOREIGN KEY (AccountID) REFERENCES Account(AccountID);
-- 1 Group s??? c?? nhi???u Account (1 Nh??m s??? c?? nhi???u ng?????i)
-- 1 ng?????i s??? thu???c nhi???u NH??m  (1 Account s??? thu???c nhi???u Group)
-- Li??n k???t nhi???u - nhi???u (n-n)

ALTER TABLE Question ADD CONSTRAINT LK_4 FOREIGN KEY (TypeID) REFERENCES TypeQuestion(TypeID);
ALTER TABLE Question ADD CONSTRAINT LK_5 FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID);

ALTER TABLE ExamQuestion ADD CONSTRAINT LK_6 FOREIGN KEY (ExamID) REFERENCES Exam(ExamID);
ALTER TABLE ExamQuestion ADD CONSTRAINT LK_7 FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID);

INSERT INTO Department(DepartmentID,Departmentname)
value   (1,'sele'),
		(2,'marketing'),
		(3,'nhansu'),
		(4,'ketoan'),
		(5,'kythuat'),
		(6,'tuvan'),
		(7,'hanhchinh'),
		(8,'giamdoc'),
		(9,'phogiamdoc'),
		(10,'nhanvien');
commit;

INSERT INTO Position (PositionID,PositionName)
value 	(1,'Developer'),
		(2,'test engineer'),
		(3,'ScrumMaster'),
		(4,'Programe manager'),
		(5,'Database Engineer'),
		(6,'administrator'),
		(7,'System Security'),
		(8,'NetworkArchitects'),
		(9,'System Analysist'),
		(10,'Java Developer');
commit;

INSERT INTO Account (Email,Username,Fullname,DepartmentID,PositionID,CreateDate)
value	('tuan@gmail.com' ,'minhtuan','TuMinhTuan',1,1,'1998-12-01'),
		('hoang@gmail.com' ,'hoangpham','Ph???m V??n Ho??ng',2,2,'2020-12-01'),
		('ngocanh@gmail.com' ,'anhnguyen','Nguy???n Ng???c Anh',3,3,'2018-12-01'),
		('huyentrang@gmail.com' ,'huyentrang','Tr????ng Huy???n Trang',4,4,'2021-12-10'),
		('quanglam@gmail.com' ,'lamnguyen','Nguy???n Quang L??m',5,5,'2019-12-12'),
		('thuhang@gmail.com' ,'hangnguyen','Nguy???n Th??? Thu H???ng',6,6,'2017-12-01'),
		('thanhluan@gmail.com' ,'luonho','H??? Th??nh Lu??n',7,7,'2021-12-01'),
		('kieuoanh@gmail.com' ,'oanhnguyen','Nguy???n Th??? Ki???u Oanh',8,8,'2022-12-01'),
		('vanvuong@gmail.com' ,'vuongnguyen','Nguy???n V??n V?????ng',9,9,'2020-10-01'),
		('vanluc@gmail.com' ,'lucnguyen','Nguy???n V??n L???c',10,10,'2021-12-01');

commit;

INSERT INTO `Group` (GroupID,GroupName,CreateDate)
value	(1,'nhom A','2018-12-01'),
		(2,'nhom B','2021-12-01'),
		(3,'nhom C','2020-12-01'),
		(4,'nhom D','2021-12-01'),
		(5,'nhom E','2022-12-01'),
		(6,'nhom F','2019-12-01'),
		(7,'nhom G','2021-12-01'),
		(8,'nhom H','2019-12-01'),
		(9,'nhom I','2018-12-01');




INSERT INTO GroupAccount (GroupID,AccountID,JoinDate)
value 	(1,1,'2017-12-01'),
		(2,2,'2019-12-01'),
		(3,2,'2021-12-02'),
        (4,2,'2018-12-03'),
        (5,5,'2021-12-04'),
        (6,6,'2021-12-05'),
        (7,7,'2019-12-06'),
        (8,8,'2021-12-07'),
        (9,9,'2020-12-08');


select * from GroupAccount;

 INSERT INTO TypeQuestion (TypeID,TypeName)
 value	 (1,'type1'),
		 (2,'type2'),
		 (3,'type3'),
		 (4,'typ4'),
		 (5,'type5'),
		 (6,'type6'),
		 (7,'type7'),
		 (8,'type8'),
		 (9,'type9'),
		 (10,'type10');

select * from TypeQuestion;

INSERT INTO CategoryQuestion value  (1,'java'),
									(2,'.Net'),
									(3,'SQL'),
									(4,'rupy'),
									(5,'Postman'),
									(6,'python'),
									(7,'c#'),
									(8,'c++'),
									(9,'database'),
									(10,'bigdata');


INSERT INTO Question(QuestionID,Content,TypeID,CategoryID,CreatorID,CreatorDate)
 value	(1,'noi dung cau hoi java',1,1,1,'2020-12-01'),
		(2,'noi dung cau hoi .Net',2,2,2,'2018-12-01'),
		(3,'noi dung cau hoi SQL',3,3,3,'2021-12-03'),
		 (4,'noi dung cau hoi rupy',4,4,4,'2018-12-04'),
		 (5,'noi dung cau hoi Postman',5,5,5,'2022-12-06'),
		 (6,'noi dung cau hoi python',6,6,6,'2018-12-03'),
		 (7,'noi dung cau hoi c#',7,7,7,'2012-12-08'),
		 (8,'noi dung cau hoi c++',8,8,8,'2021-12-05'),
		 (9,'noi dung cau hoi database',9,9,9,'2021-12-02'),
		 (10,'noi dung cau hoi bigdata',10,10,10,'2020-12-03');

select * from Question;

INSERT INTO Answer(Content,QuestionID)
value	 ('noidung cau tra loi java',1),
		('noidung cau tra loi .Net',1),
        ('noidung cau tra loi .Net',1),
        ('noidung cau tra loi .Net',1),
        ('noidung cau tra loi .Net',1),
		('noidung cau tra loi SQL',3),
		('noidung cau tra loi rupy',4),
		('noidung cau tra loi Postman',5),
		('noidung cau tra loi python',6),
		('noidung cau tra loi c#',7),
		('noidung cau tra loi c++',8),
		('noidung cau tra loi database',9),
		('noidung cau tra loi bigdata',10);



 INSERT INTO Exam value  (1,1,'title1', 1,120,1,'2021-12-01 12:01'),
						 (2,2,'title2',2,20,2,'2021-12-01 12:01'),
						 (3,3,'title3',3,60,3,'2021-12-01 12:01'),
						 (4,4,'title4',4,90,4,'2021-12-01 12:01'),
						 (5,5,'title5',5,180,5,'2021-12-01 12:01'),
						 (6,6,'title6',6,30,6,'2021-12-01 12:01'),
						 (7,7,'title7',7,60,7,'2021-12-01 12:01'),
						 (8,8,'title8',8,35,8,'2021-12-01 12:01'),
						 (9,9,'title9',9,90,9,'2021-12-01 12:01'),
						 (10,10,'title2',10,90,10,'2021-12-01 12:01');
 commit;
select * from Exam;


INSERT INTO ExamQuestion value (1,1),
								(2,2),
								(3,3),
								(4,4),
								(5,5),
								(6,6),
								(7,7),
								(8,8),
								(9,9),
								(10,10);




-- ----------------------------------------------Assign3

CREATE DATABASE Testing_System_Assignment_3;

use Testing_System_Assignment_1;

-- Question 1: Th??m ??t nh???t 10 record v??o m???i table
-- Question 2: l???y ra t???t c??? c??c ph??ng ban
select * from Department;

-- Question 3: l???y ra id c???a ph??ng ban "Sale"
select DepartmentID from Department where DepartmentName = "Sele";



-- Question 4: l???y ra th??ng tin account c?? full name d??i nh???t
select * from `Account` 
Where char_length(FullName) = (select max(char_length(FullName))From `Account`);


-- Question 5: L???y ra th??ng tin account c?? full name d??i nh???t v?? thu???c ph??ng ban c?? id=3

select * from (select * from `Account` 
where  DepartmentID=3 
group by Fullname) as temp
having char_length(temp.FullName) = (select max(char_length(FullName))From `Account` where DepartmentID=3);

-- Question 6: L???y ra t??n group ???? tham gia tr?????c ng??y 20/12/2010
select * from `Group`;
Select GroupName from `Group` where CreateDate < '2010-12-20';

-- Question 7: L???y ra ID c???a question c?? >= 4 c??u tr??? l???i
select * from answer;
select QuestionID,count(content)as cautraloi
 from answer
 group by QuestionID
having count(content) >=4;


-- Question 8: L???y ra c??c m?? ????? thi c?? th???i gian thi >= 60 ph??t v?? ???????c t???o tr?????c ng??y20/12/2019
select * from exam;
select ExamID from exam
where Duration >= 60 and CreateDate <= '2021-12-02';

-- Question 9: L???y ra 5 group ???????c t???o g???n ????y nh???t
select * from `group` order by createDate desc limit 5;

-- Question 10: ?????m s??? nh??n vi??n thu???c department c?? id = 2
select DepartmentID,count(DepartmentID) as soluong
 From Account
 where DepartmentID = 2
 group by DepartmentID;

-- Question 11: L???y ra nh??n vi??n c?? t??n b???t ?????u b???ng ch??? "T" v?? k???t th??c b???ng ch??? "g"
select Fullname from Account
where (Fullname like "T%")and (Fullname like "%g");
-- Question 12: X??a t???t c??? c??c exam ???????c t???o tr?????c ng??y 20/12/2019
Delete from exam where CreateDate <'2019-12-20';

-- Question 13: X??a t???t c??? c??c question c?? n???i dung b???t ?????u b???ng t??? "c??u h???i"
select * from question;
Delete from Question
where (Content like"cauhoi%");

-- Question 14: Update th??ng tin c???a account c?? id = 5 th??nh t??n "Nguy???n B?? L???c" v?? email th??nh loc.nguyenba@vti.com.vn
select * from Account;
update Account set Fullname = 'Nguy???n B?? L???c',Email = 'loc.nguyenba@vti.com.vn'where AccountID = 5;

-- Question 15: update account c?? id = 5 s??? thu???c group c?? id = 4
SELECT * 
FROM `GroupAccount`;
SET SQL_SAFE_UPDATES = 0;
UPDATE Groupaccount
 SET GroupID = 4
 WHERE AccountID = 5;
 