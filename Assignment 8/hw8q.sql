Create temp table negative_table as
Select Company_ID,class,
CASE WHEN Industry_risk='N' THEN 1 ELSE 0 END +
CASE WHEN Management_risk='N' THEN 1 ELSE 0 END +
CASE WHEN Financial_Flexibility='N' THEN 1 ELSE 0 END +
CASE WHEN Credibility='N' THEN 1 ELSE 0 END +
CASE WHEN Competitiveness='N' THEN 1 ELSE 0 END +
CASE WHEN Operating_Risk='N' THEN 1 ELSE 0 END as Negative
From feild;

Create temp table risk as
Select Company_ID, negative_table.class,
Case
  When Negative <= 2 then 'Low'
  When Negative < 4 then 'Medium'
  When Negative < 5 then 'Med_High'
  Else 'High'
  End as Rating
from negative_table;

\echo TABLE_NOT_BANKRUPT
Select
Sum(Case WHEN Rating = 'Low' THEN 1 ELSE 0 END) as Low,
Sum(Case WHEN Rating = 'Medium' THEN 1 ELSE 0 END) as Medium,
Sum(Case WHEN Rating = 'Med_High' THEN 1 ELSE 0 END) as Med_High,
Sum(Case WHEN Rating = 'High' THEN 1 ELSE 0 END) as High
from
  risk
where
  risk.Class = 'NB';

\echo TABLE_BANKRUPT
Select
  Sum(Case WHEN Rating = 'Low' THEN 1 ELSE 0 END) as Low,
  Sum(Case WHEN Rating = 'Medium' THEN 1 ELSE 0 END) as Medium,
  Sum(Case WHEN Rating = 'Med_High' THEN 1 ELSE 0 END) as Med_High,
  Sum(Case WHEN Rating = 'High' THEN 1 ELSE 0 END) as High
from
  risk
where
  risk.Class = 'B';

\echo TABLE_RISK
select
  feild.Company_ID, feild.Industry_risk, feild.Management_risk,
  feild.Financial_Flexibility, feild.Credibility, feild.Competitiveness,
  feild.Operating_Risk, feild.class,risk.rating
from risk
left outer join feild
on risk.Company_ID = feild.Company_ID
where
  risk.rating = 'Medium' or
  risk.rating = 'Med_High' or
  risk.rating = 'High' and
  risk.class = 'NB'
order by feild.Company_ID;
