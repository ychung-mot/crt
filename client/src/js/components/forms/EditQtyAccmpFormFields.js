import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import * as Yup from 'yup';
import moment from 'moment';
import { useFormikContext } from 'formik';

import SingleDropdownField from '../ui/SingleDropdownField';
import SingleDropdown from '../ui/SingleDropdown';
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
  forecast: Yup.number().lessThan(10000000, 'Value must be less than 10 million'),
  schedule7: Yup.number().lessThan(10000000, 'Value must be less than 10 million'),
  actual: Yup.number().lessThan(10000000, 'Value must be less than 10 million'),
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
  const [qtyOrAccmp, setQtyOrAccmp] = useState(null);
  const { values, setValues } = useFormikContext();

  let currentYear = moment().year().toString();
  let defaultFiscalYearLkupId = fiscalYears.find((year) => year.name.startsWith(currentYear))?.id;

  useEffect(() => {
    setInitialValues({ ...defaultValues, fiscalYearLkupId: defaultFiscalYearLkupId });
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
          setQtyOrAccmp(response.data.qtyAccmpLkup.codeSet);
          setLoading(false);
        })
        .catch((error) => console.log(error.response));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleOnChange = (type) => {
    setQtyOrAccmp(type);
    setFieldValue('qtyAccmpLkupId', undefined);
    setFieldValue('schedule7', undefined);
    setValues({ ...values, qtyAccmpLkupId: undefined, schedule7: undefined });
  };

  if (loading || formValues === null) return <PageSpinner />;

  return (
    <React.Fragment>
      <FormRow name="fiscalYearLkupId" label="Fiscal Year*">
        <SingleDropdownField items={fiscalYears} name="fiscalYearLkupId" />
      </FormRow>
      <FormRow name="qtyOrAccmp" label="Quantity or Accomplishment">
        <SingleDropdown
          items={qtyAccmpArray}
          name="qtyOrAccmp"
          handleOnChange={handleOnChange}
          defaultTitle={qtyOrAccmp}
        />
      </FormRow>
      {qtyOrAccmp && (
        <>
          <FormRow name="qtyAccmpLkupId" label={qtyOrAccmp === 'QUANTITY' ? 'Quantity*' : 'Accomplishment*'}>
            <SingleDropdownField
              items={qtyOrAccmp === 'QUANTITY' ? quantities : accomplishments}
              name="qtyAccmpLkupId"
            />
          </FormRow>
          <FormRow name="forecast" label="Forecast">
            <FormNumberInput name="forecast" id="forecast" setFieldValue={setFieldValue} value={formValues.forecast} />
          </FormRow>
          {qtyOrAccmp === 'QUANTITY' && (
            <FormRow name="schedule7" label="Schedule 7">
              <FormNumberInput
                name="schedule7"
                id="schedule7"
                setFieldValue={setFieldValue}
                value={formValues.schedule7}
              />
            </FormRow>
          )}
          <FormRow name="actual" label="Actual">
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
