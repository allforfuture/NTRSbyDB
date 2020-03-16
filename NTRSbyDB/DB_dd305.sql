--dd305
--0(Bin A||OK)	1(Bin B)	8(NG)	9(null)

--AE_1总判断
WITH AE_1_judge AS(
	(SELECT AE_1.judge_text
	 FROM(
		 SELECT Insp.process_at,Insp.serial_cd,Insp.judge_text,
		 ROW_NUMBER()OVER(PARTITION BY serial_cd ORDER BY process_at DESC)
		 FROM t_insp_dd305 Insp
		 JOIN m_process Proc ON Insp.proc_uuid = Proc.proc_uuid
		 WHERE Proc.process_cd = 'AE-1'
		 AND Insp.serial_cd = '{0}'
	 )AS AE_1
	 WHERE AE_1.row_number = '1')
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_1_result AS(
	SELECT*,
	CASE
	WHEN AE_1_judge.judge_text IS NULL THEN NULL
	WHEN AE_1_judge.judge_text ='0' THEN 'Bin A'
	ELSE 'NG'
	END AS data_type,
	CASE
	WHEN AE_1_judge.judge_text IS NULL THEN 'AE-1 缺少数据'
	WHEN AE_1_judge.judge_text ='0' THEN 'AE-1 OK'
	ELSE AE_1_judge.judge_text||'AE-1 NG'
	END
	||':'||
	CASE
	WHEN AE_1_judge.judge_text IS NULL THEN ''
	ELSE AE_1_judge.judge_text
	END
	AS data_message
	FROM AE_1_judge)

--AE_1_DT2温度
,AE_1_DT2 AS(
	(SELECT inspect_text
	 FROM t_data_dd305 t_data
	 JOIN t_insp_dd305 insp ON t_data.insp_seq=insp.insp_seq
	 WHERE insp.proc_uuid IN
	 (SELECT proc_uuid FROM m_process
	  WHERE process_cd='AE-1')
	 AND insp.serial_cd='{0}'
	 AND t_data.inspect_cd='DT2'
	 ORDER BY t_data.process_at DESC)
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_1_DT2_result AS(
	SELECT*,
	CASE
	WHEN AE_1_DT2.inspect_text IS NULL THEN NULL
	WHEN AE_1_DT2.inspect_text::FLOAT <=3 THEN 'Bin A'
	WHEN AE_1_DT2.inspect_text::FLOAT >3 AND AE_1_DT2.inspect_text::FLOAT <=5 THEN 'Bin B'
	ELSE 'NG'
	END AS data_type,
	CASE
	WHEN AE_1_DT2.inspect_text IS NULL THEN 'AE-1_DT2 缺少数据'
	WHEN AE_1_DT2.inspect_text::FLOAT <=3 THEN 'AE-1_DT2 Bin A'
	WHEN AE_1_DT2.inspect_text::FLOAT >3 AND AE_1_DT2.inspect_text::FLOAT <=5 THEN 'AE-1_DT2 Bin B'
	ELSE 'AE-1_DT2 NG'
	END
	||':'||
	CASE
	WHEN AE_1_DT2.inspect_text IS NULL THEN ''
	ELSE AE_1_DT2.inspect_text
	END
	
	AS data_message
	FROM AE_1_DT2)

--AE_1_DT3温度
,AE_1_DT3 AS(
	(SELECT inspect_text
	 FROM t_data_dd305 t_data
	 JOIN t_insp_dd305 insp ON t_data.insp_seq=insp.insp_seq
	 WHERE insp.proc_uuid IN
	 (SELECT proc_uuid FROM m_process
	  WHERE process_cd='AE-1')
	 AND insp.serial_cd='{0}'
	 AND t_data.inspect_cd='DT3'
	 ORDER BY t_data.process_at DESC)
	UNION ALL
	SELECT NULL
	LIMIT 1)
,AE_1_DT3_result AS(
	SELECT*,
	CASE
	WHEN AE_1_DT3.inspect_text IS NULL THEN NULL
	WHEN AE_1_DT3.inspect_text::FLOAT <=3 THEN 'Bin A'
	WHEN AE_1_DT3.inspect_text::FLOAT >3 AND AE_1_DT3.inspect_text::FLOAT <=5 THEN 'Bin B'
	ELSE 'NG'
	END AS data_type,
	CASE
	WHEN AE_1_DT3.inspect_text IS NULL THEN 'AE-1_DT3 缺少数据'
	WHEN AE_1_DT3.inspect_text::FLOAT <=3 THEN 'AE-1_DT3 Bin A'
	WHEN AE_1_DT3.inspect_text::FLOAT >3 AND AE_1_DT3.inspect_text::FLOAT <=5 THEN 'AE-1_DT3 Bin B'
	ELSE 'AE-1_DT3 NG'
	END
	||':'||
	CASE
	WHEN AE_1_DT3.inspect_text IS NULL THEN ''
	ELSE AE_1_DT3.inspect_text
	END
	AS data_message
	FROM AE_1_DT3)

--显示data_value
SELECT AE_1_result.data_message||'
'||AE_1_DT2_result.data_message||'
'||AE_1_DT3_result.data_message AS data_value,
--显示data_type
CASE
WHEN(AE_1_result.data_type IS NULL
	 OR AE_1_DT2_result.data_type IS NULL
	 OR AE_1_DT3_result.data_type IS NULL
	 )THEN NULL
ELSE GREATEST(AE_1_result.data_type
			  ,AE_1_DT2_result.data_type
			  ,AE_1_DT3_result.data_type)
END AS data_type,
--显示data_message
AE_1_result.data_message||'
'||AE_1_DT2_result.data_message||'
'||AE_1_DT3_result.data_message AS data_message
,*
FROM AE_1_result,AE_1_DT2_result,AE_1_DT3_result