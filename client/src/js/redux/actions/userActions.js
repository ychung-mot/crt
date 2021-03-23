import * as api from '../../Api';

import { FETCH_CURRENT_USER, FETCH_USER_STATUSES, FETCH_PROJECT_MANAGERS } from './types';

export const fetchCurrentUser = () => (dispatch) => {
  return api.getCurrentUser().then((response) => {
    const data = response.data;
    //sorts regionIds for user
    data.regions = data.regions.slice(0).sort((a, b) => a.regionNumber - b.regionNumber);
    dispatch({ type: FETCH_CURRENT_USER, payload: data });
  });
};

export const fetchUserStatuses = () => (dispatch) => {
  return api.getUserStatuses().then((response) => {
    const data = response.data;
    dispatch({ type: FETCH_USER_STATUSES, payload: data });
  });
};

// export const fetchProjectManagers = () => (dispatch) => {
//   return api.getProjectManagers().then((response) => {
//     const data = response.data;
//     dispatch({ type: FETCH_PROJECT_MANAGERS, payload: data });
//   });
// };
