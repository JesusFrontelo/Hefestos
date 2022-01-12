column dummy noprint;
column  pct_used format 9999.9       heading "%|Used";
column  name    format a40      heading "Tablespace Name";
column  Kbytes   format 9999999D99    heading "MBytes";
column  used    format 9999999D99   heading "Used";
column  free    format 999999D99  heading "Free";
column  largest    format 999999D99  heading "Largest";
break   on report;
compute sum of kbytes on report;
compute sum of free on report;
compute sum of used on report;
set linesize 200;
set pagesize 500;

select nvl(b.tablespace_name,
             nvl(a.tablespace_name,'UNKOWN')) name,
       Mbytes_alloc kbytes,
       Mbytes_alloc-nvl(Mbytes_free,0) used,
       nvl(Mbytes_free,0) free,
       ((Mbytes_alloc-nvl(Mbytes_free,0))/
                          Mbytes_alloc)*100 pct_used,
       nvl(largest,0) largest
from ( select sum(bytes)/1024/1024 Mbytes_free,
              max(bytes)/1024/1024 largest,
              tablespace_name
       from  sys.dba_free_space
       group by tablespace_name ) a,
     ( select sum(bytes)/1024/1024 Mbytes_alloc,
              tablespace_name
       from sys.dba_data_files
       group by tablespace_name )b
where a.tablespace_name (+) = b.tablespace_name
order by 5 desc;