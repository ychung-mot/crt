/*** Scripts to retrieve data, inject into appropriate worksheet of excel workbook ./Mapping.xslx

-- retrieve values from Legacy table
SELECT ID, Category FROM tblCategories
WHERE Active = 1
ORDER BY Category

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'PROGRAM_CATEGORY'
AND END_DATE IS NULL
ORDER BY CODE_NAME

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_PROGRAM_CATEGORY', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_PROGRAM_CATEGORY;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_PROGRAM_CATEGORY
(
	LEGACY_ID numeric(9, 0) NOT NULL,
	CRT_ID numeric(9, 0) NOT NULL
)  ON [PRIMARY]

COMMIT
GO

BEGIN TRANSACTION
SET NOCOUNT ON

INSERT INTO MAP_CATEGORY VALUES (1, 890);  --Capital  > Capital Expansion
INSERT INTO MAP_CATEGORY VALUES (4, 894);  --Unclassified > Other
INSERT INTO MAP_CATEGORY VALUES (2, 891);  --Preservation > Preservation
INSERT INTO MAP_CATEGORY VALUES (6, 892);  --Stimulus > Stimulus
INSERT INTO MAP_CATEGORY VALUES (3, 893);  --Transit > Transit

COMMIT
GO


DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) 
FROM tblAccomplishments
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'PHASE'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_PHASE

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_PHASE

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjects
	WHERE [Project Phase] IN (SELECT ID FROM 
		(SELECT * FROM MAP_PHASE mp
		RIGHT JOIN tblProjectPhases pp
		ON pp.ID = mp.LEGACY_ID
		WHERE pp.Active = 1) AS Phase
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Projects linked to un-mapped Phases'
END

/*
-- Should find zero!

SELECT *
FROM tblProjects
WHERE [Project Phase] IN (SELECT ID FROM 
	(SELECT * FROM MAP_PHASE mp
	RIGHT JOIN tblProjectPhases pp
	ON pp.ID = mp.LEGACY_ID
	WHERE pp.Active = 1) AS Phase
	WHERE LEGACY_ID IS NULL)
*/
