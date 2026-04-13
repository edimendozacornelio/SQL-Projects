select 
    jobs.company_id,
    jobs.job_id,
    companies.name,
    jobs.job_health_insurance,
    extract (quarter from jobs.job_posted_date) as quarter,
    extract (year from jobs.job_posted_date) as year
from job_postings_fact as jobs
inner join company_dim as companies 
    on jobs.company_id = companies.company_id
where jobs.job_health_insurance = TRUE AND
    extract (quarter from jobs.job_posted_date) = 2 AND
    extract (year from jobs.job_posted_date) = 2023
limit 100;