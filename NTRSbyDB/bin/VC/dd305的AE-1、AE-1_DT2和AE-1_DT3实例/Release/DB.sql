﻿WITH AE_1 AS(
	(SELECT c.judge_text
	 FROM(
		 SELECT a.process_at,a.serial_cd,a.judge_text,
		 ROW_NUMBER()OVER(PARTITION BY serial_cd ORDER BY process_at DESC)
		 FROM t_insp_dd305 a
		 JOIN m_process b ON a.proc_uuid = b.proc_uuid
		 WHERE b.process_cd = 'AE-1'
		 AND a.serial_cd = '{0}'
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
,AE_1_DT2 AS(
	(SELECT inspect_text
	 FROM t_data_dd305 data
	 JOIN t_insp_dd305 insp ON data.insp_seq=insp.insp_seq
	 WHERE insp.proc_uuid IN
	 (SELECT proc_uuid FROM m_process
	  WHERE process_cd='AE-1')
	 AND insp.serial_cd='{0}'
	 AND data.inspect_cd='DT2'
	 ORDER BY data.process_at DESC)
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_1_DT2_result AS(
	SELECT*,
	CASE
	WHEN AE_1_DT2.inspect_text is NULL THEN NULL
	WHEN AE_1_DT2.inspect_text::FLOAT <=2 THEN 'Bin A'
	WHEN AE_1_DT2.inspect_text::FLOAT >2 AND AE_1_DT2.inspect_text::FLOAT <=2.5 THEN 'Bin B'
	WHEN AE_1_DT2.inspect_text::FLOAT >2.5 THEN 'Bin C'
	ELSE 'NG'
	END AS type,
	CASE
	WHEN AE_1_DT2.inspect_text is NULL THEN 'AE-1_DT2 缺少数据'
	WHEN AE_1_DT2.inspect_text::FLOAT <=2 THEN 'AE-1_DT2 Bin A'
	WHEN AE_1_DT2.inspect_text::FLOAT >2 AND AE_1_DT2.inspect_text::FLOAT <=2.5 THEN 'AE-1_DT2 Bin B'
	WHEN AE_1_DT2.inspect_text::FLOAT >2.5 THEN 'AE-1_DT2 Bin C'
	ELSE 'AE-1_DT2 NG'
	END AS message
	FROM AE_1_DT2)
,AE_1_DT3 AS(
	(SELECT inspect_text
	 FROM t_data_dd305 data
	 JOIN t_insp_dd305 insp ON data.insp_seq=insp.insp_seq
	 WHERE insp.proc_uuid IN
	 (SELECT proc_uuid FROM m_process
	  WHERE process_cd='AE-1')
	 AND insp.serial_cd='{0}'
	 AND data.inspect_cd='DT3'
	 ORDER BY data.process_at DESC)
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_1_DT3_result AS(
	SELECT*,
	CASE
	WHEN AE_1_DT3.inspect_text is NULL THEN NULL
	WHEN AE_1_DT3.inspect_text::FLOAT <=2 THEN 'Bin A'
	WHEN AE_1_DT3.inspect_text::FLOAT >2 AND AE_1_DT3.inspect_text::FLOAT <=2.5 THEN 'Bin B'
	WHEN AE_1_DT3.inspect_text::FLOAT >2.5 THEN 'Bin C'
	ELSE 'NG'
	END AS type,
	CASE
	WHEN AE_1_DT3.inspect_text is NULL THEN 'AE-1_DT3 缺少数据'
	WHEN AE_1_DT3.inspect_text::FLOAT <=2 THEN 'AE-1_DT3 Bin A'
	WHEN AE_1_DT3.inspect_text::FLOAT >2 AND AE_1_DT3.inspect_text::FLOAT <=2.5 THEN 'AE-1_DT3 Bin B'
	WHEN AE_1_DT3.inspect_text::FLOAT >2.5 THEN 'AE-1_DT3 Bin C'
	ELSE 'AE-1_DT3 NG'
	END AS message
	FROM AE_1_DT3)

SELECT GREATEST(AE_1_DT2_result.inspect_text,AE_1_DT3_result.inspect_text) AS value,
CASE
WHEN(AE_1_result.type IS NULL OR AE_1_DT2_result.type IS NULL OR AE_1_DT3_result.type IS NULL)THEN NULL
WHEN(AE_1_result.type='NG' OR AE_1_DT2_result.type='NG' OR AE_1_DT3_result.type='NG')THEN 'NG'
WHEN AE_1_DT2_result.inspect_text::FLOAT >= AE_1_DT3_result.inspect_text::FLOAT THEN AE_1_DT2_result.type
ELSE AE_1_DT3_result.type
END AS type,
AE_1_result.message||'
'||AE_1_DT2_result.message||'
'||AE_1_DT3_result.message AS message
,*
FROM AE_1_result,AE_1_DT2_result,AE_1_DT3_result