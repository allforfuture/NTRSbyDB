WITH AE_1 AS(
	(SELECT c.judge_text
	 FROM(
		 SELECT a.process_at,a.serial_cd,a.judge_text,
		 ROW_NUMBER()OVER(PARTITION BY serial_cd ORDER BY process_at DESC)
		 FROM t_insp_ee149 a
		 JOIN m_process b ON a.proc_uuid = b.proc_uuid
		 WHERE b.process_cd = 'AE-1'
		 AND a.serial_cd = 'C4879398A1G001133'
	 )AS c
	 WHERE c.row_number = '1')
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_1_result AS(
	SELECT*,
	CASE
	WHEN AE_1.judge_text is NULL THEN NULL
	WHEN AE_1.judge_text ='0' THEN 'OK'
	ELSE 'NG'
	END AS type,
	CASE
	WHEN AE_1.judge_text is NULL THEN 'AE-1 缺少数据'
	WHEN AE_1.judge_text ='0' THEN 'AE-1 OK'
	ELSE 'AE-1 NG'
	END AS message
	FROM AE_1)
,AE_7 AS(
	(SELECT inspect_text
	 FROM t_data_ee149 data
	 JOIN t_insp_ee149 insp ON data.insp_seq=insp.insp_seq
	 WHERE insp.proc_uuid IN
	 (SELECT proc_uuid FROM m_process
	  WHERE process_cd='AE-7')
	 AND insp.serial_cd='C4879398A1G001133'
	 AND data.inspect_cd='FLATNESS'
	 ORDER BY data.process_at DESC)
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_7_result AS(
	SELECT*,
	CASE
	WHEN AE_7.inspect_text is NULL THEN NULL
	WHEN AE_7.inspect_text::FLOAT <=0.2 THEN 'Bin A'
	WHEN AE_7.inspect_text::FLOAT >0.2 AND AE_7.inspect_text::FLOAT <=0.25 THEN 'Bin B'
	ELSE 'NG'
	END AS type,
	CASE
	WHEN AE_7.inspect_text is NULL THEN 'AE-7 缺少数据'
	WHEN AE_7.inspect_text::FLOAT <=0.2 THEN 'AE-7 Bin A'
	WHEN AE_7.inspect_text::FLOAT >0.2 AND AE_7.inspect_text::FLOAT <=0.25 THEN 'AE-7 Bin B'
	ELSE 'AE-7 NG'
	END AS message
	FROM AE_7)
	
SELECT AE_7_result.inspect_text AS value,
CASE
WHEN(AE_1_result.type IS NULL OR AE_7_result.type IS NULL)THEN NULL
WHEN(AE_1_result.type='NG' OR AE_7_result.type='NG')THEN 'NG'
ELSE AE_7_result.type
END AS type,
AE_1_result.message||'
'||AE_7_result.message AS message
,*
FROM AE_1_result,AE_7_result