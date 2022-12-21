Select *
From [Portfolio Project]..CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From [Portfolio Project]..CovidVaccinations
--Order by 3,4
-- Select data that we are going to be using 

Select location, Date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].. CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in your country
Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project].. CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows percentage of population have got Covid
Select location, Date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project].. CovidDeaths
-- Where location like '%states%'
Order by 1,2

-- Looking at Countries with Highest infection Rate compared to population 

Select continent, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project].. CovidDeaths
-- Where location like '%states%'
Group by continent, population
Order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].. CovidDeaths
-- Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- LET'S BREAL THINGS DOWN BY CONTINENT

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].. CovidDeaths
-- Where location like '%states%'
Where continent is null
Group by continent
Order by TotalDeathCount desc

-- Showing continents with highest death counts per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project].. CovidDeaths
-- Where location like '%states%'
Where continent is null
Group by location
Order by TotalDeathCount desc

-- Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)), SUM(New_cases)*100 as DeathPercentage
From [Portfolio Project].. CovidDeaths
-- Where location like '%states%'
where continent is not null
-- Group by date
Order by 1,2

-- Looking at total population vs vaccination

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
-- Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, RollingPeopleVaccinated)
as
