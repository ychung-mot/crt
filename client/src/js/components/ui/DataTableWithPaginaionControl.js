import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';

import PaginationControl from './PaginationControl';
import DataTableControl from './DataTableControl';

const DataTableWithPaginaionControl = ({ searchPagination, onPageNumberChange, onPageSizeChange, ...props }) => {
  return (
    <React.Fragment>
      <DataTableControl {..._.omit(props, ['searchPagination', 'onPageNumberChange', 'onPageSizeChange'])} />
      <PaginationControl
        currentPage={searchPagination.pageNumber}
        pageCount={searchPagination.pageCount}
        onPageChange={onPageNumberChange}
        pageSize={searchPagination.pageSize}
        onPageSizeChange={onPageSizeChange}
        totalCount={searchPagination.totalCount}
        itemCount={props.dataList.length}
      />
    </React.Fragment>
  );
};

const isOverflowY = (props, propName, componentName) => {
  if (props[propName]) {
    return new Error(
      `${propName} is not a valid prop for ${componentName}. ${propName} does not work well with pagination`
    );
  }
};

DataTableWithPaginaionControl.propTypes = {
  dataList: PropTypes.arrayOf(PropTypes.object).isRequired,
  tableColumns: PropTypes.arrayOf(
    PropTypes.shape({
      heading: PropTypes.string.isRequired,
      key: PropTypes.string.isRequired,
      nosort: PropTypes.bool,
      badge: PropTypes.shape({
        //badge will show active/inactive string based on boolean value
        active: PropTypes.string.isRequired,
        inactive: PropTypes.string.isRequired,
      }),
      //link will be the url path of where you want to go. ie. /projects/:id <- will look at dataList item for id attribute
      link: PropTypes.shape({
        path: PropTypes.string,
        key: PropTypes.string, //will display what is in item[key]. Key takes precedence over heading.
        heading: PropTypes.string, //will display this string if item[key] doesn't exist.
        title: PropTypes.string, //adds html title attribute. Mouse hover shows title.
      }),
      currency: PropTypes.bool, //if true then format values as currency
      thousandSeparator: PropTypes.bool, //if true then format values with thousand comma separators
      labelHoverText: PropTypes.shape({
        key: PropTypes.string, //will display what is in item[key] when hovered using html title property. Takes precdence over title.
        title: PropTypes.string, //will display this string if item[key] doesn't exist.
      }),
    })
  ).isRequired,
  editable: PropTypes.bool.isRequired,
  deletable: PropTypes.bool.isRequired,
  cloneable: PropTypes.bool.isRequired,
  cloneHoverText: PropTypes.string.isRequired, //changes hover (title) text for associated buttons
  editHoverText: PropTypes.string.isRequired,
  deleteHoverText: PropTypes.string.isRequired,
  disableHoverText: PropTypes.string.isRequired,
  deleteButtonDefaultText: PropTypes.string, //sets default button text for the delete button popover. Default is "disable".
  deleteButtonAltText: PropTypes.string, //sets button text for "disabled" state of the record popover.
  editPermissionName: PropTypes.string,
  searchPagination: PropTypes.shape({
    pageNumber: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    pageCount: PropTypes.number.isRequired,
    totalCount: PropTypes.number,
    hasPreviousPage: PropTypes.bool,
    hasNextPage: PropTypes.bool,
  }).isRequired,
  onPageNumberChange: PropTypes.func.isRequired,
  onPageSizeChange: PropTypes.func.isRequired,
  onEditClicked: PropTypes.func,
  onDeleteClicked: PropTypes.func,
  onCloneClicked: PropTypes.func,
  onHeadingSortClicked: PropTypes.func,
  overflowY: isOverflowY, //should not use overflowY in this component.
  easyDelete: PropTypes.bool, //allows user to not set end date to disable record
  hover: PropTypes.bool, //determines whether rows are highlighted when hovered
};

DataTableWithPaginaionControl.defaultProps = {
  editable: false,
  deletable: false,
  cloneable: false,
  easyDelete: false,
  hover: false,
  cloneHoverText: 'Clone Record',
  editHoverText: 'Edit Record',
  deleteHoverText: 'Delete Record',
  disableHoverText: 'Disable Record',
};

export default DataTableWithPaginaionControl;
