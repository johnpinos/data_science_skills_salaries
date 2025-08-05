/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Scientist roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data scientist
*/

-- CTE 1: Count the number of posts per skill (Reuse query 3)
WITH skills_demand AS( 
  SELECT 
    sj.skill_id,
    s.skills,
    COUNT(sj.job_id) AS demand_count
  FROM job_postings_fact jp
  INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
  INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
  WHERE
    job_title_short = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
  GROUP BY sj.skill_id, s.skills
), 
-- CTE 2: Calculate the average annual salary by skill (Reuse query 4)
average_salary AS( 
  SELECT 
    sj.skill_id,
    s.skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
  FROM job_postings_fact jp
  INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
  INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
  WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
  GROUP BY sj.skill_id, s.skills
)
-- Main consultation: demonstrates skills that are in high demand and well paid.
SELECT 
  skills_demand.skill_id,
  skills_demand.skills,
  demand_count,
  avg_salary
FROM
  skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
  demand_count > 10 -- Filter skills with sufficient volume
ORDER BY
  demand_count DESC, -- Prioritize by demand
  avg_salary DESC -- Then by salary
LIMIT 10; -- Show the top 10

/*
Results:
[
  {
    "skill_id": 1,
    "skills": "python",
    "demand_count": "763",
    "avg_salary": "143828"
  },
  {
    "skill_id": 0,
    "skills": "sql",
    "demand_count": "591",
    "avg_salary": "142833"
  },
  {
    "skill_id": 5,
    "skills": "r",
    "demand_count": "394",
    "avg_salary": "137885"
  },
  {
    "skill_id": 182,
    "skills": "tableau",
    "demand_count": "219",
    "avg_salary": "146970"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "demand_count": "217",
    "avg_salary": "149630"
  },
  {
    "skill_id": 92,
    "skills": "spark",
    "demand_count": "149",
    "avg_salary": "150188"
  },
  {
    "skill_id": 99,
    "skills": "tensorflow",
    "demand_count": "126",
    "avg_salary": "151536"
  },
  {
    "skill_id": 74,
    "skills": "azure",
    "demand_count": "122",
    "avg_salary": "142306"
  },
  {
    "skill_id": 101,
    "skills": "pytorch",
    "demand_count": "115",
    "avg_salary": "152603"
  },
  {
    "skill_id": 93,
    "skills": "pandas",
    "demand_count": "113",
    "avg_salary": "144816"
  }
]
*/