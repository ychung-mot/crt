export const HELPER_TEXT = {
  //projects
  projectNumber: `Manually assigned by financial ee's using an H0277 form`,
  projectName: `Typically created by project manager using project naming conventions`,
  description: `Non-technical description of the project; meant for public consumption`,
  scope: `Technical description, meant for internal consumption`,
  capIndxLkupId: `A value assigned to indicate whether expenditures related to a project are capitalizable (contributes to extending the life of an asset) or expensable (does not materially contribute to extending the life of an asset)`,
  rcLkupId: `Financial Code`,
  projectMgrLkupId: `Key contact for the project`,
  nearstTwnLkupId: `Used to report on project outcomes`,
  endDate: `Is project complete`,
  tenderNumber: `Identifier for the tender <project#>-####`,
  plannedDate: `Planned date for posting Tender at Provincial Contracts`,
  actualDate: `Actual date for posting Tender at Provincial Contracts`,
  tenderValue: `Estimated dollar value of contract`,
  winningCntrctrLkupId: `Contractor that wins the tender`,
  bidValue: `Dollar value of the winning bid`,
  anncmentValue: `Project value as communicated through announcement done by GCPE`,
  c035Value: `Value on the road side signs for the project value`,
  anncmentComment: `Comments on project announcements`,
  // temporary fix remove when estimated value is implemented
  estimatedValue: `THIS FIELD IS NOT ACTIVE YET Project Value determined through available information, in the absence of formal announcement and/or C-035 Values`,

  //codetables
  codeValueText: `Representative values for descriptive fields (e.g. C for Construct). For records with no such values this field can be left empty, and just Code Name can be provide, (e.g. names of towns)`,
  codeName: `Description for Code Value (e.g. Construct), or independent look up value where no code value is applicable (e.g. Town names - Abbotsford)`,

  //elements
  elementCode: `Code representing the program and funding association`,
  elementDescription: `Detailed text explaining project element`,
  programCategoryLkupId: `The funding vertical within which the element belongs (e.g. Transit, Preservation, Capital)`,
  programLkupId: `The program within the program category to which the element belongs (e.g. RSIP, SRIP)`,
  serviceLineLkupId: `Code to which Element is charged`,
};
