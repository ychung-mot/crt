import * as api from '../../Api';

import { FETCH_CURRENT_USER, FETCH_USER_STATUSES, FETCH_USER_REGIONS } from './types';

export const fetchCurrentUser = () => (dispatch) => {
  return api.getCurrentUser().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_CURRENT_USER, payload: data });
  });
};

export const fetchUserStatuses = () => (dispatch) => {
  return api.getUserStatuses().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_USER_STATUSES, payload: data });
  });
};

//temporary hard code to grab user regions information
export const fetchUserRegions = () => (dispatch) => {
  let data = [
    { id: 0, number: 0, name: 'Headquarters' },
    { id: 1, number: 1, name: 'Nothern Region' },
    { id: 2, number: 2, name: 'Southern Region' },
    { id: 3, number: 3, name: 'Southern Coast Region' },
  ];
  return dispatch({ type: FETCH_USER_REGIONS, payload: data });
};
