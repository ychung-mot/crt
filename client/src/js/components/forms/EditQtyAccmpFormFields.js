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
  qtyAccmpLkupId: undefined,
  forecast: undefined,
  schedule7: undefined,
  actual: undefined,
  comments: '',
};

const validationSchema = Yup.object({
  fiscalYearLkupId: Yup.number().required('Fiscal Year Required'),
  qtyAccmpLkupId: Yup.number().required('Please choose Quantity or Accomplishment'),
});

//temporary fix hard code quantity and accomplishments
const qtyAccmpArray = [
  { id: 'ACCOMPLISHMENT', name: 'Accomplishment' },
  { id: 'QUANTITY', name: 'Quantity' },
];

const EditQtyAccmpFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  qtyAccmpId,
  formType,
  fiscalYears,
  quantities,
  accomplishments,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      //temporary fix, need to change to post finTarget
      setLoading(true);
      api
        .getQtyAccmp(projectId, qtyAccmpId)
        .then((response) => {
          setInitialValues({
            ...response.data,
            qtyOrAccmp: response.data.qtyAccmpLkup.codeSet,
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
      <FormRow name="qtyOrAccmp" label="Quantity or Accomplishment">
        <SingleDropdownField items={qtyAccmpArray} name="qtyOrAccmp" />
      </FormRow>
      {formValues.qtyOrAccmp && (
        <>
          <FormRow name="qtyAccmpLkupId" label={formValues.qtyOrAccmp === 'QUANTITY' ? 'Quantity' : 'Accomplishment'}>
            <SingleDropdownField
              items={formValues.qtyOrAccmp === 'QUANTITY' ? quantities : accomplishments}
              name="qtyAccmpLkupId"
            />
          </FormRow>
          <FormRow name="forecast" label="Forecast">
            <FormInput type="number" name="forecast" placeholder="0" />
          </FormRow>
          {formValues.qtyOrAccmp === 'quantity' && (
            <FormRow name="schedule7" label="Schedule 7">
              <FormInput type="number" name="schedule7" placeholder="0" />
            </FormRow>
          )}
          <FormRow name="amount" label="Amount">
            <FormInput type="number" name="amount" placeholder="0" />
          </FormRow>
          <FormRow name="comment" label="Comment">
            <FormInput type="input" name="comment" placeholder="Insert Comment Here" value={formValues.comment} />
          </FormRow>
        </>
      )}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    fiscalYears: state.codeLookups.fiscalYears,
    quantities: state.codeLookups.quantities,
    accomplishments: state.codeLookups.accomplishments,
  };
};

export default connect(mapStateToProps, null)(EditQtyAccmpFormFields);
