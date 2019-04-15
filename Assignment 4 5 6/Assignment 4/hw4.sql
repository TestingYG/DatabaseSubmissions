Begin;

Drop Table if exists securities cascade;
Drop Table if exists fundamentals cascade;
Drop Table if exists prices cascade;

Set client_encoding = 'Latin1';

Create Table securities(
  Symbol text not null,
  Company text,
  Sector text,
  "Sub Industry" text,
  "Initial Trade Date" Date
);

Create Table fundamentals(
  ID integer not null,
  Symbol text not null,
  "Year Ending" Date,
  "Cash and Cash Equivalents" numeric,
  "Earnings Before Intrest and Taxes" numeric,
  "Gross Margin" integer,
  "Net Income" numeric,
  "Total Assests" numeric,
  "Total Liabilities" numeric,
  "Total Revenue" numeric,
  Year integer not null,
  "Earnings Per Share" Float,
  "Shares Outstanding" Float
);

Create Table prices(
  Date Date not null,
  Symbol text not null,
  Open float,
  Close float,
  Low float,
  High float,
  Volume Integer
);

\COPY securities from './securities.csv' delimiter ',' csv;
\COPY fundamentals FROM './fundamentals.csv' delimiter ',' csv ;
\COPY prices FROM './prices.csv' delimiter ',' csv;

Alter table only securities
  Add CONSTRAINT securities_pkey primary key (Symbol);

Alter table only fundamentals
  add CONSTRAINT fundamentals_pkeyc primary key (ID);

Alter table only fundamentals
  add CONSTRAINT symbol_fkey FOREIGN key (Symbol) REFERENCES securities(Symbol);

Alter table only prices
  add CONSTRAINT symbol_fkey FOREIGN key (symbol) REFERENCES securities(Symbol);

Commit;
ANALYZE securities;
ANALYZE fundamentals;
ANALYZE prices;
