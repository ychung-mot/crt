import _ from 'lodash';

import { FETCH_REGIONS } from '../actions/types';

const defaultState = {
  regions: {},
};

const lookupsReducer = (state = defaultState, action) => {
  switch (action.type) {
    case FETCH_REGIONS:
      return { ...state, regions: { ...state.regions, ..._.mapKeys(action.payload, 'id') } };
    default:
      return state;
  }
};

export default lookupsReducer;
