SELECT s.loginame, db_name(s.dbid) name, s.hostname, s.program_name,
s.stmt_start, s.stmt_end, s.spid, CONVERT(smallint, s.waittype) waittype, s.lastwaittype,
s.ecid, s.waittime, CONVERT(varchar(64), s.context_info) context_info, s.blocked, r.plan_handle
,[obj] = QUOTENAME(OBJECT_SCHEMA_NAME(t.objectid, t.[dbid]))
 + '.' + QUOTENAME(OBJECT_NAME(t.objectid, t.[dbid])),
t.[text]
FROM master..sysprocesses AS s
LEFT OUTER JOIN sys.dm_exec_sessions es ON es.session_id = s.spid
LEFT OUTER JOIN sys.dm_exec_requests r ON r.session_id = s.spid
OUTER APPLY
 sys.dm_exec_sql_text(s.[sql_handle]) AS t
WHERE (
s.dbid<>0
AND s.cmd NOT LIKE '%BACKUP%'
AND s.cmd NOT LIKE '%RESTORE%'
AND es.is_user_process = 1
AND s.spid<>@@SPID
)