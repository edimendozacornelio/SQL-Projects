# Introduction
This project explores the most important job positions for Data Analysts. Classifying them based on the skills most requiered and top payed for the role.

To see the queries used for this analysis you can check them out here: [sql_excercises foler](/sql_excercises/)

# Background
This project arose from an interest in applying the knowledge gained in Data Analysis to identify the most rewarding roles in this field, those offering the best balance between desired salary and the skills required and in demand.

### The specific questions this project seeks to answer are:
- What are the highest-paying jobs for Data Analysts?
- What skills are required for these positions?
- Which skills are the highest-paying for these positions?
- Which skills are in highest demand?
- Which of these skills are the best to learn?

# Tools Used
Throughout the project, various powerful tools were used for data analysis:
- **SQL**: Primarily used for data manipulation by running queries that subsequently provided the insights presented here.
- **PostgreSQL**: Used to manage the database selected for the analysis
- **Visual Studio Code**: Used for database management and running queries
- **Git and GitHub**: Essential tools for publishing, analyzing results and insights, and tracking the project for future collaborations.
# Analysis
The queries used in the project focused on answering the questions posed above. Below is a detailed description of how each one was approached:

### 1. Top Paying Data Analyst jobs
The analysis was conducted by filtering the results based on the highest-paying jobs, as well as location, taking into account job postings that offer remote work options. The query used for the analysis is shown below:

```sql
select 
    jp.job_id,
    jp.job_title,
    cd.name as company_name,
    jp.job_schedule_type,
    jp.salary_year_avg,
    jp.job_posted_date
from 
    job_postings_fact as jp
left join 
    company_dim as cd ON
    jp.company_id = cd.company_id
where 
    job_title_short = 'Data Analyst' AND 
    job_work_from_home = TRUE and 
    salary_year_avg is NOT NULL
order by 
    salary_year_avg desc
limit 10

```

The data shows the highest salaries for the position of Data Analyst in 2023; below is a more detailed analysis of the findings:

|Annual Salary (USD)	|Position
|-----------------------|----------------------------
|$650,000 	            |Data Analyst
|$336,500 	            |Director of Analytics
|$255,830 	            |Associate Director - Data Insights
|$232,423 	            |Data Analyst, Marketing
|$217,000 	            |Data Analyst (Hybrid/Remote)
|$205,000 	            |Principal Data Analyst (Remote)
|$189,309 	            |Director, Data Analyst

- **Salary Overview**
    - Average salary: $264,506 per year
    - Minimum salary: $184,000
    - Maximum salary: $650,000
- **Salary Distribution**
75% of jobs pay less than ~$250,000
Only a few roles significantly exceed that range (outliers)
There is a difference of more than $460,000 between the minimum and maximum


### 2. Skills requiered for the Top Paying Data Analyst jobs
Two joins were added to the previous query with the supplementary databases “skills_dim” and “skills_job_dim,” which contained data on the skills required for each of the job postings listed in the main database. The query used is shown below:
 
```sql
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
```

The dataset shows the 10 highest-paying Data Analyst jobs along with the required skills.

The highest-paying roles combine data analysis + light engineering + knowledge of modern tools:

![Top Paying Roles](assets\Skills_in_high_paying_jobs_DA.png)


**What stands out visually:**
- SQL is present in 8 out of 10 jobs
- Python is present in 7 out of 10 jobs 
- Tableau appears in 6 out of 10 jobs

**All the highest-paying roles combine:**
- data extraction and manipulation (SQL)
- advanced analysis / automation (Python)
- Visualization tools (Tableu and Power BI)

### 3. Top skills in-demand for Data Analysts

The most sought-after skills for the position were analyzed; the query used was as follows:
```sql
select count (sj.job_id) as times_demanded, sd.skills
from job_postings_fact as jp
inner join skills_job_dim as sj on jp.job_id = sj.job_id
inner join skills_dim as sd on sj.skill_id = sd.skill_id
where jp.job_title_short = 'Data Analyst'
group by sd.skills
order by times_demanded desc
limit 5
```
The table shows the key skills companies require in data analysts; below is a breakdown of the information:

|Skills	    |Times Demanded
------------|--------------
|sql	    |92628
|excel	    |67031
|python	    |57326
|tableau    |46554
|power bi   |39468


- SQL tops the list with over 92,000 mentions

- Excel follows closely behind with just over 67,000

- Python (57,326), Tableau (46,554), and Power BI (39,468) round out the list 

### 4. Top skills for Data Analysts based on salary

We also looked for the skills associated with the highest average annual income; the query used to obtain this data was as follows:
```sql
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
```
|Average Salary (USD)	|Skills
|-----------------------|--------------
|208172	                |pyspark
|189155	                |bitbucket
|160515	                |watson
|160515	                |couchbase
|155486	                |datarobot
|154500	                |gitlab
|153750	                |swift
|152777	                |jupyter
|151821	                |pandas
|145000	                |elasticsearch


The data reveals that the highest salaries are concentrated in three specific technology niches:

-  PySpark tops the list with an average salary of $208,172

- Following we have tools such as Bitbucket ($189k) and GitLab ($154k)

- AI and Applied Data Science tools like Watson (IBM), DataRobot, and libraries like Pandas complete the list.

### 5. Top optimal skills (more demand + highest payed) for Data Analysts
Finally, we analyzed the skills most commonly found in data analyst positions, combined with those that offer the highest annual salaries. The query used is as follows:
```sql
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
```
|Skill ID   |Skills	    |Times Demanded	|Average Salary (USD)
|-----------|-----------|---------------|---------------------
|8	        |go	        |27	            |115320
|234	    |confluence	|11	            |114210
|97	        |hadoop	    |22	            |113193
|80	        |snowflake	|37	            |112948
|74	        |azure	    |34	            |111225
|77	        |bigquery	|13	            |109654
|76	        |aws	    |32	            |108317
|4	        |java	    |17	            |106906
|194	    |ssis	    |12	            |106683
|233	    |jira	    |20	            |104918



- Cloud Expertise tools like Snowflake ($112k), Azure ($111k), and AWS ($108k) show strong demand (37, 34 and 32 respectively).

- Python stands out with great demand (236 mentions) while maintaining an average salary of $101,397.

- Looker ($103k) and Tableau ($99k) are also present in the list.

**Key Insight:** 

The Cloud Ecosystem Is the Key Differentiator.
True value lies not only in knowing how to analyze data (using Python or R), but also in knowing where the data resides.
Getting certified in a cloud data warehouse platform is what raises your salary ceiling above $110,000 in the job market

# Knowledge learnt
### Building Complex Queries
I gained greater proficiency in using SQL and it's different sentences, operators, and clauses. Also gained expertise working and manipulating tables using subqueries and CTEs, and joining them using JOINs and UNION.
### Data Aggregation
Additionally, I was able to refine my use of queries focused on data aggregation using GROUP BY, COUNT(), and AVG()
### Analytical Skills
I was able to develop my ability to transform questions into results, and then convert those results into useful insights to guide future actions.
# Insights found
1. **Top Paying Data Analyst jobs:**

    There is a very high outlier (~$650k) that skews the average
    The median ($211k) better reflects the actual market
    Higher salaries are more closely related to:
    - Experience
    - Specialization
    - Business impact
2. Skills requiered for the Top Paying Data Analyst jobs:

    SQL appears in 8 out of 10 jobs, with 
    Python (7 out of 10 jobs) and Tableau (6 out of 10 jobs) following. We can say that these are the "Core" skills for the business.

    Although this "core" skills appear for almost every job, complementary skills appear almost twice as often in general.

    Which leads to the conclussion that salary increases when you upgrade from “analyzing data” to becoming part of the entire data ecosystem. To achieve this, you need to:

    - Perfect your core skills with solid knowledge
    - Then, focus on a path toward specializing in your role as a Data Analyst and acquire the complementary skills required for it.
3. Top skills in-demand for Data Analysts:

    - Data Language (SQL): Is the undisputed top skill. It is not optional; it is the standard for extracting and manipulating data.

    - Management Tools (Excel): It continues to be the preferred software for quick analysis, financial reporting, and data cleaning.

    - Visualization and Programming: The ability to automate (Python) and tell stories with data (Tableau/Power BI) are key competitive differentiators.


4. Top skills for Data Analysts based on salary:

    - PySpark toping the list indicates that the ability to handle massive volumes of data is the highest-paying skill in the market.
   - Tools like Bitbucket  and GitLab rank surprisingly high, suggesting that companies pay a premium for analysts who know how to integrate their work into professional development workflows.

    - The presence of Watson, DataRobot, and Pandas confirms that the transition from descriptive to predictive analytics (Machine Learning) skyrockets a professional’s value.

5. Top optimal skills (more demand + highest payed) for Data Analysts:

    - The presence of Snowflake, Azure, and AWS as highly optimal skills show how moving data to the cloud is a corporate priority that pays well.

    - Versatile Programming Languages like Python stands out with massive demand and great salary. It strikes the perfect balance between employability and pay.

    - Advanced Visualization tools like Tableau and Looker are also classified as very optimal skills to learn. Confirming that the ability to create complex, functional dashboards remains a cornerstone of high-value data analysis.

# Closing
This project has been very helpful in demonstrating the data analysis skills I’ve acquired, as well as in applying those skills to my job search by prioritizing the ones I need to land those positions. I believe it’s important to understand the needs of the market, which is becoming increasingly complex and growing at a rapid pace. In such a dynamic and increasingly demanding environment, staying up to date on new trends and tools can make a big difference.