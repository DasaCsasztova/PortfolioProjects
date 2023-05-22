/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject..NashvilleHousing

-- Changing Date Format

SELECT SaleDate, CONVERT (Date, SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- If not updating properly

ALTER TABLE NashvilleHousing
Add SaleDateConv Date;

Update NashvilleHousing
SET SaleDateConv = CONVERT(Date,SaleDate)

Select SaleDateConv
From PortfolioProject.dbo.NashvilleHousing

-- Deleting old SaleDate column

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;

 --------------------------------------------------------------------------------------------------------------------------

-- Filling Property Address data

SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is Null
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL (A.PropertyAddress, B.PropertyAddress) as ReplaceWith
FROM PortfolioProject..NashvilleHousing A
JOIN PortfolioProject..NashvilleHousing B
	on A.ParcelID = B.ParcelID
	and A.[UniqueID ] <> b.[UniqueID ]
WHERE A.PropertyAddress is NULL

UPDATE A
SET PropertyAddress = ISNULL (A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..NashvilleHousing A
JOIN PortfolioProject..NashvilleHousing B
	on A.ParcelID = B.ParcelID
	and A.[UniqueID ] <> b.[UniqueID ]
WHERE A.PropertyAddress is NULL

--------------------------------------------------------------------------------------------------------------------------

-- Property and Owner Address Breakdown into Individual Columns (Address, City, State)

-- Property using SUBSTRING

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address -- +/-1 so we don't see the comma
, SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertyAddressSplit Nvarchar(255);

Update NashvilleHousing
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertyCitySplit Nvarchar(255);

Update NashvilleHousing
SET PropertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress;


--Owner, using PARSENAME

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
PARSENAME (REPLACE(OwnerAddress,',','.'), 3) as Address -- change , to . since PARSENAME works only with .
,PARSENAME (REPLACE(OwnerAddress,',','.'), 2) as City -- PARSENAME works backwards, so 3 2 1
,PARSENAME (REPLACE(OwnerAddress,',','.'), 1) as State
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerAddressSplit Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressSplit = PARSENAME (REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerCitySplit Nvarchar(255);

Update NashvilleHousing
SET OwnerCitySplit = PARSENAME (REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerStateSplit Nvarchar(255);

Update NashvilleHousing
SET OwnerStateSplit = PARSENAME (REPLACE(OwnerAddress,',','.'), 1)

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress;


--------------------------------------------------------------------------------------------------------------------------


-- Changing Y and N to Yes and No in "SoldAsVacant" field

SELECT DISTINCT (SoldAsVacant)
FROM PortfolioProject..NashvilleHousing 

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing 

UPDATE NashvilleHousing
SET SoldAsVacant =
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
END

-- Deleting rows containing NULL values in Owners name and address

DELETE FROM NashvilleHousing
WHERE OwnerName is Null and OwnerAddressSplit is Null
