import _ from 'lodash';

import { FETCH_REGIONS, FETCH_ELEMENTS } from '../actions/types';

const defaultState = {
  regions: {},
};

const lookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    case FETCH_REGIONS:
      return { ...state, regions: _.orderBy(action.payload, ['regionNumber']) };
    case FETCH_ELEMENTS:
      return { ...state, elements: _.orderBy(action.payload, ['name']) };
    default:
      return state;
  }
};

export default lookupsReducer;
