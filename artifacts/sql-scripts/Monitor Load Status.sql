/* Monitor the load status - print results */
SELECT   r.[start_time]
,       r.[request_id]
,       r.[status]
,       r.resource_class
,       r.command
,       r.total_elapsed_time as total_elapsed_time_millisec
,       r.total_elapsed_time/1000 as total_elapsed_time_sec
,       r.total_elapsed_time/60000 as total_elapsed_time_min
,       (sum(w.bytes_processed)/(1024*1024))/(r.total_elapsed_time/1000) as average_mbps
,       sum(w.bytes_processed) AS bytes_processed
,       sum(w.bytes_processed)/(1024*1024) AS bytes_processed_mb
,       sum(w.bytes_processed)/(1024*1024*1024) AS bytes_processed_gb
,       sum(w.rows_processed) AS rows_processed
FROM    sys.dm_pdw_exec_requests r
              LEFT OUTER JOIN sys.dm_pdw_dms_workers w
                     ON r.[request_id] = w.request_id and w.type = 'WRITER'
WHERE (r.[label] like 'COPY : nyctaxi%' OR
    r.[label] like 'CTAS : nyctaxi%')
and r.session_id <> session_id() 
GROUP BY r.[start_time], r.[request_id],
        r.[status],
        r.resource_class,
        r.command,
        r.total_elapsed_time
ORDER BY r.[start_time] desc