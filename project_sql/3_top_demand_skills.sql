/* 
Question: What are the most in-demand skills for data scientist?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data scientist.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/

SELECT 
  skills,
  COUNT(sj.job_id) AS demand_count -- Frequency of the skill in offers
FROM job_postings_fact jp
-- Match each job offer with the required skills.
INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE
  job_title_short = 'Data Scientist' --Data scientist positions
  AND job_work_from_home = True  --Remote work only
GROUP BY
  skills
ORDER BY
  demand_count DESC --Sort by skill demand
LIMIT 5; -- Show the Top 5

/*
Results:
[
  {
    "skills": "python",
    "demand_count": "10390"
  },
  {
    "skills": "sql",
    "demand_count": "7488"
  },
  {
    "skills": "r",
    "demand_count": "4674"
  },
  {
    "skills": "aws",
    "demand_count": "2593"
  },
  {
    "skills": "tableau",
    "demand_count": "2458"
  }
]
*/