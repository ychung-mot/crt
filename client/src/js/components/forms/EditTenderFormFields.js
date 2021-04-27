import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';
import { connect } from 'react-redux';
import moment from 'moment';

import SingleDropdownField from '../ui/SingleDropdownField';
import SingleDateField from '../ui/SingleDateField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput, FormNumberInput } from './FormInputs';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const defaultValues = {
  tenderNumber: '',
  plannedDate: undefined,
  actualDate: undefined,
  tenderValue: 0,
  winningCntrctrLkUpId: undefined,
  bidValue: 0,
  comment: '',
};

const validationSchema = Yup.object({
  tenderNumber: Yup.string().required('Tender Number is Required'),
  tenderValue: Yup.number().lessThan(10000000000, 'Value must be less than 10 billion').nullable(),
  bidValue: Yup.number().lessThan(10000000000, 'Value must be less than 10 billion').nullable(),
});

const EditTenderFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  tenderId,
  formType,
  contractors,
  autofocus,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setValidationSchema(validationSchema);
    setInitialValues(defaultValues);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      api
        .getTender(projectId, tenderId)
        .then((response) => {
          setInitialValues({
            ...response.data,
            plannedDate: response.data.plannedDate ? moment(response.data.plannedDate) : null,
            actualDate: response.data.actualDate ? moment(response.data.actualDate) : null,
            comment: response.data.comment ? response.data.comment : '',
          });
          setLoading(false);
        })
        .catch((error) => console.log(error.response));
    }

    if (formType === Constants.FORM_TYPE.CLONE) {
      setLoading(true);
      api
        .getTender(projectId, tenderId)
        .then((response) => {
          setInitialValues({
            ...response.data,
            tenderNumber: '',
            plannedDate: response.data.plannedDate ? moment(response.data.plannedDate) : null,
            actualDate: response.data.actualDate ? moment(response.data.actualDate) : null,
            comment: response.data.comment ? response.data.comment : '',
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
      <FormRow name="tenderNumber" label="Tender Number*" helper="tenderNumber">
        <FormInput type="text" name="tenderNumber" placeholder="Tender Number" id="tenderNumber" innerRef={autofocus} />
      </FormRow>
      <FormRow name="plannedDate" label="Planned Date" helper="plannedDate">
        <SingleDateField name="plannedDate" placeholder={Constants.DATE_DISPLAY_FORMAT} isOutsideRange={() => false} />
      </FormRow>
      <FormRow name="actualDate" label="Actual Date" helper="actualDate">
        <SingleDateField name="actualDate" placeholder={Constants.DATE_DISPLAY_FORMAT} isOutsideRange={() => false} />
      </FormRow>
      <FormRow name="tenderValue" label="Ministry Estimate" helper="tenderValue">
        <FormNumberInput
          name="tenderValue"
          id="tenderValue"
          decimalScale="0"
          prefix="$"
          value={formValues.tenderValue}
        />
      </FormRow>
      <FormRow name="winningCntrctrLkupId" label="Winning Contractor" helper="winningCntrctrLkupId">
        <SingleDropdownField items={contractors} name="winningCntrctrLkupId" searchable clearable />
      </FormRow>
      <FormRow name="bidValue" label="Winning Bid" helper="bidValue">
        <FormNumberInput name="bidValue" id="bidValue" decimalScale="0" prefix="$" value={formValues.bidValue} />
      </FormRow>
      <FormRow name="comment" label="Comment">
        <FormInput
          type="textarea"
          name="comment"
          placeholder="Insert Comment Here"
          id="comment"
          value={formValues.comment}
          rows={5}
        />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    contractors: state.codeLookups.contractors,
  };
};

export default connect(mapStateToProps, null)(EditTenderFormFields);
