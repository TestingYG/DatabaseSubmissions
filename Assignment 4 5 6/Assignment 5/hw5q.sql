Create Temp Table partitioned_dates as
(With New_Date as
  (Select Row_number() over (partition by DATE_TRUNC ('year', prices.Date) order by prices.Date desc) as num, prices.Date
    From Prices
    Where symbol = 'YHOO')
Select New_Date.Date, symbol, Prices.close as Close_Price
  From New_Date
  Inner Join prices on New_Date.Date = Prices.Date where num = 1
    order by symbol DESC);

Create temp table annual_returns as
Select
  Symbol, Date, Close_Price,
  (Close_Price / (lead(Close_Price) over (partition by symbol order by Date desc)) - 1):: numeric (10,4) as return
From
  partitioned_dates;

Create temp table Top_Comp as
Select Distinct annual_returns.Symbol, annual_returns.return, annual_returns.Close_Price
From annual_returns
left outer join fundamentals
  on annual_returns.Symbol = fundamentals.Symbol
Where
  return is not null
order by
  return DESC
Limit 60;

Create temp table Pot_Cwwomp as /* Remove this line to get querue results for question 2 */
SELECT DISTINCT ON (Symbol, Year) fundamentals.Symbol, fundamentals.Year,
    Total_Assests - Total_Revenue - Net_Income as High_Net_Worth,
    ROUND((Net_Income / LAG(Net_Income) OVER(PARTITION BY Top_Comp.Symbol ORDER BY year)-1)*100,4) AS Net_Income_Growth,
    ROUND((Total_Revenue / LAG(Total_Revenue) OVER(PARTITION BY Top_Comp.Symbol ORDER BY year)-1)*100,4) AS Revenue_Growth_Per_Year,
    ROUND((Earnings_Per_Share / LAG(Earnings_Per_Share) OVER(PARTITION BY Top_Comp.Symbol ORDER BY year)-1)*100,4) AS Earnings_Per_Share_Growth,
    Cash_and_Cash_Equivalents - Total_Liabilities AS debt,
    ROUND(Top_Comp.Close_Price/Earnings_Per_Share,2) AS Price_To_Earnings_Ratio
FROM Top_Comp
  Left outer join fundamentals
  on Top_Comp.Symbol = fundamentals.Symbol
ORDER BY Symbol;

/* Above this is the Querey's for question 1*/

/* Below is for question 2 and 3*/

Create temp table Pot_Comp as
SELECT DISTINCT ON (Symbol, Year) fundamentals.Symbol, fundamentals.Year,
    Total_Assests - Total_Revenue - Net_Income as High_Net_Worth,
    ROUND((Net_Income / LAG(Net_Income) OVER(PARTITION BY fundamentals.Symbol ORDER BY year)-1)*100,4) AS Net_Income_Growth,
    ROUND((Total_Revenue / LAG(Total_Revenue) OVER(PARTITION BY fundamentals.Symbol ORDER BY year)-1)*100,4) AS Revenue_Growth_Per_Year,
    ROUND((Earnings_Per_Share / LAG(Earnings_Per_Share) OVER(PARTITION BY fundamentals.Symbol ORDER BY year)-1)*100,4) AS Earnings_Per_Share_Growth,
    Cash_and_Cash_Equivalents - Total_Liabilities AS debt
FROM fundamentals
ORDER BY Symbol;

Select DISTINCT On (symbol) Pot_Comp.Symbol, securities.Company as companies, securities.sector as sectorss,
  Pot_Comp.High_Net_Worth, Pot_Comp.Net_Income_Growth, Pot_Comp.Revenue_Growth_Per_Year,Pot_Comp.Earnings_Per_Share_Growth,
  Pot_Comp.Debt
From Pot_Comp
  Left outer join securities
  on Pot_Comp.Symbol = securities.symbol
Where
  Pot_Comp.Revenue_Growth_Per_Year is not null and
  Pot_Comp.Net_Income_Growth is not null and
  Pot_Comp.Year = 2016 and
  Pot_Comp.Earnings_Per_Share_Growth is not null and
  Pot_Comp.High_Net_Worth > -1000000000
Order by Symbol;
