import _ from 'lodash';

import { FETCH_REGIONS, FETCH_ELEMENTS, FETCH_DISTRICTS } from '../actions/types';

const defaultState = {
  regions: [],
  elements: [],
  districts: [],
};

const lookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    case FETCH_REGIONS:
      return { ...state, regions: _.orderBy(action.payload, ['regionNumber']) };
    case FETCH_ELEMENTS:
      return { ...state, elements: _.orderBy(action.payload, ['name']) };
    case FETCH_DISTRICTS:
      return { ...state, districts: _.orderBy(action.payload, ['districtNumber']) };
    default:
      return state;
  }
};

export default lookupsReducer;
