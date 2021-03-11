import {
  FETCH_CAPITAL_INDEXES,
  FETCH_RC_NUMBERS,
  FETCH_NEAREST_TOWNS,
  FETCH_PHASES,
  FETCH_FISCAL_YEARS,
  FETCH_QUANTITIES,
  FETCH_ACCOMPLISHMENTS,
  FETCH_CONTRACTORS,
  FETCH_FUNDING_TYPES,
  FETCH_RATIO_RECORD_TYPES,
  FETCH_ELECTORAL_DISTRICTS,
  FETCH_HIGHWAYS,
  FETCH_ECONOMIC_REGIONS,
  FETCH_CODESETS,
} from './types';

import * as api from '../../Api';

export const fetchCapitalIndexes = () => (dispatch) => {
  return api.getCapitalIndexes().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_CAPITAL_INDEXES, payload: data });
  });
};

export const fetchRCNumbers = () => (dispatch) => {
  return api.getRCNumbers().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_RC_NUMBERS, payload: data });
  });
};

export const fetchNearestTowns = () => (dispatch) => {
  return api.getNearestTowns().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_NEAREST_TOWNS, payload: data });
  });
};

export const fetchFiscalYears = () => (dispatch) => {
  return api.getFiscalYears().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_FISCAL_YEARS, payload: data });
  });
};

export const fetchQuantities = () => (dispatch) => {
  return api.getQuantities().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_QUANTITIES, payload: data });
  });
};

export const fetchAccomplishments = () => (dispatch) => {
  return api.getAccomplishments().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_ACCOMPLISHMENTS, payload: data });
  });
};

export const fetchPhases = () => (dispatch) => {
  return api.getPhases().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_PHASES, payload: data });
  });
};

export const fetchContractors = () => (dispatch) => {
  return api.getContractors().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_CONTRACTORS, payload: data });
  });
};

export const fetchFundingTypes = () => (dispatch) => {
  return api.getFundingTypes().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_FUNDING_TYPES, payload: data });
  });
};

export const fetchRatioRecordTypes = () => (dispatch) => {
  return api.getRatioRecordTypes().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_RATIO_RECORD_TYPES, payload: data });
  });
};

export const fetchElectoralDistricts = () => (dispatch) => {
  return api.getElectoralDistricts().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_ELECTORAL_DISTRICTS, payload: data });
  });
};

export const fetchHighways = () => (dispatch) => {
  return api.getHighways().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_HIGHWAYS, payload: data });
  });
};

export const fetchEconomicRegions = () => (dispatch) => {
  return api.getEconomicRegions().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_ECONOMIC_REGIONS, payload: data });
  });
};

export const fetchCodesets = () => (dispatch) => {
  return api.getCodesets().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_CODESETS, payload: data });
  });
};
