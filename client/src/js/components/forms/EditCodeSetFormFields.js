import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';

import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const EditCodeSetFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  formType,
  codeSetId,
  codeValueText,
}) => {
  const defaultValues = { codeValueText: '', codeName: '', displayOrder: 0, codeSet: codeValueText };

  const [loading, setLoading] = useState(false);

  const validationSchema = Yup.object({
    codeValueText: Yup.string().max(20, 'Must be less than 20 characters'),
    codeName: Yup.string().required(`Code name is required`),
    displayOrder: Yup.number().integer('Order number must be an integer e.g. 1,2,3').required(),
  });

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      api
        .getCodeTable(codeSetId)
        .then((response) => {
          setInitialValues({ ...response.data });
          setLoading(false);
        })
        .catch((error) => console.log(error.response));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading || formValues === null) return <PageSpinner />;

  return (
    <React.Fragment>
      <FormRow name="codeSet" label="Code Set">
        <FormInput type="text" name="codeSet" id={`codeSet`} disabled />
      </FormRow>
      <FormRow name="codeValueText" label="Code Value" helper="codeValueText">
        <FormInput type="text" name="codeValueText" id={`codeValue`} />
      </FormRow>
      <FormRow name="codeName" label="Code Name" helper="codeName">
        <FormInput type="text" name="codeName" id={`codeName`} />
      </FormRow>
      <FormRow name="displayOrder" label="Order Number">
        <FormInput type="number" name="displayOrder" id={`displayOrder`} />
      </FormRow>
    </React.Fragment>
  );
};

export default EditCodeSetFormFields;
