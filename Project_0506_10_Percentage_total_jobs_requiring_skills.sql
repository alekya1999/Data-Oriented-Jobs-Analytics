---2)What are the percentage of total job requiring skills by job function?
SELECT a.sklName AS 'Skill Name',a.jobFunction AS 'Job Function',
	   CONCAT(CAST(ROUND((CAST(jobcountskillfunction AS FLOAT)/CAST(Jobcounttotal AS FLOAT)) * 100,2) AS VARCHAR),'%') AS 'Skill demand (in %)'
FROM
	(
	SELECT DISTINCT s.sklName,j.jobFunction, COUNT(j.jobId) OVER(PARTITION BY s.sklId, j.jobFunction) AS 'jobcountskillfunction',
	                a.Jobcounttotal
	FROM [PerfectAnalyst.Job] j , [PerfectAnalyst.Skill] s , [PerfectAnalyst.Require] r , 
		(
		SELECT j.jobFunction ,COUNT(j.jobId)as 'Jobcounttotal'
		FROM [PerfectAnalyst.Job] j 
		GROUP BY j.jobFunction
		) a
	WHERE j.jobid = r.jobid and s.sklId = r.sklId and a.jobFunction = j.jobFunction
) a
ORDER BY a.jobFunction , a.sklName