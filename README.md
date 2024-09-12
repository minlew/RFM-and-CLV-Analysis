# RFM and CLV Analysis

## Project Description

This project contains SQL queries, Excel sheets, and Power BI visualizations for performing RFM (Recency, Frequency, Monetary) analysis and Customer Lifetime Value (CLV) calculations on a dataset.

## Project Components
1. SQL Queries:
    * RFM Query.sql: Performs RFM analysis on customer data
    * CLV Query.sql: Calculates Customer Lifetime Value
2. Excel Spreadsheet:
    * Contains processed data and additional calculations
3. Power BI Dashboard:
    * Visualizes the results of the RFM and CLV analyses

## RFM Analysis Query
1. Calculates total revenue for each customer
2. Computes RFM values:
    * Recency: Days since last purchase
    * Frequency: Number of purchases
    * Monetary: Total amount spent
3. Divides RFM values into quartiles
4. Assigns RFM scores (1-4) based on quartiles
5. Calculates overall RFM score and RFM cell
6. Segments customers based on their RFM cell

## CLV Analysis Query
1. Identifies user registration dates.
2. Tracks purchase events and revenue.
3. Calculates weekly revenue per user for the first 13 weeks after registration.
4. Provides a cohort analysis of customer value over time.

## Requirements
* SQL environment to run the queries.
* Power BI Desktop to view the .pbix file.
* A spreadsheet viewer to view the .xlsx file
* Dataset stored in Google BigQuery (based on the SQL references).

## Notes
* The RFM analysis covers the period from 2010-12-01 to 2011-12-01
* The CLV analysis tracks customer value for the first 13 weeks after registration
