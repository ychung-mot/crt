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
  fiscalYearLkupId: undefined,
  phaseLkupId: undefined,
  element: undefined,
  forecastTypeLkupId: undefined,
  amount: 0,
  description: '',
  endDate: null,
};

const validationSchema = Yup.object({
  fiscalYearLkupId: Yup.number().required('Fiscal Year Required'),
  phaseLkupId: Yup.number().required('Phase Required'),
  element: Yup.number().required('Element Required'),
  forecastTypeLkupId: Yup.number().required('Forecast Type Required'),
});

const EditFinTargetFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  formType,
  fiscalYears,
  phases,
  forecastTypes,
  elements,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      //temporary fix, need to change to post finTarget
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
      <FormRow name="fiscalYearLkupId" label="Fiscal Year*">
        <SingleDropdownField items={fiscalYears} name="fiscalYearLkupId" />
      </FormRow>
      <FormRow name="phaseLkupId" label="Phase*">
        <SingleDropdownField items={phases} name="phaseLkupId" />
      </FormRow>
      <FormRow name="element" label="Element*">
        <SingleDropdownField items={elements} name="element" />
      </FormRow>
      <FormRow name="forecastTypeLkupId" label="Phase*">
        <SingleDropdownField items={forecastTypes} name="forecastTypeLkupId" />
      </FormRow>
      <FormRow name="amount" label="Amount">
        <FormInput type="number" name="amount" placeholder="0" />
      </FormRow>
      <FormRow name="description" label="Description">
        <FormInput type="textarea" name="description" placeholder="Description" />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    fiscalYears: state.codeLookups.fiscalYears,
    phases: state.codeLookups.phases,
    forecastTypes: state.codeLookups.forecastTypes,
    elements: state.lookups.elements,
  };
};

export default connect(mapStateToProps, null)(EditFinTargetFormFields);
