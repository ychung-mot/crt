import React, { useState, useRef } from 'react';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
import { Formik, Form } from 'formik';

import SubmitButton from '../ui/SubmitButton';

import * as Constants from '../../Constants';

const useFormModal = (formTitle, formFieldsChildElement, handleFormSubmit, options = {}) => {
  // This is needed until Formik fixes its own setSubmitting function
  const [submitting, setSubmitting] = useState(false);
  const [initialValues, setInitialValues] = useState(null);
  const [isOpen, setIsOpen] = useState(false);
  const [formType, setFormType] = useState(Constants.FORM_TYPE.ADD);
  const [formOptions, setFormOptions] = useState({});
  const [validationSchema, setValidationSchema] = useState({});
  //saveCheck modal states:
  const [modalSaveCheckOpen, setModalSaveCheckOpen] = useState(false);

  const autofocus = useRef();

  const { size = '', saveCheck = false, showModalHeader = true, showModalFooter = true } = options;

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
    setFormOptions(options);
    setIsOpen(true);
  };

  const closeForm = () => {
    setFormOptions({});
    toggle();
  };

  const onFormSubmit = (values) => handleFormSubmit(values, formType);

  const formatTitle = (title) => {
    //converts the title to display based on formType. ie. ADD_FORM -> Add EDIT_FORM -> Edit
    let formattedTitle = title.match(/^[^_]+/)[0];
    formattedTitle = formattedTitle[0] + formattedTitle.slice(1).toLowerCase();
    return formattedTitle;
  };

  const title = `${formatTitle(formType)} ${formTitle}`;

  const setFocus = () => {
    //need to delay because sometimes, autofocus.current is set after onOpened
    setTimeout(() => {
      autofocus.current && autofocus.current.focus();
    }, 200);
  };

  const formModal = () => {
    return (
      <Modal isOpen={isOpen} toggle={toggle} backdrop="static" size={size} onOpened={setFocus}>
        <Formik
          enableReinitialize={true}
          initialValues={initialValues}
          validationSchema={validationSchema}
          onSubmit={onFormSubmit}
        >
          {({ dirty, values }) => (
            <Form noValidate>
              {showModalHeader && <ModalHeader toggle={() => toggle(dirty)}>{title}</ModalHeader>}
              <ModalBody>
                {isOpen &&
                  React.cloneElement(formFieldsChildElement, {
                    ...formOptions,
                    formType,
                    formValues: values,
                    setInitialValues,
                    setValidationSchema,
                    closeForm,
                    autofocus,
                  })}
              </ModalBody>
              {showModalFooter && (
                <ModalFooter>
                  <SubmitButton size="sm" submitting={submitting} disabled={submitting || !dirty}>
                    Submit
                  </SubmitButton>
                  <Button color="secondary" size="sm" onClick={() => toggle(dirty)}>
                    Cancel
                  </Button>
                </ModalFooter>
              )}
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
