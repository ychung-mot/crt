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
  setFieldValue,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
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
            <FormNumberInput name="forecast" id="forecast" setFieldValue={setFieldValue} value={formValues.forecast} />
          </FormRow>
          {formValues.qtyOrAccmp === 'QUANTITY' && (
            <FormRow name="schedule7" label="Schedule 7">
              <FormNumberInput
                name="schedule7"
                id="schedule7"
                setFieldValue={setFieldValue}
                value={formValues.schedule7}
              />
            </FormRow>
          )}
          <FormRow name="actual" label="Amount">
            <FormNumberInput name="actual" id="actual" setFieldValue={setFieldValue} value={formValues.actual} />
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
