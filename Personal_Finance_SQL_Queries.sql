--First view of imported data.

SELECT*
FROM Dick_and_Jane..Dick_and_Jane

--Use of DROP COLUMN function to get rid of F5 and F6 columns that were created upon import.

ALTER TABLE Dick_and_Jane..Dick_and_Jane
DROP COLUMN F5

ALTER TABLE Dick_and_Jane..Dick_and_Jane
DROP COLUMN F6

--Confirm unwanted columns were successfully removed.

SELECT*
FROM Dick_and_Jane..Dick_and_Jane

--Use of CAST function to remove unnecessary time stamp.

SELECT CAST(Date_of_Transaction as date) as Transaction_Date, Company_Name, Transaction_Amount, Expense_Category 
FROM Dick_and_Jane..Dick_and_Jane
ORDER BY Transaction_Date

--Total expenses for six month range of transaction history.

SELECT Expense_Category, SUM(Transaction_Amount) as Category_Total
FROM Dick_and_Jane..Dick_and_Jane
GROUP by Expense_Category

--View totals of each category by month sorted chronologically by month through the use of a CTE.

WITH CTE_DandJ as (
SELECT DATENAME(MONTH, Date_of_Transaction) as Calendar_Month, Transaction_Amount, Expense_Category
FROM Dick_and_Jane..Dick_and_Jane
)
SELECT Expense_Category, Calendar_Month, SUM(Transaction_Amount) as Monthly_Total
FROM CTE_DandJ
GROUP BY Calendar_Month, Expense_Category
ORDER BY 
	CASE
		WHEN Calendar_Month = 'February' THEN 1
		WHEN Calendar_Month = 'March' THEN 2
		WHEN Calendar_Month = 'April' THEN 3
		WHEN Calendar_Month = 'May' THEN 4
		WHEN Calendar_Month = 'June' THEN 5
		WHEN Calendar_Month = 'July' THEN 6
		WHEN Calendar_Month = 'August' THEN 7
		ELSE NULL
		END

--Monthly totals for grocery vs dining out
WITH CTE_DandJ as (
SELECT DATENAME(MONTH, Date_of_Transaction) as Calendar_Month, Transaction_Amount, Expense_Category
FROM Dick_and_Jane..Dick_and_Jane
WHERE Expense_Category = 'Grocery' OR Expense_Category = 'Dining Out'
)
SELECT Expense_Category, Calendar_Month, SUM(Transaction_Amount) as Monthly_Total
FROM CTE_DandJ
GROUP BY Calendar_Month, Expense_Category
ORDER BY 
	CASE
		WHEN Calendar_Month = 'February' THEN 1
		WHEN Calendar_Month = 'March' THEN 2
		WHEN Calendar_Month = 'April' THEN 3
		WHEN Calendar_Month = 'May' THEN 4
		WHEN Calendar_Month = 'June' THEN 5
		WHEN Calendar_Month = 'July' THEN 6
		WHEN Calendar_Month = 'August' THEN 7
		ELSE NULL
		END

--Determine total debt paid over the last six months
SELECT SUM(Transaction_Amount) as Debt_Paid, Expense_Category
FROM Dick_and_Jane..Dick_and_Jane
WHERE Expense_Category = 'Debt'
GROUP BY Expense_Category
