import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import moment from 'moment';

import MultiSelect from '../ui/MultiSelect';
import SingleDateField from '../ui/SingleDateField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';

import * as api from '../../Api';

const EditUserFormFields = ({ setInitialValues, formValues, setValidationSchema, userId, validationSchema }) => {
  const [loading, setLoading] = useState(true);
  const [roles, setRoles] = useState([]);

  useEffect(() => {
    setValidationSchema(validationSchema);

    api
      .getUser(userId)
      .then((response) => {
        setInitialValues({
          ...response.data,
          endDate: response.data.endDate ? moment(response.data.endDate) : null,
        });

        return api.getRoles().then((response) => {
          const data = response.data.sourceList
            .filter((r) => r.isActive === true)
            .map((r) => ({ ...r, description: r.name }));

          setRoles(data);
        });
      })
      .then(() => setLoading(false));

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading || formValues === null) return <PageSpinner />;

  return (
    <React.Fragment>
      <FormRow name="username" label="User Id*">
        <FormInput type="text" name="username" placeholder="User Id" disabled />
      </FormRow>
      <FormRow name="userRoleIds" label="User Roles*">
        <MultiSelect items={roles} name="userRoleIds" />
      </FormRow>
      <FormRow name="endDate" label="End Date">
        <SingleDateField name="endDate" placeholder="End Date" />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {};
};

export default connect(mapStateToProps, null)(EditUserFormFields);
