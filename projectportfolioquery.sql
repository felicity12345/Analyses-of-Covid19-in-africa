
select *
from projectportfolio.dbo.['owid-covid-data$']
order by 3,4

-- Here we order the results in ascending order based on the values in the 'location' column  and 'date' column.

select  location, date,total_cases, new_cases,new_deaths, total_deaths, population
from projectportfolio.dbo.['owid-covid-data$']
order by  location, date desc


-- Here we look at the total cases vs the total deaths and the percentage deaths when you contact Covid 19 in this africa

select  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As 'death percentage'
from projectportfolio.dbo.['owid-covid-data$']
where continent like '%Africa%' 
order by  location, date desc



-- Here we look at country with the highest covid infection cases in countries in Africa and the percentage of infection

select  location, population, Max(cast(total_cases as int)) As highest_infection_count, max(total_cases/population)*100 As percentage_of_population
from projectportfolio.dbo.['owid-covid-data$']
where continent = 'Africa' 
group by location, population
order by highest_infection_count desc



-- Here we look at country with the highest covid dealth cases in countries in Africa and the percentage of infection

select  location, population, Max(cast(total_deaths as int)) As highest_deaths_count, max(total_deaths/population)*100 As percentage_of_population
from projectportfolio.dbo.['owid-covid-data$']
where continent = 'Africa' 
group by  location, population
order by  highest_deaths_count desc



 -- Here we calculate the total number of cases, Total deaths, and the percentage of covid in entire Afraca 

 select sum(new_cases) As Total_cases, sum(cast(new_deaths as int)) As Total_deaths, sum(cast
 (new_deaths As int))/ sum(new_cases)*100 AS Death_percentage
from projectportfolio.dbo.['owid-covid-data$']
where continent like '%Africa%' 
order by Total_cases, Total_deaths


                                   
							

--Total population vs vaccination for covid in Africa

select continent, location, date, population, new_vaccinations,
sum(cast(new_vaccinations as int)) over (partition by location order by location, date) As People_vaccinated
from projectportfolio.dbo.['owid-covid-data$']
where continent like '%Africa%'  
order by new_vaccinations, people_vaccinated 


--using CTE to make the query more readable
with populationvsvaccination( continent, location, date, population, new_vaccinations, people_vaccinated)
as
(
select continent, location, date,population, new_vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by location order by location, date) As People_vaccinated
from projectportfolio.dbo.['owid-covid-data$']
where continent like '%Africa%' and location = 'Nigeria'
)
select *, (people_vaccinated/population)*100 As percentage_vaccinated
from populationvsvaccination



-- Using Temp Table
drop Table if exists #percentpopulationvaccinated
create Table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
people_vaccinated numeric
)

insert into #percentpopulationvaccinated
select continent, location, date,population, new_vaccinations,
sum(cast(new_vaccinations as int)) over (partition by location order by location, date) As People_vaccinated
from projectportfolio.dbo.['owid-covid-data$']
where continent like '%Africa%' and location = 'Nigeria' 

select *, (people_vaccinated/population)*100 As percentage_vaccinated
from #percentpopulationvaccinated



 -- Here we calculate the country with the highest number of vaccination and their percentage in Afraca for covid 19

select  location, population, Max(cast(total_vaccinations as int)) As highest_vaccination_count, max(total_vaccinations/population)*100 As percentage_of_population
from projectportfolio.dbo.['owid-covid-data$']
where continent = 'Africa' 
group by  location, population 
order by highest_vaccination_count desc




 -- Here we calculate persons with fully vaccination and their percentage with country by country in Afraca for covid 19

select  location, population, Max(cast(people_fully_vaccinated as int)) As Fully_vaccinated_persons, max(people_fully_vaccinated/population)*100 As percentage_of_population
from projectportfolio.dbo.['owid-covid-data$']
where continent = 'Africa' 
group by  location, population 
order by Fully_vaccinated_persons desc



--Creating view to store data for visualisation

--create view percentpopulationvaccinated as
--select continent, location, date,population, new_vaccinations,
--sum(cast(new_vaccinations as int)) over (partition by location order by location, date) As People_vaccinated
--from projectportfolio.dbo.['owid-covid-data$']
--where continent like '%Africa%'  

select *
from percentpopulationvaccinated



