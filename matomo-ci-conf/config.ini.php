; <?php exit; ?> DO NOT REMOVE THIS LINE
; file automatically generated or modified by Matomo; you can manually override the default values in global.ini.php by redefining them in this file.
[database]
host = "CI_DB_HOST"
username = "CI_DB_USER"
password = "CI_DB_PASS"
dbname = "CI_DB_NAME"
tables_prefix = "matomo_"
charset = "utf8mb4"

[log]
log_writers[] = "database"
log_writers[] = "file"
log_level = "ERROR"

[General]
show_multisites_sparklines = 0
browser_archiving_disabled_enforce = 1
login_allowlist_apply_to_reporting_api_requests = 0
login_allow_logme = 1
noreply_email_address = "mtmo@digitalist.se"
noreply_email_name = "Digitalist Matomo"
enable_trusted_host_check = 0
proxy_client_headers[] = "HTTP_X_FORWARDED_FOR"
proxy_client_headers[] = "HTTP_X_FORWARDED_FOR"
salt = "AAAbbbCCC111222333DDDeeeFFFpeace"
trusted_hosts[] = "mtmo.ci"
cors_domains[] = "*"

[Tracker]
ignore_visits_cookie_name = "piwik_ignore"

[Deletelogs]
delete_logs_enable = 1
delete_logs_older_than = 30

[mail]
transport = "smtp"
port = 1025
host = "127.0.0.1"
type = "Plain"
encryption = "tls"

[Plugins]
Plugins[] = "CoreVue"
Plugins[] = "CorePluginsAdmin"
Plugins[] = "CoreAdminHome"
Plugins[] = "CoreHome"
Plugins[] = "WebsiteMeasurable"
Plugins[] = "IntranetMeasurable"
Plugins[] = "Diagnostics"
Plugins[] = "CoreVisualizations"
Plugins[] = "Proxy"
Plugins[] = "API"
Plugins[] = "Widgetize"
Plugins[] = "Transitions"
Plugins[] = "LanguagesManager"
Plugins[] = "Actions"
Plugins[] = "Dashboard"
Plugins[] = "MultiSites"
Plugins[] = "Referrers"
Plugins[] = "UserLanguage"
Plugins[] = "DevicesDetection"
Plugins[] = "Goals"
Plugins[] = "Ecommerce"
Plugins[] = "SEO"
Plugins[] = "Events"
Plugins[] = "UserCountry"
Plugins[] = "GeoIp2"
Plugins[] = "VisitsSummary"
Plugins[] = "VisitFrequency"
Plugins[] = "VisitTime"
Plugins[] = "VisitorInterest"
Plugins[] = "RssWidget"
Plugins[] = "Monolog"
Plugins[] = "Login"
Plugins[] = "TwoFactorAuth"
Plugins[] = "UsersManager"
Plugins[] = "SitesManager"
Plugins[] = "Installation"
Plugins[] = "CoreUpdater"
Plugins[] = "CoreConsole"
Plugins[] = "ScheduledReports"
Plugins[] = "UserCountryMap"
Plugins[] = "Live"
Plugins[] = "PrivacyManager"
Plugins[] = "ImageGraph"
Plugins[] = "Annotations"
Plugins[] = "MobileMessaging"
Plugins[] = "Overlay"
Plugins[] = "SegmentEditor"
Plugins[] = "Insights"
Plugins[] = "Morpheus"
Plugins[] = "Contents"
Plugins[] = "TestRunner"
Plugins[] = "BulkTracking"
Plugins[] = "Resolution"
Plugins[] = "DevicePlugins"
Plugins[] = "Heartbeat"
Plugins[] = "Intl"
Plugins[] = "Marketplace"
Plugins[] = "UserId"
Plugins[] = "CustomJsTracker"
Plugins[] = "Tour"
Plugins[] = "PagePerformance"
Plugins[] = "CustomDimensions"
Plugins[] = "DBStats"
Plugins[] = "TagManager"
Plugins[] = "AbTesting"
Plugins[] = "ActivityLog"
Plugins[] = "BotTracker"
Plugins[] = "CustomAlerts"
Plugins[] = "CustomReports"
Plugins[] = "CustomVariables"
Plugins[] = "DBHealth"
Plugins[] = "ExtraTools"
Plugins[] = "FormAnalytics"
Plugins[] = "Funnels"
Plugins[] = "HeatmapSessionRecording"
Plugins[] = "InvalidateReports"
Plugins[] = "LogViewer"
Plugins[] = "MarketingCampaignsReporting"
Plugins[] = "MediaAnalytics"
Plugins[] = "MultiChannelConversionAttribution"
Plugins[] = "RollUpReporting"
Plugins[] = "SearchEngineKeywordsPerformance"
Plugins[] = "SingleDigitalGateway"
Plugins[] = "UserConsole"
Plugins[] = "UserFeedback"
Plugins[] = "UsersFlow"
Plugins[] = "VisitorGenerator"
Plugins[] = "WhiteLabel"

[PluginsInstalled]
PluginsInstalled[] = "Diagnostics"
PluginsInstalled[] = "DBStats"
PluginsInstalled[] = "Login"
PluginsInstalled[] = "CoreAdminHome"
PluginsInstalled[] = "UsersManager"
PluginsInstalled[] = "SitesManager"
PluginsInstalled[] = "Installation"
PluginsInstalled[] = "Monolog"
PluginsInstalled[] = "Intl"
PluginsInstalled[] = "CorePluginsAdmin"
PluginsInstalled[] = "CoreHome"
PluginsInstalled[] = "WebsiteMeasurable"
PluginsInstalled[] = "CoreVisualizations"
PluginsInstalled[] = "Proxy"
PluginsInstalled[] = "API"
PluginsInstalled[] = "Transitions"
PluginsInstalled[] = "Actions"
PluginsInstalled[] = "Referrers"
PluginsInstalled[] = "UserLanguage"
PluginsInstalled[] = "DevicesDetection"
PluginsInstalled[] = "Goals"
PluginsInstalled[] = "SEO"
PluginsInstalled[] = "Events"
PluginsInstalled[] = "UserCountry"
PluginsInstalled[] = "GeoIp2"
PluginsInstalled[] = "VisitsSummary"
PluginsInstalled[] = "VisitFrequency"
PluginsInstalled[] = "VisitTime"
PluginsInstalled[] = "VisitorInterest"
PluginsInstalled[] = "CoreUpdater"
PluginsInstalled[] = "CoreConsole"
PluginsInstalled[] = "UserCountryMap"
PluginsInstalled[] = "Live"
PluginsInstalled[] = "ImageGraph"
PluginsInstalled[] = "Annotations"
PluginsInstalled[] = "Insights"
PluginsInstalled[] = "Morpheus"
PluginsInstalled[] = "Contents"
PluginsInstalled[] = "DevicePlugins"
PluginsInstalled[] = "UserId"
PluginsInstalled[] = "ExtraTools"
PluginsInstalled[] = "LanguagesManager"
PluginsInstalled[] = "SegmentEditor"
PluginsInstalled[] = "Dashboard"
PluginsInstalled[] = "ScheduledReports"
PluginsInstalled[] = "PrivacyManager"
PluginsInstalled[] = "CustomVariables"
PluginsInstalled[] = "IntranetMeasurable"
PluginsInstalled[] = "Widgetize"
PluginsInstalled[] = "MultiSites"
PluginsInstalled[] = "Ecommerce"
PluginsInstalled[] = "RssWidget"
PluginsInstalled[] = "Feedback"
PluginsInstalled[] = "TwoFactorAuth"
PluginsInstalled[] = "MobileMessaging"
PluginsInstalled[] = "Overlay"
PluginsInstalled[] = "TestRunner"
PluginsInstalled[] = "BulkTracking"
PluginsInstalled[] = "Resolution"
PluginsInstalled[] = "Heartbeat"
PluginsInstalled[] = "Marketplace"
PluginsInstalled[] = "ProfessionalServices"
PluginsInstalled[] = "TagManager"
PluginsInstalled[] = "Tour"
PluginsInstalled[] = "AbTesting"
PluginsInstalled[] = "ActivityLog"
PluginsInstalled[] = "CustomDimensions"
PluginsInstalled[] = "CustomReports"
PluginsInstalled[] = "FormAnalytics"
PluginsInstalled[] = "Funnels"
PluginsInstalled[] = "HeatmapSessionRecording"
PluginsInstalled[] = "InvalidateReports"
PluginsInstalled[] = "LogViewer"
PluginsInstalled[] = "MarketingCampaignsReporting"
PluginsInstalled[] = "MediaAnalytics"
PluginsInstalled[] = "MultiChannelConversionAttribution"
PluginsInstalled[] = "RollUpReporting"
PluginsInstalled[] = "SearchEngineKeywordsPerformance"
PluginsInstalled[] = "UserFeedback"
PluginsInstalled[] = "UsersFlow"
PluginsInstalled[] = "VisitorGenerator"
PluginsInstalled[] = "WhiteLabel"
PluginsInstalled[] = "CustomJsTracker"
PluginsInstalled[] = "PagePerformance"
PluginsInstalled[] = "AdminNotification"
PluginsInstalled[] = "AnonymousPiwikUsageMeasurement"
PluginsInstalled[] = "Bandwidth"
PluginsInstalled[] = "CustomAlerts"
PluginsInstalled[] = "CustomOptOut"
PluginsInstalled[] = "DeviceDetectorCache"
PluginsInstalled[] = "ExampleAPI"
PluginsInstalled[] = "ExampleCommand"
PluginsInstalled[] = "ExampleLogTables"
PluginsInstalled[] = "ExamplePlugin"
PluginsInstalled[] = "ExampleReport"
PluginsInstalled[] = "ExampleSettingsPlugin"
PluginsInstalled[] = "ExampleTheme"
PluginsInstalled[] = "ExampleTracker"
PluginsInstalled[] = "ExampleUI"
PluginsInstalled[] = "ExampleVisualization"
PluginsInstalled[] = "GroupPermissions"
PluginsInstalled[] = "LoginLdap"
PluginsInstalled[] = "MobileAppMeasurable"
PluginsInstalled[] = "Provider"
PluginsInstalled[] = "QueuedTracking"
PluginsInstalled[] = "SecurityInfo"
PluginsInstalled[] = "TasksTimetable"
PluginsInstalled[] = "TrackingSpamPrevention"
PluginsInstalled[] = "TreemapVisualization"
PluginsInstalled[] = "UserConsole"
PluginsInstalled[] = "SingleDigitalGateway"
PluginsInstalled[] = "DBHealth"
PluginsInstalled[] = "Cohorts"
PluginsInstalled[] = "GoogleAnalyticsImporter"
PluginsInstalled[] = "BotTracker"
PluginsInstalled[] = "CoreVue"
PluginsInstalled[] = "ExampleVue"
PluginsInstalled[] = "TrackerDomain"

[CustomReports]
datatable_archiving_maximum_rows_custom_reports = 500
datatable_archiving_maximum_rows_subtable_custom_reports = 500
custom_reports_validate_report_content_all_websites = 1
custom_reports_always_show_unique_visitors = 0
custom_reports_max_execution_time = 0
custom_reports_disabled_dimensions = ""

[Funnels]
funnels_num_max_rows_in_actions = 100
funnels_num_max_rows_in_referrers = 50
funnels_num_max_rows_populate_at_once = 60000

[MediaAnalytics]
media_analytics_exclude_query_parameters = "enablejsapi,player_id"
datatable_archiving_maximum_rows_media = 1000
datatable_archiving_maximum_rows_subtable_media = 1000

[UsersFlow]
UsersFlow_num_max_steps = 10
UsersFlow_num_max_rows_in_actions = 100
UsersFlow_num_max_links_per_interaction = 5000

[MultiChannelConversionAttribution]
default_day_prior_to_conversion = 30
available_days_prior_to_conversion = "7,30,60,90"

[HeatmapSessionRecording]
add_tracking_code_only_when_needed = 1
session_recording_sample_limits = "50,100,250,500,1000,2000,5000"

[QueuedTracking]
notify_queue_threshold_single_queue = 250000

[RollUpReporting]
force_aggregate_raw_data_for_day = 1
force_aggregate_raw_data_for_day_segment = 1

[DeviceDetectorCache]
num_cache_entries = 200000
access_log_path = "/var/log/httpd/access_log"
access_log_regex = "/^(\\S+) (\\S+) (\\S+) (\\S+) \\[([^:]+):(\\d+:\\d+:\\d+) ([^\\]]+)\\] \\&quot;(\\S+) (.*?) (\\S+)\\&quot; (\\S+) (\\S+) &quot;([^&quot;]*)&quot; &quot;([^&quot;]*)&quot; (\\d+)&#36;/"
regex_match_entry = 14

[TrackingSpamPrevention]
block_cloud_sync_throw_exception_on_error = 0
iprange_allowlist[] = ""
block_geoip_organisations[] = "alicloud"
block_geoip_organisations[] = "alibaba cloud"

