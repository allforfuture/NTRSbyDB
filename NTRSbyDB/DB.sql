WITH v_proc AS(
	SELECT process_cd,proc_uuid
	FROM m_process
	WHERE process_cd IN ('LOAD','VMT','TRAP1')
)
,v_data AS(
	SELECT*
	FROM(
		SELECT ROW_NUMBER() OVER(PARTITION BY v_proc.process_cd ORDER BY v_insp.process_at DESC ) AS v_list
		,v_proc.process_cd,v_insp.judge_text
		--,*
		FROM t_insp_kk10 AS v_insp
		JOIN v_proc ON v_proc.proc_uuid =v_insp.proc_uuid
		WHERE v_insp.serial_cd =SUBSTRING('{0}',1,17)
	) AS v_temp
	--WHERE v_list<=6
)
,v_table1 AS(
	SELECT process_cd
	--,ARRAY_AGG(judge_text) AS v_result
	,string_agg(judge_text,'') AS v_result
	FROM v_data
	GROUP BY process_cd
)

SELECT*FROM v_table1