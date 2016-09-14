insert into expire_dates(date_expire,active,created_at,updated_at)values('01/01/2017','1','08/03/2016','08/03/2016')

QUERY QUE VAI SER USADA PARA ARRUMAR O DB PREPARA MALA

begin transaction

UPDATE
  meetings
SET
  type_research = regexp_replace(
    research_path, '/[0-9]+$', ''
  )


SELECT count(id), clerk_name,
 type_research
FROM
 meetings
 
GROUP BY
 clerk_name,type_research
 ORDER BY
 clerk_name,type_research;
 

 select distinct(type_research) from meetings