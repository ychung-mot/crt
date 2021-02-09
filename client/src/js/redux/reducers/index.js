import { combineReducers } from 'redux';

import codeLookupsReducer from './codeLookupsReducer';
import errorDialogReducer from './errorDialogReducer';
import userReducer from './userReducer';
import lookupsReducer from './lookupsReducer';
import projectSearchHistoryReducer from './projectSearchHistoryReducer';

export default combineReducers({
  codeLookups: codeLookupsReducer,
  errorDialog: errorDialogReducer,
  user: userReducer,
  lookups: lookupsReducer,
  projectSearchHistory: projectSearchHistoryReducer,
});
