create database maven;
use maven;
drop database maven;
drop table airline_ps;
create table airline_ps  (
id int not null,
gender	varchar(60)	,
age	int	not null,
customer_type	varchar(60)	,
type_of_travel	varchar(60)	,
class varchar(60)	,
flight_distance	int	not null,
departure_delay	int	not null,
arrival_delay	int	,
departure_and_arrival_time_convenience int	not null,
ease_of_online_booking int not null,
`check_in_service` int not null,
online_boarding	int not null	,
gate_location	int	 not null,
`on-board_service`	int not null	,
seat_comfort int not null	,
leg_room_service int not null	,
cleanliness	int	 not null,
food_and_drink	int	 not null,
in_flight_service	int	 not null,
in_flight_wifi_service	int	 not null,
in_flight_entertainment	int	 not null,
baggage_handling int  not null	,
satisfaction varchar(100));

/*set sql_mode = ""*/
/*set global max_allowed_packet=15000;*/

load data infile 'C:\\airline_passenger_satisfaction_updated.csv'
into table airline_ps
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


drop procedure call_dataset;
delimiter &&
create procedure call_dataset()
begin
select * from airline_ps;
end&&

call call_dataset();

-- Total Passengers --

select count(id) as total_passanger from airline_ps;

-- Average Flight Distance of airlines --

select avg(flight_distance) as avg_flight_dist from airline_ps;

-- Average Flight departure delay --

select avg(departure_delay) as avg_departure_delay from airline_ps;

-- Average Flight arrival delay --

select avg(arrival_delay) as avg_arrival_delay from airline_ps;

-- Total_Passengers by gender --

select gender,count(gender) as total
from airline_ps
group by gender;

-- maximun age of airline passenger --

select max(age) as max_age from airline_ps;

-- minimum age of airline passenger --

select min(age) as min_age from airline_ps;

-- total passengers by age group --

select count(age) as total_passengers
,case 
    when age<16 then 'child'
    when age>=16 and age<30 then 'young adult'
    when age>=30 and age<45 then 'early middle age'
    when age>=45 and age<60 then 'late middle age'
    else 'senior'  
end as age_group
from airline_ps 
group by age_group 
order by total_passengers desc; 


-- Total_Passengers by Customer type --

call call_dataset();
select customer_type,count(customer_type) as total_pass 
from  airline_ps
group by customer_type;

-- Total_Passengers by Type of Travel --

select type_of_travel,count(type_of_travel) as total_pass 
from  airline_ps
group by type_of_travel;

-- Total Passengers categorised based on airline class --

select class,count(class) as total_pass
from  airline_ps
group by class;

-- Total_Passengers by Satisfaction --

select satisfaction,count(id) as total_pass 
from airline_ps 
group by satisfaction;

-- Analysis of passenger satisfaction by type of travel --

select type_of_travel,satisfaction,count(id) as total_passengers 
from airline_ps 
group by 1,2;

-- Total Passengers travelling for Business purpose --

call call_dataset();

select count(type_of_travel) as business__purpose_passengers 
from airline_ps 
where type_of_travel='business';

-- Analysis of Passengers' Satisfaction When Traveling for Business purpose --

call call_dataset();
select satisfaction,count(type_of_travel) as total_passengers
from airline_ps where type_of_travel='Business' 
group by satisfaction;


-- Total Passengers travelling for Personal purpose --

select count(type_of_travel) as personal_purpose_passengers 
from airline_ps 
where type_of_travel='Personal';

-- Analysis of Passengers' Satisfaction When Traveling for Personal purpose --

call call_dataset();
select satisfaction,count(type_of_travel) as total_passengers
from airline_ps where type_of_travel='Personal' 
group by satisfaction;

-- the satisfaction patterns for personal purpose passengers based on customer type --

select customer_type,satisfaction,count(id) as total_passengers 
from airline_ps 
where type_of_travel='personal'
group by satisfaction,customer_type;

-- the satisfaction patterns for business-related passengers based on customer type --

select customer_type,satisfaction,count(id) as total_passengers 
from airline_ps 
where type_of_travel='business'
group by 1,2
order by 1;

-- departure_and_arrival_time_convenience --

select round(avg(departure_and_arrival_time_convenience),2) as avg_departure_and_arrival_time_convenience 
from airline_ps;

-- ease_of_online_booking --

select round(avg(ease_of_online_booking),2) as avg_ease_of_online_booking 
from airline_ps;

-- check_in_service --

select round(avg(check_in_service),2) as avg_check_in_service 
from airline_ps;

-- online_boarding --

select round(avg(online_boarding),2) avg_online_boarding 
from airline_ps;

-- gate_location --

select round(avg(gate_location),2) avg_gate_location 
from airline_ps;

-- on_board_service --

select round(avg(`on-board_service`),2) avg_on_board_service 
from airline_ps;


-- seat_comfort --

select round(avg(seat_comfort),2) avg_seat_comfort 
from airline_ps;

-- leg_room_service --
select round(avg(leg_room_service),2) avg_leg_room_service 
from airline_ps;

-- cleanliness --

select round(avg(cleanliness),2) avg_cleanliness 
from airline_ps;

-- food_and_drink --

select round(avg(food_and_drink),2) avg_food_and_drink 
from airline_ps;

-- in_flight_service --

select round(avg(in_flight_service),2) avg_in_flight_service 
from airline_ps;

-- in_flight_wifi_service --

select round(avg(in_flight_wifi_service),2) avg_in_flight_wifi_service 
from airline_ps;

-- in_flight_entertainment --

select round(avg(in_flight_entertainment),2) avg_in_flight_entertainment 
from airline_ps;

-- baggage_handling --

select round(avg(baggage_handling),2) avg_baggage_handling 
from airline_ps;


-- percentage of people according class type;;

select  
 class,
count(id) as total_customers,
round((count(class)/(select count(id) from airline_ps)) *100,0) as percentage
from airline_ps
group by class;


-- percentage of people according class type --

select class,
count(id) as total_customers,
round((count(class)/(select count(id) from airline_ps)) *100,0) as percentage
from airline_ps
group by class;








