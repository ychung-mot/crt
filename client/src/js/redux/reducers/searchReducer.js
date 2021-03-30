import { UPDATE_PROJECTS_SEARCH } from '../actions/types';

const defaultState = {
  projects: {},
};

const searchReducer = (state = defaultState, action) => {
  switch (action.type) {
    case UPDATE_PROJECTS_SEARCH:
      return { ...state, projects: action.payload };
    default:
      return state;
  }
};

export default searchReducer;
