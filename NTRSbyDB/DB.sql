WITH tempTable AS(
	(
		SELECT serial_cd,process_at::DATE=CURRENT_DATE istoday,process_at
		FROM (
		SELECT *,ROW_NUMBER() OVER(PARTITION BY serial_cd  ORDER BY process_at DESC  ) AS num FROM t_insp_kk13
		WHERE proc_uuid IN (SELECT proc_uuid FROM m_process WHERE  process_cd ='TRAP1')
		AND serial_cd ='{0}'
		)a WHERE num=1
	)
	UNION ALL
	SELECT NULL,NULL,NULL
	LIMIT 1
)

SELECT
CASE
	WHEN istoday IS NULL THEN NULL
	WHEN istoday=FALSE THEN 'NG'
	WHEN process_at::TIME<'4:00:00'  THEN 'Bin A'
	WHEN process_at::TIME<'8:00:00'  THEN 'Bin B'
	WHEN process_at::TIME<'12:00:00'  THEN 'Bin C'
	WHEN process_at::TIME<'16:00:00'  THEN 'Bin D'
	WHEN process_at::TIME<'20:00:00'  THEN 'Bin E'
	--WHEN process_at::TIME<CURRENT_DATE+1  THEN 'Bin F'
	ELSE 'Bin F'
END AS data_type,
serial_cd||'
'||process_at AS data_value,
--NULL AS data_message,
NULL AS data_message,
*
FROM tempTable