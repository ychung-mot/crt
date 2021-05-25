import React, { useState, useEffect } from 'react';
import { useFormikContext, useField } from 'formik';

import SingleDropdown from './SingleDropdown';

const SingleDropdownField = (props) => {
  const { items, name, defaultTitle, disabled, searchable, clearable } = props;
  const { values, setFieldValue, setFieldTouched } = useFormikContext();
  const [title, setTitle] = useState(values[name] && values[name].length > 0 ? values[name] : defaultTitle);
  const [field, meta, helpers] = useField(props);

  useEffect(() => {
    if (field.value) setTitle(items.find((o) => o.id === field.value)?.name || defaultTitle);
    else setTitle(defaultTitle);
  }, [field.value, items, defaultTitle]);

  const handleOnSelect = (item) => {
    setFieldValue(name, item);
  };

  let style = {};
  let isInvalidClassName = '';

  if (meta.touched && meta.error) {
    style = { display: 'block' };
    isInvalidClassName = 'is-invalid';
  }

  return (
    <SingleDropdown
      name={name}
      items={items}
      value={field.value}
      defaultTitle={title}
      handleOnChange={handleOnSelect}
      handleOnBlur={() => setFieldTouched(name, true)}
      disabled={disabled}
      isInvalidClassName={isInvalidClassName}
      errorStyle={style}
      fieldMeta={meta}
      helpers={helpers}
      resetFieldValue={() => {
        setFieldValue(name, undefined, true); // note this doesn't work well with required fields. Hitting submit will erase error messages due to bug https://github.com/formium/formik/issues/2332 "formik version": "^2.2.5",
        setFieldTouched(name, true);
      }}
      searchable={searchable}
      clearable={clearable}
    />
  );
};

export default SingleDropdownField;
