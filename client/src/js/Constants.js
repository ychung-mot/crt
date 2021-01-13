export const API_URL = window.RUNTIME_REACT_APP_API_HOST
  ? `${window.location.protocol}//${window.RUNTIME_REACT_APP_API_HOST}/api`
  : process.env.REACT_APP_API_HOST;

const CODE_LOOKUP = '/codelookup';

export const API_PATHS = {
  CODE_LOOKUP: CODE_LOOKUP,
  PERMISSIONS: '/permissions',
  ROLE: '/roles',
  USER: '/users',
  USER_CURRENT: '/users/current',
  USER_STATUSES: '/users/userstatus',
  USER_REGIONS: '/users/regions',
  USER_AD_ACCOUNT: '/users/adaccount',
  MAINTENANCE_TYPES: `${CODE_LOOKUP}/maintenancetypes`,
  UNIT_OF_MEASURES: `${CODE_LOOKUP}/unitofmeasures`,
  FEATURE_TYPES: `${CODE_LOOKUP}/featuretypes`,
  SUPPORTED_FORMATS: '/exports/supportedformats',
  VERSION: '/version',
};

export const PATHS = {
  UNAUTHORIZED: '/unauthorized',
  HOME: '/',
  ABOUT: '/admin/about',
  API_ACCESS: '/admin/api-access',
  ADMIN: '/admin',
  ADMIN_USERS: '/admin/users',
  ADMIN_ROLES: '/admin/roles',
  VERSION: '/version',
};

export const MESSAGE_DATE_FORMAT = 'YYYY-MM-DD hh:mmA';

export const DATE_DISPLAY_FORMAT = 'YYYY-MM-DD';

export const DATE_UTC_FORMAT = 'YYYY-MM-DDTHH:mm';

export const FORM_TYPE = { ADD: 'ADD_FORM', EDIT: 'EDIT_FORM' };

export const PERMISSIONS = {
  CODE_W: 'CODE_W',
  CODE_R: 'CODE_R',
  USER_W: 'USER_W',
  USER_R: 'USER_R',
  ROLE_W: 'ROLE_W',
  ROLE_R: 'ROLE_R',
};

export const USER_TYPE = { INTERNAL: 'INTERNAL', BUSINESS: 'BUSINESS' };

export const ACTIVE_STATUS = {
  ACTIVE: 'ACTIVE',
  INACTIVE: 'INACTIVE',
};

export const ACTIVE_STATUS_ARRAY = Object.keys(ACTIVE_STATUS).map((key) => ({
  id: ACTIVE_STATUS[key],
  name: ACTIVE_STATUS[key],
}));

export const SORT_DIRECTION = {
  ASCENDING: 'asc',
  DESCENDING: 'desc',
};

export const DEFAULT_PAGE_SIZE_OPTIONS = process.env.REACT_APP_DEFAULT_PAGE_SIZE_OPTIONS.split(',').map((o) =>
  parseInt(o)
);

export const DEFAULT_PAGE_SIZE = parseInt(process.env.REACT_APP_DEFAULT_PAGE_SIZE);
