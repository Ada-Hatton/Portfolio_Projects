-- CLEANING DATA WITH SQL QUERIES


-- Standardise Date Format


SELECT SaleDateConverted
FROM [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)


-- Populate Property Address Data


SELECT a.ParcelID
		,a.PropertyAddress
		,b.ParcelID
		,b.PropertyAddress
		,ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


-- Breaking out Property_Address into individual columns (address, city, state) using SUBSTRING


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Street_Address
	,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM [Portfolio Project]..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitStreet NVARCHAR(255);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);


UPDATE NashvilleHousing
SET PropertySplitStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- Breaking out Owner_Address into individual columns (address, city, state) using PARSENAME


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
	,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
	,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Portfolio Project]..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitStreet NVARCHAR(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);


UPDATE NashvilleHousing
SET OwnerSplitStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Changing Y and N to Yes and No in SoldAsVacant


SELECT SoldAsVacant
		,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM [Portfolio Project]..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END


-- Remove Duplicates


WITH RowNumCTE AS
(
SELECT *,
		ROW_NUMBER() 
			OVER(	
				PARTITION BY ParcelID
				,PropertyAddress
				,SalePrice
				,SaleDate
				,LegalReference
				ORDER BY UniqueID
				)row_num

FROM [Portfolio Project]..NashvilleHousing
--ORDER BY ParcelID
)

DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


-- Delete unused columns


SELECT *
FROM [Portfolio Project]..NashvilleHousing


ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN OwnerAddress
			,TaxDistrict
			,PropertyAddress

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN SaleDate

