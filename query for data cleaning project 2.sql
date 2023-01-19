SELECT * FROM
[SQL_portfolio project]..[NASHVILLEDATA]

-- STANDARDIZE DATE COLUMN--

SELECT SALEDATECONVERTED, CONVERT(DATE,SALEDATE)
FROM [SQL_portfolio project]..[NASHVILLEDATA]

ALTER TABLE NASHVILLEDATA 
ADD SALEDATECONVERTED DATE;

UPDATE NASHVILLEDATA 
SET SALEDATECONVERTED = CONVERT(DATE,SALEDATE)

--POPULATE PROPERTY ADDRESS DATA --

ALTER TABLE NASHVILLEDATA
DROP COLUMN SALEDATECONVERTEDD

SELECT *
FROM [SQL_portfolio project]..[NASHVILLEDATA]
ORDER BY PARCELID

SELECT a.parcelID ,a.propertyaddress, b.parcelID,b.propertyaddress,ISnull(a.propertyaddress,b.propertyaddress)
from [SQL_portfolio project]..[NASHVILLEDATA] a
join [SQL_portfolio project]..[NASHVILLEDATA] b
     on a.parcelId = b.parcelId
	 and a.[uniqueID] <> b.[uniqueId]
where a.propertyaddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
from [SQL_portfolio project]..[NASHVILLEDATA] a
join [SQL_portfolio project]..[NASHVILLEDATA] b
     on a.parcelId = b.parcelId
	 and a.[uniqueID] <> b.[uniqueId]
where a.propertyaddress is null

--breaking out address into individual columns(address,city,state)

select
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)as address
,SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1 ,len(propertyaddress)) as address
 from [SQL_portfolio project]..[NASHVILLEDATA]


 alter table nashvilledata
 add propertysplitaddress nvarchar(225);

update nashvilledata
set propertysplitaddress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)


alter table nashvilledata
add propertysplitcity nvarchar(225);

update nashvilledata
set propertysplitcity = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1 ,len(propertyaddress))


select *from [SQL_portfolio project]..nashvilledata;



--owner address--
select owneraddress
from [SQL_portfolio project]..[NASHVILLEDATA]

select 
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)
from [SQL_portfolio project]..[NASHVILLEDATA]
order by owneraddress desc

alter table nashvilledata
add ownersplitaddress nvarchar(225);

update nashvilledata
set ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3)


alter table nashvilledata
add ownersplitcity nvarchar(225);

update nashvilledata
set ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2)


alter table  nashvilledata 
add ownersplitstate nvarchar(225);

update nashvilledata
set ownersplitstate = PARSENAME(replace(owneraddress,',','.'),1)

select *
from [SQL_portfolio project]..[NASHVILLEDATA]


--change y and n to yes and no in sold as vacant --
select soldasvacant
, case when soldasvacant ='y' then 'yes'
       when soldasvacant = 'n' then 'no'
	   else soldasvacant
	   end
  from [SQL_portfolio project]..[NASHVILLEDATA]

  update [NASHVILLEDATA]
  set soldasvacant = case when soldasvacant ='y' then 'yes'
       when soldasvacant = 'n' then 'no'
	   else soldasvacant
	   end
  from [SQL_portfolio project]..[NASHVILLEDATA]

  select distinct(soldasvacant) ,count(soldasvacant)
  from [SQL_portfolio project]..[NASHVILLEDATA]
  group by soldasvacant

  --remove duplicate --

  with rownumcte AS(
  select *,
       row_number() over(
	   partition by parcelid,
	                propertyaddress,
					saleprice,
					saledate,
					legalreference
					order by 
					    uniqueid
					   )row_num
from [SQL_portfolio project].dbo.[NASHVILLEDATA]
)

select *
from rownumCTE 
where row_num> 1
order by propertyaddress










  --delete unused column--
  
  select *
  from [SQL_portfolio project]..[NASHVILLEDATA]
   
  alter table [SQL_portfolio project]..[NASHVILLEDATA]
  drop column owneraddress,taxdistrict, propertyaddress

  alter table [SQL_portfolio project]..[NASHVILLEDATA]
  drop column saledate