import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';

import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput, FormNumberFormat } from './FormInputs';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const defaultValues = {
  anncmentValue: 0,
  c035Value: 0,
  anncementComment: '',
};

const validationSchema = Yup.object({});

const EditAnnouncementFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  formType,
  setFieldValue,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setValidationSchema(validationSchema);
    setInitialValues(defaultValues);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      api
        .getProject(projectId)
        .then((response) => {
          setInitialValues({
            ...response.data,
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
      <FormRow name="anncmentValue" label="Announcement Value" helper="anncmentValue">
        <FormNumberFormat
          name="anncmentValue"
          id="anncmentValue"
          setFieldValue={setFieldValue}
          value={formValues.anncmentValue}
        />
      </FormRow>
      <FormRow name="c035Value" label="C-035 Value" helper="c035Value">
        <FormInput type="number" name="c035Value" id="c035Value" />
      </FormRow>
      <FormRow name="anncmentComment" label="Annoucement Notes" helper="anncmentComment">
        <FormInput
          type="textArea"
          name="anncmentComment"
          placeholder="Insert Comment Here"
          id="anncmentComment"
          value={formValues.anncmentComment}
        />
      </FormRow>
    </React.Fragment>
  );
};

export default EditAnnouncementFormFields;
