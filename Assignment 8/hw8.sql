Begin;

Drop Table if exists feild cascade;

set client_encoding = "Latin1";

CREATE TYPE BNB AS ENUM ('B','NB');
CREATE TYPE PAN AS ENUM ('P','A','N');

Create Table feild(
  Company_ID integer,
  Industry_risk PAN,
  Management_risk PAN,
  Financial_Flexibility PAN,
  Credibility PAN,
  Competitiveness PAN,
  Operating_Risk PAN,
  Class BNB
);

\COPY feild from './ids.csv' delimiter ',' csv;

Alter table only feild
  Add CONSTRAINT feild_pkey primary key (Company_ID);

Commit;
ANALYZE feild;
