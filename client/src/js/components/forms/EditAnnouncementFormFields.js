import React, { useEffect, useState } from 'react';
import _ from 'lodash';
import * as Yup from 'yup';

import PageSpinner from '../ui/PageSpinner';
import { FormRow, FormInput, FormNumberInput } from './FormInputs';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const defaultValues = {
  anncmentValue: 0,
  c035Value: 0,
  estimatedValue: 0,
  anncementComment: '',
};

const validationSchema = Yup.object({
  anncmentValue: Yup.number().lessThan(10000000000, 'Value must be less than 10 billion'),
  c035Value: Yup.number().lessThan(10000000000, 'Value must be less than 10 billion'),
  estimatedValue: Yup.number().lessThan(10000000000, 'Value must be less than 10 billion'),
});

const EditAnnouncementFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  formType,
  autofocus,
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
          let data = _.omitBy(response.data, _.isNil);
          setInitialValues({
            ...defaultValues,
            ...data,
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
        <FormNumberInput
          name="anncmentValue"
          id="anncmentValue"
          decimalScale="0"
          prefix="$"
          value={formValues.anncmentValue}
          getInputRef={autofocus}
        />
      </FormRow>
      <FormRow name="c035Value" label="C-035 Value" helper="c035Value">
        <FormNumberInput name="c035Value" id="c035Value" decimalScale="0" prefix="$" value={formValues.c035Value} />
      </FormRow>
      <FormRow name="estimatedValue" label="Estimated Value" helper="estimatedValue">
        <FormNumberInput
          name="estimatedValue"
          id="estimatedValue"
          decimalScale="0"
          prefix="$"
          value={formValues.estimatedValue}
        />
      </FormRow>
      <FormRow name="anncmentComment" label="Annoucement Notes" helper="anncmentComment">
        <FormInput
          rows={5}
          type="textarea"
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
