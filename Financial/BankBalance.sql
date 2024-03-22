use two16
go
CREATE VIEW silver.vwBankBalance AS
SELECT dbo.GL00105.ACTNUMST AS 'Account_Number',
       dbo.GL00100.ACTDESCR AS 'Account_Name',
       dbo.CM00100.CHEKBKID AS 'Checkbook_ID',
       dbo.CM00100.CURRBLNC AS 'Current_Bank_Balance',
       dbo.GL20000.JRNENTRY AS 'Journal_Number',
       dbo.GL20000.TRXDATE AS 'Transaction_Date',
       YEAR(dbo.GL20000.TRXDATE) AS 'Transaction_Year',
       MONTH(dbo.GL20000.TRXDATE) AS 'Transaction_Month',
       CASE dbo.GL20000.SERIES
           WHEN 2 THEN dbo.GL20000.REFRENCE
           ELSE dbo.GL20000.ORMSTRNM
       END AS 'Source_Name',
       dbo.GL20000.DEBITAMT AS 'Debit',
       dbo.GL20000.CRDTAMNT AS 'Credit',
       dbo.GL20000.DEBITAMT - dbo.GL20000.CRDTAMNT AS 'Net',
       CASE
           WHEN (dbo.GL20000.DEBITAMT - dbo.GL20000.CRDTAMNT) < 0 THEN 'Decrease'
           ELSE 'Increase'
       END AS Effect,
       CASE dbo.GL20000.SERIES
           WHEN 2 THEN 'Financial'
           WHEN 3 THEN 'Sales'
           WHEN 4 THEN 'Purchasing'
           WHEN 5 THEN 'Inventory'
           WHEN 6 THEN 'Payroll'
           WHEN 7 THEN 'Project'
           ELSE 'Other'
       END AS Series,
       dbo.GL20000.ORPSTDDT AS 'Date_Posted',
       dbo.GL20000.SOURCDOC
FROM dbo.GL20000
INNER JOIN dbo.GL00100 ON dbo.GL20000.ACTINDX = dbo.GL00100.ACTINDX
INNER JOIN dbo.GL00105 ON dbo.GL00100.ACTINDX = dbo.GL00105.ACTINDX
INNER JOIN dbo.CM00100 ON dbo.GL00105.ACTINDX = dbo.CM00100.ACTINDX
WHERE (dbo.GL20000.VOIDED = 0)
  AND (dbo.GL20000.SOURCDOC <> 'BBF')
UNION
SELECT dbo.GL00105.ACTNUMST AS 'Account_Number',
       dbo.GL00100.ACTDESCR AS 'Account_Name',
       dbo.CM00100.CHEKBKID AS 'Checkbook_ID',
       dbo.CM00100.CURRBLNC AS 'Current_Bank_Balance',
       dbo.GL30000.JRNENTRY AS 'Journal_Number',
       dbo.GL30000.TRXDATE AS 'Transaction_Date',
       YEAR(dbo.GL30000.TRXDATE) AS 'Transaction_Year',
       MONTH(dbo.GL30000.TRXDATE) AS 'Transaction_Month',
       CASE dbo.GL30000.SERIES
           WHEN 2 THEN dbo.GL30000.REFRENCE
           ELSE dbo.GL30000.ORMSTRNM
       END AS 'Source_Name',
       dbo.GL30000.DEBITAMT AS 'Debit',
       dbo.GL30000.CRDTAMNT AS 'Credit',
       dbo.GL30000.DEBITAMT - dbo.GL30000.CRDTAMNT AS 'Net',
       CASE
           WHEN (dbo.GL30000.DEBITAMT - dbo.GL30000.CRDTAMNT) < 0 THEN 'Decrease'
           ELSE 'Increase'
       END AS Effect,
       CASE dbo.GL30000.SERIES
           WHEN 2 THEN 'Financial'
           WHEN 3 THEN 'Sales'
           WHEN 4 THEN 'Purchasing'
           WHEN 5 THEN 'Inventory'
           WHEN 6 THEN 'Payroll'
           WHEN 7 THEN 'Project'
           ELSE 'Other'
       END AS Series,
       dbo.GL30000.ORPSTDDT AS 'Date_Posted',
       dbo.GL30000.SOURCDOC
FROM dbo.GL30000
INNER JOIN dbo.GL00100 ON dbo.GL30000.ACTINDX = dbo.GL00100.ACTINDX
INNER JOIN dbo.GL00105 ON dbo.GL00100.ACTINDX = dbo.GL00105.ACTINDX
INNER JOIN dbo.CM00100 ON dbo.GL00105.ACTINDX = dbo.CM00100.ACTINDX
WHERE (dbo.GL30000.VOIDED = 0)
  AND (dbo.GL30000.SOURCDOC <> 'BBF') 
