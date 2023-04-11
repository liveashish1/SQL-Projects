/*
Shark Tank Data Exploration 
Skills used: Procedure,Union, CTE's, Temp Tables, Aggregate Functions, Creating Views.
*/

create database shark_tank;  #creating database
use shark_tank;              #using databse
drop database shark_tank;    #droping databse
show databases;              #vieving all database
describe shark_dataset_csv;

select * from shark_dataset_csv;
-- to call agaian and again we
-- using procedure
delimiter &&
create procedure dataset()
begin
select * from shark_dataset_csv;
end&&
call dataset();
drop procedure call_data;

-- total episodes --
call dataset();
select max(Ep_No) as Total_Ep from shark_dataset_csv;
-- or
select count(distinct Ep_No) as Total_Ep from shark_dataset_csv;

-- pitches
call dataset();
select count(distinct brand) as Total_brand from shark_dataset_csv;

-- total amount invest by sharks--
call dataset();
select sum(Amount_Invested_lakhs) as Total_Investment_by_sharks from shark_dataset_csv;


-- total pitches converted (or got some fumding)
call dataset();
select Amount_Invested_lakhs,if(Amount_Invested_lakhs>0,1,0) as got_investment from shark_dataset_csv;


select count(Amount_Invested_lakhs) as total_pitches,sum(got_investment) as pitch_got_investment from 
(select Amount_Invested_lakhs,if(Amount_Invested_lakhs>0,1,0) as got_investment from shark_dataset_csv) as pitches_converted;


-- total pitches converted vs how much pitched (or got some fumding)
call dataset();
select Amount_Invested_lakhs,if(Amount_Invested_lakhs>0,1,0) as got_investment from shark_dataset_csv;

select count(Amount_Invested_lakhs) as total_pitches,sum(got_investment) as pitch_got_investment from 
(select Amount_Invested_lakhs,if(Amount_Invested_lakhs>0,1,0) as got_investment from shark_dataset_csv) as pitches_converted;

#or using case statement

call dataset();
select Amount_Invested_lakhs,
case when Amount_Invested_lakhs>0 then 1 else 0
end as got_investment from shark_dataset_csv;

select count(Amount_Invested_lakhs) as total_pitches,sum(got_investment) as pitch_got_investment from 
(select Amount_Invested_lakhs,
case when Amount_Invested_lakhs>0 then 1 else 0
end as got_investment 
from shark_dataset_csv) as pitches_converted;

-- total male pitchers
call dataset();
select sum(Male) from shark_dataset_csv;

-- total female pitchers
call dataset();
select sum(Female) from shark_dataset_csv;

-- gender ratio
call dataset();
select (sum(Female)/sum(Male))*100 as gender_ratio from shark_dataset_csv;

-- avg equity taken by all sharks
call dataset();
select avg(Equity_Taken_in_Prec) from
(select * from shark_dataset_csv where Equity_Taken_in_Prec>0) as All_shark_equity;

-- highest deal taken
call dataset();
select max(Amount_Invested_lakhs) as higest_deal_by_shark_lakhs from shark_dataset_csv;

--higheest equity taken
call dataset();
select max(Equity_Taken_in_Prec) as Max_equity_Perc from shark_dataset_csv;

-- startups having at least women
call dataset();
select count(Female) as female_pitchers 
from shark_dataset_csv where Female > 0;

-- pitches converted having atleast one women in pitch
-- using sub queries
call dataset();
select count(*) as female_pitchers 
from
(select * from shark_dataset_csv where Deal!='No Deal'and Female > 0) as Got_Deal;

-- avg team members

call dataset();
select avg(team_members) from shark_dataset_csv;

-- avg amount invested per deal by sharks
-- using sub queries and cte
call dataset();
select avg(Amount_Invested_lakhs) as Avg_intvestment from
(select * from shark_dataset_csv where deal!='no deal') as Avg_intvestment_data;
-- or 
with Avg_intvestment_data as 
(select * from shark_dataset_csv where deal!='no deal')   
select avg(Amount_Invested_lakhs) from Avg_intvestment_data;

-- avg age group of contestants

call dataset();
select Avg_age,count(Avg_age) a 
from shark_dataset_csv where Avg_age !='0'  
group by Avg_age order by a desc limit 1,3;


-- top 3 avg age group of contestants

call dataset();
select Avg_age,count(Avg_age) as age_group from shark_dataset_csv 
where Avg_age !='0' 
group by Avg_age order by age_group desc limit 1,3;

-- location group of contestants
call dataset();
select Location,count(Location) as pitch_location 
from shark_dataset_csv 
where location!='0' 
group by Location order by pitch_location desc;

-- sector group of contestants
call dataset();
select Sector,count(Sector) as Sector_Distribution 
from shark_dataset_csv 
where Sector!='0' 
group by Sector order by Sector_Distribution desc;

-- max pitches from sectors wise

call dataset();

select Sector,count(Sector) as Sector_Distribution 
from shark_dataset_csv 
group by Sector
having Sector!='0'  order by 2 desc limit 1;


-- min pitches from sectors wise
call dataset();
select Sector,count(Sector) as Sector_Distribution 
from shark_dataset_csv 
group by Sector
having Sector!='0'  order by 2 limit 1;

-- collabration on deals
call dataset();
 select count(Partners) as  collabratve_deals from shark_dataset_csv where Partners!='0' and length(Partners)>3;

-- making the matrix data
call dataset();

create view matrix_data as (
select * from (
select 'Ashneer' as Shark_name,sum(Ashneer_Amount_Invested) as Total_Investment,
round((Ashneer_Equity_Taken_in_Prec),2) as Avg_Equity,
count(Ashneer_Amount_Invested) as No_of_Investment
from shark_dataset_csv where Ashneer_Equity_Taken_in_Prec !=0
union
select 'Namita' as Shark_name,sum(Namita_Amount_Invested) as Total_Investment,
round((Namita_Equity_Taken_in_Prec),2) as Avg_Equity,
count(Namita_Amount_Invested) as No_of_Investment
from shark_dataset_csv where Namita_Equity_Taken_in_Prec !=0
union
select 'Peyush' as Shark_name,sum(Peyush_Amount_Invested) as Total_Investment,
round(avg(Peyush_Equity_Taken_in_Prec),2) as Avg_Equity,
count(Peyush_Amount_Invested) as No_of_Investment
from shark_dataset_csv where Peyush_Equity_Taken_in_Prec !=0
union
select 'Aman' as Shark_name,sum(Aman_Amount_Invested) as Total_Investment,
avg(Aman_Equity_Taken_in_Prec) as Avg_Equity,
count(Aman_Amount_Invested) as No_of_Investment
from shark_dataset_csv where Aman_Equity_Taken_in_Prec !=0
union
select 'Ghazal' as Shark_name,sum(Ghazal_Amount_Invested) as Total_Investment,
round(avg(Ghazal_Equity_Taken_in_Prec),2) as Avg_Equity,
count(Ghazal_Amount_Invested) as No_of_Investment
from shark_dataset_csv where Ghazal_Equity_Taken_in_Prec !=0) as matrix_Data) ;

select * from matrix_data order by Total_Investment desc;

-- which is the startup in which the highest amount has been invested in each domain/sector
call dataset();

select * from 
(select brand,sector,Amount_Invested_lakhs,rank() over(partition by sector order by Amount_Invested_lakhs desc)as t1
from shark_dataset_csv where sector!='0' and Amount_Invested_lakhs!=0) as test where t1=1;

-- which is the top 3 startup in which the highest amount has been invested in each domain/sector

call dataset();

select * from 
(select brand,sector,Amount_Invested_lakhs,dense_rank() over(partition by sector order by Amount_Invested_lakhs desc) as t1
from shark_dataset_csv where sector!='0' and Amount_Invested_lakhs!=0) as test where t1 in (1,2,3);




