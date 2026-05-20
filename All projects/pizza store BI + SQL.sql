SELECT SUM(total_price) as Total_Revenue FROM pizza_sales

Select ROUND (Sum(total_price)/COUNT(DISTINCT order_id), 2) as Avg_Order_Value FROM pizza_sales

SELECT SUM(quantity)AS Total_Pizza_Sold from pizza_sales

SELECT COUNT(DISTINCT order_id) AS Total_orders from Pizza_sales

SELECT cast(sum (quantity) as decimal (10,2))/
cast(Count (DISTINCT order_id) as decimal (10,2))
as Avg_Pizza_Per_Order From Pizza_sales

-- Problem question
SELECT DATENAME(DW, order_date) as order_day, count(DISTINCT order_id) as Total_Orders
from pizza_sales
Group by DATENAME(DW, order_date)

SELECT DATENAME(MONTH, order_date) as order_day, count(DISTINCT order_id) as Total_Orders
from pizza_sales
Group by DATENAME(MONTH, order_date)
order by  Total_Orders desc

Select pizza_category, sum(total_price) * 100 / (Select sum(total_price) from pizza_sales) as PCT
from pizza_sales 
WHERE MONTH (order_date) = 1
group by pizza_category


Select pizza_size, round (sum(total_price), 2) as Total_Sales, cast(sum(total_price) * 100 / (Select sum(total_price) from pizza_sales) as decimal (10,2)) as PCT
from pizza_sales 
where DATEPART (QUARTER, order_date) = 1
group by pizza_size
order by PCT desc

Select TOp 5 pizza_name, Sum(total_price) as Total_Revenue from pizza_sales
group by pizza_name
order by total_revenue desc

Select TOp 5 pizza_name, Sum(total_price) as Total_Revenue from pizza_sales
group by pizza_name
order by total_revenue asc

Select TOp 5 pizza_name, Sum(quantity) as Total_Quantity from pizza_sales
group by pizza_name
order by Total_Quantity asc

Select TOp 5 pizza_name, count (distinct order_id) as Total_Order from pizza_sales
group by pizza_name
order by Total_Order asc
