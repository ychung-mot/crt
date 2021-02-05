import {
  FETCH_CAPITAL_INDEXES,
  FETCH_RC_NUMBERS,
  FETCH_NEAREST_TOWNS,
  FETCH_PHASES,
  FETCH_FISCAL_YEARS,
  FETCH_QUANTITIES,
  FETCH_ACCOMPLISHMENTS,
  FETCH_CONTRACTORS,
  FETCH_FORECAST_TYPES,
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

export const fetchForecastTypes = () => (dispatch) => {
  return api.getForecastTypes().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_FORECAST_TYPES, payload: data });
  });
};
