/*
 Fiction "Awesome Chocolate" company exploration
Skills used: Joins, Windows Functions, Aggregate Functions, sub query.
 THE Data set used can be found using the below link
 https://files.chandoo.org/sql/awesome-chocolates-data.sql
*/
set sql_mode=(select replace(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

use `awesome chocolates` ;

 select * from geo;
 select * from people;
 select * from products;
 select * from sales;
 
 -- Printing details of shipments (sales) where amounts are > 2,000 and boxes are <100?
  SELECT 
    *
FROM
    sales
WHERE
    amount > 2000 AND boxes < 100;
    

-- How many shipments (sales) each of the sales persons had in the month of January 2022? 
select distinct s.spid, p.salesperson,
  sum(amount) over(partition by spid) as Jan_2022_Totalsales,
  sum(boxes) over (partition by spid) as total_boxes_sold_in2022
from sales s
join people p 
on s.spid = p.spid
where saledate like '%2022-01%'
group by s.spid, s.saledate
order by jan_2022_totalsales desc;


-- Which product sells more boxes? Milk Bars or Eclairs?
SELECT 
    p.product, SUM(boxes) AS No_of_soldbox
FROM
    sales s
        JOIN
    products p ON s.pid = p.pid
WHERE
    p.product IN ('milk bars' , 'eclairs')
GROUP BY p.product
ORDER BY no_of_soldbox DESC;


-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
SELECT 
    p.product, SUM(boxes) AS No_of_soldbox
FROM
    sales s
        JOIN
    products p ON s.pid = p.pid
WHERE
    p.product IN ('milk bars' , 'eclairs')
    and saledate between '2022-02-01' and '2022-02-07'
GROUP BY p.product
ORDER BY no_of_soldbox DESC;



-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
SELECT 
    *,
    CASE
        WHEN DAY(saledate) = '04' THEN 'wednesday_shipment'
        ELSE ''
    END wednesday_sales
FROM
    sales s
WHERE
    customers < 100 AND boxes < 100;
    


-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT DISTINCT
    p.salesperson
FROM
    sales s
        JOIN
    people p ON s.spid = p.spid
WHERE
    saledate BETWEEN '2022-01-01' AND '2022-01-07'
    order by salesperson;


-- Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT DISTINCT
    p.salesperson
FROM
    people p
WHERE
    p.spid NOT IN (SELECT DISTINCT
            s.spid
        FROM
            sales s
        WHERE
            saledate BETWEEN '2022-01-01' AND '2022-01-07')
ORDER BY p.salesperson;


 -- How many times we shipped more than 1,000 boxes in each month?
 
 SELECT 
    MONTH(saledate) month,
    YEAR(saledate) year,
    COUNT(*) sales_above_onek
FROM
    (SELECT 
        *
    FROM
        sales
    WHERE
        boxes > 1000) x
GROUP BY MONTH(saledate) , YEAR(saledate);

select * from sales;
-- Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
 
 select month(saledate), year(saledate) ,
 case when sum(boxes > 1) then 'yes'
 else 'no'
 end after_nine_sales
 from
 sales s
 join products p on s.pid = p.pid
 join geo g on g.geoid = s.geoid
 where p.product = 'after nines' and g.geo  = 'new zealand'
group by month(saledate), year(saledate) 
order by month(saledate), year(saledate) ; 

 
 -- India or Australia? Who buys more bars on a monthly basis?
 SELECT 
    YEAR(saledate) Year,
    MONTH(saledate) Month,
    SUM(CASE
        WHEN g.geo = 'India' = 1 THEN boxes
        ELSE 0
    END) India_Boxes,
    SUM(CASE
        WHEN g.geo = 'Australia' = 1 THEN boxes
        ELSE 0
    END) Australia_Boxes
FROM
    sales s
        JOIN
    geo g ON g.GeoID = s.GeoID
        JOIN
    products p ON p.pid = s.pid
WHERE
    p.category = 'bars'
GROUP BY YEAR(saledate) , MONTH(saledate)
ORDER BY YEAR(saledate) , MONTH(saledate);
 



