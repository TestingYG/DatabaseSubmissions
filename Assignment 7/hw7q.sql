create temp table q as
Select
  median_age, (cast(total_males as numeric)/cast(total_population as numeric)) * 100 as male_percent, avg_household_size
from
  census_data
Where
  zip_code = 93591;

create temp table p as
Select
  zip_code, median_age, (cast(total_males as numeric)/cast(total_population as numeric))*100 as male_percent, avg_household_size
from
  census_data
where
  total_population != 0 and
  zip_code != 93591;

select p.zip_code, p.male_percent, p.avg_household_size,
  ROUND(SQRT(POWER(q.median_age-p.median_age,2)+POWER(q.male_percent-p.male_percent,2)+POWER(q.avg_household_size-p.avg_household_size,2)),4) as distance
FROM q
CROSS JOIN p
order by distance
Limit 10;
