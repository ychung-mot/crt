import React, { useState, useEffect, useMemo } from 'react';
import { DropdownToggle, DropdownMenu, UncontrolledDropdown, DropdownItem, FormFeedback, Input } from 'reactstrap';

const SingleDropdown = (props) => {
  const {
    items,
    defaultTitle,
    value,
    disabled,
    handleOnChange,
    handleOnBlur,
    isInvalidClassName,
    fieldMeta,
    errorStyle,
    searchable,
  } = props;
  const [title, setTitle] = useState(defaultTitle);
  const [textFilter, setTextFilter] = useState('');

  useEffect(() => {
    const item = items.find((o) => {
      // disable strict type checking
      // eslint-disable-next-line
      return o.id == value;
    });

    if (item) setTitle(item.name);
  }, [value, items]);

  useEffect(() => {
    setTitle(defaultTitle);
  }, [defaultTitle]);

  const handleOnSelect = (item) => {
    if (handleOnChange) handleOnChange(item.id);

    setTitle(item.name);
  };

  const displayItems = useMemo(() => {
    if (textFilter.trim().length > 0) {
      const pattern = new RegExp(textFilter.trim(), 'i');
      const filteredItems = items.filter((item) => pattern.test(item.name));

      return filteredItems;
    }

    return items;
  }, [items, textFilter]);

  const renderMenuItems = () => {
    return displayItems.map((item, index) => {
      const displayName = item.name;

      if (item.type === 'header') {
        return (
          <DropdownItem header key={index}>
            {displayName}
          </DropdownItem>
        );
      } else {
        return (
          <DropdownItem key={index} onClick={() => handleOnSelect(item)}>
            {displayName}
          </DropdownItem>
        );
      }
    });
  };

  return (
    <div style={{ padding: '0' }}>
      <UncontrolledDropdown
        className={`form-control form-input ${disabled ? 'disabled' : ''} ${isInvalidClassName}`}
        disabled={disabled}
        style={{ padding: '0' }}
      >
        <DropdownToggle caret onBlur={handleOnBlur}>
          {title}
        </DropdownToggle>
        <DropdownMenu className="pre-scrollable">
          {searchable && (
            <Input
              type="textbox"
              placeholder="Search"
              value={textFilter}
              onChange={(e) => {
                setTextFilter(e.target.value);
              }}
            />
          )}
          {renderMenuItems()}
        </DropdownMenu>
      </UncontrolledDropdown>
      {fieldMeta && fieldMeta.touched && fieldMeta.error && (
        <FormFeedback style={errorStyle}>{fieldMeta.error}</FormFeedback>
      )}
    </div>
  );
};

export default SingleDropdown;
