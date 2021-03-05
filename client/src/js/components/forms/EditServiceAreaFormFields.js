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
  serviceAreaId: undefined,
  ratioRecordTypeLkupId: undefined,
};

const EditHighwayFormFields = ({
  setInitialValues,
  formValues,
  setValidationSchema,
  projectId,
  ratioId,
  formType,
  ratioTypeName,
  highways,
  ratioRecordTypes,
}) => {
  const [loading, setLoading] = useState(false);

  const validationSchema = Yup.object({
    ratio: Yup.number()
      .positive('Must be a positive number')
      .min(0, 'Ratio must between 0 and 1')
      .max(1, 'Ratio must be between 0 and 1'),
    ratioRecordLkupId: Yup.number().required(`${ratioTypeName} Required`),
  });

  useEffect(() => {
    setInitialValues({
      ...defaultValues,
      ratioRecordTypeLkupId: ratioRecordTypes.find((ratioType) => ratioType.codeName === ratioTypeName)?.id,
    });
    setValidationSchema(validationSchema);

    if (formType === Constants.FORM_TYPE.EDIT) {
      setLoading(true);
      api
        .getRatio(projectId, ratioId)
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
      <FormRow name="serviceAreaId" label={`${ratioTypeName}*`}>
        <SingleDropdownField items={highways} name="serviceAreaId" searchable={true} />
      </FormRow>
      <FormRow name="ratio" label="Ratio*">
        <FormInput type="number" name="ratio" placeholder="Value between 0 and 1" id={`ratio`} step={0.1} />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    highways: Object.values(state.codeLookups.highways),
    ratioRecordTypes: Object.values(state.codeLookups.ratioRecordTypes),
  };
};

export default connect(mapStateToProps, null)(EditHighwayFormFields);
