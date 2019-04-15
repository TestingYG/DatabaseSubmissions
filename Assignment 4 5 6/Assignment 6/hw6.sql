Select Distinct securities.symbol, securities.company, securities.sector, prices.close, prices.date
from securities
  left outer join prices
  on securities.symbol = prices.symbol
Where
  securities.symbol = 'BDX' or
  securities.symbol = 'HOLX' or
  securities.symbol = 'MSFT' or
  securities.symbol = 'QCOM' or
  securities.symbol = 'CAG' or
  securities.symbol = 'GIS' or
  securities.symbol = 'COL' or
  securities.symbol = 'TDG' or
  securities.symbol = 'VIAB' or
  securities.symbol = 'DIS'
Order by prices.date DESC
limit 10;

-- psql -U Ying -f hw5q.sql -- Back up command
-- psql -d hw4  -U Ying -tAF, -f hw6.sql > output_file.csv -- CSV view command used.
