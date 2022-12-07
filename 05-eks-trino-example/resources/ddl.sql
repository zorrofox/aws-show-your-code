CREATE EXTERNAL TABLE `call_center`(
  `cc_call_center_sk` bigint, 
  `cc_call_center_id` string, 
  `cc_rec_start_date` string, 
  `cc_rec_end_date` string, 
  `cc_closed_date_sk` string, 
  `cc_open_date_sk` bigint, 
  `cc_name` string, 
  `cc_class` string, 
  `cc_employees` bigint, 
  `cc_sq_ft` bigint, 
  `cc_hours` string, 
  `cc_manager` string, 
  `cc_mkt_id` bigint, 
  `cc_mkt_class` string, 
  `cc_mkt_desc` string, 
  `cc_market_manager` string, 
  `cc_division` bigint, 
  `cc_division_name` string, 
  `cc_company` bigint, 
  `cc_company_name` string, 
  `cc_street_number` bigint, 
  `cc_street_name` string, 
  `cc_street_type` string, 
  `cc_suite_number` string, 
  `cc_city` string, 
  `cc_county` string, 
  `cc_state` string, 
  `cc_zip` bigint, 
  `cc_country` string, 
  `cc_gmt_offset` bigint, 
  `cc_tax_percentage` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/call_center/';

CREATE EXTERNAL TABLE `catalog_page`(
  `cp_catalog_page_sk` bigint, 
  `cp_catalog_page_id` string, 
  `cp_start_date_sk` bigint, 
  `cp_end_date_sk` bigint, 
  `cp_department` string, 
  `cp_catalog_number` bigint, 
  `cp_catalog_page_number` bigint, 
  `cp_description` string, 
  `cp_type` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/catalog_page/';

CREATE EXTERNAL TABLE `catalog_returns`(
  `cr_returned_date_sk` bigint, 
  `cr_returned_time_sk` bigint, 
  `cr_item_sk` bigint, 
  `cr_refunded_customer_sk` bigint, 
  `cr_refunded_cdemo_sk` bigint, 
  `cr_refunded_hdemo_sk` bigint, 
  `cr_refunded_addr_sk` bigint, 
  `cr_returning_customer_sk` bigint, 
  `cr_returning_cdemo_sk` bigint, 
  `cr_returning_hdemo_sk` bigint, 
  `cr_returning_addr_sk` bigint, 
  `cr_call_center_sk` bigint, 
  `cr_catalog_page_sk` bigint, 
  `cr_ship_mode_sk` bigint, 
  `cr_warehouse_sk` bigint, 
  `cr_reason_sk` bigint, 
  `cr_order_number` bigint, 
  `cr_return_quantity` bigint, 
  `cr_return_amount` decimal, 
  `cr_return_tax` decimal, 
  `cr_return_amt_inc_tax` decimal, 
  `cr_fee` decimal, 
  `cr_return_ship_cost` decimal, 
  `cr_refunded_cash` decimal, 
  `cr_reversed_charge` decimal, 
  `cr_store_credit` decimal, 
  `cr_net_loss` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/catalog_returns/';

CREATE EXTERNAL TABLE `catalog_sales`(
  `cs_sold_date_sk` bigint, 
  `cs_sold_time_sk` bigint, 
  `cs_ship_date_sk` bigint, 
  `cs_bill_customer_sk` bigint, 
  `cs_bill_cdemo_sk` bigint, 
  `cs_bill_hdemo_sk` bigint, 
  `cs_bill_addr_sk` bigint, 
  `cs_ship_customer_sk` bigint, 
  `cs_ship_cdemo_sk` bigint, 
  `cs_ship_hdemo_sk` bigint, 
  `cs_ship_addr_sk` bigint, 
  `cs_call_center_sk` bigint, 
  `cs_catalog_page_sk` bigint, 
  `cs_ship_mode_sk` bigint, 
  `cs_warehouse_sk` bigint, 
  `cs_item_sk` bigint, 
  `cs_promo_sk` bigint, 
  `cs_order_number` bigint, 
  `cs_quantity` bigint, 
  `cs_wholesale_cost` decimal, 
  `cs_list_price` decimal, 
  `cs_sales_price` decimal, 
  `cs_ext_discount_amt` decimal, 
  `cs_ext_sales_price` decimal, 
  `cs_ext_wholesale_cost` decimal, 
  `cs_ext_list_price` decimal, 
  `cs_ext_tax` decimal, 
  `cs_coupon_amt` decimal, 
  `cs_ext_ship_cost` decimal, 
  `cs_net_paid` decimal, 
  `cs_net_paid_inc_tax` decimal, 
  `cs_net_paid_inc_ship` decimal, 
  `cs_net_paid_inc_ship_tax` decimal, 
  `cs_net_profit` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/catalog_sales/';

CREATE EXTERNAL TABLE `customer`(
  `c_customer_sk` bigint, 
  `c_customer_id` string, 
  `c_current_cdemo_sk` bigint, 
  `c_current_hdemo_sk` bigint, 
  `c_current_addr_sk` bigint, 
  `c_first_shipto_date_sk` bigint, 
  `c_first_sales_date_sk` bigint, 
  `c_salutation` string, 
  `c_first_name` string, 
  `c_last_name` string, 
  `c_preferred_cust_flag` string, 
  `c_birth_day` bigint, 
  `c_birth_month` bigint, 
  `c_birth_year` bigint, 
  `c_birth_country` string, 
  `c_login` string, 
  `c_email_address` string, 
  `c_last_review_date_sk` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/customer/';

CREATE EXTERNAL TABLE `customer_address`(
  `ca_address_sk` bigint, 
  `ca_address_id` string, 
  `ca_street_number` bigint, 
  `ca_street_name` string, 
  `ca_street_type` string, 
  `ca_suite_number` string, 
  `ca_city` string, 
  `ca_county` string, 
  `ca_state` string, 
  `ca_zip` bigint, 
  `ca_country` string, 
  `ca_gmt_offset` bigint, 
  `ca_location_type` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/customer_address/';

CREATE EXTERNAL TABLE `customer_demographics`(
  `cd_demo_sk` bigint, 
  `cd_gender` string, 
  `cd_marital_status` string, 
  `cd_education_status` string, 
  `cd_purchase_estimate` bigint, 
  `cd_credit_rating` string, 
  `cd_dep_count` bigint, 
  `cd_dep_employed_count` bigint, 
  `cd_dep_college_count` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/customer_demographics/';

CREATE EXTERNAL TABLE `date_dim`(
  `d_date_sk` bigint, 
  `d_date_id` string, 
  `d_date` string, 
  `d_month_seq` bigint, 
  `d_week_seq` bigint, 
  `d_quarter_seq` bigint, 
  `d_year` bigint, 
  `d_dow` bigint, 
  `d_moy` bigint, 
  `d_dom` bigint, 
  `d_qoy` bigint, 
  `d_fy_year` bigint, 
  `d_fy_quarter_seq` bigint, 
  `d_fy_week_seq` bigint, 
  `d_day_name` string, 
  `d_quarter_name` string, 
  `d_holiday` string, 
  `d_weekend` string, 
  `d_following_holiday` string, 
  `d_first_dom` bigint, 
  `d_last_dom` bigint, 
  `d_same_day_ly` bigint, 
  `d_same_day_lq` bigint, 
  `d_current_day` string, 
  `d_current_week` string, 
  `d_current_month` string, 
  `d_current_quarter` string, 
  `d_current_year` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/date_dim/';

CREATE EXTERNAL TABLE `household_demographics`(
  `hd_demo_sk` bigint, 
  `hd_income_band_sk` bigint, 
  `hd_buy_potential` string, 
  `hd_dep_count` bigint, 
  `hd_vehicle_count` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/household_demographics/';

CREATE EXTERNAL TABLE `income_band`(
  `ib_income_band_sk` bigint, 
  `ib_lower_bound` bigint, 
  `ib_upper_bound` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/income_band/';

CREATE EXTERNAL TABLE `inventory`(
  `inv_date_sk` bigint, 
  `inv_item_sk` bigint, 
  `inv_warehouse_sk` bigint, 
  `inv_quantity_on_hand` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/inventory/';

CREATE EXTERNAL TABLE `item`(
  `i_item_sk` bigint, 
  `i_item_id` string, 
  `i_rec_start_date` string, 
  `i_rec_end_date` string, 
  `i_item_desc` string, 
  `i_current_price` decimal, 
  `i_wholesale_cost` decimal, 
  `i_brand_id` bigint, 
  `i_brand` string, 
  `i_class_id` bigint, 
  `i_class` string, 
  `i_category_id` bigint, 
  `i_category` string, 
  `i_manufact_id` bigint, 
  `i_manufact` string, 
  `i_size` string, 
  `i_formulation` string, 
  `i_color` string, 
  `i_units` string, 
  `i_container` string, 
  `i_manager_id` bigint, 
  `i_product_name` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/item/';

CREATE EXTERNAL TABLE `promotion`(
  `p_promo_sk` bigint, 
  `p_promo_id` string, 
  `p_start_date_sk` bigint, 
  `p_end_date_sk` bigint, 
  `p_item_sk` bigint, 
  `p_cost` decimal, 
  `p_response_target` bigint, 
  `p_promo_name` string, 
  `p_channel_dmail` string, 
  `p_channel_email` string, 
  `p_channel_catalog` string, 
  `p_channel_tv` string, 
  `p_channel_radio` string, 
  `p_channel_press` string, 
  `p_channel_event` string, 
  `p_channel_demo` string, 
  `p_channel_details` string, 
  `p_purpose` string, 
  `p_discount_active` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/promotion/';

CREATE EXTERNAL TABLE `reason`(
  `r_reason_sk` bigint, 
  `r_reason_id` string, 
  `r_reason_desc` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/reason/';

CREATE EXTERNAL TABLE `ship_mode`(
  `sm_ship_mode_sk` bigint, 
  `sm_ship_mode_id` string, 
  `sm_type` string, 
  `sm_code` string, 
  `sm_carrier` string, 
  `sm_contract` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/ship_mode/';

CREATE EXTERNAL TABLE `store`(
  `s_store_sk` bigint, 
  `s_store_id` string, 
  `s_rec_start_date` string, 
  `s_rec_end_date` string, 
  `s_closed_date_sk` bigint, 
  `s_store_name` string, 
  `s_number_employees` bigint, 
  `s_floor_space` bigint, 
  `s_hours` string, 
  `s_manager` string, 
  `s_market_id` bigint, 
  `s_geography_class` string, 
  `s_market_desc` string, 
  `s_market_manager` string, 
  `s_division_id` bigint, 
  `s_division_name` string, 
  `s_company_id` bigint, 
  `s_company_name` string, 
  `s_street_number` bigint, 
  `s_street_name` string, 
  `s_street_type` string, 
  `s_suite_number` string, 
  `s_city` string, 
  `s_county` string, 
  `s_state` string, 
  `s_zip` bigint, 
  `s_country` string, 
  `s_gmt_offset` bigint, 
  `s_tax_percentage` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/store/';

CREATE EXTERNAL TABLE `store_returns`(
  `sr_returned_date_sk` bigint, 
  `sr_return_time_sk` bigint, 
  `sr_item_sk` bigint, 
  `sr_customer_sk` bigint, 
  `sr_cdemo_sk` bigint, 
  `sr_hdemo_sk` bigint, 
  `sr_addr_sk` bigint, 
  `sr_store_sk` bigint, 
  `sr_reason_sk` bigint, 
  `sr_ticket_number` bigint, 
  `sr_return_quantity` bigint, 
  `sr_return_amt` decimal, 
  `sr_return_tax` decimal, 
  `sr_return_amt_inc_tax` decimal, 
  `sr_fee` decimal, 
  `sr_return_ship_cost` decimal, 
  `sr_refunded_cash` decimal, 
  `sr_reversed_charge` decimal, 
  `sr_store_credit` decimal, 
  `sr_net_loss` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/store_returns/';


CREATE EXTERNAL TABLE `store_sales`(
  `ss_sold_date_sk` bigint, 
  `ss_sold_time_sk` bigint, 
  `ss_item_sk` bigint, 
  `ss_customer_sk` bigint, 
  `ss_cdemo_sk` bigint, 
  `ss_hdemo_sk` bigint, 
  `ss_addr_sk` bigint, 
  `ss_store_sk` bigint, 
  `ss_promo_sk` bigint, 
  `ss_ticket_number` bigint, 
  `ss_quantity` bigint, 
  `ss_wholesale_cost` decimal, 
  `ss_list_price` decimal, 
  `ss_sales_price` decimal, 
  `ss_ext_discount_amt` decimal, 
  `ss_ext_sales_price` decimal, 
  `ss_ext_wholesale_cost` decimal, 
  `ss_ext_list_price` decimal, 
  `ss_ext_tax` decimal, 
  `ss_coupon_amt` decimal, 
  `ss_net_paid` decimal, 
  `ss_net_paid_inc_tax` decimal, 
  `ss_net_profit` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/store_sales/';


CREATE EXTERNAL TABLE `time_dim`(
  `t_time_sk` bigint, 
  `t_time_id` string, 
  `t_time` bigint, 
  `t_hour` bigint, 
  `t_minute` bigint, 
  `t_second` bigint, 
  `t_am_pm` string, 
  `t_shift` string, 
  `t_sub_shift` string, 
  `t_meal_time` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/time_dim/';

CREATE EXTERNAL TABLE `warehouse`(
  `w_warehouse_sk` bigint, 
  `w_warehouse_id` string, 
  `w_warehouse_name` string, 
  `w_warehouse_sq_ft` bigint, 
  `w_street_number` bigint, 
  `w_street_name` string, 
  `w_street_type` string, 
  `w_suite_number` string, 
  `w_city` string, 
  `w_county` string, 
  `w_state` string, 
  `w_zip` bigint, 
  `w_country` string, 
  `w_gmt_offset` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/warehouse/';

CREATE EXTERNAL TABLE `web_page`(
  `wp_web_page_sk` bigint, 
  `wp_web_page_id` string, 
  `wp_rec_start_date` string, 
  `wp_rec_end_date` string, 
  `wp_creation_date_sk` bigint, 
  `wp_access_date_sk` bigint, 
  `wp_autogen_flag` string, 
  `wp_customer_sk` bigint, 
  `wp_url` string, 
  `wp_type` string, 
  `wp_char_count` bigint, 
  `wp_link_count` bigint, 
  `wp_image_count` bigint, 
  `wp_max_ad_count` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/web_page/';


CREATE EXTERNAL TABLE `web_returns`(
  `wr_returned_date_sk` bigint, 
  `wr_returned_time_sk` bigint, 
  `wr_item_sk` bigint, 
  `wr_refunded_customer_sk` bigint, 
  `wr_refunded_cdemo_sk` bigint, 
  `wr_refunded_hdemo_sk` bigint, 
  `wr_refunded_addr_sk` bigint, 
  `wr_returning_customer_sk` bigint, 
  `wr_returning_cdemo_sk` bigint, 
  `wr_returning_hdemo_sk` bigint, 
  `wr_returning_addr_sk` bigint, 
  `wr_web_page_sk` bigint, 
  `wr_reason_sk` bigint, 
  `wr_order_number` bigint, 
  `wr_return_quantity` bigint, 
  `wr_return_amt` decimal, 
  `wr_return_tax` decimal, 
  `wr_return_amt_inc_tax` decimal, 
  `wr_fee` decimal, 
  `wr_return_ship_cost` decimal, 
  `wr_refunded_cash` decimal, 
  `wr_reversed_charge` decimal, 
  `wr_account_credit` decimal, 
  `wr_net_loss` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/web_returns/';

CREATE EXTERNAL TABLE `web_sales`(
  `ws_sold_date_sk` bigint, 
  `ws_sold_time_sk` bigint, 
  `ws_ship_date_sk` bigint, 
  `ws_item_sk` bigint, 
  `ws_bill_customer_sk` bigint, 
  `ws_bill_cdemo_sk` bigint, 
  `ws_bill_hdemo_sk` bigint, 
  `ws_bill_addr_sk` bigint, 
  `ws_ship_customer_sk` bigint, 
  `ws_ship_cdemo_sk` bigint, 
  `ws_ship_hdemo_sk` bigint, 
  `ws_ship_addr_sk` bigint, 
  `ws_web_page_sk` bigint, 
  `ws_web_site_sk` bigint, 
  `ws_ship_mode_sk` bigint, 
  `ws_warehouse_sk` bigint, 
  `ws_promo_sk` bigint, 
  `ws_order_number` bigint, 
  `ws_quantity` bigint, 
  `ws_wholesale_cost` decimal, 
  `ws_list_price` decimal, 
  `ws_sales_price` decimal, 
  `ws_ext_discount_amt` decimal, 
  `ws_ext_sales_price` decimal, 
  `ws_ext_wholesale_cost` decimal, 
  `ws_ext_list_price` decimal, 
  `ws_ext_tax` decimal, 
  `ws_coupon_amt` decimal, 
  `ws_ext_ship_cost` decimal, 
  `ws_net_paid` decimal, 
  `ws_net_paid_inc_tax` decimal, 
  `ws_net_paid_inc_ship` decimal, 
  `ws_net_paid_inc_ship_tax` decimal, 
  `ws_net_profit` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/web_sales/';


CREATE EXTERNAL TABLE `web_site`(
  `web_site_sk` bigint, 
  `web_site_id` string, 
  `web_rec_start_date` string, 
  `web_rec_end_date` string, 
  `web_name` string, 
  `web_open_date_sk` bigint, 
  `web_close_date_sk` bigint, 
  `web_class` string, 
  `web_manager` string, 
  `web_mkt_id` bigint, 
  `web_mkt_class` string, 
  `web_mkt_desc` string, 
  `web_market_manager` string, 
  `web_company_id` bigint, 
  `web_company_name` string, 
  `web_street_number` bigint, 
  `web_street_name` string, 
  `web_street_type` string, 
  `web_suite_number` string, 
  `web_city` string, 
  `web_county` string, 
  `web_state` string, 
  `web_zip` bigint, 
  `web_country` string, 
  `web_gmt_offset` bigint, 
  `web_tax_percentage` decimal)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://greg-tpc-ds/3T/web_site/';