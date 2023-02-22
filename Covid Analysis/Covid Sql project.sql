select * from CovidDeaths
where continent is not null
ORDER BY 3,4

--selecting data
select location,date,total_cases,new_cases,total_deaths,
population 
from CovidDeaths
where continent is not null
ORDER BY 1,2 

--Looking at total cases v/s total deaths
--shows likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like 'india%'
and continent is not null
ORDER BY 1,2 

--Looking at the total cases v/s population
--shows what % of popultion got Covid

select location,date,total_cases,population,
(total_cases/population)*100 as infectedPecentage
from CovidDeaths
where location like 'india%' 
and continent is not null
ORDER BY 1,2 


--looking at countries with highest infected rate compared to population
select location,population,max(total_cases) HighestInfectionCount, 
max((total_cases/population))*100 
as PercentPopulationInfected
from CovidDeaths
--where location like 'india%' 
where continent is not null
group by location,population
ORDER BY PercentPopulationInfected DESC

---showing countries with the highest death count per population
select location, max(cast(total_deaths as int)) TotalDeathCount
from CovidDeaths
--where location like 'india%'
where continent is not null
group by location
ORDER BY TotalDeathCount desc

--LET'S BREAK THINGS BY CONTINENT
select location, max(cast(total_deaths as int)) TotalDeathCount
from CovidDeaths
--where location like 'india%'
where continent is null 
--irregularity in data that's why continent is null statement used 
and location not in ('High income','Upper middle income','Lower middle income','Low income')
group by location
ORDER BY TotalDeathCount desc

--showing continent with highest death count per population
select continent, max(cast(total_deaths as int)) TotalDeathCount
from CovidDeaths
--where location like 'india%'
where continent is not null
group by continent
ORDER BY TotalDeathCount desc

--global numbers
select SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
from CovidDeaths
where continent is not null
--group by date
ORDER BY 1,2 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) TotalVaccinatedPeople
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
order by 2,3


-- use cte
with PopvsVac (continent,location,date,population,new_vaccinations,TotalVaccinatedPeople)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) TotalVaccinatedPeople
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
select*,(TotalVaccinatedPeople/population)*100 as TotVaccPercent
from PopvsVac

--death vs pop using cte clause
with PopvsDea (continent,location,date,population,new_deaths,TotalDeaths)
as
(
select continent,location,date,population,new_deaths
,sum(CONVERT(bigint,new_deaths)) over ( order by location,date) as TotalDeaths
from CovidDeaths
where continent is not null
--ORDER BY  2,3
)
select*,(TotalDeaths/population)*100 as TotDeathPercent
from PopvsDea


--TEMP TABLE
drop table if exists #PercentPopulationVaccinated
create table  #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
TotalVaccinatedPeople numeric,
)


insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) TotalVaccinatedPeople
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
select*,(TotalVaccinatedPeople/population)*100 as TotVaccPercent
from #PercentPopulationVaccinated

--creating view to store data for later visualization

Create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) TotalVaccinatedPeople
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 

-- view
select * from PercentPopulationVaccinated
