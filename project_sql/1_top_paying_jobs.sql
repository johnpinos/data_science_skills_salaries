/*
Question: What are the top-paying data scientist jobs?
- Identify the top 10 highest-paying Data Scientist roles that are available remotely
- Focuses on job postings with specified salaries (remove nulls)
- BONUS: Include company names of top 10 roles
- Why? Highlight the top-paying opportunities for Data Scientist, offering insights into employment options and location flexibility.
*/

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
  SELECT
    *,
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
LIMIT 10;

/*
Results
[
  {
    "job_id": 40145,
    "job_title": "Staff Data Scientist/Quant Researcher",
    "company_name": "Selby Jennings",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "550000.0",
    "job_posted_date": "2023-08-16 16:05:16"
  },
  {
    "job_id": 1714768,
    "job_title": "Staff Data Scientist - Business Analytics",
    "company_name": "Selby Jennings",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "525000.0",
    "job_posted_date": "2023-09-01 19:24:02"
  },
  {
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "company_name": "Algo Capital Group",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "375000.0",
    "job_posted_date": "2023-07-31 14:05:21"
  },
  {
    "job_id": 1742633,
    "job_title": "Head of Data Science",
    "company_name": "Demandbase",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "351500.0",
    "job_posted_date": "2023-07-12 03:07:31"
  },
  {
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "company_name": "Teramind",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "320000.0",
    "job_posted_date": "2023-03-26 23:46:39"
  },
  {
    "job_id": 1161630,
    "job_title": "Director of Data Science & Analytics",
    "company_name": "Reddit",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "313000.0",
    "job_posted_date": "2023-08-23 22:03:48"
  },
  {
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "company_name": "Storm5",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "job_posted_date": "2023-11-24 14:08:44"
  },
  {
    "job_id": 129924,
    "job_title": "Director of Data Science",
    "company_name": "Storm4",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "job_posted_date": "2023-01-21 11:09:36"
  },
  {
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "company_name": "Walmart",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "job_posted_date": "2023-08-06 11:00:43"
  },
  {
    "job_id": 457991,
    "job_title": "Head of Battery Data Science",
    "company_name": "Lawrence Harvey",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "job_posted_date": "2023-10-02 16:40:07"
  }
]
*/