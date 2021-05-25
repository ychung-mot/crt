import React, { useEffect, useState, useRef } from 'react';
import _ from 'lodash';

import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
import PageSpinner from '../ui/PageSpinner';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const defaultFormState = { startCoordinates: '', endCoordinates: '', description: '' };

function EditSegmentFormFields({ closeForm, projectId, refreshData, formType, segmentId }) {
  const [loading, setLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [initialFormState, setInitialFormState] = useState(defaultFormState);
  const [url, setURL] = useState(`${Constants.PATHS.TWM}?c=crt&project=${projectId}`);

  const myIframe = useRef(null);

  useEffect(() => {
    window.addEventListener('message', addEventListenerCloseForm);
    window.addEventListener('message', addEventListenerInitialFormState);

    return function cleanUp() {
      removeEventListenerCloseForm();
      removeEventListenerInitialFormState();
    };
  });

  useEffect(() => {
    if (formType === Constants.FORM_TYPE.EDIT) {
      setURL(`${url}&segment=${segmentId}`);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  //event functions

  const addEventListenerCloseForm = (event) => {
    if (event.data.message === 'closeForm' && event.origin === `${window.location.protocol}//${window.location.host}`) {
      setLoading(true);

      //convert route lineString data into groups of 2. Represents lon and lat coordinates.
      let data = _.chunk(event.data.route, 2);
      let description = event.data.description;

      if (formType === Constants.FORM_TYPE.ADD) {
        api
          .postSegment(projectId, { route: data, description })
          .then(() => {
            setLoading(false);
            refreshData();
            closeForm();
          })
          .catch((error) => {
            console.log(error);
          });
      } else if (formType === Constants.FORM_TYPE.EDIT) {
        api
          .putSegment(projectId, segmentId, { route: data, description })
          .then(() => {
            setLoading(false);
            refreshData();
            closeForm();
          })
          .catch((error) => {
            console.log(error);
          });
      }
    }
  };

  const addEventListenerInitialFormState = (event) => {
    if (
      event.data.message === 'setInitialFormState' &&
      event.origin === `${window.location.protocol}//${window.location.host}`
    ) {
      let { startCoordinates, endCoordinates, description } = event.data.formState;

      //space needed after comma in start/end coordinates to match TWM
      //this is needed for the dirtyCheck();
      //ie. startCoordinate = 56.698250,-121.707720
      //convert to 56.698250, -121.707720
      startCoordinates = startCoordinates.replace(',', ', ');
      endCoordinates = endCoordinates.replace(',', ', ');

      setInitialFormState({ ...defaultFormState, startCoordinates, endCoordinates, description });
    }
  };

  const removeEventListenerCloseForm = () => {
    window.removeEventListener('message', addEventListenerCloseForm);
  };

  const removeEventListenerInitialFormState = () => {
    window.removeEventListener('message', addEventListenerInitialFormState);
  };

  //modal helper functions

  const toggle = () => {
    setModalOpen(!modalOpen);
  };

  const handleClose = () => {
    if (dirtyCheck()) {
      toggle();
    } else {
      closeForm();
    }
  };

  const dirtyCheck = () => {
    // check if iFrame form is empty. if it's dirty we should ask user to confirm leaving
    let myForm = myIframe.current.contentWindow.document.forms['simple-router-form'];
    let dirtyFlag = false;

    //fixes crash if myiFrame hasn't loaded and user clicks cancel.
    if (!myForm) {
      return dirtyFlag;
    }

    for (let each in initialFormState) {
      if (initialFormState[each] !== myForm[each].value) {
        dirtyFlag = true;
      }
    }

    return dirtyFlag;
  };

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <iframe
        className="w-100"
        style={{ height: '800px' }}
        src={url}
        name="myIframe"
        id="myIframe"
        title="map"
        ref={myIframe}
      />
      <Button className="float-right mb-2" onClick={handleClose}>
        Cancel
      </Button>
      <Modal isOpen={modalOpen}>
        <ModalHeader>You have unsaved changes.</ModalHeader>
        <ModalBody>
          If the screen is closed before saving these changes, they will be lost. Do you want to continue without
          saving?
        </ModalBody>
        <ModalFooter>
          <Button size="sm" color="primary" onClick={closeForm}>
            Leave
          </Button>
          <Button color="secondary" size="sm" onClick={toggle}>
            Go Back
          </Button>
        </ModalFooter>
      </Modal>
    </React.Fragment>
  );
}

export default EditSegmentFormFields;
