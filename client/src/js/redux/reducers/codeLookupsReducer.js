import _ from 'lodash';

import {} from '../actions/types';

const defaultState = {
  locationCodes: [],
  activityCodes: [],
  thresholdLevels: [],
  roadLengthRules: [],
  surfaceTypeRules: [],
  roadClassRules: [],
};

const codeLookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    default:
      return state;
  }
};

export default codeLookupsReducer;
