import React from 'react';
import PropTypes from 'prop-types';
import { Table, Badge } from 'reactstrap';

import { Link } from 'react-router-dom';
import NumberFormat from 'react-number-format';

import Authorize from '../fragments/Authorize';
import FontAwesomeButton from './FontAwesomeButton';
import DeleteButton from './DeleteButton';

const DataTableControl = ({
  dataList,
  tableColumns,
  editable,
  deletable,
  editPermissionName,
  onEditClicked,
  onDeleteClicked,
  onHeadingSortClicked,
}) => {
  const handleEditClicked = (id) => {
    if (onEditClicked) onEditClicked(id);
  };

  const linkFormatter = (item = {}, link = {}) => {
    //finds all parts of the URL that have : to replace with attribute from item keys
    let path = link.path;
    const regex = /:[a-z 0-9]*/gi;
    let variableParams = path.match(regex);

    if (!variableParams) {
      return path;
    }

    for (let each of variableParams) {
      path = path.replace(each, item[each.slice(1)]);
    }

    return path;
  };

  const displayFormatter = (item = {}, column = {}) => {
    //checks if item should be rendered as a special type. ie. currency, link or no formatting
    if (column.link) {
      return <Link to={() => linkFormatter(item, column.link)}>{item[column.link?.key] || column.link?.heading}</Link>;
    }

    if (column.currency) {
      return <NumberFormat value={item[column.key]} prefix="$" thousandSeparator={true} displayType="text" />;
    }

    if (column.thousandSeparator) {
      return <NumberFormat value={item[column.key]} thousandSeparator={true} displayType="text" />;
    }

    return item[column.key];
  };

  return (
    <React.Fragment>
      <Table size="sm" responsive hover>
        <thead className="thead-dark">
          <tr>
            {tableColumns.map((column) => {
              let style = { whiteSpace: 'nowrap' };

              if (column.maxWidth) style.maxWidth = column.maxWidth;

              return (
                <th key={column.heading} style={style}>
                  {column.heading}
                  {!column.nosort && <FontAwesomeButton icon="sort" onClick={() => onHeadingSortClicked(column.key)} />}
                </th>
              );
            })}
            {(editable || deletable) && (
              <Authorize requires={editPermissionName}>
                <th></th>
              </Authorize>
            )}
          </tr>
        </thead>
        <tbody>
          {dataList.map((item, index) => {
            return (
              <tr key={index}>
                {tableColumns.map((column) => {
                  if (column.badge)
                    return (
                      <td key={column.key}>
                        {item[column.key] ? (
                          <Badge color="success">{column.badge.active}</Badge>
                        ) : (
                          <Badge color="danger">{column.badge.inactive}</Badge>
                        )}
                      </td>
                    );

                  let style = { position: 'relative' };
                  if (column.maxWidth) {
                    style.maxWidth = column.maxWidth;
                  }
                  return (
                    <td key={column.key} className={column.maxWidth ? 'text-overflow-hiden' : ''} style={style}>
                      {displayFormatter(item, column)}
                    </td>
                  );
                })}
                {(editable || deletable) && (
                  <Authorize requires={editPermissionName}>
                    <td style={{ width: '1%', whiteSpace: 'nowrap' }}>
                      {editable && (
                        <FontAwesomeButton
                          icon="edit"
                          className="mr-1"
                          onClick={() => handleEditClicked(item.id)}
                          title="Edit Record"
                        />
                      )}
                      {deletable && (
                        <DeleteButton
                          itemId={item.id}
                          buttonId={`item_${item.id}_delete`}
                          defaultEndDate={item.endDate}
                          onDeleteClicked={onDeleteClicked}
                          permanentDelete={item.canDelete}
                          title={item.canDelete ? 'Delete Record' : 'Disable Record'}
                        ></DeleteButton>
                      )}
                    </td>
                  </Authorize>
                )}
              </tr>
            );
          })}
        </tbody>
      </Table>
    </React.Fragment>
  );
};

DataTableControl.propTypes = {
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
      }),
      currency: PropTypes.bool, //if true then format values as currency
      thousandSeparator: PropTypes.bool, //if true then format values with thousand comma separators
    })
  ).isRequired,
  editable: PropTypes.bool.isRequired,
  editPermissionName: PropTypes.string,
  onEditClicked: PropTypes.func,
  onDeleteClicked: PropTypes.func,
  onHeadingSortClicked: PropTypes.func,
};

DataTableControl.defaultProps = {
  editable: false,
  deletable: false,
};

export default DataTableControl;
