import React, { useState } from 'react';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
import { Formik, Form } from 'formik';

import SubmitButton from '../ui/SubmitButton';

import * as Constants from '../../Constants';

const useFormModal = (formTitle, formFieldsChildElement, handleFormSubmit, saveCheck = false) => {
  // This is needed until Formik fixes its own setSubmitting function
  const [submitting, setSubmitting] = useState(false);
  const [initialValues, setInitialValues] = useState(null);
  const [isOpen, setIsOpen] = useState(false);
  const [formType, setFormType] = useState(Constants.FORM_TYPE.ADD);
  const [formOptions, setFormOptions] = useState({});
  const [validationSchema, setValidationSchema] = useState({});
  //saveCheck modal states:
  const [modalSaveCheckOpen, setModalSaveCheckOpen] = useState(false);

  const toggle = (dirty = false) => {
    if (dirty && saveCheck) {
      toggleModalSaveCheck();
    } else {
      setIsOpen(false);
    }
  };

  const toggleModalSaveCheck = () => {
    setModalSaveCheckOpen(!modalSaveCheckOpen);
  };

  const handleConfirmLeave = () => {
    setIsOpen(false);
    setModalSaveCheckOpen(false);
  };

  const openForm = (formType, options) => {
    setFormType(formType);
    setFormOptions({ ...options });
    setIsOpen(true);
  };

  const closeForm = () => {
    setFormOptions({});
    toggle();
  };

  const onFormSubmit = (values) => handleFormSubmit(values, formType);

  const title = formType === Constants.FORM_TYPE.ADD ? `Add ${formTitle}` : `Edit ${formTitle}`;

  const formModal = () => {
    return (
      <Modal isOpen={isOpen} toggle={toggle} backdrop="static">
        <Formik
          enableReinitialize={true}
          initialValues={initialValues}
          validationSchema={validationSchema}
          onSubmit={onFormSubmit}
        >
          {({ dirty, values, setFieldValue }) => (
            <Form>
              <ModalHeader toggle={() => toggle(dirty)}>{title}</ModalHeader>
              <ModalBody>
                {isOpen &&
                  React.cloneElement(formFieldsChildElement, {
                    ...formOptions,
                    formType,
                    formValues: values,
                    setInitialValues,
                    setValidationSchema,
                    setFieldValue,
                  })}
              </ModalBody>
              <ModalFooter>
                <SubmitButton size="sm" submitting={submitting} disabled={submitting || !dirty}>
                  Submit
                </SubmitButton>
                <Button color="secondary" size="sm" onClick={() => toggle(dirty)}>
                  Cancel
                </Button>
                <Modal isOpen={modalSaveCheckOpen}>
                  <ModalHeader>You have unsaved changes.</ModalHeader>
                  <ModalBody>
                    If the screen is closed before saving these changes, they will be lost. Do you want to continue
                    without saving?
                  </ModalBody>
                  <ModalFooter>
                    <Button size="sm" color="primary" onClick={handleConfirmLeave}>
                      Leave
                    </Button>
                    <Button color="secondary" size="sm" onClick={toggleModalSaveCheck}>
                      Go Back
                    </Button>
                  </ModalFooter>
                </Modal>
              </ModalFooter>
            </Form>
          )}
        </Formik>
      </Modal>
    );
  };

  return {
    isOpen,
    openForm,
    closeForm,
    submitting,
    setSubmitting,
    formElement: formModal(),
  };
};

export default useFormModal;
