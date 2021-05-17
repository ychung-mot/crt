import React, { useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

import { Button, Modal, ModalHeader, ModalBody, ModalFooter, Alert } from 'reactstrap';
import PageSpinner from '../ui/PageSpinner';
import CalculatorLoadingIcon from '../ui/CalculatorLoadingIcon';

import * as api from '../../Api';

function DetermineRatiosModal({ isOpen, toggle, dirty, projectId, refreshData }) {
  //helper functions
  const calculateRatios = () => {
    setModalState(MODAL_STATE.PROCEED);
    api
      .putDetermineProjectRatios(projectId)
      .then(() => {
        setModalState(MODAL_STATE.SUCCESS);
        refreshData();
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
        setModalState(MODAL_STATE.FAIL);
      });
  };

  const dirtyCheck = (dirty) => {
    if (dirty === false) {
      setModalState(MODAL_STATE.PROCEED);
      calculateRatios();
    }
  };

  const resetState = () => {
    setModalState(MODAL_STATE.CONFIRM);
  };

  //different modal states
  const MODAL_STATE = {
    CONFIRM: 'CONFIRM',
    PROCEED: 'PROCEED',
    SUCCESS: 'SUCCESS',
    FAIL: 'FAIL',

    properties: {
      CONFIRM: {
        body: (
          <div>
            <strong>Warning!</strong>
            <br />
            This action will overwrite the current project ratios information based on the current project segments. Do
            you want to continue?
          </div>
        ),
        nextButton: (
          <Button color="danger" onClick={calculateRatios}>
            Proceed
          </Button>
        ),
      },
      PROCEED: {
        body: (
          <div className="text-center">
            <span>This process may take a few minutes to complete</span>
            {/* <PageSpinner /> */}
            <CalculatorLoadingIcon height={80} width={62} />
            <strong>Calculating...</strong>
          </div>
        ),
      },
      SUCCESS: {
        body: (
          <Alert color="success">
            <strong>Ratios determined.</strong>
            <hr />
            These calculated values are suggestions determined using segment data. Please verify and, if needed, make
            updates or add values to the appropriate ratios.
          </Alert>
        ),
      },
      FAIL: {
        body: <Alert color="danger">Operation Failed</Alert>,
      },
    },
  };

  //component hooks
  const [modalState, setModalState] = useState(MODAL_STATE.CONFIRM);

  return (
    <Modal
      size="md"
      isOpen={isOpen}
      toggle={toggle}
      backdrop="static"
      onClosed={resetState}
      onOpened={() => dirtyCheck(dirty)}
    >
      <ModalHeader toggle={toggle}>Determine Ratios Using Segments</ModalHeader>
      <ModalBody>{MODAL_STATE.properties[modalState].body}</ModalBody>
      <ModalFooter>
        <div className="float-right">
          {MODAL_STATE.properties[modalState]?.nextButton}
          <Button color="secondary" onClick={toggle}>
            Close
          </Button>
        </div>
      </ModalFooter>
    </Modal>
  );
}

export default connect(null, { showValidationErrorDialog })(DetermineRatiosModal);
