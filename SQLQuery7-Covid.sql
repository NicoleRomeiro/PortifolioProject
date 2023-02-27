--PROJETO BASEADO NO VÍDEO 
--Data Analyst Portfolio Project | SQL Data Exploration | Project 1/4 | https://www.youtube.com/watch?v=qfyynHBFOsM
--Canal: Alex The Analyst

SELECT * FROM [dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT * FROM [dbo].[CovidVaccination$]
--ORDER BY 3,4

-- Select the data we are going to using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY Location, Date

--Looking at Total Cases x Total Deaths
SELECT Location, Date, total_cases, total_deaths, ((total_deaths/total_cases)*100) AS DeathPercentage
FROM [dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 1,2

--Shows likelihood of dying if you contract covid in your country
SELECT Location, Date, total_cases, total_deaths, ((total_deaths/total_cases)*100) AS DeathPercentage
FROM [dbo].[CovidDeaths]
WHERE Location = 'Brazil' AND continent IS NOT NULL
ORDER BY 1,2

--Looking at Total Cases vc Population
SELECT Location, date, total_cases, population, ((total_cases/population)*100) AS PercentagePopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY Location, Date


--Looking at countries with Highest Infection Rate compared to Population
SELECT location, Population, MAX(total_cases) AS HighestInfecationCount, MAX((total_cases/population)*100) AS PercentagePopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentagePopulationInfected DESC


--Showing the countries with Highest Death Count per Population
SELECT location, MAX(cast (total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE Continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

----Showing the Continents with Highest Death Count per Population
SELECT continent, MAX(cast (total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Showing The continents With the highest Death Count
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY continent
ORDER BY totalDeathCount DESC

--Global Numbers
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths, (SUM(cast(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage
FROM [dbo].[CovidDeaths]
WHERE continent IS NOT NULL
--GROUP BY Date
ORDER BY 1,2

--Looking Tota Population vs Population
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [dbo].[CovidDeaths] AS dea
JOIN CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (Partition BY dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2,3

--USE CTE
WITH PopvcVac (Continent, location, date, population, New_Vaccinations, RolligPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (Partition BY dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
--ORDER
)
SELECT *, (RolligPeopleVaccinated/population)*100
FROM PopvcVac


--TEMP TABLE

DROP TABLE IF exists TB_PERCENT_POPULATION_VACCINATION
CREATE TABLE TB_PERCENT_POPULATION_VACCINATION
(Continent NVARCHAR(255),
Location NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLING_PEOPLE_VACCINATION NUMERIC,
)

INSERT INTO TB_PERCENT_POPULATION_VACCINATION
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (Partition BY dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * FROM TB_PERCENT_POPULATION_VACCINATION

--Creating View to store data for later visulizations

CREATE VIEW VW_PERCENT_POPULATION_VACCINATION AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER (Partition BY dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * FROM VW_PERCENT_POPULATION_VACCINATION
