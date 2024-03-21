CREATE VIEW [dbo].[vwGeneralAccount]
 AS
	Select distinct
    CONCAT(rtrim([ACTNUMBR_1]), '-', rtrim([ACTNUMBR_2]), '-', rtrim([ACTNUMBR_3])) as ACCTIDNUM
     , ['Account Summary Master View'].[ACCATNUM]
     , [MNACSGMT]
     , [ACTDESCR]
     , [PSTNGTYP]
     , case
           when [PSTNGTYP] = '0' then
               'Balance Sheet'
           else
               'Profit and Loss'
       END   as PSTYPEdESCR
     , ['Account Category Master'].ACCATDSC
FROM GL11110  AS ['Account Summary Master View']
    INNER JOIN GL00102 AS ['Account Category Master']
        ON ['Account Summary Master View'].ACCATNUM = ['Account Category Master'].ACCATNUM
GO
