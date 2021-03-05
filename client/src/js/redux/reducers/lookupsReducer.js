import _ from 'lodash';

import { FETCH_REGIONS, FETCH_ELEMENTS, FETCH_DISTRICTS, FETCH_SERVICE_AREAS } from '../actions/types';

const defaultState = {
  regions: [],
  elements: [],
  districts: [],
  serviceAreas: [],
};

const lookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    case FETCH_REGIONS:
      return { ...state, regions: _.orderBy(action.payload, ['regionNumber']) };
    case FETCH_ELEMENTS:
      return { ...state, elements: _.orderBy(action.payload, ['name']) };
    case FETCH_DISTRICTS:
      return { ...state, districts: _.orderBy(action.payload, ['districtNumber']) };
    case FETCH_SERVICE_AREAS:
      return { ...state, serviceAreas: _.orderBy(action.payload, ['serviceAreatNumber']) };
    default:
      return state;
  }
};

export default lookupsReducer;
