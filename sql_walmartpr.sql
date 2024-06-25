
select * 
from walmart_pr;	
describe walmart_pr;


create table walmart_pr(
Invoice_id varchar(50) primary key not null,
Branch varchar(50) not null,
City varchar(50) not null,
Customer_type varchar(50) not null,
Gender varchar(50) not null,
Product_line varchar(50) not null,
Unit_price double not null,
Quantity int not null,
Tax_5 double not null,
Total double not null,
Date date not null,
Time time not null,
Payment varchar(50) not null,
cogs double not null,
gross_margin_percentage double  not null,
gross_income double not null,
Rating double not null);
 

-- 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon andEvening. This will help answer the question on which part of the day most sales are made.
alter table walmart_pr
add  column time_of_day varchar(50) not null;

SET SQL_SAFE_UPDATES = 0;

update walmart_pr
set time_of_day =
	case
		when time >"00:00:00" and time<="11:59:00"  then "morning"
        when time >="12:00:00" and time<"18:00:00"  then "afternoon"
        else "evening"
	end
where time is not null;

-- 2. Add a new column named day_name that contains the extracted days of the week on which thegiven transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on whichweek of the day each branch is busiest.

alter table walmart_pr
add  column day_name varchar(50) not null;

update walmart_pr
set day_name =dayname(date);
-- 3. Add a new column named month_name that contains the extracted months of the year on which thegiven transaction took place (Jan, Feb, Mar). Help determine which month of the year has the mostsales and profit.
alter table walmart_pr
add  column month_name varchar(50) not null;

update walmart_pr
set month_name =monthname(date);

-- 1. How many unique cities does the data have?
select count(distinct City) as number_of_cities_in_data
from walmart_pr;

-- 2. In which city is each branch?
select city,branch
from walmart_pr
group by Branch,city
order by Branch;

-- 1.How many unique product lines does the data have? --
select count(distinct Product_line) as product_lines
 from walmart_pr;

-- 2.What is the most common payment method?--
select Payment as most_commom_payment_method
from walmart_pr
group by Payment
order by count(*) desc
limit 1;

-- 3.What is the most selling product line?
select product_line as mostselling_productline
from walmart_pr
group by Product_line
order by count(*) desc
limit 1;

-- 4.What is the total revenue by month?
select sum(cogs) as revenue_by_month,month_name
from walmart_pr
group by month_name;

-- 5. What month had the largest COGS?
select month_name as month_of_largest_cogs
from walmart_pr
group by month_name
order by sum(cogs) desc
limit 1;

-- 6. What product line had the largest revenue?
select Product_line as productline_having_largestrevenue
from walmart_pr
group by Product_line
order by sum(cogs) desc
limit 1;

-- 7. What is the city with the largest revenue?
select city as city_with_largest_revenue
from walmart_pr
group by city
order by sum(cogs) desc
limit 1;

-- 8.What product line had the largest VAT?
select product_line as productline_with_largrest_vat
from walmart_pr
group by Product_line
order by sum(Tax_5) desc
limit 1;

/*9. Fetch each product line and add a column to those product line showing "Good","Bad",Good if its 
greaterthan average sales*/
select Product_line,
case
	when Quantity>avg(Quantity) then "good"
	else "bad"
end as sales_a_cg
from walmart_pr
group by Product_line;
   
      
-- 10. Which branch sold more products than average product sold?
select branch
from walmart_pr
group by branch
having sum(Quantity)>avg(Quantity)
limit 1;


-- 11. What is the most common product line by gender?
select product_line as most_common_productline_by_gender
from walmart_pr
group by Product_line,gender
order by gender,count(*)  desc
limit 1;

-- 12. What is the average rating of each product line?
select product_line,avg(Rating) as average_rating
from walmart_pr
group by Product_line;

-- sales--
-- 1. Number of sales made in each time of the day per weekday
select day_name,time_of_day,count(quantity) as sales
from walmart_pr
group by time_of_day,day_name;


-- 2. Which of the customer types brings the most revenue?
select customer_type as customer_type_with_mostrevenue
from walmart_pr
group by Customer_type
order by sum(cogs) desc
limit 1;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city
from walmart_pr
group by city
order by sum(Tax_5) desc
limit 1;

-- 4. Which customer type pays the most in VAT?
select Customer_type as customer_paying_highest_vat
from walmart_pr
group by Customer_type
order by sum(Tax_5)  desc
limit 1;

-- customers --
-- 1. How many unique customer types does the data have?
select count(distinct Customer_type)
from walmart_pr;

-- 2. How many unique payment methods does the data have?
select count(distinct payment) as types_of_payment_methods
from walmart_pr;

-- 3. What is the most common customer type?
select Customer_type
from walmart_pr
group by Customer_type
order by count(*) desc
limit 1;

-- 4. Which customer type buys the most?
select Customer_type
from walmart_pr
group by Customer_type
order by sum(quantity) desc
limit 1;

-- 5. What is the gender of most of the customers?
select gender as most_common_gender
from walmart_pr
group by Gender
order by count(*) desc
limit 1;

-- 6. What is the gender distribution per branch?
select Branch,gender,count(*) as gender_distribution_per_branch
from walmart_pr
group by branch,Gender
order by branch;

-- 7. Which time of the day do customers give most ratings?
select time_of_day as time_of_most_ratings
from walmart_pr
group by time_of_day
order by count(Rating) desc
limit 1;


-- 8. Which time of the day do customers give most ratings per branch?
select Branch,time_of_day as time_of_day_with_most_ratings
from walmart_pr
group by Branch,time_of_day
order by count(rating) desc
limit 3;


-- 9. Which day of the week has the best avg ratings?
select day_name as day_with_best_avg
from walmart_pr
group by day_name
order by avg(rating) desc
limit 1;

-- 10. Which day of the week has the best average ratings per branch?
select branch,day_name as day_with_best_average_rating
from walmart_pr
group by branch,day_name
order by avg(rating) desc
limit 3;
