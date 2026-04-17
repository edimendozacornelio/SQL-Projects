

with cte as (
    select 
        jp.job_id,
        jp.job_title,
        cd.name as company_name,
        jp.salary_year_avg

    from job_postings_fact as jp
    left join 
        company_dim as cd ON
        jp.company_id = cd.company_id
    where 
        job_title_short = 'Data Analyst' AND 
        job_work_from_home = TRUE and 
        salary_year_avg is NOT NULL
    order by salary_year_avg desc
    limit 10
)
select 
    cte.*,
    sd.skills
from cte
inner join skills_job_dim as sj on cte.job_id = sj.job_id
inner join skills_dim as sd on sj.skill_id = sd.skill_id
order by cte.salary_year_avg DESC