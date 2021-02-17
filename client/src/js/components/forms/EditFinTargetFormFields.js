import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import * as Yup from 'yup';
import moment from 'moment';

import SingleDropdownField from '../ui/SingleDropdownField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput, FormNumberInput } from './FormInputs';

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
  qtyOrAccmp: undefined,
};

const validationSchema = Yup.object({
  fiscalYearLkupId: Yup.number().required('Fiscal Year Required'),
  phaseLkupId: Yup.number().required('Phase Required'),
  elementId: Yup.number().required('Element Required'),
  forecastTypeLkupId: Yup.number().required('Forecast Type Required'),
  amount: Yup.number().lessThan(10000000, 'Value must be less than 10 million'),
});

const EditFinTargetFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  finTargetId,
  formType,
  fiscalYears,
  phases,
  forecastTypes,
  elements,
}) => {
  const [loading, setLoading] = useState(false);
  let currentYear = moment().year().toString();
  let defaultFiscalYearLkupId = fiscalYears.find((year) => year.name.startsWith(currentYear))?.id;

  useEffect(() => {
    setInitialValues({ ...defaultValues, fiscalYearLkupId: defaultFiscalYearLkupId });
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      api
        .getFinTarget(projectId, finTargetId)
        .then((response) => {
          setInitialValues({
            ...response.data,
            endDate: response.data.endDate ? moment(response.data.endDate) : null,
          });
          setLoading(false);
        })
        .catch((error) => console.log(error.response));
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
      <FormRow name="elementId" label="Element*">
        <SingleDropdownField items={elements} name="elementId" />
      </FormRow>
      <FormRow name="forecastTypeLkupId" label="Forecast Type*">
        <SingleDropdownField items={forecastTypes} name="forecastTypeLkupId" />
      </FormRow>
      <FormRow name="amount" label="Amount">
        <FormNumberInput name="amount" id="amount" value={formValues.amount} />
      </FormRow>
      <FormRow name="description" label="Description">
        <FormInput type="textarea" name="description" placeholder="Description" id="description" />
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
