import { FETCH_CAPITAL_INDEXES, FETCH_RC_NUMBERS, FETCH_NEAREST_TOWNS } from './types';

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
