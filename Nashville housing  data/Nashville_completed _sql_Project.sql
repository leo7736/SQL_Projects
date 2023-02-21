--cleaning data in sql Queries
select * 
from Nashville_Housing

--normalize the date format
select SaleDateConverted,
CONVERT(Date,SaleDate)
from Nashville_Housing
--create a new column for convertedDate
alter table Nashville_Housing
add SaleDateConverted Date
--updating converted dates to new column
update Nashville_Housing
set SaleDateConverted=CONVERT(date,SaleDate)

--populate property address data(to populate-join the table with itself "self join")
select *
from Nashville_Housing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull (a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull (a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual coloumn(address,city,state)
--(propertyAddress)
 select * 
from Nashville_Housing

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
--CHARINDEX gives the index number of the given character in a column
from Nashville_Housing


select 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
--CHARINDEX gives the index number of the given character in a column
from Nashville_Housing

alter table Nashville_Housing
add PropertySplitAddress nvarchar(255)

update Nashville_Housing
set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


alter table Nashville_Housing
add PropertySplitCity nvarchar(255)

update Nashville_Housing
set PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select PropertySplitAddress,PropertySplitCity 
from Nashville_Housing

--breaking out Owneraddress into individual coloumn(address,city,state)using ParseName()
--Parsename() parse column based on '.' so we need to replace ','in column with '.'
select PARSENAME(replace(OwnerAddress,',','.'),1)
from Nashville_Housing

select PARSENAME(replace(OwnerAddress,',','.'),2)
from Nashville_Housing

select PARSENAME(replace(OwnerAddress,',','.'),3)
from Nashville_Housing

alter table Nashville_Housing
add OwnerAddressSplit nvarchar(255)

update Nashville_Housing
set OwnerAddressSplit =PARSENAME(replace(OwnerAddress,',','.'),3)


alter table Nashville_Housing
add OwnerCitySplit nvarchar(255)

update Nashville_Housing
set OwnerCitySplit =PARSENAME(replace(OwnerAddress,',','.'),2)


alter table Nashville_Housing
add OwnerStateSplit nvarchar(255)

update Nashville_Housing
set OwnerStateSplit =PARSENAME(replace(OwnerAddress,',','.'),1)

select OwnerAddressSplit,OwnerCitySplit,OwnerStateSplit
from Nashville_Housing

--change Y and N o 'Yes' and 'No' in "Sold as vacant" field
select distinct(SoldAsVacant),count(SoldAsVacant)
from Nashville_Housing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case 
when SoldAsVacant = 'Y' then 'YES'
WHEN SoldAsVacant= 'N' THEN 'No'
else SoldAsVacant
END
from Nashville_Housing


update Nashville_Housing
set SoldAsVacant=case 
when SoldAsVacant = 'Y' then 'YES'
WHEN SoldAsVacant= 'N' THEN 'No'
else SoldAsVacant
END

---selecting  all  rows (one or more than one repeatation)
select *,
row_number() over (partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference 
	order by UniqueID) as Row_num
from Nashville_Housing
order by ParcelID

--selecting  rows (more than one repeatation)
with RowNumCTE as (
select *,
row_number() over (partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference 
	order by UniqueID) as Row_num
from Nashville_Housing
--order by ParcelID
)
select * from RowNumCTE
where Row_num >1

--delete duplicate
with RowNumCTE as (
select *,
row_number() over (partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference 
	order by UniqueID) as Row_num
from Nashville_Housing
--order by ParcelID
)
delete from RowNumCTE
where Row_num >1

--Delete Unused columns
alter table Nashville_Housing
drop column owneraddress,taxdistrict,propertyaddress


alter table Nashville_Housing
drop column SaleDate


select * 
from Nashville_Housing