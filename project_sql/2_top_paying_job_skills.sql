/*
Question: What skills are required for the top-paying data scientist jobs?
- Use the top 10 highest-paying Data Scientist jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

-- Reuse the previous logic to obtain the top 10 remote jobs
WITH top_10_jobs AS (
  SELECT
    jp.job_id,
    jp.job_title,
    c.name AS company_name,
    jp.job_location,
    jp.job_schedule_type,
    jp.salary_year_avg,
    jp.job_posted_date
  FROM (
    -- Assign ranking by job title according to annual salary (desc)
    SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY job_title
      ORDER BY salary_year_avg DESC
    ) AS rn
  FROM job_postings_fact
  WHERE
    job_title_short = 'Data Scientist'  -- Data scientist positions
    AND job_location = 'Anywhere' -- Remote work only
    AND salary_year_avg IS NOT NULL -- Ensures valid salary data
) jp
-- Join to get the company name
LEFT JOIN company_dim c ON jp.company_id = c.company_id
--Filter only the best offer by job title
WHERE rn = 1
ORDER BY salary_year_avg DESC 
LIMIT 10
)
-- Link each of the 10 jobs with their required skills.
SELECT
  t.job_id,
  t.job_title,
  t.company_name,
  t.salary_year_avg,
  s.skills
FROM top_10_jobs t
-- Match each job offer with the required skills.
INNER JOIN skills_job_dim sj ON t.job_id = sj.job_id
INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
ORDER BY t.salary_year_avg DESC, t.job_id;

/*
Results:
[
  {
    "job_id": 40145,
    "job_title": "Staff Data Scientist/Quant Researcher",
    "company_name": "Selby Jennings",
    "salary_year_avg": "550000.0",
    "skills": "sql"
  },
  {
    "job_id": 40145,
    "job_title": "Staff Data Scientist/Quant Researcher",
    "company_name": "Selby Jennings",
    "salary_year_avg": "550000.0",
    "skills": "python"
  },
  {
    "job_id": 1714768,
    "job_title": "Staff Data Scientist - Business Analytics",
    "company_name": "Selby Jennings",
    "salary_year_avg": "525000.0",
    "skills": "sql"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "sql"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "python"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "java"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "cassandra"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "spark"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "hadoop"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "salary_year_avg": "375000.0",
    "skills": "tableau"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "azure"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "aws"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "tensorflow"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "keras"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "pytorch"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "scikit-learn"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "salary_year_avg": "320000.0",
    "skills": "datarobot"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "salary_year_avg": "300000.0",
    "skills": "sql"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "salary_year_avg": "300000.0",
    "skills": "python"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "salary_year_avg": "300000.0",
    "skills": "java"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "salary_year_avg": "300000.0",
    "skills": "c"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "salary_year_avg": "300000.0",
    "skills": "aws"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "salary_year_avg": "300000.0",
    "skills": "gcp"
  },
  {
    "job_id": 129924,
    "job_title": "Director of Data Science",
    "company_name": "Storm4",
    "salary_year_avg": "300000.0",
    "skills": "python"
  },
  {
    "job_id": 129924,
    "job_title": "Director of Data Science",
    "company_name": "Storm4",
    "salary_year_avg": "300000.0",
    "skills": "pandas"
  },
  {
    "job_id": 129924,
    "job_title": "Director of Data Science",
    "company_name": "Storm4",
    "salary_year_avg": "300000.0",
    "skills": "numpy"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "salary_year_avg": "300000.0",
    "skills": "scala"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "salary_year_avg": "300000.0",
    "skills": "java"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "salary_year_avg": "300000.0",
    "skills": "spark"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "salary_year_avg": "300000.0",
    "skills": "tensorflow"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "salary_year_avg": "300000.0",
    "skills": "pytorch"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "salary_year_avg": "300000.0",
    "skills": "kubernetes"
  },
  {
    "job_id": 457991,
    "job_title": "Head of Battery Data Science",
    "company_name": "Lawrence Harvey",
    "salary_year_avg": "300000.0",
    "skills": "python"
  },
  {
    "job_id": 457991,
    "job_title": "Head of Battery Data Science",
    "company_name": "Lawrence Harvey",
    "salary_year_avg": "300000.0",
    "skills": "aws"
  },
  {
    "job_id": 457991,
    "job_title": "Head of Battery Data Science",
    "company_name": "Lawrence Harvey",
    "salary_year_avg": "300000.0",
    "skills": "gcp"
  }
]
*\