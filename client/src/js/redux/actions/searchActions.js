import { UPDATE_PROJECTS_SEARCH } from './types';

export const updateProjectsSearch = (values) => {
  return { type: UPDATE_PROJECTS_SEARCH, payload: values };
};
