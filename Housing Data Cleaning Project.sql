/*

Cleaning Data in SQL Queries

*/

select *
from [Portfolio Project]..NashvilleHousing

--standardize date format

select SaleDateConverted, Convert(date,SaleDate)
from [Portfolio Project]..NashvilleHousing

/*update NashvilleHousing
set SaleDate= convert(date, SaleDate)*/

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)



--populate property address data

select *
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


---breaking out addresses into individual columns(address, city, state)


select PropertyAddress
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as address,
substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as address
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))


select *
 from [Portfolio Project]..NashvilleHousing




 select OwnerAddress
 from [Portfolio Project]..NashvilleHousing


 select 
 parsename(replace(OwnerAddress, ',' , '.'),3),
  parsename(replace(OwnerAddress, ',' , '.'),2),
   parsename(replace(OwnerAddress, ',' , '.'),1)
 from [Portfolio Project]..NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress =  parsename(replace(OwnerAddress, ',' , '.'),3)


alter table NashvilleHousing
add OwnerSplitcity Nvarchar(255);

update NashvilleHousing
set OwnerSplitcity =  parsename(replace(OwnerAddress, ',' , '.'),2)


alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',' , '.'),1)






---chanhe Y and N to yes or No in "sold as vacant" field


select distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end
from [Portfolio Project]..NashvilleHousing


update NashvilleHousing
set
SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
                    when SoldAsVacant='N' then 'No'
	                else SoldAsVacant
	                end








-------------------------Remove Duplicates----------------------------------------------------------------------------------------------------------


with RowNumCTE as(
select *,
    row_number() over(
	partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
				   UniqueID
				   ) row_num

from [Portfolio Project]..NashvilleHousing
)
Select *
from RowNumCTE
where row_num >1
order by PropertyAddress





----------------------Delete unused Columns---------------------------------------------------------------------------------------------------------------


select * 
from [Portfolio Project]..NashvilleHousing

alter table [Portfolio Project]..NashvilleHousing
drop column OwnerAddress, Taxdistrict,PropertyAddress

alter table [Portfolio Project]..NashvilleHousing
drop column SaleDate







