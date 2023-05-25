/*
Exploring data
*/

SELECT *
FROM PortfolioProject..Pokemon

-- Pokemon with Multiple Sizes

SELECT PokedexNum, COUNT (PokedexNum) as Sizes
FROM PortfolioProject..Pokemon
GROUP BY PokedexNum
HAVING COUNT (PokedexNum) > 1

-- Number of Pokemon with the same Type 1

SELECT [Type 1], COUNT ([Type 1]) as Type1Total
FROM PortfolioProject..Pokemon
GROUP BY [Type 1]
HAVING COUNT ([Type 1]) > 1
ORDER BY Type1Total DESC

-- Number of Pokemon with the same Type 2

SELECT [Type 2], COUNT ([Type 2]) as Type2Total
FROM PortfolioProject..Pokemon
GROUP BY [Type 2]
HAVING COUNT ([Type 2]) > 1
ORDER BY Type2Total DESC

-- Dual Type Pokemon

SELECT Name,[Type 1], [Type 2]
FROM PortfolioProject..Pokemon
WHERE [Type 2] is not Null

-- Number of Legendary Pokemon including Mega Evolutions

SELECT Legendary, COUNT (Legendary) as LegendaryNum
FROM PortfolioProject..Pokemon
WHERE Legendary = 'TRUE'
GROUP BY Legendary

-- Top 10 Strongest Pokemon

SELECT TOP 10 Name, Total
FROM PortfolioProject..Pokemon
ORDER BY Total DESC

-- Top 10 Strongest Pokemon types Excluding Legendary & Mega Evolution Pokemon

SELECT TOP 10 Name, Total
FROM PortfolioProject..Pokemon
WHERE Legendary = 0 AND Name not like '%Mega%'
ORDER BY Total DESC

-- Strength of Pokemon based on Generations

SELECT Generation,
				ROUND(AVG(Total), 1) AvgTotal,
				ROUND(AVG(HP), 1) AvgHP,
				ROUND(AVG(Attack), 1) AvgAtk,
				ROUND(AVG(Defense), 1) AvgDef,
				ROUND(AVG(SPAttack), 1) AvgSpAtk,
				ROUND(AVG(SPDefence), 1) AvgSpDef,
				ROUND(AVG(Speed), 1) AvgSpeed,
				COUNT(*) Count
FROM PortfolioProject..Pokemon
GROUP BY Generation
ORDER BY 2 DESC

-- Which generation had the strongest Legendary Pokemon

SELECT Generation, 
				ROUND(AVG(Total), 1) AvgTotal,
				ROUND(AVG(HP), 1) AvgHP,
				ROUND(AVG(Attack), 1) AvgAtk,
				ROUND(AVG(Defense), 1) AvgDef,
				ROUND(AVG(SPAttack), 1) AvgSpAtk,
				ROUND(AVG(SPDefence), 1) AvgSpDef,
				ROUND(AVG(Speed), 1) AvgSpeed,
				COUNT(*) Count
FROM PortfolioProject..Pokemon
WHERE Legendary = 1 and Name not like '%Mega%'
GROUP BY Generation
ORDER BY 2 DESC

