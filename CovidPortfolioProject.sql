

/*
Covid 19 Data Exploration
Skills: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null  --When NULL it shows Continent in Location
ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVax
WHERE continent is not null
ORDER BY 3,4

-- Selecting data that we're using (Jan 2020 - May 2021)

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

/* 
Using the CovidDeaths Table
*/

-- Czechia Total Cases vs Total Deaths in %
-- Probability of death in Czechia when catching Covid 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%Czechia%'
WHERE continent is not null
ORDER BY 1,2


-- Total cases vs Population
-- Percentage of population that has gotten Covid


SELECT location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
WHERE continent is not null
ORDER BY 1,2


-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX (total_cases) as HighestInfCount, MAX((total_cases/population))*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectedPercentage Desc


-- Countries with the Highest Death Count per Population

SELECT location, MAX (cast(Total_deaths as int)) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
Where continent is not null 
GROUP BY location
ORDER BY TotalDeathsCount Desc


--BREAKDOWN BY CONTINENT
-- Highest Death Count per Population

SELECT continent, MAX (cast(Total_deaths as int)) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
--Where location like '%Czechia%'
Where continent is not null 
GROUP BY continent
ORDER BY TotalDeathsCount Desc


-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null 
ORDER BY 1,2


-- Joining Tables
-- Total Population vs. Vaccinations
-- Percentage of Population with at least one vaccination

SELECT Death.continent, Death.location, Death.date, Death.population, Vax.new_vaccinations
, SUM(Convert(int, Vax.new_vaccinations)) OVER (Partition by Death.Location Order by Death.Location, Death.Date)
	as PeopleVaccinated
--, (PeopleVaccinated/population)*100 -> Need to use CTE
FROM PortfolioProject..CovidDeaths as Death
JOIN PortfolioProject..CovidVax as Vax
	ON Death.location = Vax.location
	AND Death.date = Vax.date
Where Death.continent is not null
ORDER BY 2,3 



-- Using CTE for calculation in previous query


WITH CTE_PopulVax (Continent, Location, Date, Population,New_Vaccinations, PeopleVaccinated)
as
(
SELECT Death.continent, Death.location, Death.date, Death.population, Vax.new_vaccinations
, SUM(Convert(int, Vax.new_vaccinations)) OVER (Partition by Death.Location Order by Death.Location, Death.Date)
	as PeopleVaccinated
FROM PortfolioProject..CovidDeaths as Death
JOIN PortfolioProject..CovidVax as Vax
	ON Death.location = Vax.location
	AND Death.date = Vax.date
Where Death.continent is not null
--ORDER BY 2,3 Cannot use in CTE
)

Select *, (PeopleVaccinated/Population)*100
From CTE_PopulVax



--Using Temp Table for calculation in previous query

DROP TABLE if exists #PercentPopulationVax -- can run multiple times
CREATE TABLE #PercentPopulationVax
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVax
SELECT Death.continent, Death.location, Death.date, Death.population, Vax.new_vaccinations
, SUM(Convert(int, Vax.new_vaccinations)) OVER (Partition by Death.Location Order by Death.Location, Death.Date)
	as PeopleVaccinated
FROM PortfolioProject..CovidDeaths as Death
JOIN PortfolioProject..CovidVax as Vax
	ON Death.location = Vax.location
	AND Death.date = Vax.date
Where Death.continent is not null

SELECT *, (PeopleVaccinated/Population)*100
FROM #PercentPopulationVax


-- Creating Views to store data for later visualizations

CREATE VIEW PercentPopulationVax as
SELECT Death.continent, Death.location, Death.date, Death.population, Vax.new_vaccinations
, SUM(CONVERT(int, Vax.new_vaccinations)) OVER (Partition by Death.Location Order by Death.Location, Death.Date)
	as PeopleVaccinated
--, (PeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths Death
JOIN PortfolioProject..CovidVax Vax
	On Death.location = Vax.location
	and Death.date = Vax.date
Where Death.continent is not null 

SELECT *
FROM PercentPopulationVax