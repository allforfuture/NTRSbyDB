select inspect_text AS value,
CASE
 WHEN  inspect_text::float  <=0.2 THEN 'Bin A'
 WHEN  inspect_text::float  >0.2 and inspect_text::float  <=0.25 THEN 'Bin B'
 ELSE 'Bin C'
END AS type
from t_data_ee149 data
join t_insp_ee149 insp on data.insp_seq=insp.insp_seq
where insp.proc_uuid in
(select proc_uuid from m_process
where process_cd='AE-7')
and insp.serial_cd='{0}'
order by data.process_at desc
limit 1