select 
    jp.job_id,
    jp.job_title,
    cd.name as company_name,
    jp.job_schedule_type,
    jp.salary_year_avg,
    jp.job_posted_date

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