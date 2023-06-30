select *
from CovidDeaths$
order by 3,4




--select *
--from CovidVaccinations$
--order by 3,4


-- select data that we are going to using

--select location, date, total_cases, new_cases, total_deaths, population
--from CovidDeaths$
--order by 1,2



select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from CovidDeaths$
order by 1,2



select location, date, population, total_cases, (total_cases/population)*100 as popualation_percentage
from CovidDeaths$
where location like 'Egypt'
order by 1,2



select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as percentagePoulationInfected
from CovidDeaths$
--where location like 'Egypt'
group by location , population
order by percentagePoulationInfected desc



--Highest death count
select location, Max(cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths$
--where location like 'Egypt'
where continent is null
group by location
order by TotalDeathCount desc


-- Global Numbers


select Sum(new_cases)as totalCases, SUM(cast (new_Deaths as int)) as totalDeaths, SUM(cast (new_deaths as int))/SUM(cast (total_cases as int))*100 as DeathPercentage
from CovidDeaths$
--where location like 'Egypt'
where continent is not null
--Group by date
order by 1,2



select *
from CovidDeaths$ dea
join CovidVaccinations$ vas
    on dea.location = vas.location
	and dea.date = vas.date

	--Looking at total popuation VS total Vaccinations
select dea.continent, dea.date , dea.location, dea.population, vas.new_vaccinations
 , sum(Convert(int,vas.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccienated
 , (RollingPeopleVaccienated/population)*100
From CovidDeaths$ dea
join CovidVaccinations$ vas
    on dea.location = vas.location
	and dea.date = vas.date
where dea.continent is not null
order by 2,3





with PopvsVac (continent, location, Date, Population, new_vaccinations, RollingPeopleVaccienate)
as 
(
 select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
  dea.date) as RollingPeopleVaccienated
 FROM PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
)
select *, (RollingPeopleVaccienate/Population)*100
from PopvsVac







--Temp table
drop table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(
continent nvarchar(225),
Location nvarchar(225),
Date datetime,
population numeric,
New_Vaccinations numeric,
RollingPeopleVaccienated numeric
)

insert into #percentPopulationVaccinated
	select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
  dea.date) as RollingPeopleVaccienated
 FROM PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 select *, (RollingPeopleVaccienated/Population)*100
from #percentPopulationVaccinated



-- create view to store data for later visualization

create view percentPopulationVaccinated as
 select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
  dea.date) as RollingPeopleVaccienated
 FROM PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3



 Select *
 from percentPopulationVaccinated