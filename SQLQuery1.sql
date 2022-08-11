select *
From Covid19Project..CovidDeaths
where continent is not null
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid19Project..CovidDeaths
order by 1,2

-- analysing total deaths against total cases in pakistan
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From Covid19Project..CovidDeaths
Where location like '%Pakistan%'
order by 1,2

-- total cases against population in pakistan
Select Location, date, total_cases, population, (total_cases/population)*100 as percentage_of_population_affected
From Covid19Project..CovidDeaths
Where location like '%Pakistan%'
order by 1,2

--countries with highest infection rate
Select Location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as percentage_of_population_affected
From Covid19Project..CovidDeaths
Group by Location, population
order by percentage_of_population_affected desc

--countries with highest death count per population
Select Location, MAX(cast(total_deaths as int)) as deathCount
From Covid19Project..CovidDeaths
where continent is not null
Group by Location
order by deathCount desc

--analysing by continent
Select Location, MAX(cast(total_deaths as int)) as deathCount
From Covid19Project..CovidDeaths
where continent is null
Group by Location
order by deathCount desc

--continents with highest death count?????????
Select date, sum(new_cases), sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From Covid19Project..CovidDeaths
Where continent is not null
order by 1,2

--total population vs vaccinations
create Table #percentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

with popVsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
From Covid19Project..CovidDeaths dea
join Covid19Project..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (rolling_people_vaccinated/population)*100 from #percentPopulationVaccinated

--creating temporary table


