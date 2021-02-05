import _ from 'lodash';

import {
  FETCH_CAPITAL_INDEXES,
  FETCH_RC_NUMBERS,
  FETCH_NEAREST_TOWNS,
  FETCH_PHASES,
  FETCH_FISCAL_YEARS,
  FETCH_QUANTITIES,
  FETCH_ACCOMPLISHMENTS,
  FETCH_CONTRACTORS,
  FETCH_FORECAST_TYPES,
} from '../actions/types';

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
  phases: [],
  fiscalYears: [],
  quantities: [],
  accomplishments: [],
  contractors: [],
  forecastTypes: [],
};

const codeLookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    case FETCH_CAPITAL_INDEXES:
      return { ...state, capitalIndexes: _.orderBy(action.payload, ['id'], ['desc']) };
    case FETCH_RC_NUMBERS:
      return { ...state, rcNumbers: _.orderBy(action.payload, ['name']) };
    case FETCH_NEAREST_TOWNS:
      return { ...state, nearestTowns: _.orderBy(action.payload, ['name']) };
    case FETCH_PHASES:
      return { ...state, phases: _.orderBy(action.payload, ['name']) };
    case FETCH_FISCAL_YEARS:
      return { ...state, fiscalYears: _.orderBy(action.payload, ['name']) };
    case FETCH_QUANTITIES:
      return { ...state, quantities: _.orderBy(action.payload, ['name']) };
    case FETCH_ACCOMPLISHMENTS:
      return { ...state, accomplishments: _.orderBy(action.payload, ['name']) };
    case FETCH_CONTRACTORS:
      return { ...state, contractors: _.orderBy(action.payload, ['name']) };
    case FETCH_FORECAST_TYPES:
      return { ...state, forecastTypes: _.orderBy(action.payload, ['name']) };
    default:
      return state;
  }
};

export default codeLookupsReducer;
