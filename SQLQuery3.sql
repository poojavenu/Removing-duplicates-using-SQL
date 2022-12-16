   <<<<>>>> Scenario 1: Data duplicated based on SOME of the columns <<<<>>>>
   ########################################################################## */

-- Requirement: Delete duplicate data from cars table. Duplicate record is identified based on the model and brand name.

create database cars;
use cars;

drop table if exists cars;
create table cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);


insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars
order by model, brand;

1.delete using unique identifier

delete from cars
where id in
(
select  max(id)
from cars
group by model,brand 
having count(*)>1  )

2. delete using self join

delete from cars 
where id in 
(
select c2.id
from cars c1 
join cars c2 on 
c1.model=c2.model
and c1.brand=c2.brand
where c1.id< c2.id )

3. delete using window function


delete from cars 
where id in(
select id from(
select *,
row_number() over(partition by model, brand order by brand) rn
from cars ) x
where x.rn >1 ) 

4.using min function - works even for multiple duplicates


delete from cars 
where id not in (
select min(id)
from cars 
group by model, brand)


/* ##########################################################################
   <<<<>>>> Scenario 2: Data duplicated based on ALL of the columns <<<<>>>>
   ########################################################################## */

-- Requirement: Delete duplicate entry for a car in the CARS table.

drop table if exists cars;
create table  cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);

select * from cars
order by model, brand

with carsCTE as  
(
select *, row_number()  over(partition by id order by id) row_num
from cars ) 
delete  from  carsCTE where row_num>1


















