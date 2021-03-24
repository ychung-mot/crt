import React, { useEffect, useState } from 'react';
import * as Yup from 'yup';
import { connect } from 'react-redux';

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
  programs,
  programCategories,
  serviceLines,
}) => {
  const defaultValues = {
    code: '',
    description: '',
    programLkupId: undefined,
    programCategoryLkupId: undefined,
    serviceLineLkupId: undefined,
    displayOrder: defaultDisplayOrder,
  };

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
      <FormRow name="code" label="Element*" helper="elementCode">
        <FormInput type="text" name="code" id={`code`} />
      </FormRow>
      <FormRow name="description" label="Element Description*" helper="elementDescription">
        <FormInput type="text" name="description" id={`description`} />
      </FormRow>
      <FormRow name="programCategoryLkupId" label="Program Category*" helper="programCategoryLkupId">
        <SingleDropDownField items={programCategories} name="programCategoryLkupId" searchable />
      </FormRow>
      <FormRow name="programLkupId" label="Program*" helper="programLkupId">
        <SingleDropDownField items={programs} name="programLkupId" searchable />
      </FormRow>
      <FormRow name="serviceLineLkupId" label="Service Line*" helper="serviceLineLkupId">
        <SingleDropDownField items={serviceLines} name="serviceLineLkupId" searchable />
      </FormRow>
      <FormRow name="displayOrder*" label="Order Number">
        <FormInput type="number" name="displayOrder" id={`displayOrder`} />
      </FormRow>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    programs: state.codeLookups.programs,
    programCategories: state.codeLookups.programCategories,
    serviceLines: state.codeLookups.serviceLines,
  };
};

export default connect(mapStateToProps, null)(EditElementFormFields);
