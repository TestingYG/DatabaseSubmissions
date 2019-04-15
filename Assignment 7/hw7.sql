Begin;

Drop Table if exists census_data cascade;

Set client_encoding = "Latin1";

Create Table census_data(
  zip_code integer not null,
  total_population integer,
  median_age numeric not null,
  total_males integer,
  total_females integer,
  total_households integer,
  avg_household_size numeric not null
);

\COPY census_data from './census.csv' delimiter ',' csv;

Alter table only census_data
  Add CONSTRAINT census_data_pkey primary key (zip_code);

Commit;
ANALYZE census_data;
