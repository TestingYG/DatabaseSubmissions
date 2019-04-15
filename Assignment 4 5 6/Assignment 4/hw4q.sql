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
Select Distinct annual_returns.Symbol, annual_returns.return
From annual_returns
left outer join fundamentals
  on annual_returns.Symbol = fundamentals.Symbol
Where
  return is not null
order by
  return DESC
Limit 60;

select * from Top_Comp;
