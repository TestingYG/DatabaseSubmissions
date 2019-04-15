-- 1.
Select referrer, count(referrer) as count
From buyers
  inner join transactions
    on transactions.cust_id = buyers.cust_id
group by referrer
order by count DESC
;


-- 2.
select buyers.fname as First_Name, buyers.lname as Last_Name
From buyers
  left outer join transactions
    on buyers.cust_id = transactions.cust_id
where transactions.cust_id is null
order by First_Name
;

-- 3.
select boats.prod_id, boats.brand as Boats_Not_Sold
From boats
  left outer join transactions
    on boats.prod_id = transactions.prod_id
where transactions.prod_id is null
;

-- 4.
select buyers.fname as First_Name, buyers.lname as Last_Name, Boats.brand as Boat_Brand, Boats.category as Boat_Category
From buyers
  inner join transactions
    on buyers.cust_id = transactions.cust_id
  inner join boats
    on transactions.prod_id = boats.prod_id
where
  buyers.fname = 'Alan' and buyers.lname = 'Weston'
;

-- 5.
select buyers.cust_id as Custid, buyers.fname as First_Name, buyers.lname as Last_Name, bob.count
From (
  Select transactions.cust_id as Custid, count(transactions.cust_id) as count
  From transactions
  group by Custid
  Having  Count(*) > 1
) bob

inner join buyers
  on bob.Custid = buyers.cust_id
Order by Custid ASC;
;
