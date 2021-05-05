/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S09_01_APP_CRT_V1.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-05-03 15:39                                */
/* ---------------------------------------------------------------------- */

USE CRT_DEV;
GO

/* ---------------------------------------------------------------------- */
/* Repair/add views                                                       */
/* ---------------------------------------------------------------------- */

CREATE OR ALTER VIEW [dbo].[CRT_PROGRAM_PROJECT_FINANCIALS_VW] AS

SELECT 
      prj.PROJECT_ID
      ,fin_t.FIN_TARGET_ID
      ,fy_code.CODE_NAME												AS FIN_TARGET_FISCAL_YEAR
      ,PH.CODE_VALUE_TEXT 												AS PRJ_PHASE_CODE
      ,PH.CODE_NAME														AS PRJ_PHASE_DESC
	  ,FT.CODE_VALUE_TEXT 												AS FUNDING_TYPE_CODE
      ,FT.CODE_NAME														AS FUNDING_TYPE_DESC					
      ,fin_t.AMOUNT														AS FIN_TARGET_AMOUNT
      ,fin_t.DESCRIPTION												AS FIN_TARGET_DESCRIPTION
      ,fin_t.END_DATE													AS FIN_TARGET_END_DATE
      ,PRG_CTGRY.CODE_VALUE_TEXT 									    AS PRG_CTGRY_CODE
      ,PRG_CTGRY.CODE_NAME												AS PROGRAM_GATEGORY
	  ,prg_elm.PROGRAM_LKUP_ID
      ,PROGRAM_LKUP.CODE_VALUE_TEXT 									AS PROGRAM_CODE
      ,PROGRAM_LKUP.CODE_NAME											AS PROGRAM_DESC 
      ,SL.CODE_VALUE_TEXT 												AS FIN_TARGET_SERVICE_LINE_CODE
      ,SL.CODE_NAME														AS FIN_TARGET_SERVICE_LINE_DESC
      ,SL.END_DATE														AS SERVICE_LINE_END_DATE
      ,fin_t.ELEMENT_ID
	  ,prg_elm.CODE														AS FIN_TARGET_PRG_ELEMENT
      ,prg_elm.DESCRIPTION												AS FIN_TARGET_PRG_ELEMENT_DESCRIPTION
      ,prg_elm.END_DATE													AS PRG_ELEMENT_END_DATE
	  ,fin_t.APP_LAST_UPDATE_USERID										AS UPDATED_BY
	  ,fin_t.APP_LAST_UPDATE_TIMESTAMP									AS UPDATED_ON
      ,fin_t.DB_AUDIT_CREATE_TIMESTAMP									AS FIN_TARGET_DB_AUDIT_CREATE_TIMESTAMP
      ,fin_t.DB_AUDIT_LAST_UPDATE_TIMESTAMP								AS FIN_TARGET_DB_AUDIT_LAST_UPDATE_TIMESTAMP
	FROM CRT_PROJECT   prj 
	LEFT OUTER JOIN CRT_FIN_TARGET fin_t ON prj.PROJECT_ID = fin_t.PROJECT_ID
	LEFT OUTER JOIN CRT_ELEMENT prg_elm ON fin_t.ELEMENT_ID = prg_elm.ELEMENT_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP fy_code ON fin_t.FISCAL_YEAR_LKUP_ID = fy_code.CODE_LOOKUP_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP PROGRAM_LKUP ON prg_elm.PROGRAM_LKUP_ID = PROGRAM_LKUP.CODE_LOOKUP_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP PRG_CTGRY ON prg_elm.PROGRAM_CATEGORY_LKUP_ID = PRG_CTGRY.CODE_LOOKUP_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP SL ON prg_elm.SERVICE_LINE_LKUP_ID = SL.CODE_LOOKUP_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP PH ON fin_t.PHASE_LKUP_ID = PH.CODE_LOOKUP_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP FT ON fin_t.FUNDING_TYPE_LKUP_ID = FT.CODE_LOOKUP_ID;
GO


CREATE  OR ALTER VIEW [dbo].[CRT_PRJ_QTY_ACCOMPLISHMENTS_VW] AS

  SELECT 
      prj.PROJECT_ID
      ,qac.QTY_ACCMP_ID
      ,fy_code.CODE_NAME												AS QTY_ACCMP_FISCAL_YEAR
      ,ACCMP_code.CODE_SET												AS QTY_ACCMP_TYPE
      ,ACCMP_code.CODE_VALUE_TEXT 										AS QTY_ACCMP_CODE
      ,ACCMP_code.CODE_NAME												AS QTY_ACCMP_DESC
      ,qac.FORECAST														AS QTY_ACCMP_FORECAST
      ,qac.SCHEDULE7													AS QTY_ACCMP_SCHEDULE7
      ,qac.ACTUAL														AS QTY_ACCMP_ACTUAL
      ,qac.COMMENT														AS QTY_ACCMP_COMMENT
      ,qac.END_DATE														AS QTY_ACCMP_END_DATE
      ,qac.DB_AUDIT_CREATE_TIMESTAMP									AS QTY_ACCMP_DB_AUDIT_CREATE_TIMESTAMP
      ,qac.DB_AUDIT_LAST_UPDATE_TIMESTAMP								AS QTY_ACCMP_DB_AUDIT_LAST_UPDATE_TIMESTAMP 
	  ,qac.APP_LAST_UPDATE_USERID										AS UPDATED_BY
	  ,qac.APP_LAST_UPDATE_TIMESTAMP									AS UPDATED_ON
	FROM CRT_PROJECT   prj  
	INNER JOIN   CRT_QTY_ACCMP qac ON prj.PROJECT_ID = qac.PROJECT_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP fy_code ON qac.FISCAL_YEAR_LKUP_ID = fy_code.CODE_LOOKUP_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP ACCMP_code ON qac.QTY_ACCMP_LKUP_ID = ACCMP_code.CODE_LOOKUP_ID;
GO


CREATE  OR ALTER VIEW [dbo].[CRT_PROJECT_TENDERS_VW] AS

SELECT
	   prj.PROJECT_ID
      ,tbd.[TENDER_ID]
      ,tbd.[TENDER_NUMBER]
      ,tbd.[PLANNED_DATE]
      ,tbd.[ACTUAL_DATE]
      ,tbd.[TENDER_VALUE]
      ,win_cntr_code.CODE_NAME 											AS WINNING_CONTRACTOR
      ,tbd.[BID_VALUE]
      ,tbd.[COMMENT]													AS TENDER_COMMENT
FROM	CRT_PROJECT						prj
	LEFT OUTER JOIN CRT_TENDER	tbd ON tbd.PROJECT_ID = prj.PROJECT_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP win_cntr_code ON win_cntr_code.CODE_LOOKUP_ID = tbd.WINNING_CNTRCTR_LKUP_ID;
GO


CREATE  OR ALTER VIEW [dbo].[CRT_PROJECT_SEGMENTS_VW] AS

SELECT
	   prj.PROJECT_ID
      ,seg.[SEGMENT_ID]
      ,seg.[START_LATITUDE]
      ,seg.[START_LONGITUDE]
      ,seg.[END_LATITUDE]
      ,seg.[END_LONGITUDE]
      ,seg.[GEOMETRY]
      ,seg.[DESCRIPTION]                                                   	AS SEGMENT_DESCRIPTION

FROM
	CRT_PROJECT		prj
			LEFT OUTER JOIN CRT_SEGMENT	seg ON seg.PROJECT_ID = prj.PROJECT_ID;
GO


CREATE  OR ALTER VIEW [dbo].[CRT_PROJECT_NOTES_VW] AS

SELECT
	   prj.PROJECT_ID
      ,nte.[NOTE_ID]
      ,nte.[NOTE_TYPE]
      ,CAST (nte.APP_CREATE_TIMESTAMP as date)								AS NOTE_CREATE_DATE													
      ,nte.APP_CREATE_USERID
      ,nte.[COMMENT]                                                        AS NOTES
	  
	FROM  	CRT_PROJECT   prj
    LEFT OUTER JOIN CRT_NOTE nte 			ON nte.PROJECT_ID = prj.PROJECT_ID;
GO


CREATE  OR ALTER VIEW [dbo].[CRT_PROJECT_VW] AS

SELECT
	   prj.[PROJECT_ID]
      ,prj.[PROJECT_NUMBER]
      ,prj.[PROJECT_NAME]
      ,prj.[DESCRIPTION]										AS PRJ_DESCRIPTION
	  ,prj.[SCOPE]												AS PRJ_SCOPE
	  ,cr.[REGION_NUMBER]
	  ,cr.[REGION_NAME] 
      ,cap_indx.[CODE_VALUE_TEXT]  								AS CAP_INDX_CODE
      ,cap_indx.[CODE_NAME]  									AS CAP_INDX_DESC
	  ,twn.[CODE_VALUE_TEXT]		 							AS NEAREST_TWN_CODE
      ,twn.[CODE_NAME]											AS NEAREST_TWN_DESC      
	  ,rc.[CODE_VALUE_TEXT]										AS RC_CODE
      ,rc.[CODE_NAME]  											AS RC_DESC
	  ,prj_mgr.[CODE_VALUE_TEXT] 								AS PROJECT_MGR_CODE
      ,prj_mgr.[CODE_NAME] 										AS PROJECT_MGR_DESC
      ,prj.[ANNCMENT_VALUE]
      ,prj.[C035_VALUE]
      ,prj.[ANNCMENT_COMMENT]
      ,prj.[ESTIMATED_VALUE]
	FROM CRT_PROJECT   prj
	LEFT OUTER JOIN CRT_REGION cr 				ON cr.REGION_ID = prj.REGION_ID
	LEFT OUTER JOIN CRT_CODE_LOOKUP cap_indx 	ON cap_indx.CODE_LOOKUP_ID = prj.CAP_INDX_LKUP_ID 
	LEFT OUTER JOIN CRT_CODE_LOOKUP twn 		ON twn.CODE_LOOKUP_ID = prj.NEARST_TWN_LKUP_ID 
	LEFT OUTER JOIN CRT_CODE_LOOKUP rc 			ON rc.CODE_LOOKUP_ID = prj.RC_LKUP_ID 
	LEFT OUTER JOIN CRT_CODE_LOOKUP prj_mgr 	ON prj_mgr.CODE_LOOKUP_ID = prj.PROJECT_MGR_LKUP_ID ;
GO

