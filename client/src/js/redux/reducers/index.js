import { combineReducers } from 'redux';

import codeLookupsReducer from './codeLookupsReducer';
import errorDialogReducer from './errorDialogReducer';
import userReducer from './userReducer';
import lookupsReducer from './lookupsReducer';
import searchReducer from './searchReducer';

export default combineReducers({
  codeLookups: codeLookupsReducer,
  errorDialog: errorDialogReducer,
  user: userReducer,
  lookups: lookupsReducer,
  search: searchReducer,
});
