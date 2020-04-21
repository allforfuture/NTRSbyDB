SELECT
sn AS data_value,
sn_group AS data_type,
sn_group AS data_message
FROM result_sn
WHERE sn='{0}'
ORDER BY update_time DESC
--显示data_value
--显示data_type
--显示data_message