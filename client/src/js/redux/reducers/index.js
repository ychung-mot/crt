import { combineReducers } from 'redux';

import codeLookupsReducer from './codeLookupsReducer';
import errorDialogReducer from './errorDialogReducer';
import userReducer from './userReducer';
import regionsReducer from './regionsReducer';

export default combineReducers({
  codeLookups: codeLookupsReducer,
  errorDialog: errorDialogReducer,
  user: userReducer,
  regions: regionsReducer,
});
