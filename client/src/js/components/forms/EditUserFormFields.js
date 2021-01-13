import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import moment from 'moment';

import MultiSelect from '../ui/MultiSelect';
import SingleDateField from '../ui/SingleDateField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput, FormCheckboxInput } from './FormInputs';

import * as api from '../../Api';

const EditUserFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  userId,
  validationSchema,
  userRegions,
}) => {
  const [loading, setLoading] = useState(true);
  const [roles, setRoles] = useState([]);

  useEffect(() => {
    setValidationSchema(validationSchema);

    api
      .getUser(userId)
      .then((response) => {
        setInitialValues({
          ...response.data,
          userRegions: [], //temporary fix line 31 and 32 added until api provides a set of regions and program manager
          userProjectManager: false,
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
      <FormRow>
        <FormCheckboxInput name="userProjectManager" label="Project Manager" />
      </FormRow>
      <FormRow name="userRoleIds" label="User Roles*">
        <MultiSelect items={roles} name="userRoleIds" />
      </FormRow>
      <FormRow name="userRegions" label="MoTI Region*">
        <MultiSelect items={userRegions} name="userRegions" showSelectAll={true} />
      </FormRow>
      <FormRow name="endDate" label="End Date">
        <SingleDateField name="endDate" placeholder="End Date" />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    userRegions: Object.values(state.user.regions),
  };
};

export default connect(mapStateToProps, null)(EditUserFormFields);
