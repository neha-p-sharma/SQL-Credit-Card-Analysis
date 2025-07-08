-- 1 - write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends
with cte as
(
select city,
	sum(amount)as total_spend
from credit_card_transcations
group by city
),
amt_sum as
(
select  sum(total_spend)as total_amount from cte
)

select top 5 c.*, 
	round(total_spend/total_amount *100,2) as per_contribution
from cte c
inner join amt_sum a
on 1=1
order by total_spend desc


-- 2 - write a query to print highest spend month and amount spent in that month for each card type
with yr_mnt as
(
select card_type,
	DATEPART(year,transaction_date)as yr,
	DATEPART(month,transaction_date)as mnt,
	sum(amount)as sales
from credit_card_transcations
group by card_type,	DATEPART(year,transaction_date),DATEPART(month,transaction_date)
)
select * from
(select *, rank() over(partition by card_type order by sales desc) as rn
from yr_mnt)a
where rn=1



-- 3 - write a query to print the transaction details(all columns from the table) for each card type when 
-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
with cte as
(
select *
	,sum(amount) over (partition by card_type order by transaction_date,transaction_id)as total_spend
from credit_card_transcations
)
select * from 
(
select *, rank() over (partition by card_type order by total_spend)as rn
from cte
where total_spend >=1000000
)a
where rn =1

-- 4- write a query to find city which had lowest percentage spend for gold card type
with gold_sales as
(
select city,
	card_type,
	sum(amount)as sales,
	sum (case when card_type = 'Gold' then amount end)as gold_amount
from credit_card_transcations
group by city,card_type
)  
select city,
	sum(gold_amount)*1.0/sum(sales) as gold_ratio
from gold_sales
group by city
having count(gold_amount)>0 and sum(gold_amount) >0
order by gold_ratio;



-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with cte as
(
select city,
	exp_type,
	sum(amount)as amount
from credit_card_transcations
group by city,exp_type
)
select city,
	max(case when drn =1 then exp_type end)as highest_exp_type,
	max(case when arn=1 then exp_type end)as lowest_exp_type	
from 
(
	select *,
		RANK() over(partition by city order by amount desc)as drn ,
		RANK() over(partition by city order by amount asc)as arn 
	from cte
)a
group by city


-- 6 - write a query to find percentage contribution of spends by females for each expense type
select exp_type,
	sum(case when gender ='F' then amount else 0 end )*1.0/sum(amount)as per_female_contribution
from credit_card_transcations
group by exp_type
order by per_female_contribution desc


-- 7- which card and expense type combination saw highest month over month growth in Jan-2014
with exp_cte as(
select card_type,
	exp_type,
	DATEPART(year,transaction_date)as yr,
	DATEPART(month, transaction_date)as mnt,
	sum(amount)as amount
from credit_card_transcations
group by card_type,
	exp_type,
	DATEPART(year,transaction_date),
	DATEPART(month,transaction_date)
)
select top 1 *, (amount - prev_amt ) as mom_growth
from 
(
select *,
	lag(amount,1) over(partition by card_type order by yr,mnt )as prev_amt
from exp_cte
)a
where prev_amt is not null and yr=2014 and mnt=1
order by mom_growth desc


-- 8- during weekends which city has highest total spend to total no of transcations ratio 
select  top 1 city,
	sum(amount)*1.0 / count(1) as ratio
from credit_card_transcations
where DATEPART(WEEKDAY,transaction_date) in (1,7)
group by city 
order by ratio desc


--9- which city took least number of days to reach its
--500th transaction after the first transaction in that city;
with cte as
(
select *,
	ROW_NUMBER() over(partition by city order by transaction_date,transaction_id)as rn
from credit_card_transcations
)
select top 1 city, DATEDIFF(day, min(transaction_date),max(transaction_date))as date_diff
from cte
where rn=1 or rn=500
group by city
having count(1)=2
order by date_diff
