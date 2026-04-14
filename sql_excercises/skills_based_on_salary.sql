select round (avg(jp.salary_year_avg), 0) as avg_salary, sd.skills
from job_postings_fact as jp
inner join skills_job_dim as sj on jp.job_id = sj.job_id
inner join skills_dim as sd on sj.skill_id = sd.skill_id
where jp.job_title_short = 'Data Analyst'
    and jp.salary_year_avg is not null
    and jp.job_work_from_home = TRUE
group by sd.skills
order by avg_salary desc
limit 10