import * as Constants from '../../Constants';
import {
  SET_PROJECT_SEARCH_HISTORY,
  SET_PROJECT_SEARCH_FORMIK_VALUES,
  RESET_PROJECT_SEARCH_FORMIK_VALUES,
} from '../actions/types';

const defaultFormikInitialValues = {
  searchText: '',
  regionIds: [],
  projectManagerIds: [],
  isInProgress: ['inProgress'],
};

const defaultState = {
  projectSearch: Constants.API_PATHS.PROJECTS,
  formikInitialValues: defaultFormikInitialValues,
};

const projectSearchHistoryReducer = (state = defaultState, action) => {
  //this state is used so closing the project details, planning and tender screens retains the search results at Projects home screen.
  switch (action.type) {
    case SET_PROJECT_SEARCH_HISTORY:
      return { ...state, projectSearch: action.payload };
    case SET_PROJECT_SEARCH_FORMIK_VALUES:
      return { ...state, formikInitialValues: action.payload };
    case RESET_PROJECT_SEARCH_FORMIK_VALUES:
      return { ...state, formikInitialValues: defaultFormikInitialValues };
    default:
      return state;
  }
};

export default projectSearchHistoryReducer;
