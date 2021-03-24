import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';

import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput } from './FormInputs';
import SingleDropDownField from '../ui/SingleDropdownField';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const EditElementFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  formType,
  defaultDisplayOrder,
}) => {
  const defaultValues = { code: '', description: '', displayOrder: defaultDisplayOrder };

  const [loading, setLoading] = useState(false);

  const validationSchema = Yup.object({
    code: Yup.string().required(`Code is required`),
    description: Yup.string().required(`Description is required`),
    displayOrder: Yup.number().integer('Order number must be an integer e.g. 1,2,3').required(),
  });

  useEffect(() => {
    setInitialValues(defaultValues);
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      //   api
      //     .getCodeTable(codeSetId)
      //     .then((response) => {
      //       setInitialValues({ ...response.data });
      //       setLoading(false);
      //     })
      //     .catch((error) => console.log(error.response));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading || formValues === null) return <PageSpinner />;

  return (
    <React.Fragment>
      <FormRow name="code" label="Element*">
        <FormInput type="text" name="code" id={`code`} />
      </FormRow>
      <FormRow name="description" label="Element Description*">
        <FormInput type="text" name="description" id={`description`} />
      </FormRow>
      {/* <FormRow name="codeName*" label="Code Name" helper="codeName">
          
        <FormInput type="text" name="codeName" id={`codeName`} />
      </FormRow> */}
      <FormRow name="displayOrder*" label="Order Number">
        <FormInput type="number" name="displayOrder" id={`displayOrder`} />
      </FormRow>
    </React.Fragment>
  );
};

export default EditElementFormFields;
