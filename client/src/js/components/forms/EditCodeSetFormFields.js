import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';

import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const defaultValues = {};

const EditCodeSetFormFields = ({ setInitialValues, formValues, setValidationSchema, formType }) => {
  const [loading, setLoading] = useState(false);

  const validationSchema = Yup.object({});

  useEffect(() => {
    setInitialValues({
      ...defaultValues,
    });
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      //api get codeset
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading || formValues === null) return <PageSpinner />;

  return <React.Fragment></React.Fragment>;
};

export default EditCodeSetFormFields;
