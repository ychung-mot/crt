import axios from 'axios';

import store from './redux/store';

import { SHOW_ERROR_DIALOG_MODAL } from './redux/actions/types';
import { buildApiErrorObject } from './utils';
import * as Constants from './Constants';

export const instance = axios.create({
  baseURL: '/api',
  headers: { 'Access-Control-Allow-Origin': '*', Pragma: 'no-cache' },
});

instance.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (!error.response || error.response.status !== 422)
      store.dispatch({ type: SHOW_ERROR_DIALOG_MODAL, payload: buildApiErrorObject(error.response) });

    return Promise.reject(error);
  }
);

export const getCurrentUser = () => instance.get(Constants.API_PATHS.USER_CURRENT);
export const getUser = (id) => instance.get(`${Constants.API_PATHS.USER}/${id}`);
export const getUserStatuses = () => instance.get(Constants.API_PATHS.USER_STATUSES);
export const postUser = (userData) => instance.post(Constants.API_PATHS.USER, userData);
export const putUser = (id, userData) => instance.put(`${Constants.API_PATHS.USER}/${id}`, userData);
export const deleteUser = (id, endDate) =>
  instance.delete(`${Constants.API_PATHS.USER}/${id}`, { data: { id, endDate } });
export const searchUsers = (params) => instance.get(Constants.API_PATHS.USER, { params: { ...params } });
export const getUserAdAccount = (username) => instance.get(`${Constants.API_PATHS.USER_AD_ACCOUNT}/${username}`);

export const getRoles = () => instance.get(Constants.API_PATHS.ROLE);
export const getRole = (id) => instance.get(`${Constants.API_PATHS.ROLE}/${id}`);
export const searchRoles = (params) => instance.get(Constants.API_PATHS.ROLE, { params: { ...params } });
export const postRole = (roleData) => instance.post(Constants.API_PATHS.ROLE, roleData);
export const putRole = (id, roleData) => instance.put(`${Constants.API_PATHS.ROLE}/${id}`, roleData);
export const deleteRole = (id, endDate) =>
  instance.delete(`${Constants.API_PATHS.ROLE}/${id}`, { data: { id, endDate } });

export const getPermissions = () => instance.get(Constants.API_PATHS.PERMISSIONS);

//Projects
export const deleteProject = (id, endDate) =>
  instance.delete(`${Constants.API_PATHS.PROJECTS}/${id}`, { data: { id, endDate } });
export const getProjectManagers = () => instance.get(`${Constants.API_PATHS.PROJECT_MANAGERS}`);
export const postProject = (projectData) => instance.post(Constants.API_PATHS.PROJECTS, projectData);
export const getProject = (id) => instance.get(`${Constants.API_PATHS.PROJECTS}/${id}`);
export const putProject = (id, projectData) => instance.put(`${Constants.API_PATHS.PROJECTS}/${id}`, projectData);
export const postNote = (projectId, noteData) =>
  instance.post(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.NOTES}`, noteData);
export const getProjectPlan = (projectId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.PROJECT_PLAN}`);

//Projects FinTargets
export const getFinTarget = (projectId, finTargetId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.FIN_TARGETS}/${finTargetId}`);
export const postFinTarget = (projectId, finTargetData) =>
  instance.post(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.FIN_TARGETS}`, finTargetData);
export const putFinTarget = (projectId, finTargetId, finTargetData) =>
  instance.put(
    `${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.FIN_TARGETS}/${finTargetId}`,
    finTargetData
  );
export const deleteFinTarget = (projectId, finTargetId) =>
  instance.delete(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.FIN_TARGETS}/${finTargetId}`);

//Projects QtyAccmps
export const getQtyAccmp = (projectId, qtyAccmpId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.QTY_ACCMPS}/${qtyAccmpId}`);
export const postQtyAccmp = (projectId, qtyAccmpData) =>
  instance.post(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.QTY_ACCMPS}`, qtyAccmpData);
export const putQtyAccmp = (projectId, qtyAccmpId, qtyAccmpData) =>
  instance.put(
    `${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.QTY_ACCMPS}/${qtyAccmpId}`,
    qtyAccmpData
  );
export const deleteQtyAccmp = (projectId, qtyAccmpId) =>
  instance.delete(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.QTY_ACCMPS}/${qtyAccmpId}`);

//Projects Tender
export const getProjectTender = (projectId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.PROJECT_TENDER}`);
export const getTender = (projectId, tenderId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.TENDER}/${tenderId}`);
export const postTender = (projectId, tenderData) =>
  instance.post(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.TENDER}`, tenderData);
export const putTender = (projectId, tenderId, tenderData) =>
  instance.put(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.TENDER}/${tenderId}`, tenderData);
export const deleteTender = (projectId, tenderId) =>
  instance.delete(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.TENDER}/${tenderId}`);

//Projects Locations/Segments/Ratios
export const getProjectLocations = (projectId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.PROJECT_LOCATION}`);
export const postSegment = (projectId, segmentData) =>
  instance.post(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.PROJECT_SEGMENT}`, segmentData);
export const getSegments = (projectId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.PROJECT_SEGMENT}`);
export const deleteSegment = (projectId, segmentId) =>
  instance.delete(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.PROJECT_SEGMENT}/${segmentId}`);
export const getRatio = (projectId, ratioId) =>
  instance.get(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.RATIO}/${ratioId}`);
export const postRatio = (projectId, ratioData) =>
  instance.post(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.RATIO}`, ratioData);
export const deleteRatio = (projectId, ratioId) =>
  instance.delete(`${Constants.API_PATHS.PROJECTS}/${projectId}${Constants.API_PATHS.RATIO}/${ratioId}`);
export const putRatio = (projectid, ratioId, ratioData) =>
  instance.put(`${Constants.API_PATHS.PROJECTS}/${projectid}${Constants.API_PATHS.RATIO}/${ratioId}`, ratioData);

//Code Table
export const getCodeTable = (codeTableId) => instance.get(`${Constants.API_PATHS.CODE_TABLE}/${codeTableId}`);
export const postCodeTable = (codeTableData) => instance.post(`${Constants.API_PATHS.CODE_TABLE}`, codeTableData);
export const putCodeTable = (codeTableId, codeTableData) =>
  instance.put(`${Constants.API_PATHS.CODE_TABLE}/${codeTableId}`, codeTableData);
export const deleteCodeTable = (codeTableId) => instance.delete(`${Constants.API_PATHS.CODE_TABLE}/${codeTableId}`);

//Lookups
export const getRegions = () => instance.get(Constants.API_PATHS.REGIONS);
export const getDistricts = () => instance.get(Constants.API_PATHS.DISTRICTS);
export const getServiceAreas = () => instance.get(Constants.API_PATHS.SERVICE_AREAS);

//Code Lookups
export const getCapitalIndexes = () => instance.get(Constants.API_PATHS.CAPITAL_INDEXES);
export const getRCNumbers = () => instance.get(Constants.API_PATHS.RC_NUMBERS);
export const getNearestTowns = () => instance.get(Constants.API_PATHS.NEAREST_TOWNS);
export const getFiscalYears = () => instance.get(Constants.API_PATHS.FISCAL_YEARS);
export const getQuantities = () => instance.get(Constants.API_PATHS.QUANTITIES);
export const getAccomplishments = () => instance.get(Constants.API_PATHS.ACCOMPLISHMENTS);
export const getPhases = () => instance.get(Constants.API_PATHS.PHASES);
export const getContractors = () => instance.get(Constants.API_PATHS.CONTRACTORS);
export const getFundingTypes = () => instance.get(Constants.API_PATHS.FUNDING_TYPES);
export const getElements = () => instance.get(Constants.API_PATHS.ELEMENTS);
export const getRatioRecordTypes = () => instance.get(Constants.API_PATHS.RATIO_RECORDS_TYPES);
export const getElectoralDistricts = () => instance.get(Constants.API_PATHS.ELECTORAL_DISTRICTS);
export const getHighways = () => instance.get(Constants.API_PATHS.HIGHWAYS);
export const getEconomicRegions = () => instance.get(Constants.API_PATHS.ECONOMIC_REGIONS);
export const getCodesets = () => instance.get(Constants.API_PATHS.CODESETS);

export const getApiClient = () => instance.get(`${Constants.API_PATHS.USER}/api-client`);
export const createApiClient = () => instance.post(`${Constants.API_PATHS.USER}/api-client`);
export const resetApiClientSecret = () => instance.post(`${Constants.API_PATHS.USER}/api-client/secret`);

export const getVersion = () => instance.get(Constants.API_PATHS.VERSION);
