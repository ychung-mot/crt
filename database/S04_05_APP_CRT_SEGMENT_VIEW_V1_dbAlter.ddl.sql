/*
	Name: Ayodeji Kuponiyi
	Date: 04/03/2021
*/

/*
	veiw to display segment records on the pop-up map
*/

USE CRT_DEV;
GO


CREATE or ALTER VIEW [DBO].[SEGMENT_RECORD]
AS
	SELECT
		cp.project_name,
		cs.segment_id,
		cs.project_id,
		cs.description,
		cs.geometry

	FROM
		[DBO].[CRT_SEGMENT]	cs,
		[DBO].[CRT_PROJECT]	cp

	WHERE cs.PROJECT_ID = cp.PROJECT_ID;