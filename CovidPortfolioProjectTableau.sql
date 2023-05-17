

/*
Queries used for Tableau Project
*/

-- 1.

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null 
ORDER BY 1,2

-- 2.
-- This is not inluded in the other queries
-- European Union is part of Europe

SELECT location, SUM(cast(new_deaths as int)) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
WHERE continent is null 
and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathsCount DESC

--3.

SELECT location, population, MAX (total_cases) as HighestInfCount, MAX((total_cases/population))*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectedPercentage Desc

--4.

SELECT location, population, date, MAX (total_cases) as HighestInfCount, MAX((total_cases/population))*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
WHERE continent is not null
GROUP BY location, population, date
ORDER BY InfectedPercentage Desc
