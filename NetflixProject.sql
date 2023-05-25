
/* 
Data cleaning: Treat Duplicates, Populate missing rows, Drop unneeded columns, Change date format
*/

SELECT *
FROM PortfolioProject..NetflixData

-- Check for duplicates

SELECT show_id, COUNT (*)
FROM PortfolioProject..NetflixData
GROUP BY show_id
ORDER BY show_id DESC

-- Renaming "Not Given" in Director as "Unknown"

SELECT COUNT(director)
FROM PortfolioProject..NetflixData
WHERE director = 'Not Given'

SELECT REPLACE(Director, 'Not Given', 'Unknown') as DirectorNew
FROM PortfolioProject..NetflixData

ALTER TABLE NetflixData
Add DirectorNew Nvarchar(255);
 
UPDATE NetflixData
SET DirectorNew = REPLACE(Director, 'Not Given', 'Unknown')

-- Dropping old director column

ALTER TABLE NetflixData
DROP COLUMN director;

-- Changing date format so its consistent

SELECT date_added, CONVERT (date, date_added)
FROM PortfolioProject..NetflixData

UPDATE NetflixData
SET date_added = CONVERT (date, date_added)

