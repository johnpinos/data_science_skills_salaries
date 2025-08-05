# Strategic Analysis of Data Science Skills and Salaries
## Introduction
📊This project analyzes 💰 the highest paying jobs, 🔥 the most in-demand skills, and the intersection between the two factors in the field of data science.

🔍 SQL queries? Check out the corresponding repository here [project_sql folder](/project_sql/)

## Context
The objective of this analysis is to identify which technical skills offer the highest return in terms of salary and demand within the data science field, in order to support strategic decisions in professional development.

The data used is from Luke Barousse's [SQL Course](https://lukebarousse.com/sql) and has been adapted to focus specifically on Data Scientist roles.

### Key Questions
The SQL queries developed in this project aim to answer the following core questions:

1. What are the highest-paying Data Scientist positions?
2. What skills are required for these top-paying roles?
3. Which competencies are most in demand for Data Scientists today?
4. Which skills are associated with the highest average salaries?
5. Which skills are most strategic when considering both demand and compensation?

## Tools Used
To efficiently and systematically analyze the data science job market, the following tools were employed:

- **SQL:** The primary language for extracting, transforming, and analyzing job posting data.
- **PostgreSQL:** The database management system selected for its robustness, reliability, and widespread adoption in professional environments.
- **Visual Studio Code:** The development environment used to write and execute SQL queries, offering flexibility and strong extension support.
- **Git and GitHub:** Essential tools for version control, project documentation, and publishing the analysis in an organized and transparent manner.

## Analysis
Each of the questions posed in this project is intended to examine key aspects of the data science job market. Below is a breakdown of the approach used to address each of them:

### 1. Highest-Paid Data Scientist Positions
The top 10 highest-paying remote job positions for the role of *Data Scientist* were identified, considering only those listings that specify an annual salary.

```sql
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
```
Below is a breakdown of the highest-paying remote Data Scientist positions in 2023.
- **Salary range:** Between $300,000 and $550,000 USD per year.
- **Top companies:** Selby Jennings leads with two positions exceeding $500,000. Other notable companies include Algo Capital Group, Demandbase, Walmart, and Reddit.
- **Role diversity:** Positions range from *Staff Data Scientist* to *Director* and *Head of Data Science*, reflecting a broad spectrum of levels and specializations within the field.

![Top Paying Roles][assets\1_top_paying_data_roles.png] 
*Bar graph visualizing the salary for the top 10 salaries for data scientist; ChatGPT generated this graph from my SQL query results*

 ### 2. Skills Required in the Highest-Paying Data Scientist Jobs
To identify the key skills, I analyzed the 10 Data Scientist vacancies with the highest average salaries and extracted the competencies required in each.

```sql
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
```
Below is a breakdown of the most in-demand skills found in the top 10 highest-paying data scientist job postings in 2023.

- **Python** tops the list with 5 mentions, followed by SQL with 4.
- **Java** and **AWS** appear in 3 job postings each.
- **Big Data** technology such as Apache Spark, and cloud platforms like Google Cloud Platform (GCP), are each mentioned in 2 postings.
- In terms of **machine learning frameworks**, both **TensorFlow** and **PyTorch** are included in 2 job descriptions.
- Other relevant tools include **DataRobot** and **Scala**, each appearing once.

![Top Paying Skills][assets\2_top_paying_data_roles_skills.png]
*Bar graph visualizing the count of skills for the top 10 paying jobs for data scientist; ChatGPT generated this graph from my SQL query results*

### 3. Most In-Demand Skills for Data Scientists
To identify the most sought-after competencies in the job market, I analyzed all remote Data Scientist job postings. Based on this analysis, I extracted the five most frequent skills, providing insight into which tools and languages have the greatest practical value today.

```sql
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
```

Below is a breakdown of the most in-demand skills for data scientists in 2023.
- **Python** leads the ranking with 10,390 mentions, establishing itself as the essential tool in data science.
- **SQL** holds second place with 7,488 appearances, confirming its central role in data manipulation and extraction.
- **R** remains relevant with 4,674 mentions, being especially important for advanced statistical analysis.
- **AWS** stands out with 2,593 mentions, reflecting the growing demand for cloud infrastructure knowledge.
- **Tableau**, with 2,458 mentions, highlights the importance of data visualization for effective communication of results.

| Skills    | Demand Count |
|-----------|--------------|
| python    | 10,390       |
| sql       | 7,488        |
| r         | 4,674        |
| aws       | 2,593        |
| tableau   | 2,458        |

*Table of the demand for the top 5 skills in data scientist job postings*

### 4. Skills Based on Salary
The analysis of average salaries associated with different skills revealed which ones are the highest-paying for remote data scientists.

```sql
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
```
Below is a breakdown of the highest-paying skills for data scientists:
- **Experience in data privacy and compliance:** Skills such as GDPR lead with the highest salaries, reflecting the growing industry demand for knowledge in regulation and data protection.
- **Advanced programming and systems skills:** Languages and tools like Golang and OpenCV are highly valued, indicating high compensation for those proficient in backend development and computer vision.
- **Automation and project management tools:** Tools such as Selenium and the Atlassian suite (Jira, Confluence) are associated with higher salaries, emphasizing the value of automation and efficient workflow management in data science roles.

| Skills        | Average Salary      |
|---------------|---------------------|
| gdpr          | $217,738            |
| golang        | $208,750            |
| atlassian     | $189,700            |
| selenium      | $180,000            |
| opencv        | $172,500            |
| neo4j         | $171,655            |
| microstrategy | $171,147            |
| dynamodb      | $169,670            |
| php           | $168,125            |
| tidyverse     | $165,513            |

*Table of the average salary for the top 10 paying skills for data scientist*

### 5. Optimal Skills: High Demand and High Salary
This analysis identifies the most strategic skills for data scientists by combining two key criteria: high job demand and high average salary. The study focused exclusively on remote jobs with specified compensation

```sql
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
```
Below is a breakdown of the optimal skills for data scientists that combine high demand and high salary:

- **Python** stands out as the most in-demand skill (763 mentions) with a competitive average salary of $143,828, solidifying its status as the essential language in data science.
- **SQL** also shows very high demand (591 mentions) and a strong average salary of $142,833, making it a key tool for database manipulation.
- **R** maintains a considerable presence (394 mentions) with a solid average salary of $137,885, proving useful for advanced statistical analysis.
- **Tableau**, although less in demand (219 mentions), offers an above-average salary ($146,970), making it a valuable tool for data visualization.
- **AWS and Azure**, the leading cloud platforms, show a combination of good demand (217 and 122 mentions, respectively) and high salaries, especially AWS with an average of $149,630, reflecting its importance in modern data environments.
- **Spark**, with 149 mentions and an average salary of $150,188, is a well-paid technology focused on processing large volumes of data.
- **TensorFlow and PyTorch**, two leading machine learning frameworks, combine high salaries ($151,536 and $152,603, respectively) with solid technical demand (126 and 115 mentions), positioning themselves as key tools in predictive model development.
- **Pandas**, while more modest in demand (113 mentions), offers a competitive salary of $144,816 and is essential for data analysis in Python.

| Skills      | Demand Count | Average Salary    |
|-------------|--------------|-------------------|
| Python      | 763          | $143,828          |
| SQL         | 591          | $142,833          |
| R           | 394          | $137,885          |
| Tableau     | 219          | $146,970          |
| AWS         | 217          | $149,630          |
| Spark       | 149          | $150,188          |
| TensorFlow  | 126          | $151,536          |
| Azure       | 122          | $142,306          |
| PyTorch     | 115          | $152,603          |
| Pandas      | 113          | $144,816          |

*Table of the most optimal skills for data scientist sorted by salary*

## Conclusions
This project enabled the extraction of key insights about the data science job market, with a particular focus on remote positions. Based on the analysis, the following conclusions stand out:

1. **Demand vs. compensation:** Not all high-demand skills are the highest paid. Some, although less popular, offer high profitability.
2. **Essential languages:** Python is established as the indispensable language. SQL remains relevant in nearly every job posting.
3.  **Emerging trends:** Cloud infrastructure, data orchestration, and automation are rising in both demand and salary.
4. **Technical specialization:** Mastering specific technical tools can open opportunities in better-paid and less competitive roles.
5. **Strategic recommendation:** It is advisable to combine widely used skills (Python, SQL) with high-value specializations (cloud, machine learning, automation).

This analysis provides an objective and actionable foundation for planning a professional development path in data science.

## What I Learned
Throughout this project, I strengthened my data analysis skills using SQL, focusing on real-world labor market scenarios:

- 🧠 **Advanced queries:** Use of CTEs, subqueries, and multiple JOIN operations to build complex and modular analyses.
- 📊 **Grouping and aggregation:** Application of functions like COUNT(), AVG(), ROUND(), and GROUP BY.
- 🔍 **Applied analytical thinking:** Ability to translate strategic questions into precise SQL queries.
- 📈 **Data-driven interpretation:** Critical identification of patterns and trends relevant to decision-making.

[assets\1_top_paying_data_roles.png]: assets\1_top_paying_data_roles.png
[assets\2_top_paying_data_roles_skills.png]: assets\2_top_paying_data_roles_skills.png