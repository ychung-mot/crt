/*** Scripts to retrieve data, inject into appropriate worksheet of excel workbook ./Mapping.xslx

-- retrieve values from Legacy table
SELECT ID, [Accomplishment Type] FROM tblAccomplishments
WHERE Active = 1 
OR ID = 30	-- 30 is inactive but referened by accomplishments table
ORDER BY [Accomplishment Type]

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE (CODE_SET = 'ACCOMPLISHMENT' OR CODE_SET = 'QUANTITY')
AND END_DATE IS NULL
ORDER BY CODE_NAME

***/

BEGIN TRANSACTION
IF OBJECT_ID('dbo.MAP_ACCOMPLISHMENT', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_ACCOMPLISHMENT;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_ACCOMPLISHMENT
(
	LEGACY_ID numeric(9, 0) NOT NULL,
	CRT_ID numeric(9, 0) NOT NULL
)  ON [PRIMARY]

COMMIT
GO

BEGIN TRANSACTION
SET NOCOUNT ON;

/*** Generated Inserts Go Here ***/
INSERT INTO MAP_ACCOMPLISHMENT VALUES (43, 718);  --Active Transportation Project 
INSERT INTO MAP_ACCOMPLISHMENT VALUES (18, 714);  --Asphalt Mix  (tonnes)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (40, 719);  --Bridge Installed, New  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (21, 720);  --Bridge Rehabbed  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (27, 721);  --Bridge Replaced  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (22, 722);  --Bridge Resurfaced  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (29, 723);  --Concrete Overlay  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (47, 724);  --Culvert <3m  (lineal m)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (39, 725);  --Culvert 3m+ Rehabbed  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (38, 726);  --Culvert 3m+ Replaced  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (8, 728);  --Durable Pavement Marking  (linear m)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (37, 727);  --Durable Pavement Marking  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (10, 729);  --Fencing Rehabbed  - Shoulder (linear m)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (12, 730);  --First Time HS  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (45, 735);  --Hwy - GAS/Seal Coat  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (44, 715);  --Hwy - GAS/Seal Coat  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (49, 1218);  --Gravel in Stockpile  (m3)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (30, 1218);  --Gravel in Stockpile  (m3)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (14, 731);  --Gravelled roads  (km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (4, 732);  --Guardrail  (linear m)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (31, 733);  --High Friction Surface  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (1, 717);  --Hot in Place  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (9, 734);  --Hwy - Asphalt  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (41, 735);  --Hwy - GAS/Seal Coat  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (2, 715);  --Hwy - GAS/Seal Coat  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (16, 736);  --Hwy - HIP  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (19, 737);  --Intersection Improved  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (46, 738);  --Jobs Created (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (11, 739);  --New Fencing  (linear m)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (15, 740);  --New Guardrail  (linear m)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (28, 741);  --Passing Lanes  (km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (20, 742);  --RAP  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (48, 743);  --RIP RAP  (m3)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (50, 744);  --Road strengthening  (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (23, 746);  --Rumble Strip - Centerline (km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (7, 745);  --Rumble Strip - Shoulder (km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (25, 747);  --Seismic Upgrade  (each)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (33, 748);  --Shoulder Improvements  - CenterLine (km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (35, 749);  --Side - Asphalt  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (42, 750);  --Side - GAS/Seal Coat  (lane km)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (34, 716);  --Side - GAS/Seal Coat (m2)
INSERT INTO MAP_ACCOMPLISHMENT VALUES (36, 751);  --Side - HIP  (lane km)

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
WHERE CODE_SET = 'ACCOMPLISHMENT'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_ACCOMPLISHMENT

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_ACCOMPLISHMENT

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjectAccomplishments 
    WHERE Accomplishment IN (SELECT ID FROM 
		(SELECT * FROM MAP_ACCOMPLISHMENT ma
		RIGHT JOIN tblAccomplishments ta
		ON ta.ID = ma.LEGACY_ID
		WHERE ta.Active = 1) AS QtyAccomp
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Project Accomplishments linked to un-mapped QtyAccomp'
END

/*
-- Found 7 Project Accomplishments linked to un-mapped QtyAccomp

SELECT *
  FROM tblProjectAccomplishments
WHERE Accomplishment IN (SELECT ID FROM 
(SELECT * FROM MAP_ACCOMPLISHMENT ma
RIGHT JOIN tblAccomplishments ta
ON ta.ID = ma.LEGACY_ID
WHERE ta.Active = 1) AS QtyAccomp
WHERE LEGACY_ID IS NULL)
*/
