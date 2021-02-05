import * as api from '../../Api';

import { FETCH_REGIONS, FETCH_ELEMENTS } from './types';

export const fetchRegions = () => (dispatch) => {
  return api.getRegions().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_REGIONS, payload: data });
  });
};

export const fetchElements = () => (dispatch) => {
  return api.getElements().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_ELEMENTS, payload: data });
  });
};
