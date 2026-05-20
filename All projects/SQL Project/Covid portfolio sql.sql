SELECT *
FROM [portfolio project].[dbo].[CovidDeaths]
WHERE continent is not null
ORDER BY 3,4




SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM  [portfolio project].[dbo].[CovidDeaths]
ORDER BY 1,2

-- Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contact covid in your country.
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM  [portfolio project].[dbo].[CovidDeaths]
WHERE location like 'nigeria'
ORDER BY 1,2

-- Total cases vs Population
SELECT Location, date, total_cases, Population, (total_cases/Population)*100 as PopulationPercentage
FROM  [portfolio project].[dbo].[CovidDeaths]
WHERE location like 'nigeria'
ORDER BY 1,2

-- Country with the highest infection rate

SELECT Location, Population, MAX (total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as  PercentPopulationInfected
FROM  [portfolio project].[dbo].[CovidDeaths]
--WHERE location like 'nigeria'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

-- breaking it down 
SELECT location, MAX(cast (total_deaths as int)) as TotalDeathCount
FROM  [portfolio project].[dbo].[CovidDeaths]
--WHERE location like 'nigeria'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- breaking it down by continent
SELECT continent, MAX(cast (total_deaths as int)) as TotalDeathCount
FROM  [portfolio project].[dbo].[CovidDeaths]
--WHERE location like 'nigeria'
WHERE continent is  not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


--Showing the country with the highest death per population

SELECT Location, MAX(cast (total_deaths as int)) as TotalDeathCount
FROM  [portfolio project].[dbo].[CovidDeaths]
--WHERE location like 'nigeria'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- Showing the continents with the highest death count per population

SELECT continent, MAX(cast (total_deaths as int)) as TotalDeathCount
FROM  [portfolio project].[dbo].[CovidDeaths]
--WHERE location like 'nigeria'
WHERE continent is  not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_death , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM  [portfolio project].[dbo].[CovidDeaths]
-- WHERE location like 'nigeria'
WHERE continent is not null
-- Group by date
ORDER BY 1,2


-- Covid vaccination table
SELECT *
FROM [portfolio project].[dbo].[CovidVaccinations]
ORDER BY 3,4

-- looking at total application vs vaccination
SELECT 
    dea.continent, 
    dea.location, 
    dea.date,
    dea.population, 
    vac.new_vaccinations,
    -- Use bigint to avoid arithmetic overflow
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (
        Partition by dea.location 
        Order by dea.Date
    ) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedperpopulation 
FROM [portfolio project].[dbo].[CovidDeaths] as dea
JOIN [portfolio project].[dbo].[CovidVaccinations] as vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT 
    dea.continent, 
    dea.location, 
    dea.date,
    dea.population, 
    vac.new_vaccinations,
    -- Use bigint to avoid arithmetic overflow
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (
        Partition by dea.location 
        Order by dea.Date
    ) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedperpopulation 
FROM [portfolio project].[dbo].[CovidDeaths] as dea
JOIN [portfolio project].[dbo].[CovidVaccinations] as vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3
)
Select *,(RollingPeopleVaccinated/Population)*100 as PercentVaccinated
From PopvsVac

--TEMP TABLE 

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent  nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

SELECT 
    dea.continent, 
    dea.location, 
    dea.date,
    dea.population, 
    vac.new_vaccinations,
    -- Use bigint to avoid arithmetic overflow
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (
        Partition by dea.location 
        Order by dea.Date
    ) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedperpopulation 
FROM [portfolio project].[dbo].[CovidDeaths] as dea
JOIN [portfolio project].[dbo].[CovidVaccinations] as vac
    ON dea.location = vac.location
    AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3

Select *,(RollingPeopleVaccinated/Population)*100 as PercentVaccinated
From #PercentPopulationVaccinated

-- Creating view to store datat for later visualizations
Create View PercentPopulationVaccinated as

SELECT 
    dea.continent, 
    dea.location, 
    dea.date,
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (
        Partition by dea.location 
        Order by dea.Date
    ) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedperpopulation 
FROM [portfolio project].[dbo].[CovidDeaths] as dea
JOIN [portfolio project].[dbo].[CovidVaccinations] as vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

Select *
From PercentPopulationVaccinated