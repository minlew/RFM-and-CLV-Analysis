WITH
  registrations_table AS(   #All unique registrations are listed by finding the MIN event_date for each user id (regardless of event_name)
  SELECT
    DATE_TRUNC(PARSE_DATE('%Y%m%d', MIN(event_date)), WEEK) AS registration_week, #Registration dates are truncated into "registration_week"
    user_pseudo_id,
  FROM
    `turing_data_analytics.raw_events`
  GROUP BY
    user_pseudo_id),


  purchase_table AS(   
  SELECT
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', event_date), WEEK) AS purchase_week, #Every purchase event has its date truncated into "purchase_week"
    purchase_revenue_in_usd,
  FROM
    `turing_data_analytics.raw_events`
  WHERE
    event_name = "purchase"),


  joined_table AS(  #The tables of registrations events and purchase events are joined
  SELECT
    registrations_table.*,
    purchase_table.purchase_week,
    purchase_table.purchase_revenue_in_usd
  FROM
    registrations_table
  LEFT JOIN
    purchase_table
  ON
    registrations_table.user_pseudo_id = purchase_table.user_pseudo_id)



SELECT     #For each row in the joined table, the difference in weeks between purchase date and registration date is calculated. If this number meets a condition, then the 
           #purchase value is summed, and then this sum is divided by the number of registrations in that week
           #This is done for a difference of 0 weeks all the way through to a difference of 12 weeks
  registration_week,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 0 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_0,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 1 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_1,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 2 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_2,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 3 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_3,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 4 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_4,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 5 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_5,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 6 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_6,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 7 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_7,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 8 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_8,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 9 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_9,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 10 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_10,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 11 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_11,
  SUM(CASE WHEN DATE_DIFF(purchase_week, registration_week, WEEK) = 12 THEN purchase_revenue_in_usd END) /COUNT(DISTINCT user_pseudo_id) AS week_12,
FROM
  joined_table
  
GROUP BY registration_week
ORDER BY registration_week
