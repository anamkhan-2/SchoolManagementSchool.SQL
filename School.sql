CREATE DATABASE SchoolManagementSystem;
USE SchoolManagementSystem;
DROP DATABASE SchoolManagementSystem;

 ----- CREATING TABLES-----

-- Create a table for classes
CREATE TABLE Class (
    ClassID INT PRIMARY KEY,
    ClassName VARCHAR(50)
);
-- Create a table for students
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Birthdate DATE,
    PhoneNumber VARCHAR(50),
    Address VARCHAR(100)
);
-- Create a table for teachers
CREATE TABLE Teacher (
    TeacherID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary MONEY,
    PhoneNumber VARCHAR(50),
    Address VARCHAR(200)
);

-- Create a table for student enrollment in classes and sections
CREATE TABLE StudentEnrollments (
    StudentID INT,
    SectionID INT,
    PRIMARY KEY (StudentID, SectionID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE
);

-- Create a table for attendance
CREATE TABLE Attendence (
    AttendanceID INT PRIMARY KEY,
    StudentID INT,
    SectionID INT,
    AttendanceDate DATE,
    IsPresent VARCHAR(10) CHECK (IsPresent IN ('Present', 'Absent')),
    FOREIGN KEY (StudentID, SectionID) REFERENCES StudentEnrollments(StudentID, SectionID) ON DELETE CASCADE,
    CONSTRAINT UC_StudentAttendance UNIQUE (StudentID, AttendanceDate)
);

-- Create a table for subjects
CREATE TABLE Subject (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(100),
    TeacherID INT,
    SectionID INT,
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);


-- Create a table for fees
CREATE TABLE Fee (
    FeeID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT,
    Amount DECIMAL(10, 2) DEFAULT 8000, 
    AmountPaid DECIMAL(10, 2) DEFAULT 0,  -- New attribute to track amount paid
    TotalFee AS (Amount + AmountPaid),  -- Computed column for total fee
    IsPaid VARCHAR(10) CHECK (IsPaid IN ('Paid', 'Unpaid')),
    Month VARCHAR(20),
    FeesManagerID INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    CONSTRAINT UC_StudentMonth UNIQUE (StudentID, Month)
);




-- Create a table for fees history
CREATE TABLE FeeHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT,
    StudentName VARCHAR(100),
    ClassName VARCHAR(50),
    SectionName VARCHAR(50),
    Amount DECIMAL(10, 2),
    Month VARCHAR(20),
    FeesManagerID INT,
    FeesManagerName VARCHAR(100),
    PaidStatus VARCHAR(10),  -- Added attribute for Paid or Unpaid
    Timestamp DATETIME DEFAULT GETDATE()
);

-- Create a table for tests
CREATE TABLE Test (
    TestID INT PRIMARY KEY,
    TestDate DATE,
    CategoryID INT,
);

-- Create a table for test results
CREATE TABLE TestResult (
    ResultID INT PRIMARY KEY,
    StudentID INT,
    TestID INT,
    ObtainMarks INT,
    TotalMarks INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (TestID) REFERENCES Test(TestID),
);

CREATE TABLE FeeLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT,
    AmountPaidOld DECIMAL(10, 2),
    AmountPaidNew DECIMAL(10, 2),
    StatusOld VARCHAR(10),
    StatusNew VARCHAR(10),
    ChangeDate DATETIME
);

CREATE TABLE Section (
    SectionID INT PRIMARY KEY,
    SectionName VARCHAR(50),
    ClassID INT,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);


CREATE TABLE AttendanceLog (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    SubjectID INT NOT NULL,
    AttendenceDate DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    log_date DATETIME DEFAULT GETDATE()
);



  ----INSERTING VALUES INTO TABLES----

--Inserting in Classes--
INSERT INTO Class (ClassID, ClassName) VALUES
(1, 'Mathematics'),
(2, 'Computer Science'),
(3, 'Physics'),
(4, 'Chemistry'),
(5, 'Biology'),
(6, 'English Literature'),
(7, 'History'),
(8, 'Geography'),
(9, 'Philosophy'),
(10, 'Economics');

-- Insert values into Students table--
INSERT INTO Student (StudentID, FirstName, LastName, Birthdate, PhoneNumber, Address) VALUES
(1, 'John', 'Smith', '2001-05-15', '123-456-7890', '123 Maple Street'),
(2, 'Emma', 'Johnson', '2002-08-21', '987-654-3210', '456 Oak Avenue'),
(3, 'Michael', 'Brown', '2000-11-12', '555-123-4567', '789 Pine Road'),
(4, 'Sophia', 'Miller', '2003-03-04', '444-555-6666', '101 Elm Boulevard'),
(5, 'William', 'Wilson', '2001-07-19', '333-444-5555', '202 Cedar Lane'),
(6, 'Olivia', 'Davis', '2002-02-22', '222-333-4444', '303 Birch Drive'),
(7, 'James', 'Martinez', '2000-09-10', '111-222-3333', '404 Walnut Court'),
(8, 'Isabella', 'Garcia', '2001-01-25', '666-777-8888', '505 Cherry Street'),
(9, 'Alexander', 'Lopez', '2003-06-30', '777-888-9999', '606 Spruce Road'),
(10, 'Charlotte', 'Hernandez', '2002-12-11', '888-999-0000', '707 Ash Avenue');


INSERT INTO Section (SectionID, SectionName, ClassID) VALUES
(1, 'A', 1),
(2, 'B', 2),
(3, 'C', 3),
(4, 'D', 4),
(5, 'E', 5),
(6, 'F', 6),
(7, 'G', 7),
(8, 'H', 8),
(9, 'I', 9),
(10, 'J', 10);

-- Insert values into AttendanceLog table
INSERT INTO AttendanceLog (StudentID, SubjectID, AttendenceDate, status) VALUES
(1, 101, '2024-12-01', 'Present'),
(2, 102, '2024-12-01', 'Absent'),
(3, 103, '2024-12-01', 'Present'),
(4, 101, '2024-12-01', 'Absent'),
(5, 102, '2024-12-01', 'Present'),
(6, 103, '2024-12-01', 'Absent'),
(7, 101, '2024-12-02', 'Present'),
(8, 102, '2024-12-02', 'Present'),
(9, 103, '2024-12-02', 'Absent'),
(10, 101, '2024-12-02', 'Present');


-- Insert values into Teachers table--
INSERT INTO Teacher (TeacherID, FirstName, LastName, Salary, PhoneNumber, Address) VALUES
(1, 'David', 'Smith', 55000, '123-456-7890', '123 Maple Street'),
(2, 'Emily', 'Johnson', 60000, '234-567-8901', '456 Oak Avenue'),
(3, 'Daniel', 'Williams', 58000, '345-678-9012', '789 Pine Road'),
(4, 'Sophia', 'Brown', 62000, '456-789-0123', '101 Elm Boulevard'),
(5, 'Matthew', 'Jones', 61000, '567-890-1234', '202 Cedar Lane'),
(6, 'Ava', 'Garcia', 57000, '678-901-2345', '303 Birch Drive'),
(7, 'Ethan', 'Martinez', 59000, '789-012-3456', '404 Walnut Court'),
(8, 'Mia', 'Lopez', 63000, '890-123-4567', '505 Cherry Street'),
(9, 'James', 'Hernandez', 60000, '901-234-5678', '606 Spruce Road'),
(10, 'Isabella', 'Gonzalez', 62000, '012-345-6789', '707 Ash Avenue');

-- Insert values into StudentEnrollment table--
INSERT INTO StudentEnrollments (StudentID, SectionID) VALUES
(1, 101),
(2, 102),
(3, 103),
(4, 101),
(5, 102),
(6, 103),
(7, 104),
(8, 105),
(9, 104),
(10, 105);

-- Insert values into Attendance table--
INSERT INTO Attendence (AttendanceID, StudentID, SectionID, AttendanceDate, IsPresent) VALUES
(1, 1, 101, '2024-06-01', 'Present'),
(2, 2, 102, '2024-06-01', 'Absent'),
(3, 3, 103, '2024-06-01', 'Present'),
(4, 4, 101, '2024-06-01', 'Absent'),
(5, 5, 102, '2024-06-01', 'Present'),
(6, 6, 103, '2024-06-01', 'Present'),
(7, 7, 104, '2024-06-01', 'Absent'),
(8, 8, 105, '2024-06-01', 'Present'),
(9, 9, 104, '2024-06-01', 'Absent'),
(10, 10, 105, '2024-06-01', 'Present');

-- Insert values into Subjects table--
INSERT INTO Subject (SubjectID, SubjectName, TeacherID, SectionID) VALUES
(1, 'Mathematics', 1, 101),
(2, 'Computer Science', 2, 102),
(3, 'Physics', 3, 103),
(4, 'Chemistry', 4, 101),
(5, 'Biology', 5, 102),
(6, 'English Literature', 6, 103),
(7, 'History', 7, 104),
(8, 'Geography', 8, 105),
(9, 'Philosophy', 9, 104),
(10, 'Economics', 10, 105);

-- Insert values into Fees table with AmountPaid included
INSERT INTO Fee (StudentID, Amount, AmountPaid, IsPaid, Month, FeesManagerID) VALUES
(1, 8000, 8000, 'Paid', 'January', 101),
(2, 8000, 0, 'Unpaid', 'January', 102),
(3, 8000, 8000, 'Paid', 'February', 101),
(4, 8000, 8000, 'Paid', 'February', 103),
(5, 8000, 0, 'Unpaid', 'March', 102),
(6, 8000, 8000, 'Paid', 'March', 101),
(7, 8000, 0, 'Unpaid', 'April', 103),
(8, 8000, 8000, 'Paid', 'April', 104),
(9, 8000, 0, 'Unpaid', 'May', 102),
(10, 8000, 8000, 'Paid', 'May', 104);


-- Insert values into FeesHistory table--
INSERT INTO FeeHistory (StudentID, StudentName, ClassName, SectionName, Amount, Month, FeesManagerID, FeesManagerName, PaidStatus) VALUES
(1, 'John Smith', 'Mathematics', 'A', 8000, 'January', 101, 'Mr. David', 'Paid'),
(2, 'Emma Johnson', 'Physics', 'B', 8000, 'January', 102, 'Ms. Emily', 'Unpaid'),
(3, 'Michael Brown', 'Computer Science', 'C', 8000, 'February', 101, 'Mr. David', 'Paid'),
(4, 'Sophia Miller', 'Chemistry', 'A', 8000, 'February', 103, 'Ms. Sophia', 'Paid'),
(5, 'William Wilson', 'Biology', 'B', 8000, 'March', 102, 'Ms. Emily', 'Unpaid'),
(6, 'Olivia Davis', 'English Literature', 'C', 8000, 'March', 104, 'Mr. Matthew', 'Paid'),
(7, 'James Martinez', 'History', 'A', 8000, 'April', 103, 'Ms. Sophia', 'Unpaid'),
(8, 'Isabella Garcia', 'Geography', 'B', 8000, 'April', 104, 'Mr. Matthew', 'Paid'),
(9, 'Alexander Lopez', 'Philosophy', 'C', 8000, 'May', 105, 'Mr. Ethan', 'Unpaid'),
(10, 'Charlotte Hernandez', 'Economics', 'A', 8000, 'May', 105, 'Mr. Ethan', 'Paid');

-- Insert values into Tests table--
INSERT INTO Test (TestID, TestDate, CategoryID) VALUES
(1, '2024-06-01', 101),
(2, '2024-06-02', 102),
(3, '2024-06-03', 103),
(4, '2024-06-04', 104),
(5, '2024-06-05', 105),
(6, '2024-06-06', 106),
(7, '2024-06-07', 107),
(8, '2024-06-08', 108),
(9, '2024-06-09', 109),
(10, '2024-06-10', 110);

-- Corrected Insert for FeeLog Table
INSERT INTO FeeLog (StudentID, AmountPaidOld, AmountPaidNew, StatusOld, StatusNew, ChangeDate) 
VALUES
(1, 5000, 8000, 'Unpaid', 'Paid', '2024-06-01'),
(2, 0, 5000, 'Unpaid', 'Paid', '2024-06-02'),
(3, 4000, 8000, 'Unpaid', 'Paid', '2024-06-03'),
(4, 6000, 8000, 'Unpaid', 'Paid', '2024-06-04'),
(5, 3000, 8000, 'Unpaid', 'Paid', '2024-06-05'),
(6, 2000, 8000, 'Unpaid', 'Paid', '2024-06-06'),
(7, 4000, 8000, 'Unpaid', 'Paid', '2024-06-07'),
(8, 3000, 8000, 'Unpaid', 'Paid', '2024-06-08'),
(9, 1000, 8000, 'Unpaid', 'Paid', '2024-06-09'),
(10, 0, 8000, 'Unpaid', 'Paid', '2024-06-10');


-- Insert values into TestResults table--
INSERT INTO TestResult (ResultID, StudentID, TestID, ObtainMarks, TotalMarks) VALUES
(1, 1, 1, 45, 50),
(2, 2, 2, 40, 50),
(3, 3, 3, 38, 50),
(4, 4, 4, 42, 50),
(5, 5, 5, 48, 50),
(6, 6, 6, 36, 50),
(7, 7, 7, 44, 50),
(8, 8, 8, 41, 50),
(9, 9, 9, 39, 50),
(10, 10, 10, 47, 50);

           ----SELECT STATEMENTS----
select *from Student;
select *from Class;
select *from Teacher;
select *from StudentEnrollments;
select *from Subject;
select *from Attendence;
select *from Fee;
select *from Test;
select *from TestResult;
select *from FeeLog;
select *from AttendanceLog;

CREATE INDEX idx_student_id
ON Student (StudentID);

                       ----Triggers----

                ----Prevent Negative Marks in TestResults----
CREATE TRIGGER trg_PreventNegativeMarks
ON TestResult
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted
        WHERE ObtainMarks < 0
    )
    BEGIN
        RAISERROR ('Marks obtained cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
                   ---After Update - Fee Payment Validation---

CREATE TRIGGER trg_AfterUpdateFee
ON Fee
AFTER UPDATE
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        WHERE i.AmountPaid > i.Amount  
    )
    BEGIN
        RAISERROR ('Amount paid cannot exceed the total fee.', 16, 1);
        ROLLBACK TRANSACTION;
    END;


    IF EXISTS (
        SELECT 1
        FROM Inserted i
        INNER JOIN Deleted d ON i.StudentID = d.StudentID
        WHERE i.AmountPaid <> d.AmountPaid OR i.IsPaid <> d.IsPaid
    )
    BEGIN
       
        INSERT INTO FeeLog (StudentID, AmountPaidOld, AmountPaidNew, StatusOld, StatusNew, ChangeDate)
        SELECT 
            d.StudentID,
            d.AmountPaid AS AmountPaidOld,
            i.AmountPaid AS AmountPaidNew,
            d.IsPaid AS StatusOld,
            i.IsPaid AS StatusNew,
            GETDATE()
        FROM Inserted i
        INNER JOIN Deleted d ON i.StudentID = d.StudentID
        WHERE i.AmountPaid <> d.AmountPaid OR i.IsPaid <> d.IsPaid;
    END
END;
                                ----PROCEDURES----      
								
                           ----ADD NEW STUDENT----
CREATE PROCEDURE AddStudent(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Birthdate DATE,
    @PhoneNumber VARCHAR(50),
    @Address VARCHAR(100)
)
AS
BEGIN
    INSERT INTO Student (FirstName, LastName, Birthdate, PhoneNumber, Address)
    VALUES (@FirstName, @LastName, @Birthdate, @PhoneNumber, @Address);
END;


                          ----Get Student Fee Status----

CREATE PROCEDURE GetStudentFeeStatus(
    @StudentID INT,
    @Month VARCHAR(20)
)
AS
BEGIN
    SELECT F.StudentID, S.FirstName + ' ' + S.LastName AS StudentName, F.Amount, F.AmountPaid, F.IsPaid
    FROM Fee F
    JOIN Student S ON F.StudentID = S.StudentID
    WHERE F.StudentID = @StudentID AND F.Month = @Month;
END;

----PAID AND UNPAID----

CREATE PROCEDURE GetFeeStatusByMonth(
    @Month VARCHAR(20)
)
AS
BEGIN
    SELECT F.StudentID, 
           S.FirstName + ' ' + S.LastName AS StudentName, 
           F.Amount, 
           F.AmountPaid, 
           F.IsPaid,
           CASE 
               WHEN F.IsPaid = 1 THEN 'Paid'
               ELSE 'Unpaid'
           END AS FeeStatus
    FROM Fee F
    JOIN Student S ON F.StudentID = S.StudentID
    WHERE F.Month = @Month
    ORDER BY FeeStatus DESC, S.LastName, S.FirstName;
END;

                             ----Update Test Result----

CREATE PROCEDURE UpdateTestResult(
    @ResultID INT,
    @StudentID INT,
    @TestID INT,
    @ObtainMarks INT,
    @TotalMarks INT
)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM TestResult WHERE ResultID = @ResultID)
    BEGIN
        UPDATE TestResult
        SET ObtainMarks = @ObtainMarks, TotalMarks = @TotalMarks
        WHERE ResultID = @ResultID;
    END
    ELSE
    BEGIN
        INSERT INTO TestResult (StudentID, TestID, ObtainMarks, TotalMarks)
        VALUES (@StudentID, @TestID, @ObtainMarks, @TotalMarks);
    END;
END;
                              ----ADD Test Result----


CREATE PROCEDURE AddTestMarks(
    @StudentID INT,
    @TestID INT,
    @ObtainMarks INT,
    @TotalMarks INT
)
AS
BEGIN
    INSERT INTO TestResult (StudentID, TestID, ObtainMarks, TotalMarks)
    VALUES (@StudentID, @TestID, @ObtainMarks, @TotalMarks);
END;

                          ----View Student Attendance----

CREATE PROCEDURE GetAllStudentsAttendence
AS
BEGIN
    SELECT 
        A.StudentID, 
        S.FirstName + ' ' + S.LastName AS StudentName, 
        A.AttendanceDate, 
        A.IsPresent
    FROM 
        Attendence A
    JOIN 
        Student S ON A.StudentID = S.StudentID
    ORDER BY 
        A.AttendanceDate DESC, 
        S.FirstName, 
        S.LastName;
END;

                             --- ViewStudentMarks ---


CREATE PROCEDURE ViewStudentMarks
(
    @StudentID INT
)
AS
BEGIN
    SELECT 
        TR.TestID,
        TR.ObtainMarks,
        TR.TotalMarks,
        (CAST(TR.ObtainMarks AS FLOAT) / TR.TotalMarks) * 100 AS Percentage
    FROM TestResult TR
    WHERE TR.StudentID = @StudentID
    ORDER BY TR.TestID;
END;

                    -- View Student Data --

CREATE PROCEDURE ViewStudentData
(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
)
AS
BEGIN
    SELECT 
        StudentID,
        FirstName,
        LastName,
        Birthdate,
        PhoneNumber,
        Address
    FROM Student
    WHERE FirstName = @FirstName AND LastName = @LastName;
END;


          
		            --- View Teacher Data ---

CREATE PROCEDURE ViewTeacherData
(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
)
AS
BEGIN
   
    SELECT 
        TeacherID,
        FirstName,
        LastName,
        Salary,
        PhoneNumber,
        Address
    FROM Teacher
    WHERE FirstName = @FirstName AND LastName = @LastName;
END;