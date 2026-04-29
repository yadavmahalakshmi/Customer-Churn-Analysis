create database churn_Analysis;
use churn_Analysis;

select * from finalChurnData;
select count(*) from finalChurnData;
desc finalChurnData;

-- 1.Total Customers
select count(*) as TotalCustomers from finalChurnData;

-- 2.Total Churned Customers
select count(*) as ChurnedCustomers
from finalChurnData
where Churn = 1;

-- 3.Churn Rate %
select count(*) as TotalCustomers,
       sum(case
             when Churn = 1 then 1 else 0 end) as Churned,
       round(sum(case
                    when Churn = 1 then 1 else 0 end) * 100.0 / count(*), 2) as Churn_Rate
from finalChurnData;

-- 4.Churn by Contract Type
select Contract,
       count(*) as TotalCustomers,
       sum(case
             when Churn = 1 then 1 else 0 end) as ChurnedCustomers
from finalChurnData
group by Contract;

-- 5.Churn by Payment Method
select PaymentMethod,
       count(*) as Total,
       sum(case
             when Churn = 1 then 1 else 0 end) as Churned
from finalChurnData
group by PaymentMethod;

-- 6.Average Monthly Charges (Churn vs Non-Churn)
select Churn,
       concat(round(avg(MonthlyCharges) / 1000,2),'K') as AvgMonthlyCharges
from finalChurnData
group by Churn;

-- 7.Average Total Charges (Churn vs Non-Churn)
select Churn,
       concat(round(avg(TotalCharges) / 1000,2),'K') as AvgTotalCharges
from finalChurnData
group by Churn;

-- 8.Churn by Internet Service
select InternetService,
       count(*) as Total,
       sum(case
             when Churn = 1 then 1 else 0 end) as Churned
from finalChurnData
group by InternetService;

-- 9.High-Risk Customers (Low Tenure + High Charges)
select customerID,
       tenure,
       MonthlyCharges,
       Churn
from finalChurnData
where tenure < 12 and MonthlyCharges > 70 and Churn = 1;

-- 10.Tenure Group Analysis
select 
    case
      when tenure <=12 then '0-1 Year'
      when tenure <=24 then '1-2 Years'
      when tenure <=48 then '2-4 Years'
      else '4+ Years'
	end as Tenure_Group,
    count(*) as TotalCustomers,
    sum(case when Churn = 1 then 1 else 0 end) as Churned
from finalChurnData
group by Tenure_Group;

-- 11.Monthly Revenue Loss due to Churn
select round(sum(MonthlyCharges),2) as RevenueLoss
from finalChurnData
where Churn = 1;

-- 12.Top Factors Affecting Churn
select Contract,
       InternetService,
       PaymentMethod,
       count(*) as Total,
       sum(case when Churn = 1 then 1 else 0 end) as Churned
from finalChurnData
group by Contract, InternetService, PaymentMethod;

-- 13.Churn Rate by Contract (%)
select Contract,
       round(sum(case when Churn = 1 then 1 else 0 end) * 100.0 / count(*),2) as ChurnRate
from finalChurnData
group by Contract
order by ChurnRate desc;

-- 14.Rank Customers by Charges
select customerID,
       MonthlyCharges,
       rank() over(order by MonthlyCharges desc) as ChargeRank
from finalChurnData;


