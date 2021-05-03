import React from 'react';
import PropTypes from 'prop-types';
import { Table, Badge } from 'reactstrap';

import { Link } from 'react-router-dom';
import NumberFormat from 'react-number-format';
import ReactMarkdown from 'react-markdown';
import gfm from 'remark-gfm';

import Authorize from '../fragments/Authorize';
import FontAwesomeButton from './FontAwesomeButton';
import DeleteButton from './DeleteButton';

const DataTableControl = ({
  dataList,
  tableColumns,
  editable,
  deletable,
  cloneable,
  cloneHoverText,
  editHoverText,
  deleteHoverText,
  disableHoverText,
  deleteButtonDefaultText,
  deleteButtonAltText,
  editPermissionName,
  onEditClicked,
  onDeleteClicked,
  onCloneClicked,
  onHeadingSortClicked,
  overflowY,
  easyDelete,
  hover,
}) => {
  const handleEditClicked = (id) => {
    if (onEditClicked) onEditClicked(id);
  };

  const handleCloneClicked = (id) => {
    if (onCloneClicked) onCloneClicked(id);
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
    const label = item[column.key] ?? '';

    if (column.link) {
      return (
        <Link to={() => linkFormatter(item, column.link)} title={column.link?.title}>
          {(column.currency && <NumberFormat value={label} prefix="$" thousandSeparator={true} displayType="text" />) ||
            item[column.link?.key] ||
            column.link?.heading}
        </Link>
      );
    }

    if (column.currency) {
      return <NumberFormat value={label} prefix="$" thousandSeparator={true} displayType="text" />;
    }

    if (column.thousandSeparator) {
      return <NumberFormat value={label} thousandSeparator={true} displayType="text" />;
    }

    if (column.markdown) {
      return <ReactMarkdown linkTarget="_blank" plugins={[gfm]} source={label.replace(/\n/g, '  \n')}></ReactMarkdown>;
    }

    if (column.LabelHoverText) {
      return (
        <span title={item[column.labelHoverText?.key] || column.labelHoverText.heading} style={{ cursor: 'help' }}>
          {label}
        </span>
      );
    }

    return label;
  };

  const ConditionalWrapper = ({ condition, children, wrapper }) => {
    return condition ? wrapper(children) : children;
  };

  return (
    <React.Fragment>
      <ConditionalWrapper
        condition={overflowY}
        wrapper={(children) => (
          <div className={'overflow-auto'} style={{ maxHeight: overflowY }}>
            {children}
          </div>
        )}
      >
        <Table size="sm" responsive hover={hover}>
          <thead className="thead-dark">
            <tr>
              {tableColumns.map((column) => {
                let style = { whiteSpace: 'nowrap' };

                if (column.maxWidth) style.maxWidth = column.maxWidth;

                return (
                  <th key={column.heading} style={style}>
                    {column.heading}
                    {!column.nosort && (
                      <FontAwesomeButton icon="sort" onClick={() => onHeadingSortClicked(column.key)} />
                    )}
                  </th>
                );
              })}
              {(editable || deletable || cloneable) && (
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
                            title={editHoverText}
                          />
                        )}
                        {cloneable && (
                          <FontAwesomeButton
                            icon="copy"
                            className="mr-1"
                            onClick={() => handleCloneClicked(item.id)}
                            title={cloneHoverText}
                            color="success"
                          />
                        )}
                        {deletable && (
                          <DeleteButton
                            itemId={item.id}
                            buttonId={`item_${item.id}_delete`}
                            defaultEndDate={item.endDate}
                            defaultButtonText={deleteButtonDefaultText}
                            altButtonText={deleteButtonAltText}
                            onDeleteClicked={onDeleteClicked}
                            permanentDelete={item.canDelete}
                            title={item.canDelete ? deleteHoverText : disableHoverText}
                            easyDelete={easyDelete}
                            isActive={item?.isActive} //to assist with items that do not save end date
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
      </ConditionalWrapper>
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
        title: PropTypes.string, //adds html title attribute. Mouse hover shows title.
      }),
      currency: PropTypes.bool, //if true then format values as currency
      thousandSeparator: PropTypes.bool, //if true then format values with thousand comma separators
      markdown: PropTypes.bool, //true to make field display markdown
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
  onEditClicked: PropTypes.func,
  onCloneClicked: PropTypes.func,
  onDeleteClicked: PropTypes.func,
  onHeadingSortClicked: PropTypes.func,
  overflowY: PropTypes.string, //sets whether or not to enable Y scroll based on max-height that is set by css max-height string ie. 50vh/500px
  easyDelete: PropTypes.bool, //allows user to not set end date to disable record
  hover: PropTypes.bool, //determines whether rows are highlighted when hovered
};

DataTableControl.defaultProps = {
  editable: false,
  deletable: false,
  cloneable: false,
  easyDelete: false,
  hover: true,
  cloneHoverText: 'Clone Record',
  editHoverText: 'Edit Record',
  deleteHoverText: 'Delete Record',
  disableHoverText: 'Disable Record',
};

export default DataTableControl;
