
-- Using CTEs--

with demanding_skills as (
    select sd.skill_id, count (sj.job_id) as times_demanded, sd.skills
    from job_postings_fact as jp
    inner join skills_job_dim as sj on jp.job_id = sj.job_id
    inner join skills_dim as sd on sj.skill_id = sd.skill_id
    where jp.job_title_short = 'Data Analyst'
        and jp.salary_year_avg is not null
        and jp.job_work_from_home = TRUE
    group by sd.skill_id
), salary_per_skill as (
    select sj.skill_id, round (avg(jp.salary_year_avg), 0) as avg_salary
    from job_postings_fact as jp
    inner join skills_job_dim as sj on jp.job_id = sj.job_id
    inner join skills_dim as sd on sj.skill_id = sd.skill_id
    where jp.job_title_short = 'Data Analyst'
        and jp.salary_year_avg is not null
        and jp.job_work_from_home = TRUE
    group by sj.skill_id
)
select
    demanding_skills.skill_id,
    demanding_skills.skills,
    demanding_skills.times_demanded,
    salary_per_skill.avg_salary
from demanding_skills
inner join salary_per_skill 
on demanding_skills.skill_id = salary_per_skill.skill_id
where demanding_skills.times_demanded > 10
order by 
    salary_per_skill.avg_salary desc,
    demanding_skills.times_demanded desc
limit 25

-----------------------

-- Without using CTEs--

select
    sd.skill_id,
    sd.skills,
    count(sj.job_id) as demand_count,
    round(avg(jp.salary_year_avg),0) as avg_salary
from job_postings_fact as jp
inner join skills_job_dim as sj on jp.job_id = sj.job_id
inner join skills_dim as sd on sj.skill_id = sd.skill_id
where
    jp.job_title_short = 'Data Analyst'
    and jp.salary_year_avg is not null
    and jp.job_work_from_home = TRUE
group by sd.skill_id
having count(sj.job_id) >10
order by 
    avg_salary desc,
    demand_count desc