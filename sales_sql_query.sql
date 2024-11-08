-- Creating tables
DROP TABLE IF EXISTS sale;
	
CREATE TABLE sale(
	transaction_id INTEGER PRIMARY KEY,
	sales_date DATE ,
	sales_time TIME ,
	cust_id INTEGER ,
	gender VARCHAR(20) ,
	age INTEGER ,
	category VARCHAR(50) ,
	quantity INTEGER ,
	price_per_unit FLOAT ,
	cogs FLOAT ,
	total_sales FLOAT 
);

SELECT * FROM sale;

SELECT COUNT(*) FROM sale;

-- Check for null values
SELECT * FROM sale
WHERE 
	transaction_id IS NULL
	OR
	sales_date IS NULL
	OR
	sales_time IS NULL
	OR
	cust_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sales IS NULL;

-- Deleting rows for null values ecxept age column as we can populate it 
DELETE  FROM sale
WHERE 
	transaction_id IS NULL
	OR
	sales_date IS NULL
	OR
	sales_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sales IS NULL;

--Data exploration

--How many sales we have
SELECT COUNT(*) AS total_sales FROM sale;

--COUNT UNIQUE CUSTOMERS
SELECT COUNT(DISTINCT cust_id) AS unique_cust_id FROM sale;

--unique categories
SELECT DISTINCT category AS unique_category FROM sale;

--Data Analysis and Business key problems and answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM sale
WHERE sales_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT * FROM sale
WHERE
	category = 'Clothing'
	and
	quantity >=4 
	and
	TO_CHAR(sales_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT SUM(total_sales) AS net_sales , category , COUNT(quantity) AS total_order FROM sale
GROUP BY 2
ORDER BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS average_age , category FROM sale
GROUP BY category
HAVING category LIKE 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM sale
WHERE total_sales > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT COUNT(transaction_id) AS total_trans , gender , category FROM sale
GROUP BY 2,3
ORDER BY 3

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sales_date) as year,
    EXTRACT(MONTH FROM sales_date) as month,
    AVG(total_sales) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sales) DESC) as rank
FROM sale
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT   cust_id , sum(total_sales) as total_sales FROM sale
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT cust_id) , category FROM sale 
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM sale
)
SELECT shift,COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

--end
