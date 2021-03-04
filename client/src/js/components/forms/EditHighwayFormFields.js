import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import * as Yup from 'yup';

import SingleDropdownField from '../ui/SingleDropdownField';
import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const defaultValues = {
  ratio: 0,
  ratioRecordLkupId: undefined,
};

const validationSchema = Yup.object({
  ratio: Yup.number()
    .positive('Must be a positive number')
    .min(0, 'Ratio must between 0 and 1')
    .max(1, 'Ratio must be between 0 and 1'),
  ratioRecordLkupId: Yup.number().required('Highway Required'),
});

const EditHighwayFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  ratioId,
  formType,
  highways,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      //temporary fix, API call goes here
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading || formValues === null) return <PageSpinner />;

  return (
    <React.Fragment>
      <FormRow name="ratioRecordLkupId" label="Highway*">
        <SingleDropdownField items={highways} name="ratioRecordLkupId" searchable={true} />
      </FormRow>
      <FormRow name="ratio" label="Ratio*">
        <FormInput type="number" name="ratio" placeholder="Value between 0 and 1" id={`ratio`} />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    highways: Object.values(state.codeLookups.highways),
  };
};

export default connect(mapStateToProps, null)(EditHighwayFormFields);
