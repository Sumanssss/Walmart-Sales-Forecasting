USE Walmart_Sales;
 SELECT 
    t.Store,
    t.Dept,
    t.Date,
    t.Weekly_Sales,
    t.IsHoliday,
    f.Temperature,
    f.Fuel_Price,
    f.MarkDown1,
    f.MarkDown2,
    f.MarkDown3,
    f.MarkDown4,
    f.MarkDown5,
    f.CPI,
    f.Unemployment,
    s.Type AS Store_Type,
    s.Size AS Store_Size
INTO clean_train FROM train t
JOIN features f 
    ON t.Store = f.Store AND CAST(t.Date AS DATE) = CAST(f.Date AS DATE)
JOIN stores s 
    ON t.Store = s.Store;
--Check for NULLs
 SELECT COUNT(*) AS TotalRows,
       SUM(CASE WHEN MarkDown1 IS NULL THEN 1 ELSE 0 END) AS Null_MD1,
       SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS Null_CPI
FROM Clean_Train;
--handle missing values
UPDATE Clean_Train SET MarkDown1 = 0 WHERE MarkDown1 IS NULL;

--Analyze or Export Data
-- Total sales per store
SELECT Store, SUM(Weekly_Sales) AS TotalSales FROM Clean_Train GROUP BY Store ORDER BY TotalSales DESC;

-- Sales during holiday vs non-holiday
SELECT IsHoliday, AVG(Weekly_Sales) AS AvgSales FROM Clean_Train GROUP BY IsHoliday;

SELECT * FROM Clean_Train;
