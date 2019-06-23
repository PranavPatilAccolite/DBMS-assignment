drop database if exists movie;
create database movie;
use  movie;

-- -----------------------------------------------------
-- Table movie.auditorium
-- -----------------------------------------------------
CREATE TABLE auditorium (
  id INT NOT NULL,
  name VARCHAR(45) NULL,
  seats_no INT NULL,
  PRIMARY KEY (id))
;

Insert into auditorium(id,name,seats_no) values(1,"alankar",200);
insert into auditorium(id,name,seats_no) values(2,"bhandari",250);
insert into auditorium(id,name,seats_no) values(3,"dutta",150);
-- -----------------------------------------------------
-- Table movie.employee
-- -----------------------------------------------------
CREATE TABLE employee (
  id INT NOT NULL,
  username VARCHAR(45) NULL,
  password VARCHAR(45) NULL,
  PRIMARY KEY (id))
;

insert into employee(id,username,password) values(1,"Ram","12345");
insert into employee(id,username,password) values(2,"Disha","abcde");
insert into employee(id,username,password) values(3,"Kalpesh","askto");

-- -----------------------------------------------------
-- Table movie.movie
-- -----------------------------------------------------
CREATE TABLE movie (
  id INT NOT NULL,
  title VARCHAR(256) NOT NULL,
  director VARCHAR(256) NOT NULL,
  cast VARCHAR(1024) NOT NULL,
  description TEXT NOT NULL,
  duration INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id ASC) VISIBLE)
;

insert into movie(id,title,director,cast,description,duration) values (1,"DDLJ","yash chopra","srk kajol","romantic drama", 150);
insert into movie(id,title,director,cast,description,duration) values (2,"Golmal","rohit shetty","ajay devgan","comedy", 120);
insert into movie(id,title,director,cast,description,duration) values (3,"Don","farhan akhtar","srk priyanka chopra","action thriller", 90);

-- -----------------------------------------------------
-- Table movie.screening
-- -----------------------------------------------------
CREATE TABLE screening (
  id INT NOT NULL,
  movie_id INT NULL,
  auditorium_id INT NULL,
  PRIMARY KEY (id),
  INDEX id_idx (movie_id ASC) VISIBLE,
  INDEX id_idx1 (auditorium_id ASC) VISIBLE,
  CONSTRAINT id1
    FOREIGN KEY (movie_id)
    REFERENCES movie.movie (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT id2
    FOREIGN KEY (auditorium_id)
    REFERENCES movie.auditorium (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

insert into screening(id,movie_id,auditorium_id) values(1,1,1);
insert into screening(id,movie_id,auditorium_id) values(2,2,1);
insert into screening(id,movie_id,auditorium_id) values(3,3,1);
insert into screening(id,movie_id,auditorium_id) values(4,1,2);
insert into screening(id,movie_id,auditorium_id) values(5,2,2);
insert into screening(id,movie_id,auditorium_id) values(6,1,3);

-- -----------------------------------------------------
-- Table movie.reservation_type
-- -----------------------------------------------------
CREATE TABLE reservation_type (
  id INT NOT NULL,
  reservation_type VARCHAR(45) NULL,
  PRIMARY KEY (id))
;
insert into reservation_type(id,reservation_type) values(1,"online booking");
insert into reservation_type(id,reservation_type) values(2,"reserved");
insert into reservation_type(id,reservation_type) values(3,"ticket booking");


-- -----------------------------------------------------
-- Table movie.reservation
-- -----------------------------------------------------
CREATE TABLE reservation (
  id INT NOT NULL,
  screening_id INT NULL,
  employee_reserved_id INT NULL,
  reservation_typ_id INT NULL,
  reservation_contact VARCHAR(45) NULL,
  reserved TINYINT NULL,
  employee_paid_id INT NULL,
  paid TINYINT NULL,
  active TINYINT NULL,
  PRIMARY KEY (id),
  INDEX screening_id_idx (screening_id ASC) VISIBLE,
  INDEX employee_reserved_id_idx (employee_reserved_id ASC) VISIBLE,
  INDEX reservation_type_id_idx (reservation_typ_id ASC) VISIBLE,
  INDEX employee_paid_id_idx (employee_paid_id ASC) VISIBLE,
  CONSTRAINT screening_id
    FOREIGN KEY (screening_id)
    REFERENCES movie.screening (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT employee_reserved_id
    FOREIGN KEY (employee_reserved_id)
    REFERENCES movie.employee (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT reservation_type_id
    FOREIGN KEY (reservation_typ_id)
    REFERENCES movie.reservation_type (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT employee_paid_id
    FOREIGN KEY (employee_paid_id)
    REFERENCES movie.employee (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

-- -----------------------------------------------------
-- Table movie.seat
-- -----------------------------------------------------
CREATE TABLE seat (
  id INT NOT NULL,
  rowNum INT NULL,
  seatNum INT NULL,
  auditorium_id INT NULL,
  PRIMARY KEY (id),
  INDEX auditorium_id_idx (auditorium_id ASC) VISIBLE,
  CONSTRAINT auditorium_id
    FOREIGN KEY (auditorium_id)
    REFERENCES movie.auditorium (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;
insert into seat(id, rowNum, seatNum, auditorium_id) values (1,1,1,1);

-- -----------------------------------------------------
-- Table movie.seat_reserved
-- -----------------------------------------------------
CREATE TABLE seat_reserved ( 
  id INT NOT NULL,
  seat_id INT NULL,
  reservation_id INT NULL,
  screening_id INT NULL,
  PRIMARY KEY (id),
  INDEX screening_id_idx (screening_id ASC) VISIBLE,
  INDEX seat_id_idx (seat_id ASC) VISIBLE,
  INDEX reservation_id_idx (reservation_id ASC) VISIBLE,
  CONSTRAINT screening_id1
    FOREIGN KEY (screening_id)
    REFERENCES movie.screening (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT seat_id
    FOREIGN KEY (seat_id)
    REFERENCES movie.seat (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT reservation_id
    FOREIGN KEY (reservation_id)
    REFERENCES movie.reservation (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


DELIMITER $$  
CREATE PROCEDURE book_ticket(in movie varchar(45), in auditorium varchar(45), in rowNum int, in seatNum int, in reservation_type varchar(45), in contact varchar(45))
BEGIN 
	declare movieId int;
    declare auditoriumId int;
    declare screeningId int;
    declare seatId int;
    declare reservationtypeId int;
    declare reservationId int;
    
    select id from movie where movie.title =movie into movieId;
    select id from auditorium where auditorium.name =auditorium into auditoriumId;
    select id from seat where (seat.auditorium_id =auditoriumId and seat.seatNum = seatNum and seat.rowNum = rowNum) into seatId;
    select id from screening where(screening.movie_id = movieId and screening.auditorium_id = auditoriumId) into screeningId;
    select id from reservation_type where(reservation_type.reservation_type = reservation_type) into reservationtypeId;
    
    insert into reservation(id,screening_id,employee_reserved_id,reservation_typ_id,reservation_contact,reserved,employee_paid_id,paid,active) values(1, screeningId,1,reservationtypeID,contact,true,1,true,true);
    
    select id from reservation where reservation.reservation_contact = contact into reservationId;
    
    insert into seat_reserved(id, seat_id,reservation_id,screening_id) values(1,seatId,reservationId,screeningId);
END
$$  

call book_ticket("DDLJ", "alankar",1,1,"online booking","8767037527");


delimiter &&
create procedure show_ticket(in contact varchar(45))
begin
	select reservation.reservation_contact,movie.title, auditorium.name,employee.username,reservation_type.reservation_type,reservation.paid,seat.rowNum,seat.seatNum from reservation 
    inner join screening on screening.id = reservation.screening_id
    inner join movie on movie.id = screening.movie_id
    inner join auditorium on auditorium.id = screening.auditorium_id
    inner join seat_reserved on seat_reserved.reservation_id = reservation.id
    inner join seat on seat.id = seat_reserved.seat_id
    inner join employee on employee.id = reservation.employee_reserved_id
    inner join reservation_type on reservation_type.id = reservation.reservation_typ_id
    ;
end
&&

call show_ticket("8767037527");