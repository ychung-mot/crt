import React, { useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
import PageSpinner from '../ui/PageSpinner';

import * as api from '../../Api';

function DetermineRatiosModal({ isOpen, toggle, dirty, projectId }) {
  //helper functions
  const calculateRatios = () => {
    setModalState(MODAL_STATE.PROCEED);
    api
      .putDetermineProjectRatios(projectId)
      .then(() => {
        setModalState(MODAL_STATE.SUCCESS);
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
            <strong>Warning! </strong>This action will overwrite the current project ratios information based on the
            current project segments. Do you want to contiue?
          </div>
        ),
        nextButton: (
          <Button color="danger" onClick={calculateRatios}>
            Proceed
          </Button>
        ),
      },
      PROCEED: {
        body: <PageSpinner />,
      },
      SUCCESS: {
        body:
          'Ratios determined. These calculated values are suggestions and can be updated manually by the users to make corrections, if required.',
      },
      FAIL: {
        body: 'Unable to determine ratios',
      },
    },
  };

  //component hooks
  const [modalState, setModalState] = useState(MODAL_STATE.CONFIRM);

  return (
    <Modal
      size="sm"
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
