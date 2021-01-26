import React from 'react';
import { CustomInput, Col, FormGroup, Label, Input, FormFeedback } from 'reactstrap';
import { useField } from 'formik';
import MouseoverTooltip from '../ui/MouseoverTooltip';

export const FormRow = ({ name, label, children, helper }) => {
  return (
    <FormGroup row>
      <Col sm={3}>
        <Label className="d-inline" for={name}>
          {label}
        </Label>
        {/* temporary implementation. Will add tooltip functionaity when project core functions are complete */}
        {helper && <MouseoverTooltip id={helper.id}>{helper.text}</MouseoverTooltip>}
      </Col>
      <Col sm={9}>{children}</Col>
    </FormGroup>
  );
};

export const FormSwitchInput = ({ children, ...props }) => {
  const [field] = useField({ ...props, type: 'checkbox' });
  return <CustomInput type="switch" id={props.name} {...field} {...props} />;
};

export const FormCheckboxInput = ({ children, ...props }) => {
  const [field] = useField({ ...props, type: 'checkbox' });
  return <CustomInput type="checkbox" id={props.name} {...field} {...props} />;
};

export const FormInput = ({ children, ...props }) => {
  const [field, meta] = useField({ ...props, type: 'checkbox' });
  return (
    <React.Fragment>
      <Input {...field} {...props} invalid={meta.error && meta.touched}>
        {children}
      </Input>
      {meta.error && meta.touched && <FormFeedback>{meta.error}</FormFeedback>}
    </React.Fragment>
  );
};
