WITH AE_1 AS(
SELECT c.judge_text FROM (
SELECT a.process_at,a.serial_cd,a.judge_text,
ROW_NUMBER()over(PARTITION BY serial_cd ORDER BY process_at DESC)
FROM t_insp_ee149 a
JOIN m_process b ON a.proc_uuid = b.proc_uuid
WHERE b.process_cd = 'AE-1'
AND a.serial_cd = '{0}') AS c
WHERE c.row_number = '1'),
AE_7 AS(
SELECT inspect_text
FROM t_data_ee149 data
JOIN t_insp_ee149 insp ON data.insp_seq=insp.insp_seq
WHERE insp.proc_uuid IN
(SELECT proc_uuid FROM m_process
WHERE process_cd='AE-7')
AND insp.serial_cd='{0}'
AND data.inspect_cd='FLATNESS'
ORDER BY data.process_at DESC
LIMIT 1)

SELECT AE_7.inspect_text AS value,
CASE
 WHEN AE_1.judge_text!='0' THEN 'NG'
 WHEN  AE_7.inspect_text::FLOAT  <=0.2 THEN 'Bin A'
 WHEN  AE_7.inspect_text::FLOAT  >0.2 AND AE_7.inspect_text::FLOAT  <=0.25 THEN 'Bin B'
 ELSE 'NG'
END AS type
FROM AE_1,AE_7
