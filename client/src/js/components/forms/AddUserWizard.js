import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { Alert, Button, Modal, ModalHeader, ModalBody, ModalFooter, Row, Col, FormGroup, Label } from 'reactstrap';
import { Formik, Form } from 'formik';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import PageSpinner from '../ui/PageSpinner';
import MultiSelect from '../ui/MultiSelect';
import { FormInput, FormRow } from './FormInputs';
import SubmitButton from '../ui/SubmitButton';

import { showValidationErrorDialog, hideErrorDialog } from '../../redux/actions';

import * as api from '../../Api';

const WIZARD_STATE = {
  SEARCH: 'SEARCH',
  SEARCH_SUCCESS: 'SEARCH_SUCCESS',
  SEARCH_FAIL: 'SEARCH_FAIL',
  USER_SETUP: 'USER_SETUP',
  USER_SETUP_CONFIRM: 'USER_SETUP_CONFIRM',
};

const defaultValues = {
  username: '',
  userRoleIds: [],
  active: true,
  endDate: null,
};

const AddUserSearch = ({ submitting, toggle, values, handleSubmit }) => {
  return (
    <React.Fragment>
      <ModalBody>
        <Row>
          <Col>
            <FormGroup>
              <Label for="username">User Id</Label>
              <FormInput
                type="text"
                name="username"
                placeholder="User Id"
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && values.username) {
                    e.preventDefault();
                    handleSubmit(values);
                  }
                }}
              />
            </FormGroup>
          </Col>
        </Row>
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" size="sm" type="button" onClick={toggle}>
          Cancel
        </Button>
        <SubmitButton
          color="primary"
          type="button"
          size="sm"
          disabled={submitting || !values.username}
          submitting={submitting}
          onClick={() => handleSubmit(values)}
        >
          Next
        </SubmitButton>
      </ModalFooter>
    </React.Fragment>
  );
};

const AddUserSearchResult = ({ status, data, setWizardState }) => {
  const displayRow = (label, text) => (
    <Row>
      <Col xs={3} style={{ display: 'flex', justifyContent: 'flex-end' }}>
        <strong>{label}</strong>
      </Col>
      <Col>{text}</Col>
    </Row>
  );

  return (
    <React.Fragment>
      <ModalBody>
        <Alert color={status === WIZARD_STATE.SEARCH_SUCCESS ? 'success' : 'danger'}>
          <strong>User {status !== WIZARD_STATE.SEARCH_SUCCESS && 'Not'} Found</strong>
          <hr />
          {displayRow('User ID', data.username)}
          {status === WIZARD_STATE.SEARCH_SUCCESS && (
            <React.Fragment>
              {displayRow('First Name', data.firstName)}
              {displayRow('Last Name', data.lastName)}
              {displayRow('Email', data.email)}
              {data.businessLegalName && displayRow('Company', data.businessLegalName)}
            </React.Fragment>
          )}
        </Alert>
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" type="button" size="sm" onClick={() => setWizardState(WIZARD_STATE.SEARCH)}>
          Back
        </Button>
        <Button
          color="primary"
          type="button"
          size="sm"
          disabled={status !== WIZARD_STATE.SEARCH_SUCCESS}
          onClick={() =>
            status === WIZARD_STATE.SEARCH_SUCCESS
              ? setWizardState(WIZARD_STATE.USER_SETUP)
              : setWizardState(WIZARD_STATE.SEARCH)
          }
        >
          Next
        </Button>
      </ModalFooter>
    </React.Fragment>
  );
};

const AddUserSetupUser = ({ values, submitting, setWizardState }) => {
  const [roles, setRoles] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api
      .getRoles()
      .then((response) => {
        const data = response.data.sourceList
          .filter((r) => r.isActive === true)
          .map((r) => ({ ...r, description: r.name }));

        setRoles(data);
      })
      .finally(() => setLoading(false));
  }, []);

  return (
    <React.Fragment>
      <ModalBody>
        {loading ? (
          <PageSpinner />
        ) : (
          <React.Fragment>
            <p>
              <strong>Select roles for the new user</strong>
            </p>
            <FormRow name="userRoleIds" label="User Roles*">
              <MultiSelect items={roles} name="userRoleIds" />
            </FormRow>
          </React.Fragment>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" type="button" size="sm" onClick={() => setWizardState(WIZARD_STATE.SEARCH)}>
          Back
        </Button>
        <SubmitButton
          color="primary"
          size="sm"
          disabled={values.userRoleIds.length === 0 || submitting}
          submitting={submitting}
        >
          Submit
        </SubmitButton>
      </ModalFooter>
    </React.Fragment>
  );
};

const AddUserSetupUserSuccess = ({ toggle }) => {
  return (
    <React.Fragment>
      <ModalBody>
        <div className="text-center">
          <FontAwesomeIcon icon={['far', 'check-circle']} size="10x" className="fa-color-success" />
          <h1 className="mt-3">User Created</h1>
        </div>
      </ModalBody>
      <ModalFooter>
        <Button color="primary" size="sm" type="button" onClick={() => toggle(true)}>
          Finish
        </Button>
      </ModalFooter>
    </React.Fragment>
  );
};

const AddUserWizard = ({ isOpen, toggle, showValidationErrorDialog, hideErrorDialog, validationSchema }) => {
  const [wizardState, setWizardState] = useState(WIZARD_STATE.SEARCH);
  const [submitting, setSubmitting] = useState(false);
  const [adAccount, setAdAccount] = useState(null);

  const handleAdSearchSubmit = (values) => {
    setSubmitting(true);
    api
      .getUserAdAccount(values.username)
      .then((response) => {
        setAdAccount(response.data);
        setWizardState(WIZARD_STATE.SEARCH_SUCCESS);
      })
      .catch((error) => {
        if (!error.response || error.response.status === 404) hideErrorDialog();

        setAdAccount(values);
        setWizardState(WIZARD_STATE.SEARCH_FAIL);
      })
      .finally(() => setSubmitting(false));
  };

  const handleFinalFormSubmit = (values) => {
    if (!submitting) {
      setSubmitting(true);

      api
        .postUser(values)
        .then(() => setWizardState(WIZARD_STATE.USER_SETUP_CONFIRM))
        .catch((error) => {
          showValidationErrorDialog(error.response.data);
        })
        .finally(() => setSubmitting(false));
    }
  };

  const renderState = (values) => {
    switch (wizardState) {
      case WIZARD_STATE.SEARCH_SUCCESS:
      case WIZARD_STATE.SEARCH_FAIL:
        return <AddUserSearchResult setWizardState={setWizardState} data={adAccount} status={wizardState} />;
      case WIZARD_STATE.USER_SETUP:
        return <AddUserSetupUser setWizardState={setWizardState} values={values} submitting={submitting} />;
      case WIZARD_STATE.USER_SETUP_CONFIRM:
        return <AddUserSetupUserSuccess toggle={toggle} />;
      case WIZARD_STATE.SEARCH:
      default:
        return (
          <AddUserSearch submitting={submitting} toggle={toggle} values={values} handleSubmit={handleAdSearchSubmit} />
        );
    }
  };

  return (
    <Modal isOpen={isOpen} toggle={toggle} backdrop="static">
      <ModalHeader toggle={toggle}>Add User</ModalHeader>
      <Formik initialValues={defaultValues} validationSchema={validationSchema} onSubmit={handleFinalFormSubmit}>
        {({ values }) => <Form>{renderState(values)}</Form>}
      </Formik>
    </Modal>
  );
};

const mapStateToProps = (state) => {
  return {};
};

export default connect(mapStateToProps, { showValidationErrorDialog, hideErrorDialog })(AddUserWizard);
