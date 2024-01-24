select
    nom_table,
    code,
    cf_descr,
    cf_descr_abreg,
    us_descr,
    us_descr_abreg,
    statut,
    date_modif
from {{ var("database_gpi") }}.dbo.wl_descr
