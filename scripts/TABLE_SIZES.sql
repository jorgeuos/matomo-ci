-- Useful Query too find large tabels.

SELECT   TABLE_NAME AS `Table`,   ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS `Size (MB)` FROM   information_schema.TABLES WHERE   TABLE_SCHEMA = "matomo" ORDER BY   (DATA_LENGTH + INDEX_LENGTH) DESC;
-- Example output:
+---------------------------------------+-----------+
| Table                                 | Size (MB) |
+---------------------------------------+-----------+
| matomo_archive_blob_2022_01           |       468 |
| matomo_log_hsr_blob                   |       286 |
| matomo_logger_message                 |       194 |
| matomo_log_hsr_event                  |       140 |
| matomo_archive_blob_2021_11           |        96 |
| matomo_archive_blob_2021_09           |        95 |
| matomo_archive_blob_2021_10           |        92 |
| matomo_archive_blob_2022_02           |        92 |
| matomo_archive_blob_2021_03           |        87 |
| matomo_log_form_page                  |        84 |
| matomo_archive_blob_2021_12           |        81 |
| matomo_archive_blob_2021_02           |        75 |
| matomo_archive_blob_2021_04           |        65 |
| matomo_archive_blob_2021_05           |        60 |
| matomo_archive_blob_2021_08           |        59 |
| matomo_archive_blob_2021_01           |        50 |
| matomo_archive_blob_2022_03           |        49 |
| matomo_archive_blob_2021_06           |        47 |
| matomo_log_link_visit_action          |        35 |
| matomo_log_visit                      |        29 |
| matomo_archive_numeric_2021_09        |        19 |
| matomo_archive_numeric_2021_10        |        18 |
| matomo_archive_numeric_2021_11        |        17 |
| matomo_archive_numeric_2022_01        |        16 |
| matomo_archive_numeric_2021_03        |        15 |
| matomo_archive_numeric_2021_12        |        15 |
| matomo_archive_numeric_2022_02        |        15 |
| matomo_archive_numeric_2021_05        |        14 |
| matomo_archive_numeric_2021_02        |        14 |
| matomo_log_form_field                 |        13 |
| matomo_archive_numeric_2021_04        |        13 |
| matomo_archive_numeric_2021_01        |        12 |
| matomo_archive_numeric_2021_08        |        12 |
| matomo_log_media                      |        11 |
| matomo_archive_numeric_2021_06        |        11 |
| matomo_session                        |        10 |
| matomo_archive_numeric_2022_03        |         9 |
| matomo_archive_blob_2020_01           |         6 |
| matomo_archive_blob_2021_07           |         5 |
| matomo_archive_numeric_2019_11        |         5 |
| matomo_archive_numeric_2020_10        |         5 |
| matomo_log_media_plays                |         5 |
| matomo_log_action                     |         4 |
| matomo_tagmanager_tag                 |         4 |
| matomo_archive_numeric_2020_11        |         4 |
| matomo_archive_numeric_2020_09        |         4 |
| matomo_archive_numeric_2020_12        |         3 |
| matomo_archive_numeric_2020_01        |         3 |
| matomo_log_funnel                     |         3 |
| matomo_archive_blob_2020_09           |         3 |
| matomo_archive_blob_2020_10           |         3 |
| matomo_option                         |         3 |
| matomo_activity_log                   |         3 |
| matomo_log_advertising                |         3 |
| matomo_archive_numeric_2020_08        |         2 |
| matomo_archive_numeric_2020_02        |         2 |
| matomo_log_form                       |         2 |
| matomo_log_conversion                 |         2 |
| matomo_tagmanager_variable            |         2 |
| matomo_tagmanager_trigger             |         2 |
| matomo_archive_blob_2020_11           |         2 |
| matomo_archive_blob_2020_12           |         2 |
| matomo_archive_blob_2020_08           |         2 |
| matomo_site_hsr                       |         2 |
| matomo_archive_blob_2019_01           |         2 |
| matomo_archive_blob_2020_02           |         2 |
| matomo_archive_blob_2020_03           |         2 |
| matomo_archive_blob_2020_06           |         2 |
| matomo_archive_numeric_2020_03        |         1 |
| matomo_archive_numeric_2019_10        |         1 |
| matomo_archive_numeric_2019_12        |         1 |
| matomo_archive_numeric_2021_07        |         1 |
| matomo_archive_numeric_2020_06        |         1 |
| matomo_archive_numeric_2020_05        |         1 |
| matomo_archive_numeric_2020_07        |         1 |
| matomo_archive_blob_2020_04           |         1 |
| matomo_archive_blob_2020_05           |         1 |
| matomo_archive_numeric_2020_04        |         0 |
| matomo_log_hsr                        |         0 |
| matomo_archive_blob_2020_07           |         0 |
| matomo_archive_blob_2019_11           |         0 |
| matomo_archive_blob_2019_12           |         0 |
| matomo_log_hsr_site                   |         0 |
| matomo_site_form                      |         0 |
| matomo_archive_blob_2019_10           |         0 |
| matomo_tagmanager_container_version   |         0 |
| matomo_log_performance                |         0 |
| matomo_tagmanager_container_release   |         0 |
| matomo_alert_triggered                |         0 |
| matomo_user_dashboard                 |         0 |
| matomo_archive_numeric_2008_12        |         0 |
| matomo_archive_numeric_2009_01        |         0 |
| matomo_archive_numeric_2009_02        |         0 |
| matomo_archive_numeric_2009_03        |         0 |
| matomo_archive_numeric_2009_04        |         0 |
| matomo_archive_numeric_2009_05        |         0 |
| matomo_archive_numeric_2009_06        |         0 |
| matomo_archive_numeric_2009_07        |         0 |
| matomo_archive_numeric_2009_08        |         0 |
| matomo_archive_numeric_2009_09        |         0 |
| matomo_archive_numeric_2009_10        |         0 |
| matomo_archive_numeric_2009_11        |         0 |
| matomo_archive_numeric_2009_12        |         0 |
| matomo_archive_numeric_2010_01        |         0 |
| matomo_archive_numeric_2010_02        |         0 |
| matomo_archive_numeric_2010_03        |         0 |
| matomo_archive_numeric_2010_04        |         0 |
| matomo_archive_numeric_2010_05        |         0 |
| matomo_archive_numeric_2010_06        |         0 |
| matomo_archive_numeric_2010_07        |         0 |
| matomo_archive_numeric_2010_08        |         0 |
| matomo_archive_numeric_2010_09        |         0 |
| matomo_archive_numeric_2010_10        |         0 |
| matomo_archive_numeric_2010_11        |         0 |
| matomo_archive_numeric_2010_12        |         0 |
| matomo_archive_numeric_2011_01        |         0 |
| matomo_archive_numeric_2011_02        |         0 |
| matomo_archive_numeric_2011_03        |         0 |
| matomo_archive_numeric_2011_04        |         0 |
| matomo_archive_numeric_2011_05        |         0 |
| matomo_archive_numeric_2011_06        |         0 |
| matomo_archive_numeric_2011_07        |         0 |
| matomo_archive_numeric_2011_08        |         0 |
| matomo_archive_numeric_2011_09        |         0 |
| matomo_archive_numeric_2011_10        |         0 |
| matomo_archive_numeric_2011_11        |         0 |
| matomo_archive_numeric_2011_12        |         0 |
| matomo_archive_numeric_2012_01        |         0 |
| matomo_archive_numeric_2012_02        |         0 |
| matomo_archive_numeric_2012_03        |         0 |
| matomo_archive_numeric_2012_04        |         0 |
| matomo_archive_numeric_2012_05        |         0 |
| matomo_archive_numeric_2012_06        |         0 |
| matomo_archive_numeric_2012_07        |         0 |
| matomo_archive_numeric_2012_08        |         0 |
| matomo_archive_numeric_2012_09        |         0 |
| matomo_archive_numeric_2012_10        |         0 |
| matomo_archive_numeric_2012_11        |         0 |
| matomo_archive_numeric_2012_12        |         0 |
| matomo_archive_numeric_2013_01        |         0 |
| matomo_archive_numeric_2013_02        |         0 |
| matomo_archive_numeric_2013_03        |         0 |
| matomo_archive_numeric_2013_04        |         0 |
| matomo_archive_numeric_2013_05        |         0 |
| matomo_archive_numeric_2013_06        |         0 |
| matomo_archive_numeric_2013_07        |         0 |
| matomo_archive_numeric_2013_08        |         0 |
| matomo_archive_numeric_2013_09        |         0 |
| matomo_archive_numeric_2013_10        |         0 |
| matomo_archive_numeric_2013_11        |         0 |
| matomo_archive_numeric_2013_12        |         0 |
| matomo_archive_numeric_2014_01        |         0 |
| matomo_archive_numeric_2014_02        |         0 |
| matomo_archive_numeric_2014_03        |         0 |
| matomo_archive_numeric_2014_04        |         0 |
| matomo_archive_numeric_2014_05        |         0 |
| matomo_archive_numeric_2014_06        |         0 |
| matomo_archive_numeric_2014_07        |         0 |
| matomo_archive_numeric_2014_08        |         0 |
| matomo_archive_numeric_2014_09        |         0 |
| matomo_archive_numeric_2014_10        |         0 |
| matomo_archive_numeric_2014_11        |         0 |
| matomo_archive_numeric_2014_12        |         0 |
| matomo_archive_numeric_2015_01        |         0 |
| matomo_archive_numeric_2015_02        |         0 |
| matomo_archive_numeric_2015_03        |         0 |
| matomo_archive_numeric_2015_04        |         0 |
| matomo_archive_numeric_2015_05        |         0 |
| matomo_archive_numeric_2015_06        |         0 |
| matomo_archive_numeric_2015_07        |         0 |
| matomo_archive_numeric_2015_08        |         0 |
| matomo_archive_numeric_2015_09        |         0 |
| matomo_archive_numeric_2015_10        |         0 |
| matomo_archive_numeric_2015_11        |         0 |
| matomo_archive_numeric_2015_12        |         0 |
| matomo_archive_numeric_2016_01        |         0 |
| matomo_archive_numeric_2016_02        |         0 |
| matomo_archive_numeric_2016_03        |         0 |
| matomo_archive_numeric_2016_04        |         0 |
| matomo_archive_numeric_2016_05        |         0 |
| matomo_archive_numeric_2016_06        |         0 |
| matomo_archive_numeric_2016_07        |         0 |
| matomo_archive_numeric_2016_08        |         0 |
| matomo_archive_numeric_2016_09        |         0 |
| matomo_archive_numeric_2016_10        |         0 |
| matomo_archive_numeric_2016_11        |         0 |
| matomo_archive_numeric_2016_12        |         0 |
| matomo_archive_numeric_2017_01        |         0 |
| matomo_archive_numeric_2017_02        |         0 |
| matomo_archive_numeric_2017_03        |         0 |
| matomo_archive_numeric_2017_04        |         0 |
| matomo_archive_numeric_2017_05        |         0 |
| matomo_archive_numeric_2017_06        |         0 |
| matomo_archive_numeric_2017_07        |         0 |
| matomo_archive_numeric_2017_08        |         0 |
| matomo_archive_numeric_2017_09        |         0 |
| matomo_archive_numeric_2017_10        |         0 |
| matomo_archive_numeric_2017_11        |         0 |
| matomo_archive_numeric_2017_12        |         0 |
| matomo_archive_numeric_2018_01        |         0 |
| matomo_archive_numeric_2018_02        |         0 |
| matomo_archive_numeric_2018_03        |         0 |
| matomo_archive_numeric_2018_04        |         0 |
| matomo_archive_numeric_2018_05        |         0 |
| matomo_archive_numeric_2018_06        |         0 |
| matomo_archive_numeric_2018_07        |         0 |
| matomo_archive_numeric_2018_08        |         0 |
| matomo_archive_numeric_2018_09        |         0 |
| matomo_archive_numeric_2018_10        |         0 |
| matomo_archive_numeric_2018_11        |         0 |
| matomo_archive_numeric_2018_12        |         0 |
| matomo_archive_numeric_2019_01        |         0 |
| matomo_archive_numeric_2019_02        |         0 |
| matomo_archive_numeric_2019_03        |         0 |
| matomo_archive_numeric_2019_04        |         0 |
| matomo_archive_numeric_2019_05        |         0 |
| matomo_archive_numeric_2019_06        |         0 |
| matomo_archive_numeric_2019_07        |         0 |
| matomo_archive_numeric_2019_08        |         0 |
| matomo_archive_numeric_2019_09        |         0 |
| matomo_archive_numeric_2022_04        |         0 |
| matomo_log_abtesting                  |         0 |
| matomo_user_feedback_form_templates   |         0 |
| matomo_access                         |         0 |
| matomo_archive_blob_2008_12           |         0 |
| matomo_archive_blob_2009_01           |         0 |
| matomo_archive_blob_2009_02           |         0 |
| matomo_archive_blob_2009_03           |         0 |
| matomo_archive_blob_2009_04           |         0 |
| matomo_archive_blob_2009_05           |         0 |
| matomo_archive_blob_2009_06           |         0 |
| matomo_archive_blob_2009_07           |         0 |
| matomo_archive_blob_2009_08           |         0 |
| matomo_archive_blob_2009_09           |         0 |
| matomo_archive_blob_2009_10           |         0 |
| matomo_archive_blob_2009_11           |         0 |
| matomo_archive_blob_2009_12           |         0 |
| matomo_archive_blob_2010_01           |         0 |
| matomo_archive_blob_2010_02           |         0 |
| matomo_archive_blob_2010_03           |         0 |
| matomo_archive_blob_2010_04           |         0 |
| matomo_archive_blob_2010_05           |         0 |
| matomo_archive_blob_2010_06           |         0 |
| matomo_archive_blob_2010_07           |         0 |
| matomo_archive_blob_2010_08           |         0 |
| matomo_archive_blob_2010_09           |         0 |
| matomo_archive_blob_2010_10           |         0 |
| matomo_archive_blob_2010_11           |         0 |
| matomo_archive_blob_2010_12           |         0 |
| matomo_archive_blob_2011_01           |         0 |
| matomo_archive_blob_2011_02           |         0 |
| matomo_archive_blob_2011_03           |         0 |
| matomo_archive_blob_2011_04           |         0 |
| matomo_archive_blob_2011_05           |         0 |
| matomo_archive_blob_2011_06           |         0 |
| matomo_archive_blob_2011_07           |         0 |
| matomo_archive_blob_2011_08           |         0 |
| matomo_archive_blob_2011_09           |         0 |
| matomo_archive_blob_2011_10           |         0 |
| matomo_archive_blob_2011_11           |         0 |
| matomo_archive_blob_2011_12           |         0 |
| matomo_archive_blob_2012_01           |         0 |
| matomo_archive_blob_2012_02           |         0 |
| matomo_archive_blob_2012_03           |         0 |
| matomo_archive_blob_2012_04           |         0 |
| matomo_archive_blob_2012_05           |         0 |
| matomo_archive_blob_2012_06           |         0 |
| matomo_archive_blob_2012_07           |         0 |
| matomo_archive_blob_2012_08           |         0 |
| matomo_archive_blob_2012_09           |         0 |
| matomo_archive_blob_2012_10           |         0 |
| matomo_archive_blob_2012_11           |         0 |
| matomo_archive_blob_2012_12           |         0 |
| matomo_archive_blob_2013_01           |         0 |
| matomo_archive_blob_2013_02           |         0 |
| matomo_archive_blob_2013_03           |         0 |
| matomo_archive_blob_2013_04           |         0 |
| matomo_archive_blob_2013_05           |         0 |
| matomo_archive_blob_2013_06           |         0 |
| matomo_archive_blob_2013_07           |         0 |
| matomo_archive_blob_2013_08           |         0 |
| matomo_archive_blob_2013_09           |         0 |
| matomo_archive_blob_2013_10           |         0 |
| matomo_archive_blob_2013_11           |         0 |
| matomo_archive_blob_2013_12           |         0 |
| matomo_archive_blob_2014_01           |         0 |
| matomo_archive_blob_2014_02           |         0 |
| matomo_archive_blob_2014_03           |         0 |
| matomo_archive_blob_2014_04           |         0 |
| matomo_archive_blob_2014_05           |         0 |
| matomo_archive_blob_2014_06           |         0 |
| matomo_archive_blob_2014_07           |         0 |
| matomo_archive_blob_2014_08           |         0 |
| matomo_archive_blob_2014_09           |         0 |
| matomo_archive_blob_2014_10           |         0 |
| matomo_archive_blob_2014_11           |         0 |
| matomo_archive_blob_2014_12           |         0 |
| matomo_archive_blob_2015_01           |         0 |
| matomo_archive_blob_2015_02           |         0 |
| matomo_archive_blob_2015_03           |         0 |
| matomo_archive_blob_2015_04           |         0 |
| matomo_archive_blob_2015_05           |         0 |
| matomo_archive_blob_2015_06           |         0 |
| matomo_archive_blob_2015_07           |         0 |
| matomo_archive_blob_2015_08           |         0 |
| matomo_archive_blob_2015_09           |         0 |
| matomo_archive_blob_2015_10           |         0 |
| matomo_archive_blob_2015_11           |         0 |
| matomo_archive_blob_2015_12           |         0 |
| matomo_archive_blob_2016_01           |         0 |
| matomo_archive_blob_2016_02           |         0 |
| matomo_archive_blob_2016_03           |         0 |
| matomo_archive_blob_2016_04           |         0 |
| matomo_archive_blob_2016_05           |         0 |
| matomo_archive_blob_2016_06           |         0 |
| matomo_archive_blob_2016_07           |         0 |
| matomo_archive_blob_2016_08           |         0 |
| matomo_archive_blob_2016_09           |         0 |
| matomo_archive_blob_2016_10           |         0 |
| matomo_archive_blob_2016_11           |         0 |
| matomo_archive_blob_2016_12           |         0 |
| matomo_archive_blob_2017_01           |         0 |
| matomo_archive_blob_2017_02           |         0 |
| matomo_archive_blob_2017_03           |         0 |
| matomo_archive_blob_2017_04           |         0 |
| matomo_archive_blob_2017_05           |         0 |
| matomo_archive_blob_2017_06           |         0 |
| matomo_archive_blob_2017_07           |         0 |
| matomo_archive_blob_2017_08           |         0 |
| matomo_archive_blob_2017_09           |         0 |
| matomo_archive_blob_2017_10           |         0 |
| matomo_archive_blob_2017_11           |         0 |
| matomo_archive_blob_2017_12           |         0 |
| matomo_archive_blob_2018_01           |         0 |
| matomo_archive_blob_2018_02           |         0 |
| matomo_archive_blob_2018_03           |         0 |
| matomo_archive_blob_2018_04           |         0 |
| matomo_archive_blob_2018_05           |         0 |
| matomo_archive_blob_2018_06           |         0 |
| matomo_archive_blob_2018_07           |         0 |
| matomo_archive_blob_2018_08           |         0 |
| matomo_archive_blob_2018_09           |         0 |
| matomo_archive_blob_2018_10           |         0 |
| matomo_archive_blob_2018_11           |         0 |
| matomo_archive_blob_2018_12           |         0 |
| matomo_archive_blob_2019_02           |         0 |
| matomo_archive_blob_2019_03           |         0 |
| matomo_archive_blob_2019_04           |         0 |
| matomo_archive_blob_2019_05           |         0 |
| matomo_archive_blob_2019_06           |         0 |
| matomo_archive_blob_2019_07           |         0 |
| matomo_archive_blob_2019_08           |         0 |
| matomo_archive_blob_2019_09           |         0 |
| matomo_archive_invalidations          |         0 |
| matomo_brute_force_log                |         0 |
| matomo_custom_dimensions              |         0 |
| matomo_custom_reports                 |         0 |
| matomo_experiments                    |         0 |
| matomo_experiments_variations         |         0 |
| matomo_funnel                         |         0 |
| matomo_log_conversion_item            |         0 |
| matomo_log_profiling                  |         0 |
| matomo_plugin_setting                 |         0 |
| matomo_privacy_logdata_anonymizations |         0 |
| matomo_report_subscriptions           |         0 |
| matomo_shortcode                      |         0 |
| matomo_singledigitalgateway           |         0 |
| matomo_site_setting                   |         0 |
| matomo_tagmanager_container           |         0 |
| matomo_user_token_auth                |         0 |
| matomo_advertising_google_clickids    |         0 |
| matomo_advertising_google_reports     |         0 |
| matomo_alert                          |         0 |
| matomo_alert_site                     |         0 |
| matomo_bing_stats                     |         0 |
| matomo_bot_db                         |         0 |
| matomo_bot_db_stat                    |         0 |
| matomo_experiments_strategy           |         0 |
| matomo_funnel_steps                   |         0 |
| matomo_goal                           |         0 |
| matomo_goal_attribution               |         0 |
| matomo_google_stats                   |         0 |
| matomo_gpermissions_access            |         0 |
| matomo_gpermissions_group             |         0 |
| matomo_gpermissions_user              |         0 |
| matomo_locks                          |         0 |
| matomo_queuedtracking_queue           |         0 |
| matomo_report                         |         0 |
| matomo_segment                        |         0 |
| matomo_sequence                       |         0 |
| matomo_singledigitalgateway_log       |         0 |
| matomo_site                           |         0 |
| matomo_site_rollup                    |         0 |
| matomo_site_url                       |         0 |
| matomo_tracking_failure               |         0 |
| matomo_twofactor_recovery_code        |         0 |
| matomo_usage_measurement_profiles     |         0 |
| matomo_user                           |         0 |
| matomo_user_feedback_forms            |         0 |
| matomo_user_feedback_results          |         0 |
| matomo_user_language                  |         0 |
| matomo_yandex_stats                   |         0 |
+---------------------------------------+-----------+
402 rows in set (0.01 sec)