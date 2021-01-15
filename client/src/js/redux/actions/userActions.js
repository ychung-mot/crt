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

//temporary hard code to grab user regions information eventually use api.getUserRegions()
export const fetchUserRegions = () => (dispatch) => {
  return api.getUserRegions().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_USER_REGIONS, payload: data });
  });
};
