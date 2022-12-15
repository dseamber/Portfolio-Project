SELECT * FROM Coviddeaths
ORDER BY 3,4

--SELECT THE DATA THAT WE ARE USING 

SElECT location, date, total_cases ,total_deaths  , (total_deaths / total_cases )
from Coviddeaths order by 1,2

SELECT *  FROM Coviddeaths

--Looking at total deaths vs totalcases
SElECT location, date, total_cases ,total_deaths  , (total_deaths / total_cases )* 100 as Percentage 
from Coviddeaths where location like '%States%'
ORDER BY 1,2


-- Looking at total cases vs population
SElECT location, date, total_cases ,population  , (total_deaths / population )* 100 as Percentage 
from Coviddeaths WHERE
Location LIKE '%Afghanistan%' ORDER BY 1, 2


-- Looking at countrys highest rate infection compares to population
SELECT location ,population,  MAX(total_cases) AS HighestCount   ,  MAX ((total_cases / population ))* 100 as  Infection_Percentage 
from Coviddeaths 
--WHERE Location LIKE '%States%' 
GROUP BY location, population ORDER BY location 

-- Showing highest country death count 
SELECT location , MAX( cast (total_deaths as int)) AS HighestCount   
from Coviddeaths 
--WHERE Location LIKE '%States%' 
where continent is not null
GROUP BY location ORDER BY HighestCount desc

-- Lets break thing by Continent

-- showing the continents with highest death count

SELECT continent, MAX( cast (total_deaths as int)) AS Totaldeathscount  
from Coviddeaths 
--WHERE Location LIKE '%States%'
where continent is not null
GROUP BY continent ORDER BY Totaldeathscount desc

-- Global Numbers

SELECT  sum(new_cases) as total_cases, SUM(cast (new_deaths as float))  as total_deaths
,SUM(cast (new_deaths as float))/SUM(new_cases)*100
as Death_percentage
FROM Coviddeaths
WHERE continent is not null
--group by date
order by 1,2


-- Looking at total population vs vaccination


SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM( convert(bigint, vac.new_vaccinations  ))
OVER (Partition by dea.location ORDER BY  dea.location , dea.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM Coviddeaths dea
JOIN CovidVaccine vac
ON dea.location = vac.location
and
dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- USE CTE
WITH PopvsVac(Continent,Location,Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM( convert(bigint, vac.new_vaccinations  ))
OVER (Partition by dea.location ORDER BY  dea.location , dea.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM Coviddeaths dea
JOIN CovidVaccine vac
ON dea.location = vac.location
and
dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)

SELECT *, (RollingPeopleVaccinated/Population ) * 100  FROM PopvsVac


--  USING TEMP TABLE 

CREATE TABLE #PercentPopulationVaccinated
( continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM( convert(bigint, vac.new_vaccinations  ))
OVER (Partition by dea.location ORDER BY  dea.location , dea.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM Coviddeaths dea
JOIN CovidVaccine vac
ON dea.location = vac.location
and
dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

  SELECT *, (RollingPeopleVaccinated/Population ) * 100  FROM #PercentPopulationVaccinated

-- CREATE view to store data for later visualaization

CREATE VIEW PercentPeopleVaccinated as 
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM( convert(bigint, vac.new_vaccinations  ))
OVER (Partition by dea.location ORDER BY  dea.location , dea.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM Coviddeaths dea
JOIN CovidVaccine vac
ON dea.location = vac.location
and
dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT * FROM PercentPeopleVaccinated


CREATE VIEW Globalnumbers as
SELECT  sum(new_cases) as total_cases, SUM(cast (new_deaths as float))  as total_deaths
,SUM(cast (new_deaths as float))/SUM(new_cases)*100
as Death_percentage
FROM Coviddeaths
WHERE continent is not null
--group by date
--order by 1,2



































8












-- 


-- 


--

