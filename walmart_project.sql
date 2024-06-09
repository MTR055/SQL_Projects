create database if not exists walmart;

create table if not exists sales(
Invoice_ID varchar(30) NOT NULL primary key,	
Branch	varchar(30) NOT NULL,
City	varchar(30) NOT NULL,
Customer_type	varchar(30) NOT NULL,
Gender	varchar(30) NOT NULL,
Product_line	varchar(30) NOT NULL,
Unit_price	DECIMAL(10,2) NOT NULL,
Quantity	INT NOT NULL,
Vat float(6,4) not null,
Total	decimal(12,4) not null,
Date	datetime not null,
Time	time not null,
Payment varchar(30) NOT NULL,
cogs	decimal(10,2) NOT NULL,
gross_margin_percentage float(11,5) not null,
gross_income	decimal(12,4) not null,
Rating  float(2,1) not null
);

select * from sales;      ## Imported data from local file

-- As we used not null all the null values have filtered 
-- ------------------------------------------------------------------------------------------------------------------------
-- ---------------------FEATURE ENGINEERING--------------------------------------------------------------------------------

select time,(case
when time  between '6:00:00' and '12:00:00' then 'Morning'
when time  between '12:00:01' and '15:00:00' then 'Afternoon'
when time  between '15:00:01' and '21:00:00' then 'Evening'
else 'Night'
end) as part_of_day
 from sales;
 
 alter table sales add column part_of_day varchar(30) ;
 
 update sales 
 set part_of_day =(case
						when time  between '6:00:00' and '12:00:00' then 'Morning'
						when time  between '12:00:01' and '15:00:00' then 'Afternoon'
						when time  between '15:00:01' and '21:00:00' then 'Evening'
						else 'Night'
					end
);

-- day_name 
alter table sales add column day_name varchar(15);

update sales
set day_name = (dayname(date));

-- month_name

alter table sales add column month_name varchar(15);

update sales
set month_name = (monthname(date)); 

-- ----------------------------------------------------------------------------------------------------------------
-- -------------------Exploratory Analysis ------------------------------------------------------------------------

-- 1)  How many unique cities does the data have?

select count(distinct(city)) from sales;

-- 2)  How many branches are present in each city ?

select city, count(branch) as num_of_branches from sales group by city order by num_of_branches desc;  

-- 3)  How many unique product lines does the data have?

select count(distinct(product_line)) from sales;                     ## 6

-- 4)  What is the most common payment method?

select payment , count(distinct payment) as num from sales order by num desc limit 1;               ## credit card

-- 5)  What is the most selling product line?
    
select product_line , count(product_line) as total  from sales group by product_line order by count(Product_line) desc limit 1;         ## fashion accessories

-- 6)  What is the total revenue by month?

select month_name , sum(total) as revenue from sales group by month_name order by revenue desc limit 1;          ## January

-- 7) What month had the largest COGS(cost of goods sold)?

select month_name , sum(cogs) as revenue from sales group by month_name order by revenue desc limit 1;

-- 8)  What product line had the largest revenue?

select product_line, sum(gross_income) as revenue from sales  group by Product_line order by revenue desc limit 1;

-- 9)  What is the city with the largest revenue?

select city, sum(gross_income) as revenue from sales  group by city order by revenue desc limit 1;             ## Naypyitaw

-- 10)  What product line had the largest VAT?

select product_line, avg(vat) as vat from sales  group by Product_line order by vat desc limit 1;          ## Home and lifestyle
 
-- 11)  Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select product_line, total ,
case 
when total> avg(Total) over(partition by product_line) then 'good'
else 'bad'
end as status from sales ;

-- 12)  Which branch sold more products than average product sold?


select branch,sum(quantity)
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);



-- 13) What is the most common product line by gender?

with cte as (select gender ,Product_line, count(product_line) as num ,
dense_rank() over (partition by gender order by count(product_line) desc) as rank1
from sales 
group by gender,Product_line )

select gender,product_line
from cte
where rank1=1;

-- 14)  What is the average rating of each product line?

select  product_line,avg(rating) as rating from sales group by product_line;

-- 15)  Number of sales made in each time of the day per weekday


select  day_name,part_of_day ,count(*) as num_of_sales
from sales
group by day_name , part_of_day
order by num_of_sales desc;


-- 16)  Which of the customer types brings the most revenue?

select customer_type , avg(total) as total1 from sales group by customer_type order by total1 desc;

-- 17)  Which city has the largest tax percent/ VAT (Value Added Tax)?

select city , avg(vat) as avg_vat from sales group by city order by avg_vat desc limit 1;

-- 18)  Which customer type pays the most in VAT?

select customer_type , avg(vat) as avg_vat from sales group by customer_type order by avg_vat desc ;

-- 19)  How many unique customer types does the data have?

select count(distinct customer_type) from sales; ##2

-- 20)  How many unique payment methods does the data have?

select count(distinct payment) from sales; #3


-- 22)  Which customer type buys the most?
-- 23)  What is the gender of most of the customers?

select gender, count(*) from sales group by gender;

-- 24)  What is the gender distribution per branch?

select s.branch , s.gender , round(count(s.gender)/a.total,2) as ratio
from sales s
join (select branch , count(*) as total from sales group by branch) a on a.branch = s.branch
group by branch,gender;



-- 25)  Which time of the day do customers give most ratings?

select part_of_day , avg(rating) as avg1
from sales
group by part_of_day
order by avg1 desc;

-- 26)  Which time of the day do customers give most ratings per branch?

select branch ,part_of_day , avg(rating) as avg1
from sales
group by branch,part_of_day
order by avg1 desc;









