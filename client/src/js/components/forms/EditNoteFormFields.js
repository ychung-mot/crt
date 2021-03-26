import React, { useEffect, useState } from 'react';
import _ from 'lodash';
import * as Yup from 'yup';

import PageSpinner from '../ui/PageSpinner';
import { FormInput } from './FormInputs';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const defaultValues = {
  comment: '',
};

const validationSchema = Yup.object({});

const EditNoteFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  id,
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
        .getNote(projectId, id)
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
      <FormInput
        rows={5}
        type="textarea"
        name="comment"
        placeholder="Insert Comment Here"
        id="comment"
        value={formValues.comment}
        innerRef={autofocus}
      />
    </React.Fragment>
  );
};

export default EditNoteFormFields;
