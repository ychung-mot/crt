import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import * as Yup from 'yup';
import moment from 'moment';

import SingleDropdownField from '../ui/SingleDropdownField';
import SingleDateField from '../ui/SingleDateField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const defaultValues = {
  projectNumber: undefined,
  projectName: '',
  description: '',
  scope: '',
  capIndxLkupId: null,
  regionId: undefined,
  projectMgrId: null,
  nearstTwnLkupId: null,
  rcLkupId: null,
  endDate: null,
};

const validationSchema = Yup.object({
  projectName: Yup.string().required('Project name required'),
  regionId: Yup.number().required('Region required'),
});

const EditProjectFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  formType,
  capitalIndexes,
  userRegionIds,
  projectMgr,
  nearestTowns,
  rcNumbers,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      api.getProject(projectId).then((response) => {
        setInitialValues({ ...response.data, endDate: response.data.endDate ? moment(response.data.endDate) : null });
        setLoading(false);
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading || formValues === null) return <PageSpinner />;

  return (
    <React.Fragment>
      <FormRow name="projectNumber" label="Project Number*" helper={{ id: 'projectNumber', text: 'placeholder' }}>
        <FormInput type="text" name="projectNumber" placeholder="To be assigned" disabled={true} />
      </FormRow>
      <FormRow name="projectName" label="Project Name*">
        <FormInput type="text" name="projectName" placeholder="Project Name" />
      </FormRow>
      <FormRow name="description" label="Project Description">
        <FormInput type="text" name="description" placeholder="Project Description" />
      </FormRow>
      <FormRow name="scope" label="Project Scope">
        <FormInput type="text" name="scope" placeholder="Project Scope" />
      </FormRow>
      <FormRow name="capIndxLkupId" label="Capital Index">
        <SingleDropdownField items={capitalIndexes} name="capIndxLkupId" />
      </FormRow>
      <FormRow name="regionId" label="MoTI Region*">
        <SingleDropdownField items={userRegionIds} name="regionId" />
      </FormRow>
      <FormRow name="projectMgrId" label="Project Manager">
        <SingleDropdownField items={projectMgr} name="projectMgrId" />
      </FormRow>
      <FormRow name="nearstTwnLkupId" label="Nearest Town">
        <SingleDropdownField items={nearestTowns} name="nearstTwnLkupId" />
      </FormRow>
      <FormRow name="rcLkupId" label="RC Number">
        <SingleDropdownField items={rcNumbers} name="rcLkupId" />
      </FormRow>
      <FormRow name="endDate" label="End Date">
        <SingleDateField name="endDate" placeholder="End Date" />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    capitalIndexes: Object.values(state.codeLookups.capitalIndexes),
    userRegionIds: Object.values(state.user.current.regions),
    projectMgr: Object.values(state.user.projectMgr),
    nearestTowns: Object.values(state.codeLookups.nearestTowns),
    rcNumbers: Object.values(state.codeLookups.rcNumbers),
  };
};

export default connect(mapStateToProps, null)(EditProjectFormFields);
