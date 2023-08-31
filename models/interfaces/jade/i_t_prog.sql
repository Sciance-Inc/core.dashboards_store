select prog, progmeq as prog_meq, descrprog as descr_prog
from {{ var("database_jade") }}.dbo.t_prog
