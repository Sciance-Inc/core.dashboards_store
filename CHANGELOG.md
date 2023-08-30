# Changelog

<!--next-version-placeholder-->

## v0.5.1 (2023-08-30)

### Fix

* Dependencies will now be parsed as ref when source are used and is_context_core is set to false ([`bbecd17`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bbecd17c288be585cfabdddd41f072a8bf3ddcf3))

## v0.5.0 (2023-08-28)

### Feature

* Add id_eco to population table and add population template ([`f7d81ac`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f7d81aced05732d360e56dd2bf0396903916863e))

### Fix

* Change_dbt_project_name_to_store ([`98107ec`](https://github.com/Sciance-Inc/core.dashboards_store/commit/98107ecf0058f7b34eade8cb77e5ec5dd7281dbb))

## v0.4.0 (2023-08-24)

### Feature

* Adding a cookiecutter template to help greenfield CSS bootstraping the cssXX.data.store ([`89397b8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/89397b873f5f1d57508b8362c9983775c4cd6254))
* Adding the chronic_absenteeism dashboard ([`4fa75fa`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4fa75fa9cdeaaebcf5b309eb8b635afc8ce6d90d))
* Adding the stamping mechanism to expose the data freshness in the dashboards ([`2c7e0b7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2c7e0b7bb6b14ab6b4bf03cdeea4759bd0ae2f40))
* Adding the stamper ([`eb5713a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/eb5713ae3bdf628bacb6c338c6369f2454d3d6f6))
* Adding the retirement dashboard. This dashboard monitors the number of retired employees in the past 10 years and provides forecasts for up to 5 years. ([`7727df8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7727df84530a9b7c659f57d7e6e2e5fdbf5df15f))
* Adding hooks for implementing custom populations ([`d862769`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d862769480ba4f455a9db08386462f1d1cd50319))
* Adding fact_permanent_employe ([`ee01430`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ee014308cd9ec628bfb8d68af90f7b4842521704))

### Fix

* Typo in doc ([`4dbd33c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4dbd33c4b893d675d2b9db07f52fb96d10136ea0))
* The macro no properly delete the schema and the views ([`313456e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/313456e73549d6764a5ffce7ee99b11db9218810))
* **suivi_resultat:** Correcting seeds' friendly name and mandatory courses ([`ac66eed`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ac66eede2ea8af10d6c38f421ccbfb398f550aed))

### Documentation

* Fixing typo in the gpi's database name ([`2b5d591`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2b5d591200f5c646a7daf383848cc4f849a2936b))

## v0.3.2 (2023-06-26)

### Fix

* Casting the timeout as integer to allow for string like definition in the inherited dags ([`76f17c9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/76f17c9688ec9634251dc40ab6fd07e2ef335f87))

## v0.3.1 (2023-06-08)

### Fix

* Remove blank results and correct subject evaluation code ([`ccf6be0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ccf6be0691b988a37b1886895bae2f37d048407a))

## v0.3.0 (2023-05-30)
### Feature

* Adding the effectif_css dashboard ([`eda7eef`](https://github.com/Sciance-Inc/core.dashboards_store/commit/eda7eefc06b8817a74673c056db7d8288792f7c9))
* Adding sectors and filter-by-sectors to the transport dashboard ([`4228f3f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4228f3f5203089e492e0425910da81acfa394082))

### Fix

* Transports tests are now only executed if the transport is available ([`f2cba73`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f2cba738fad124ede43b68383cea2ec5faef0e08))
* The school filter selection is now limited to one item to avoid misinterpretations with the CSS view ([`6493f0a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6493f0a1e9efafbfd6d72d2fd70d8c96ce9ae361))

## v0.1.0 (2023-05-18)
### Feature
* Adding semantic release ([`b5db5fe`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b5db5fe2bac7d50ca1250810ac29137fd084c02d))
* Improvind documentation of the PR template ([`de1f4e4`](https://github.com/Sciance-Inc/core.dashboards_store/commit/de1f4e4fed23413e134e142cb1edb20004a7b9c3))
* Ajouter premmiere version du tdb ([`e0695f5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e0695f5cb2b9a201dd29f273ad9f60272c27b6f3))
* Adding drop schema macro ([`755d484`](https://github.com/Sciance-Inc/core.dashboards_store/commit/755d48471e9b0f42e8d1fee0b281f221f536625c))
* Adding missing seeds in core_dbt_project ([`acdfb01`](https://github.com/Sciance-Inc/core.dashboards_store/commit/acdfb01fded1c915f9f5ffdb5d4c753bbb3bd594))
* Adding MatieresEleve  interfaces ([`9045e8f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9045e8f5fe002a2aa5334735f4c417771909c27f))
* Add_masse_sal_to_this_table ([`7ad7df0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7ad7df0099d7f7b4bfa3d9d3ded5d68f3da992f0))
* Move_table_to_sub_folder_cout_roulement ([`d34758a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d34758afc060f6a9bd1dd802c9b03e0d9c538d0d))
* Move_table_to_sub_folder_cout_roulement_and_modify_filter_and_annee_type ([`13f1cab`](https://github.com/Sciance-Inc/core.dashboards_store/commit/13f1cab96c3b246ab98c29e9ee488cb495cc5fa4))
* Update_db_delete_dim_table ([`cff22f1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cff22f1937952bda17b31de9955133b57b21613c))
* Add taux roulement personnel ([`559dfba`](https://github.com/Sciance-Inc/core.dashboards_store/commit/559dfba0de64e33ad8a93cd6427ba59f55e953fb))
* Modify_filter ([`ab3a20e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ab3a20e021b552ce29db801901f33b082797e59e))
* Addtable_empl_quitter ([`7c651ba`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7c651baaa56316b5dfc961673a13a68b97dbc5bb))
* Delet_shema ([`d84c55a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d84c55a2aba9c08ab2f02fe0ae6864e95455197a))
* Add_schema_to_staging_res_etapes_table ([`75d1974`](https://github.com/Sciance-Inc/core.dashboards_store/commit/75d1974ac959c943d16b904bc230048409e13fab))
*  detele_non_used_table ([`dd015e1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/dd015e13761e43daa6f2010a0b8dbd4a7c87a3ad))
* Freezing dbt-core and dbt-sql-server to ensure across CSS dependencies consistency ([`034399f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/034399fe2366b351c37d59edd07d9702dd2a7251))
* Add_sec4_and_sec4_evaluation_to_db ([`fff74be`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fff74bea543e334fafcbd16dba00fc2c5f874c58))
* Add_new_fields_i_e_ri_resultats ([`80c8013`](https://github.com/Sciance-Inc/core.dashboards_store/commit/80c8013616d60f356bf2f9ae223ff7fcb288b7cc))
* Add_new_vars_to_dbt_project ([`0ea7623`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0ea7623027d4e557bcfe2638037c5311a54415ab))
* Update_README_with_new_info_for_model_res_etapes ([`2250c57`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2250c5751610925d4bb9c4ae78b529cdebf3ff1f))
* Add_dashboard ([`d5e2f1a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d5e2f1aae52bf0e57d78a5c75bdb8a3517d9d531))
* Add_new_table_to _schema ([`9ed638d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9ed638d8d27d872dad6b892ea05d417ea282f53f))
* Add_gouv_evaluation_name _to_seed_table ([`0864ba2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0864ba277b686ed8b8fdc3c9ff5766592f5061ca))
* Add_new_interface_table_to_schema ([`fc4a6f6`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fc4a6f617d2deb0ec9d0b484394924bcd5f4b92d))
* Extract_gouv_rslt_from_interface_table ([`03c2a43`](https://github.com/Sciance-Inc/core.dashboards_store/commit/03c2a439001f49a4b8181c962429d307902f5a74))
* DB_modification ([`9a93378`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9a93378ef00bbeabffef8b4c3d59af963d7d04ac))
* Add_res_exam_anonymous_db ([`adfb628`](https://github.com/Sciance-Inc/core.dashboards_store/commit/adfb628a3a5600cf3d83f475b43a23b34d3ae8e0))
* Add_diff_to_school_table ([`7a06431`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7a06431827eab47460bbd1859d4fbd3dd3ade49c))
* Add_dbt_utils_package ([`9750664`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9750664c3440d352090d4b34a544104f94af64b0))
* Add_id_friendly_name ([`2c266bf`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2c266bfad19d3586da0e4d587e9c103936a53e41))
* Add_new_model_emp_cong_to_dbtproject ([`f8d79e8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f8d79e8cd7aac7ed282c83e6cf14cc6ea3cdf81a))
* Move_interface_table_cssrepo_to_core_modify_schema.yml ([`3ae9e7b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3ae9e7b789c31c0661a33ce3913ce416da92368e))
* Modify_db ([`0c308d9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0c308d9879c66a5c3ad14652ea1319f76cb8bb44))
* Change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option) ([`f0ab571`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f0ab571045a14244b6d26404f5a56f064b0f93f2))
* Adapt macro test ([`396c665`](https://github.com/Sciance-Inc/core.dashboards_store/commit/396c6656fcd7b5106ee02918c45184dde51f4320))
* Add a fact table that tracks the number of part-time employees in the last 10 years ([`a269009`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a269009fbea05dfb568b242b49c870ce1bc76206))
* Connection of databases: geobus and piastreto obtain data for analyzing school transport  efficiency ([`1a492b1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1a492b12f0c2a7b9ad48f5ccb048fdfdc3cbd7ee))
* Add_new_model_emp_cong_to_dbtproject ([`c3e252e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c3e252ed1d5fd678aaa6111df167ebf91316551f))
* Move_interface_table_cssrepo_to_core_modify_schema.yml ([`4494e00`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4494e001c8e8305802e3ecebfbaecdf9e3cf0cbc))
* Modify_db ([`1e2281a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1e2281af9cddc4b7cb8338c3bc678a4f1530f31d))
* Change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option) ([`6eb0602`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6eb06029a54b3fe941ff2424ab820f6b9c09af1e))
* Connection of databases: geobus and piastreto obtain data for analyzing school transport  efficiency ([`3019137`](https://github.com/Sciance-Inc/core.dashboards_store/commit/30191372a6d9814fd5cc32545b60437608b63bc5))
* Adapt macro test ([`fd150fe`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fd150fee57c8a5815bdf1a60f111e19dd07df458))
* Add a fact table that tracks the number of part-time employees in the last 10 years ([`c56047d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c56047dc2c7dd6f79537b0896b1e22282864811f))
* Add base_spine table ([`819cf5a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/819cf5ad3ce05b628d5522e363fc874b05a6d608))
* Add stg_populations ([`512146d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/512146d40003a8151877c098b9af7ec48097ce05))
* Add adapt macro ([`de7b290`](https://github.com/Sciance-Inc/core.dashboards_store/commit/de7b290b3f442025d2823017a738c87096871e2f))
* Adding test  in the core repo ([`a4acb2a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a4acb2a9ab9e16155f780c4caf00b1692918495b))

### Fix
* Propagating renaming ([`b91cc30`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b91cc30e6a9a2f86d13f0cc6b9e59d629ed2dcfa))
* Updating the code-placeholder since the commands in the placeholders were out of order ([`64f57a9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/64f57a9c51b3380b083cee596891637be51bf8ec))
* Removing RLS from the dashboard as we don't have any RLS table yet ([`9654986`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9654986e524ff9b1d7c39865097931199812398c))
* Removing RLS from the dashboard as we don't have any RLS table yet ([`16b5171`](https://github.com/Sciance-Inc/core.dashboards_store/commit/16b51713e7c1e5fa86fcfc060b6c17df7d88246f))
* Correct_error_in_schema ([`f06127a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f06127abbd9a7716da0e7cfdbff063bf8e2f6e13))
* Modification of the 'transport' dashboard schema ([`ad28b63`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ad28b63fdea5303d1314e9f793d08c5a8290d911))
* Adding missing weighting ([`6089aff`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6089affa0723d36d77b6314cd975478643147cfb))
* Adding missing weighting ([`6ab5fc2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6ab5fc222820e1d5858095f48231b881ac60304b))
* Add_model_prefix ([`b34de7e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b34de7e5f831c05281ebb9be45dfe236cb02cd8e))
* Correcti models_name ([`4658d46`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4658d46f81ec7e236309fc91a2e8efaaf75afd55))
* Chande_db ([`cc3a90d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cc3a90d67ba6189f4a5d90a44293635825c4e63c))
* Modify_var_naming ([`6b94094`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6b94094b43f9f11bc23c7563d084d7a257341ba4))
* Fixing dbt project ([`e5a0b44`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e5a0b4410d14a32ff9db65606c8dbf900eb0c090))
* Removing dead code ([`ffb730f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ffb730fe3bbd89c862c9417c3a73c830e3cccbe6))
* Add_prefix_to test_name_to_resolve_ambiguity ([`d0a73cc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d0a73cc6f0fa3dc81f5e5374b3a822b7c76148b2))
* Modify version_from_0_to_2 ([`db7cffd`](https://github.com/Sciance-Inc/core.dashboards_store/commit/db7cffdfdc57592db47ff5e14bda7b4b83154aeb))
* Updated comments ([`75fddfd`](https://github.com/Sciance-Inc/core.dashboards_store/commit/75fddfdf1a13ab1aa6470e615b4a129f5a81f857))
* Add_prefix_to test_name_to_resolve_ambiguity ([`3630b9a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3630b9a876c1a352c3459dfa52f209f29f1cd2fe))
* Modify version_from_0_to_2 ([`295485a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/295485a62e51fb8f395ae2fa241c37b9d5393073))
* Delet_conflict_message ([`590dbcd`](https://github.com/Sciance-Inc/core.dashboards_store/commit/590dbcdd8c2fb649c7f740917d8f0a5d26eedc8f))
* Updated comments ([`9d0e27b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9d0e27bbd55be5c948ba89a11318d13a733f6003))

### Documentation
* Fixing various typos in the docs and adding a placeholder for populations ([`ccf4f9e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ccf4f9ec694e56bf7db56fede508967be9bb0500))
* Fixing a typo in the prospectif_cdep interfaces ([`edc04eb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/edc04eb08177ad0202cc04d2554caf3f3734ab5a))
