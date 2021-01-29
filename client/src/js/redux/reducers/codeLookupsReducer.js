import _ from 'lodash';

import { FETCH_CAPITAL_INDEXES, FETCH_RC_NUMBERS, FETCH_NEAREST_TOWNS } from '../actions/types';

const defaultState = {
  locationCodes: [],
  activityCodes: [],
  thresholdLevels: [],
  roadLengthRules: [],
  surfaceTypeRules: [],
  roadClassRules: [],
  capitalIndexes: [],
  rcNumbers: [],
  nearestTowns: [],
};

const codeLookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    case FETCH_CAPITAL_INDEXES:
      return { ...state, capitalIndexes: _.orderBy(action.payload, ['id'], ['desc']) };
    case FETCH_RC_NUMBERS:
      return { ...state, rcNumbers: _.orderBy(action.payload, ['name']) };
    case FETCH_NEAREST_TOWNS:
      return { ...state, nearestTowns: _.orderBy(action.payload, ['name']) };
    default:
      return state;
  }
};

export default codeLookupsReducer;
