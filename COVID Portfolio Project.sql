-- SQL QUERIES FOR DASHBOARD VISUALISATIONS IN TABLEAU


-- Used to find total cases vs total deaths, calculated into a percentage.
SELECT SUM(new_cases) AS total_cases
		,SUM(CAST(new_deaths AS INT)) AS total_deaths
		,SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%aus%'
WHERE continent IS NOT NULL 
--GROUP BY date
ORDER BY 1,2


-- Used to count total deaths grouped by location(continent).
SELECT location
		,SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%aus%'
WHERE continent IS NULL 
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC




-- Used to find total population vs max infection count, calculated into a percentage grouped by location and population.
SELECT Location
		,Population
		,MAX(total_cases) AS HighestInfectionCount
		,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%aus%'
GROUP BY Location
		,Population
ORDER BY PercentPopulationInfected DESC




-- Used to find highest percent of infected population grouped by location, population and date, sorted descending order.
SELECT Location
		,Population
		,date
		,MAX(total_cases) AS HighestInfectionCount
		,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%aus%'
GROUP BY Location
		,Population
		,date
ORDER BY PercentPopulationInfected DESC