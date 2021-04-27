import queryString from 'query-string';
import moment from 'moment';
import _ from 'lodash';

import * as Constants from './Constants';

export const buildActionWithParam = (action, param) => {
  return { action, param };
};

export const buildApiErrorObject = (response) => {
  try {
    const method = response.config.method.toUpperCase();
    const path = response.config.url.replace(response.config.baseURL, '');

    return {
      message: response.data.title,
      statusCode: response.status,
      detail: response.data.detail,
      errors: response.data.errors,
      path,
      method,
    };
  } catch {
    return {
      message: 'Connection to server cannot be established',
    };
  }
};

export const updateQueryParamsFromHistory = (history, newParam, overwrite) => {
  const params = queryString.parse(history.location.search);

  let processedParams = { ..._.pickBy(newParam, _.identity) };
  Object.keys(processedParams).forEach((key) => {
    if (moment.isMoment(processedParams[key]))
      processedParams[key] = processedParams[key].format(Constants.DATE_DISPLAY_FORMAT);
  });

  if (!overwrite) processedParams = { ...params, ...processedParams };

  // remove empty isActive
  if (newParam.isActive === null) processedParams = _.omit(processedParams, ['isActive']);
  else processedParams = { ...processedParams, isActive: newParam.isActive };

  // remove empty searchText
  if (!newParam.searchText) processedParams = _.omit(processedParams, ['searchText']);

  // remove empty regions
  if (newParam.regionIds === null) processedParams = _.omit(processedParams, ['regionIds']);

  // remove empty isInProgress
  if (newParam.isInProgress === null) processedParams = _.omit(processedParams, ['isInProgress']);
  else processedParams = { ...processedParams, isInProgress: newParam.isInProgress };

  //remove empty projectManagerIds
  if (newParam.projectManagerIds === null) processedParams = _.omit(processedParams, ['projectManagerIds']);

  return queryString.stringify(processedParams);
};

export const stringifyQueryParams = (newParam) => {
  return queryString.stringify(newParam);
};

export const buildStatusIdArray = (isActive) => {
  if (isActive === true || isActive === 'true') return [Constants.ACTIVE_STATUS.ACTIVE];

  if (isActive === false || isActive === 'false') return [Constants.ACTIVE_STATUS.INACTIVE];

  return [Constants.ACTIVE_STATUS.ACTIVE, Constants.ACTIVE_STATUS.INACTIVE];
};

export const myFiscalYear = () => {
  //returns which fiscal year user is in ie. 2021 or 2020. Based on fiscalYear end being March 31.
  let fiscalYear = moment().year();
  let today = moment();
  let fiscalChange = moment(`${fiscalYear}-${Constants.FISCAL_YEAR_END}`);

  if (fiscalChange.diff(today) > 0) {
    //date is before fiscal
    return fiscalYear - 1;
  }

  //date is after fiscal
  return fiscalYear;
};

export const arrayFormatter = (myArray) => {
  //purpose: to take arrays of objects and format fields for UI display.
  //public methods are chainable. ie. arrayFormatter(array).changeDateFormat().get().
  //to get the changed array get() function must be called at the end.

  let _myArray = [...myArray];

  function changeDateFormat(dateFormat = 'DD-MM-YYYY') {
    if (
      !checkIfPropertyExistsInArray('changeDateFormat', 'plannedDate') ||
      !checkIfPropertyExistsInArray('changeDateFormat', 'actualDate')
    ) {
      return this;
    }

    _myArray = _myArray.map((item) => {
      return {
        ...item,
        plannedDate: item.plannedDate === null ? null : moment(item.plannedDate).format(dateFormat),
        actualDate: item.actualDate === null ? null : moment(item.actualDate).format(dateFormat),
      };
    });

    return this;
  }

  function displayAfterFilter(filterWord, key) {
    //takes filter word and checks if key value = filter word.
    if (!checkIfPropertyExistsInArray('displayAfterFilter', key)) {
      return this;
    }

    if (filterWord === 'ALL') {
      return this;
    }

    _myArray = _myArray.filter((items) => items[key] === filterWord);
    return this;
  }

  function displayOnlyValidFiscalYears(fiscalYears = []) {
    //returns only the fiscalYears that exist in the project. Used for the filter dropdown.

    if (!checkIfPropertyExistsInArray('displayOnlyValidFiscalYears', 'fiscalYear')) {
      return this;
    }

    let listOfFiscalYears = _myArray.map((item) => item.fiscalYear);

    _myArray = fiscalYears.filter((fiscalYear) => listOfFiscalYears.includes(fiscalYear.codeName));

    return this;
  }

  function checkIfPropertyExistsInArray(functionName, key) {
    //throws warning if key doesn't exist. This should prevent misuse of utility functions.
    //returns false (property doesn't exist)
    //true (property exists)
    if (_myArray.length !== 0 && !_myArray[0].hasOwnProperty(key)) {
      console.warn(
        _myArray,
        `should not call function ${functionName} on this array because it does not have ${key} field property`
      );
      return false;
    }

    return true;
  }

  function roundPercentage(key) {
    if (!checkIfPropertyExistsInArray('roundPercentage', key)) {
      return this;
    }

    _myArray = _myArray.map((item) => {
      if (item[key] === null) {
        return item;
      }

      return {
        ...item,
        [key]: Math.round(item[key]) + '%',
      };
    });

    return this;
  }

  function sortBy(sortFunction) {
    //sorts array based on sort function
    _myArray = _myArray.sort(sortFunction);

    return this;
  }

  function get() {
    return _myArray;
  }

  return {
    changeDateFormat,
    displayAfterFilter,
    displayOnlyValidFiscalYears,
    roundPercentage,
    sortBy,
    get,
  };
};
