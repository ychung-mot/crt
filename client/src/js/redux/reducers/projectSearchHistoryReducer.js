import * as Constants from '../../Constants';
import { SET_PROJECT_SEARCH_HISTORY } from '../actions/types';

const defaultState = {
  projectSearch: Constants.API_PATHS.PROJECTS,
};

const projectSearchHistoryReducer = (state = defaultState, action) => {
  //this state is used so closing the project details, planning and tender screens retains the search results at Projects home screen.
  switch (action.type) {
    case SET_PROJECT_SEARCH_HISTORY:
      return { ...state, projectSearch: action.payload };
    default:
      return state;
  }
};

export default projectSearchHistoryReducer;
