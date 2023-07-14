--Cut off date 2022-03-05


-- Looking at total cases vs total deaths for the world

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM CovidProject..covidcases 
WHERE Continent IS NOT NULL
ORDER BY location, date


--Looking at countries with highest infection rates compared to population

SELECT location, population, max(total_cases) AS HighestInfectionCount, max((total_cases/population))*100 AS Percent_population_infected
FROM CovidProject..covidcases 
WHERE continent is not null
GROUP BY location, population
ORDER BY Percent_population_infected DESC

-- Looking at countries with highest death count per population

SELECT location, population, max(total_deaths) AS HighestdeathCount, max((total_deaths/population))*100 AS Percent_of_population_death
FROM CovidProject..covidcases 
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestdeathCount DESC


-- Looking at total cases vs total deaths.(Specifically for Australia)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM CovidProject..covidcases
WHERE location = 'Australia' 
ORDER BY location, date 



-- Looking at the worst day in terms of New cases, New deaths and death_percentage

--Death Percentage
SELECT TOP 1 date, (total_deaths / total_cases)*100 as death_percentage
FROM CovidProject..covidcases
WHERE location = 'Australia'
ORDER BY (total_deaths / total_cases)*100 DESC

--New Cases
SELECT TOP 1 date, new_cases 
FROM covidproject..covidcases 
WHERE location = 'Australia' 
ORDER BY new_cases DESC

-- New Deaths

SELECT TOP 1 date, new_deaths
FROM covidproject..covidcases 
WHERE location = 'Australia' 
ORDER BY new_deaths DESC



-- Percentage of Total Tested vs Total population of Australia

SELECT total_tests, population, (total_tests/population)*100 AS Tests_over_Population 
FROM CovidProject..covidcases 
WHERE location = 'Australia' and total_tests is not null 
ORDER BY Tests_over_Population DESC



-- Percentage of Total Covid Cases vs Total Population

SELECT date, total_cases, population, (total_cases/population)*100 AS Total_Cases_Over_Population
FROM CovidProject..covidcases
WHERE location = 'Australia'
ORDER BY Total_Cases_Over_Population 


-- Death count of each continent

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidProject..covidcases
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Continents with highest death count

SELECT location , max(total_deaths) as Death_Count_per_continent
FROM CovidProject..covidcases 
WHERE continent is null and location in('Europe', 'Asia', 'Africa', 'Oceania', 'North America', 'South America')
GROUP BY continent, location 
Order by Death_Count_per_continent desc


-- Death count in terms of income

SELECT location as Income , max(total_deaths) as Death_Count_per_income
FROM CovidProject..covidcases 
WHERE continent is null and location like '%income%'
GROUP BY continent, location
Order by Death_Count_per_income desc


--Global Numbers per day

SELECT date, sum(new_cases) as Total_Cases, sum(new_deaths) as Total_deaths, (sum(new_deaths)/sum(new_cases))*100 as Death_Percentage 
FROM CovidProject..covidcases 
WHERE Continent IS NOT NULL and new_cases IS NOT NULL
GROUP BY date
ORDER BY date desc

-- Total global numbers

SELECT sum(new_cases) as Total_Cases, sum(new_deaths) as Total_deaths, (sum(new_deaths)/sum(new_cases))*100 as Death_Percentage 
FROM CovidProject..covidcases 
WHERE Continent IS NOT NULL and new_cases IS NOT NULL



--Total population vs vaccinations

WITH PopvsVac (Continent, location, date, population, new_vaccinations, Rolling_vaccination_count)
AS (
SELECT ca.continent, ca.location, ca.date, ca.population, vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (PARTITION BY ca.location order by ca.location, ca.date) AS Rolling_vaccination_count
FROM CovidProject..covidcases ca
JOIN CovidProject..covidvaccinations vac
ON ca.location = vac.location 
AND ca.date = vac.date
WHERE ca.continent is not null and vac.new_vaccinations is not null
) SELECT Location, date, population, new_vaccinations, (Rolling_vaccination_count/population)*100 AS Percentage_vaccinated FROM PopvsVac


--creating views to store for visualisations

create view TotalGlobalNumbers as 
SELECT sum(new_cases) as Total_Cases, sum(new_deaths) as Total_deaths, (sum(new_deaths)/sum(new_cases))*100 as Death_Percentage 
FROM CovidProject..covidcases 
WHERE Continent IS NOT NULL and new_cases IS NOT NULL









-- Altered columns total_cases, total_deaths, new_cases and new_deaths from nvarchar to Float data types
--altered date columns from datetime to just date
alter table covidproject..covidcases
alter column total_cases float

alter table covidproject..covidcases
alter column total_deaths float

alter table covidproject..covidcases
alter column new_cases float

alter table covidproject..covidcases
alter column new_deaths float

alter table covidproject..covidcases
alter column date date 


alter table covidproject..covidvaccinations
alter column new_vaccinations float




