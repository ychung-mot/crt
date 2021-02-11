import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';
import { connect } from 'react-redux';
import moment from 'moment';

import SingleDropdownField from '../ui/SingleDropdownField';
import SingleDateField from '../ui/SingleDateField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';

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
});

const EditTenderFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  tenderId,
  formType,
  contractors,
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
        <FormInput type="text" name="tenderNumber" placeholder="Tender Number" id="tenderNumber" />
      </FormRow>
      <FormRow name="plannedDate" label="Planned Date" helper="plannedDate">
        <SingleDateField name="plannedDate" placeholder="Planned Date" />
      </FormRow>
      <FormRow name="actualDate" label="Actual Date" helper="actualDate">
        <SingleDateField name="actualDate" placeholder="Actual Date" />
      </FormRow>
      <FormRow name="tenderValue" label="Tender Value" helper="tenderValue">
        <FormInput type="number" name="tenderValue" id="tenderValue" />
      </FormRow>
      <FormRow name="winningCntrctrLkupId" label="Winning Contractor" helper="winningCntrctrLkupId">
        <SingleDropdownField items={contractors} name="winningCntrctrLkupId" searchable />
      </FormRow>
      <FormRow name="bidValue" label="Winning Bid" helper="bidValue">
        <FormInput type="number" name="bidValue" id="bidValue" />
      </FormRow>
      <FormRow name="comment" label="Comment">
        <FormInput
          type="textArea"
          name="comment"
          placeholder="Insert Comment Here"
          id="comment"
          value={formValues.comment}
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
