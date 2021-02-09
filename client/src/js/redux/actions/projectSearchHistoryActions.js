import { SET_PROJECT_SEARCH_HISTORY } from './types';

export const setProjectSearchHistory = (url) => {
  return { type: SET_PROJECT_SEARCH_HISTORY, payload: url };
};
