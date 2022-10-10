DROP DATABASE IF EXISTS Thuctap;
CREATE DATABASE Thuctap;
USE Thuctap;
DROP TABLE IF EXISTS Country;
CREATE TABLE Country (
Country_ID INT UNSIGNED  primary key auto_increment,
Country_Name Varchar(30) UNIQUE KEY
);

DROP TABLE IF EXISTS Location;
CREATE TABLE Location (
Location_ID INT UNSIGNED primary key auto_increment,
Street_Addrees Varchar(100),
Postal_Code INT NOT NULL,
Country_ID INT UNSIGNED,
FOREIGN KEY (Country_ID) REFERENCES Conutry(Country_ID)
);


DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
Employee_ID INT primary key auto_increment,
Full_Name Varchar(100) NOT NULL,
Emaill Varchar(100) NOT NULL,
Location_ID INT UNSIGNED,
FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID ON DELETE SET NULL
);

 -- Câu 1 :
 
 INSERT INTO  `thuctap`.`country` (`Country_ID`,`Country_Name`) VALUES (`1`,`Viet Nam`);
 INSERT INTO  `thuctap`.`country` (`Country_ID`,`Country_Name`) VALUES (`2`,`Han Quoc`);
 INSERT INTO  `thuctap`.`country` (`Country_ID`,`Country_Name`) VALUES (`3`,`Thai Lan`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`1`,`nn01`,`nn01@gmail.com`,`1`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`2`,`nn02`,`nn02@gmail.com`,`2`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`3`,`nn03`,`nn03@gmail.com`,`3`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`4`,`nn04`,`nn04@gmail.com`,`1`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`5`,`nn05`,`nn05@gmail.com`,`2`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`6`,`nn06`,`nn06@gmail.com`,`2`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`7`,`nn07`,`nn07@gmail.com`,`1`);
 INSERT INTO  `thuctap`.`employee` (`Employee_ID`,`Full_Name`,`Email`,`Location_ID`) VALUES (`8`,`nn08`,`nn08@gmail.com`,`2`);
 INSERT INTO  `thuctap`.`location` (`Location_ID`,`Street_Addrees`,`Postal_Code`,`Country_ID`) VALUES (`1`,`Hà Nội`,`12343`,`1`);
 INSERT INTO  `thuctap`.`location` (`Location_ID`,`Street_Addrees`,`Postal_Code`,`Country_ID`) VALUES (`2`,`Seoul`,`12345`,`2`);
 INSERT INTO  `thuctap`.`location` (`Location_ID`,`Street_Addrees`,`Postal_Code`,`Country_ID`) VALUES (`3`,`Băng Cốc`,`12346`,`1`);
 
 
 -- Câu 2 : 
 -- a) Lấy tất cả các nhân viên thuộc Việt Nam 
 
 SELECT E.Employee_ID, E.Full_Name, C.Country_Name FROM Employee E
 JOIN Location L ON L.Location_ID = E.Location_ID
 JOIN Country C ON C.Coutry_ID =L.Country_ID
 WHERE C.Country_Name = `Việt Nam`;
 
 -- b) Lấy ra tên quốc gia của employee có email là "nn03@gmail.com"
 
 SELECT 
 
 
 


 