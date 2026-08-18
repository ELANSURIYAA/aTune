CREATE OR REPLACE VIEW mv_paas_tracking_card_metrics
WITH METRICS
LANGUAGE YAML
AS $$
version: 0.1
source: team_css_analytics_prod.hpx_analytics.paas_tracking_card
dimensions:
  - name: Date
    expr: DATE(session_start_date_time)
  - name: Month Date
    expr: DATE_TRUNC('MONTH', session_start_date_time)
  - name: Os Platform
    expr: os_platform
  - name: App Version
    expr: app_version
  - name: Geo Country Code
    expr: geo_country_code
  - name: Is Hpid Signed In
    expr: is_hpid_signed_in
  - name: App Name
    expr: app_name
  - name: App Package Id
    expr: app_package_id
  - name: Session Id
    expr: session_id
  - name: App Package Deployed Uuid
    expr: app_package_deployed_uuid
  - name: Device App Package Deployed Uuid
    expr: device_app_package_deployed_uuid
  - name: Aip Device Uuid
    expr: aip_device_uuid
  - name: Is Associated Device
    expr: is_associated_device
  - name: Associated Device Session Id
    expr: associated_device_session_id
  - name: Is Viewed Aip Tracking Card
    expr: is_viewed_aip_tracking_card
  - name: Is Viewed Aip Tracking Card Order Confirmed
    expr: is_viewed_aip_tracking_card_order_confirmed
  - name: Is Viewed Aip Tracking Card Order Processing
    expr: is_viewed_aip_tracking_card_order_processing
  - name: Is Viewed Aip Tracking Card Order Shipped
    expr: is_viewed_aip_tracking_card_order_shipped
  - name: Is Viewed Aip Tracking Card Order Delivered
    expr: is_viewed_aip_tracking_card_order_delivered
  - name: Is Clicked Aip Order Accordian
    expr: is_clicked_aip_order_accordian
  - name: Is Clicked Order Confirmation
    expr: is_clicked_order_confirmation
  - name: Is Clicked Order Processing
    expr: is_clicked_order_processing
  - name: Is Clicked Track Delivery
    expr: is_clicked_track_delivery
  - name: Is Clicked Complete Setup
    expr: is_clicked_complete_setup
  - name: Is Clicked Order Confirmation Pill
    expr: is_clicked_order_confirmation_pill
  - name: Is Clicked Order Processing Pill
    expr: is_clicked_order_processing_pill
  - name: Is Clicked Order Shipped Pill
    expr: is_clicked_order_shipped_pill
  - name: Is Clicked Order Delivered Pill
    expr: is_clicked_order_delivered_pill
  - name: Is Oobe Complete
    expr: is_oobe_complete
  - name: Is Aip Setup Complete
    expr: is_aip_setup_complete
  - name: Is Clicked Support
    expr: is_clicked_support
  - name: Is Oobe Support Session
    expr: is_oobe_support_session
  - name: Is Aip Setup Start
    expr: is_aip_setup_start
  - name: Is Ows Start
    expr: is_ows_start
  - name: Is Clicked Aip Order Accord
    expr: is_clicked_aip_order_accord
  - name: Is Clicked Aip Order Accordian Order Confirmed
    expr: is_clicked_aip_order_accordian_order_confirmed
  - name: Is Clicked Aip Order Accordian Order Processing
    expr: is_clicked_aip_order_accordian_order_processing
  - name: Is Clicked Aip Order Accordian Order Shipped
    expr: is_clicked_aip_order_accordian_order_shipped
measures:
  - name: Viewed PaaS Tracking Card
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card THEN app_package_deployed_uuid END) END
  - name: Clicked Expand
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_aip_order_accordian THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_aip_order_accordian THEN app_package_deployed_uuid END) END
  - name: Clicked Order Confirmation
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_order_confirmation THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_order_confirmation THEN app_package_deployed_uuid END) END
  - name: Clicked Order Processing
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_order_processing THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_order_processing THEN app_package_deployed_uuid END) END
  - name: Clicked Track Delivery
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_track_delivery THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_track_delivery THEN app_package_deployed_uuid END) END
  - name: Clicked Complete Setup
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_complete_setup THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_complete_setup THEN app_package_deployed_uuid END) END
  - name: Confirmed
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_confirmed THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_confirmed THEN app_package_deployed_uuid END) END
  - name: Delivered
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_delivered THEN device_app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_delivered THEN device_app_package_deployed_uuid END) END
  - name: Delivered Pill
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_order_delivered_pill THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_order_delivered_pill THEN app_package_deployed_uuid END) END
  - name: Onboarded
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_delivered AND is_aip_setup_complete THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_delivered AND is_aip_setup_complete THEN app_package_deployed_uuid END) END
  - name: Order Confirmed Pill
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_order_confirmation_pill THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_order_confirmation_pill THEN app_package_deployed_uuid END) END
  - name: Processed
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_processing THEN device_app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_processing THEN device_app_package_deployed_uuid END) END
  - name: Processing Pill
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_order_processing_pill THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_order_processing_pill THEN app_package_deployed_uuid END) END
  - name: Shipped
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_shipped THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_shipped THEN app_package_deployed_uuid END) END
  - name: Shipped Pill
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_clicked_order_shipped_pill THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_clicked_order_shipped_pill THEN app_package_deployed_uuid END) END
  - name: Support Cases
    expr: CASE WHEN COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_delivered AND is_oobe_support_session THEN app_package_deployed_uuid END) = 0 THEN NULL ELSE COUNT(DISTINCT CASE WHEN is_viewed_aip_tracking_card_order_delivered AND is_oobe_support_session THEN app_package_deployed_uuid END) END
  - name: Total Printer Count
    expr: SUM(total_printer_count)
  - name: Total Device Count
    expr: SUM(total_device_count)
  - name: Total Accessory Count
    expr: SUM(total_accessory_count)
  - name: Total Pc Count
    expr: SUM(total_pc_count)
  - name: Max Total Printer Count
    expr: SUM(max_total_printer_count)
  - name: Max Total Device Count
    expr: SUM(max_total_device_count)
  - name: Max Total Accessory Count
    expr: SUM(max_total_accessory_count)
  - name: Max Total Pc Count
    expr: SUM(max_total_pc_count)
$$;