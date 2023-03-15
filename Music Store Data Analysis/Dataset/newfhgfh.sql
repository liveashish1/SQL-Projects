create database ash_new;  
use ash_new; 			

-- senior most employee based on job title --

select *
from employee;

select title, last_name, first_name 
from employee
order by levels desc
limit 1;

--  countries have the most invoices --
select *
from invoice;

select billing_country,count(*) as total_invoices 
from invoice
group by 1
order by total_invoices desc
limit 1;



-- top 3 values of total invoice --

select  total
from invoice
order by total desc
limit 3;


-- city that has the highest sum of invoice totals --

select billing_city,sum(total) as max_billing
from invoice
group by 1
order by max_billing desc
limit 1;

-- the person who has spent the most money --

select c.customer_id,c.first_name,c.last_name,sum(i.total) as total_spending
from customer c inner join invoice i on c.customer_id=i.invoice_id
group by 1
order by total_spending desc
limit 1;

-- set sql_mode=(select replace(@@sql_mode,'only_full_group_by','')); --

-- the email, first name, last name, & genre of all rock music listeners --

select distinct email,first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'rock'
)
order by email; 


select distinct email as email,first_name as firstname, last_name as lastname, genre.name as name
from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'rock'
order by email;

-- artist name and total track count of the top 10 rock bands.--

select artist.artist_id, artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;



-- amount spent by each customer on artists --

with best_selling_artist as (
	select artist.artist_id as artist_id, artist.name as artist_name, sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;

-- the most popular music genre for each country --


with popular_genre as 
(
    select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id, 
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as rowno 
    from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where rowno <= 1;



-- that customer has spent the most on music for each country --
/* method 1: using cte */

with customter_with_country as (
		select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
	    row_number() over(partition by billing_country order by sum(total) desc) as rowno 
		from invoice
		join customer on customer.customer_id = invoice.customer_id
		group by 1,2,3,4
		order by 4 asc,5 desc)
select * from customter_with_country where rowno <= 1;


/* method 2: using recursive */

with recursive 
	customter_with_country as (
		select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending
		from invoice
		join customer on customer.customer_id = invoice.customer_id
		group by 1,2,3,4
		order by 2,3 desc),

	country_max_spending as(
		select billing_country,max(total_spending) as max_spending
		from customter_with_country
		group by billing_country)

select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
from customter_with_country cc
join country_max_spending ms
on cc.billing_country = ms.billing_country
where cc.total_spending = ms.max_spending
order by 1;





