{#
  Map each job_group to a job_group_category.

  Feel free to override me to get your own custom litle mapping.
#}

SELECT 
    corp_empl AS job_group,
    descr AS job_group_description,
	CASE 
		WHEN CORP_EMPL like('1%') THEN 'Direction'
		WHEN CORP_EMPL like('2%') THEN 'Professionnel(le)'
		WHEN CORP_EMPL like('3%') THEN 'Enseignant(e)'
		WHEN CORP_EMPL like('4%') THEN 'Soutien'
		WHEN CORP_EMPL like('5%') THEN 'Ressource matérielle'
		ELSE 'Autres'
	END AS job_group_category
FROM {{ ref('i_pai_tab_corp_empl') }} AS src