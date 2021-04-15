import React, { useEffect, useState } from 'react';

import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
import PageSpinner from '../ui/PageSpinner';

function DetermineSegmentModal({ isOpen, toggle, dirty }) {
  const calculateRatios = () => {
    setModalState(MODAL_STATE.PROCEED);
    setTimeout(() => setModalState(MODAL_STATE.SUCCESS), 2000);
  };

  const MODAL_STATE = {
    CONFIRM: 'CONFIRM',
    PROCEED: 'PROCEED',
    SUCCESS: 'SUCCESS',

    properties: {
      CONFIRM: {
        body:
          'This action will overwrite the current project ratios information based on the current project segments. Do you want to continue?',
        nextButton: (
          <Button color="primary" onClick={calculateRatios}>
            Proceed
          </Button>
        ),
      },
      PROCEED: {
        body: (
          <div>
            Loading: This will succeed in 2 seconds
            <PageSpinner />
          </div>
        ),
      },
      SUCCESS: {
        body:
          'Ratios determined. These calculated values are suggestions and can be updated manually by the users to make corrections, if required.',
      },
    },
  };
  const [modalState, setModalState] = useState(MODAL_STATE.CONFIRM);

  const resetState = () => {
    setModalState(MODAL_STATE.CONFIRM);
  };

  return (
    <Modal size="sm" isOpen={isOpen} toggle={toggle} onClosed={resetState}>
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

export default DetermineSegmentModal;
