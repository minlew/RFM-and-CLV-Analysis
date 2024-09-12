WITH
  totalled_table AS(
  SELECT
    CustomerID,
    CAST(InvoiceDate AS DATE) AS InvoiceDate,
    InvoiceNo,
    Quantity * UnitPrice AS Total  #Calculate total for each customer
  FROM
    `turing_data_analytics.rfm`
  WHERE
    InvoiceDate >= '2010-12-01'
    AND InvoiceDate <= '2011-12-01'   #Only include orders from 2010-12-01 to 2011-12-01
    AND CustomerID IS NOT NULL
    AND Quantity > 0),            #Remove orders with negative quantities
  
  
  rfm_table AS(
  SELECT
    CustomerID,
    DATE_DIFF(CAST('2011-12-01' AS DATE), MAX(InvoiceDate), DAY) AS R,    #Recency is time difference between the 'present day' i.e. 2011-12-01, and the invoice date
    COUNT(DISTINCT InvoiceNo) AS F,
    SUM(Total) AS M
  FROM
    totalled_table
  GROUP BY
    CustomerID),
  
  
  quartiled_table AS(    #Divide R,F and M values into quartiles
  SELECT
    APPROX_QUANTILES(R, 4) AS R_Quartiles,
    APPROX_QUANTILES(F, 4) AS F_Quartiles,
    APPROX_QUANTILES(M, 4) AS M_Quartiles
  FROM
    rfm_table),
  
  
  quartile_values_table AS(   #Assign each quartile boundary with a name
  SELECT
    R_Quartiles[1] AS R25,
    R_Quartiles[2] AS R50,
    R_Quartiles[3] AS R75,
    F_Quartiles[1] AS F25,
    F_Quartiles[2] AS F50,
    F_Quartiles[3] AS F75,
    M_Quartiles[1] AS M25,
    M_Quartiles[2] AS M50,
    M_Quartiles[3] AS M75,
  FROM
    quartiled_table),

  RFM_values_table AS(    #Give the RFM values a RFM score of 1 to 4 based on which quartile they fall into
  SELECT
  CASE
    WHEN R <= R25 THEN 4
    WHEN R <= R50 AND R > R25 THEN 3
    WHEN R <= R75 AND R > R50 THEN 2
    WHEN R > R75 THEN 1
  END
    AS R_score,
  CASE
    WHEN F <= F25 THEN 1
    WHEN F <= F50 AND F > F25 THEN 2
    WHEN F <= F75 AND F > F50 THEN 3
    WHEN F > F75 THEN 4
  END
    AS F_score,
  CASE
    WHEN M <= M25 THEN 1
    WHEN M <= M50 AND M > M25 THEN 2
    WHEN M <= M75 AND M > M50 THEN 3
    WHEN M > M75 THEN 4
  END
    AS M_score,
  FROM
    rfm_table,
    quartile_values_table),


  rfm_cell_table AS(
  SELECT *,
  (R_score + F_score + M_score) AS RFM_score,  #Sum RFM scores to get a score of 3 to 12
  CONCAT(R_score,F_score,M_score) AS RFM_cell  #Concatenate RFM scores to get a cell value
  FROM RFM_values_table)


SELECT *,  #Place the data into different segments based on their RFM cell
CASE 
  WHEN RFM_cell IN ("444","443","434","344","433","343","334") THEN "Best Customers"
  WHEN RFM_cell IN ("333") THEN "Loyal Customers"
  WHEN RFM_cell IN ("441","442","431","432","342","341","332","331") THEN "Potentially Loyal Customer"
  WHEN RFM_cell IN ("411","412","322","321","312","311") THEN "New Customers"
  WHEN RFM_cell IN ("421","424","423","422","414","413","324","323","313","314") THEN "Promising Customers" 
  WHEN RFM_cell IN ("113","114","133","213","214","144","143") THEN "Important Customers Being Lost"
  WHEN RFM_cell IN ("244","243","234","233","242","232","224","223","142","134","132","124","123") THEN "Customers At Risk"
  WHEN RFM_cell IN ("222","122","212","211") THEN "Hibernating Customers"
  WHEN RFM_cell IN ("111","112","121","131","141","221","241","231") THEN "Lost Customers"
  END AS Segment
FROM rfm_cell_table
