SELECT count (*) AS value,
CASE
 WHEN count (*) = 0 THEN 'Type1'
 ELSE 'Type2'
END AS type
FROM t_insp_kk10 a
JOIN m_process b ON a.proc_uuid  =b.proc_uuid
WHERE b.process_cd = 'TRAQ1'
AND a.serial_cd = '{0}'