/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Scientist positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Scientist and 
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
  skills,
  ROUND(AVG(salary_year_avg), 0) AS avg_salary -- Average annual salary by skill (rounded)
FROM job_postings_fact jp
-- Match each job offer with the required skills.
INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE
  job_title_short = 'Data Scientist' --Data scientist positions
  AND salary_year_avg IS NOT NULL -- Ensures valid salary data
  AND job_work_from_home = True  -- Remote work only
GROUP BY
  skills
ORDER BY
  avg_salary DESC -- Sort by average salary
LIMIT 10; -- Show the Top 10

/*
Results:
[
  {
    "skills": "gdpr",
    "avg_salary": "217738"
  },
  {
    "skills": "golang",
    "avg_salary": "208750"
  },
  {
    "skills": "atlassian",
    "avg_salary": "189700"
  },
  {
    "skills": "selenium",
    "avg_salary": "180000"
  },
  {
    "skills": "opencv",
    "avg_salary": "172500"
  },
  {
    "skills": "neo4j",
    "avg_salary": "171655"
  },
  {
    "skills": "microstrategy",
    "avg_salary": "171147"
  },
  {
    "skills": "dynamodb",
    "avg_salary": "169670"
  },
  {
    "skills": "php",
    "avg_salary": "168125"
  },
  {
    "skills": "tidyverse",
    "avg_salary": "165513"
  }
]
*/