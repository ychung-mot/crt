import {
  SET_PROJECT_SEARCH_HISTORY,
  SET_PROJECT_SEARCH_FORMIK_VALUES,
  RESET_PROJECT_SEARCH_FORMIK_VALUES,
} from './types';

export const setProjectSearchHistory = (url) => {
  return { type: SET_PROJECT_SEARCH_HISTORY, payload: url };
};

export const setProjectSearchFormikValues = (values) => {
  return { type: SET_PROJECT_SEARCH_FORMIK_VALUES, payload: values };
};

export const resetProjectSearchFormikValues = () => {
  return { type: RESET_PROJECT_SEARCH_FORMIK_VALUES };
};
