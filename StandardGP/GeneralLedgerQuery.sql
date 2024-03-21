-- Write your own SQL object definition here, and it'll be included in your package.
USE [TWO16]
GO

/****** Object:  View [tk].[vw_GLTXR]    Script Date: 3/21/2024 8:54:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER   VIEW [tk].[vw_GLTXR]
AS
WITH CombinedTransactions AS (
    SELECT
        ACTINDX,
        OPENYEAR AS YEAR1,
        TRXDATE,
        JRNENTRY,
        ORTRXSRC,
        REFRENCE,
        ORDOCNUM,
        ORMSTRID,
        ORMSTRNM,
        DEBITAMT,
        DEBITAMT - CRDTAMNT AS Net,
        CRDTAMNT,
        CURNCYID,
        USWHPSTD
    FROM GL20000  -- Year-to-Date Transaction Open
    WHERE SOURCDOC NOT IN ('BBF', 'P/L') AND VOIDED = 0

    UNION ALL

    SELECT
        ACTINDX,
        HSTYEAR AS YEAR1,
        TRXDATE,
        JRNENTRY,
        ORTRXSRC,
        REFRENCE,
        ORDOCNUM,
        ORMSTRID,
        ORMSTRNM,
        DEBITAMT,
        DEBITAMT - CRDTAMNT AS Net,
        CRDTAMNT,
        CURNCYID,
        USWHPSTD
    FROM GL30000  -- Account Transaction History
    WHERE SOURCDOC NOT IN ('BBF', 'P/L') AND VOIDED = 0
)

SELECT
    YEAR1 AS Trx_Year,
    TRXDATE AS Trx_Date,
    JRNENTRY AS Journal_Entry,
    ORTRXSRC AS Originating_TRX_Source,
    REFRENCE AS Reference,
    ORMSTRID AS Originating_Master_ID,
    ORMSTRNM AS Originating_Master_Name,
    ORDOCNUM AS Originating_Doc_Number,
    DEBITAMT,
    CRDTAMNT AS Credit_Amount,
    Net AS Net_Amount,
    ACTNUMST AS Account_Number,
    ACTDESCR AS Account_Description,
    ACCATDSC AS Account_Category,
    CURNCYID AS Currency_ID,
    USWHPSTD AS User_Who_Posted
FROM CombinedTransactions AS GL
INNER JOIN GL00105 AS GM ON GL.ACTINDX = GM.ACTINDX
INNER JOIN GL00100 AS GA ON GL.ACTINDX = GA.ACTINDX
INNER JOIN GL00102 AS C ON GA.ACCATNUM = C.ACCATNUM;
GO


