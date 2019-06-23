drop database Employment;

create DATABASE Employment;
use Employment;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE Employee
(
 Emp_ID int not null auto_increment,
 Emp_Name varchar(55),
 Emp_Sal decimal (10,2),
 primary key(Emp_ID)
);

Insert into Employee(Emp_Name, Emp_Sal) values ('Amit',1000);
Insert into Employee(Emp_Name, Emp_Sal) values ('Mohan',1200);
Insert into Employee(Emp_Name, Emp_Sal) values ('Avin',1100);
Insert into Employee(Emp_Name, Emp_Sal) values ('Manoj',1300);
Insert into Employee(Emp_Name, Emp_Sal) values ('Riyaz',1400);

create table Employee_Audit1 
(
 Emp_ID int,
 Audit_ID int not null auto_increment,
 Emp_Name varchar(55),
 Emp_Sal decimal(10,2),
 Audit_Action varchar(100),
 Audit_Timestamp datetime,
 primary key(Audit_ID)
) ;

create table Employee_Audit2 
(
 Emp_ID int,
 Audit_ID int not null auto_increment,
 Emp_Name varchar(55),
 Emp_Sal decimal(10,2),
 Audit_Action varchar(100),
 Audit_Timestamp datetime,
 primary key(Audit_ID)
) ;

Delimiter // 
CREATE TRIGGER trgBeforeInsert before insert ON Employee
for each row begin
	declare vUser Int;
	SELECT max(Emp_ID) from Employee INTO vUser;
	Insert into Employee_Audit1(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp) values (vUser + 1,new.Emp_Name,new.Emp_Sal,"Before Insert",now());
end ;
//

Delimiter $$ 
CREATE TRIGGER trgAfterInsert after insert ON Employee
for each row begin
	Insert into Employee_Audit2(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp) values (new.Emp_ID,new.Emp_Name,new.Emp_Sal,"After Insert",now());
end ;
$$

Delimiter %% 
CREATE TRIGGER trgBeforeUpdate before update ON Employee
for each row begin
	UPDATE Employee_Audit1 SET Emp_Name = new.Emp_Name,
    Emp_Sal = new.Emp_Sal,
    Audit_Action = "Update Before",
    Audit_Timestamp = now()
    Where Emp_ID = new.Emp_ID;
end ;
%%

Delimiter !!
CREATE TRIGGER trgAfterUpdate after update ON Employee
for each row begin
	UPDATE Employee_Audit2 SET Emp_Name = new.Emp_Name,
    Emp_Sal = new.Emp_Sal,
    Audit_Action = "Update After",
    Audit_Timestamp = now()
    Where Emp_ID = new.Emp_ID;
end ;
!!


Delimiter @@
CREATE TRIGGER trgBeforeDelete before delete ON Employee
for each row begin
	UPDATE Employee_Audit2 SET Emp_Name = old.Emp_Name,
    Emp_Sal = old.Emp_Sal,
    Audit_Action = "Delete Before",
    Audit_Timestamp = now()
    Where Emp_ID = old.Emp_ID;
end ;
@@

Delimiter ##
CREATE TRIGGER trgAfterDelete after delete ON Employee
for each row begin
	UPDATE Employee_Audit2 SET Emp_Name = old.Emp_Name,
    Emp_Sal = old.Emp_Sal,
    Audit_Action = "Delete After",
    Audit_Timestamp = now()
    Where Emp_ID = old.Emp_ID;
end ;
##

insert into Employee(Emp_Name,Emp_Sal) values ("Kamakshi",1230);

select * from Employee;
select * from Employee_Audit1;
select * from Employee_Audit2;

update Employee set Emp_Sal = 2300 where Emp_ID = 6;

select * from Employee;
select * from Employee_Audit1;
select * from Employee_Audit2;

delete from Employee where Emp_ID = 6;

select * from Employee;
select * from Employee_Audit1;
select * from Employee_Audit2;

