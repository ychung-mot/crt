import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import * as Yup from 'yup';
import moment from 'moment';
import { myFiscalYear } from '../../utils';

import SingleDropdownField from '../ui/SingleDropdownField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput, FormNumberInput } from './FormInputs';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const defaultValues = {
  fiscalYearLkupId: undefined,
  phaseLkupId: undefined,
  elementId: undefined,
  fundingTypeLkupId: undefined,
  amount: 0,
  description: '',
  endDate: null,
  qtyOrAccmp: undefined,
};

const validationSchema = Yup.object({
  fiscalYearLkupId: Yup.number().required('Fiscal Year Required'),
  phaseLkupId: Yup.number().required('Phase Required'),
  elementId: Yup.number().required('Element Required'),
  fundingTypeLkupId: Yup.number().required('Funding Type Required'),
  //temporary fix until DB accepts at least 10 digits amounts are confirmed
  // amount: Yup.number().lessThan(10000000000, 'Value must be less than 10 billion'),
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
  fundingTypes,
  elements,
}) => {
  const [loading, setLoading] = useState(false);

  let defaultFiscalYearLkupId = fiscalYears.find((year) => year.name.startsWith(myFiscalYear()))?.id;

  useEffect(() => {
    setInitialValues({ ...defaultValues, fiscalYearLkupId: defaultFiscalYearLkupId });
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT || formType === Constants.FORM_TYPE.CLONE) {
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
        <SingleDropdownField items={fiscalYears} name="fiscalYearLkupId" searchable />
      </FormRow>
      <FormRow name="phaseLkupId" label="Phase*">
        <SingleDropdownField items={phases} name="phaseLkupId" searchable />
      </FormRow>
      <FormRow name="elementId" label="Element*">
        <SingleDropdownField items={elements} name="elementId" searchable />
      </FormRow>
      <FormRow name="fundingTypeLkupId" label="Funding Type*">
        <SingleDropdownField items={fundingTypes} name="fundingTypeLkupId" searchable />
      </FormRow>
      <FormRow name="amount" label="Amount">
        <FormNumberInput name="amount" id="amount" decimalScale="0" prefix="$" value={formValues.amount} />
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
    fundingTypes: state.codeLookups.fundingTypes,
    elements: state.lookups.elements,
  };
};

export default connect(mapStateToProps, null)(EditFinTargetFormFields);
