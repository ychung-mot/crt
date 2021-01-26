import React, { useState } from 'react';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
//for popover
import { Popover, PopoverHeader, PopoverBody, ButtonGroup } from 'reactstrap';
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
  //popover states:
  const [popoverOpen, setPopoverOpen] = useState(false);

  const toggle = () => setIsOpen(false);

  const toggleWithCheck = (dirty) => {
    if (dirty) {
      togglePopover();
    } else {
      toggle();
    }
  };

  const togglePopover = () => {
    setPopoverOpen(!popoverOpen);
  };

  const handleConfirmLeave = () => {
    setPopoverOpen(false);
    toggle();
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
        <ModalHeader toggle={toggle}>{title}</ModalHeader>
        <Formik
          enableReinitialize={true}
          initialValues={initialValues}
          validationSchema={validationSchema}
          onSubmit={onFormSubmit}
        >
          {({ dirty, values }) => (
            <Form>
              <ModalBody>
                {isOpen &&
                  React.cloneElement(formFieldsChildElement, {
                    ...formOptions,
                    formType,
                    formValues: values,
                    setInitialValues,
                    setValidationSchema,
                  })}
              </ModalBody>
              <ModalFooter>
                <SubmitButton size="sm" submitting={submitting} disabled={submitting || !dirty}>
                  Submit
                </SubmitButton>
                <Button
                  id="popover_cancel"
                  color="secondary"
                  size="sm"
                  onClick={saveCheck ? () => toggleWithCheck(dirty) : toggle}
                >
                  Cancel
                </Button>
                <Popover
                  placement="auto-start"
                  isOpen={popoverOpen}
                  target={'popover_cancel'}
                  toggle={() => togglePopover}
                  trigger="legacy"
                >
                  <PopoverHeader>You have unsaved changes.</PopoverHeader>
                  <PopoverBody>
                    If the screen is closed before saving these changes, they will be lost. Do you want to continue
                    without saving?
                    <div className="text-right">
                      <ButtonGroup>
                        <Button color="danger" size="sm" onClick={handleConfirmLeave}>
                          Yes
                        </Button>
                        <Button color="secondary" size="sm" onClick={togglePopover}>
                          No
                        </Button>
                      </ButtonGroup>
                    </div>
                  </PopoverBody>
                </Popover>
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
