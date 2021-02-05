import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';

//components
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import DataTableControl from '../ui/DataTableControl';
import SubmitButton from '../ui/SubmitButton';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';
import { FormInput } from '../forms/FormInputs';
import { Formik, Form } from 'formik';
import Authorize from '../fragments/Authorize';
import FontAwesomeButton from '../ui/FontAwesomeButton';

import moment from 'moment';
import * as api from '../../Api';
import * as Constants from '../../Constants';

const Comments = ({ title, dataList, projectId, noteType, show = 1 }) => {
  const [modalExpand, setModalExpand] = useState(false);
  const [modalAdd, setModalAdd] = useState(false);
  const [modalSaveCheckOpen, setModalSaveCheckOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [data, setData] = useState([]);

  const myInput = useRef();

  useEffect(() => {
    setData(
      dataList.map((comment) => {
        return { ...comment, noteDate: moment(comment.noteDate).format('YYYY-MMM-DD') };
      })
    );
    //eslint-disable-next-line
  }, []);

  const tableColumns = [
    { heading: 'Date Added', key: 'noteDate', nosort: true },
    { heading: 'User', key: 'userId', nosort: true },
    { heading: 'Comment', key: 'comment', nosort: true },
  ];

  const toggleShowAllModal = () => setModalExpand(!modalExpand);
  const toggleShowAddModal = () => setModalAdd(!modalAdd);
  const toggleModalSaveCheck = () => {
    setModalSaveCheckOpen(!modalSaveCheckOpen);
  };

  const addCommentChangeCheck = (dirty = false) => {
    if (dirty) {
      toggleModalSaveCheck();
    } else {
      toggleShowAddModal();
    }
  };

  const handleCommentSubmit = (value) => {
    setSubmitting(true);
    api
      .postNote(projectId, { projectId, ...value, noteType })
      .then((response) => {
        setData(
          response.data.notes
            .filter((note) => note.noteType === noteType)
            .map((comment) => {
              return { ...comment, noteDate: moment(comment.noteDate).format('YYYY-MMM-DD') };
            })
        );
        toggleShowAddModal();
        setSubmitting(false);
      })
      .catch((error) => {
        console.log(error);
        setSubmitting(false);
      });
  };

  const handleConfirmLeave = () => {
    setModalAdd(false);
    setModalSaveCheckOpen(false);
  };

  return (
    <MaterialCard>
      <UIHeader>
        {title}
        <div className="float-right">
          <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
            <FontAwesomeButton
              icon="plus"
              onClick={toggleShowAddModal}
              iconSize={'lg'}
              title={`Add ${title}`}
              className="mr-2"
            />
          </Authorize>
          <FontAwesomeButton
            icon="expand-alt"
            onClick={toggleShowAllModal}
            iconSize={'lg'}
            title={`Show all ${title}`}
          />
        </div>
      </UIHeader>
      <DataTableControl dataList={data.slice(show * -1)} tableColumns={tableColumns} />

      <Modal isOpen={modalExpand} toggle={toggleShowAllModal} size="lg">
        <ModalHeader toggle={toggleShowAllModal}>{title} History</ModalHeader>
        <ModalBody>
          <DataTableControl dataList={data} tableColumns={tableColumns} />
        </ModalBody>
        <ModalFooter>
          <div className="text-right">
            <Button color="primary" onClick={toggleShowAllModal}>
              Close
            </Button>
          </div>
        </ModalFooter>
      </Modal>

      <Modal
        isOpen={modalAdd}
        toggle={toggleShowAddModal}
        onOpened={() => myInput.current && myInput.current.focus()}
        size="lg"
      >
        <ModalHeader toggle={toggleShowAddModal}>Add {title}</ModalHeader>
        <Formik initialValues={{ comment: '' }} onSubmit={handleCommentSubmit}>
          {({ dirty, values }) => (
            <Form>
              <ModalBody>
                <FormInput
                  innerRef={myInput}
                  type="textarea"
                  name="comment"
                  placeholder="Insert Comment Here"
                  rows={5}
                />
              </ModalBody>
              <ModalFooter>
                <div className="text-right">
                  <SubmitButton
                    submitting={submitting}
                    disabled={!dirty || values.comment.trim().length === 0 || submitting}
                  />
                  <Button color="secondary" onClick={() => addCommentChangeCheck(dirty)}>
                    Close
                  </Button>
                </div>
              </ModalFooter>
            </Form>
          )}
        </Formik>
      </Modal>

      <Modal isOpen={modalSaveCheckOpen}>
        <ModalHeader>You have unsaved changes.</ModalHeader>
        <ModalBody>
          If the screen is closed before saving these changes, they will be lost. Do you want to continue without
          saving?
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
    </MaterialCard>
  );
};

Comments.propTypes = {
  dataList: PropTypes.arrayOf(PropTypes.shape({})).isRequired,
  projectId: PropTypes.number.isRequired,
  title: PropTypes.string.isRequired,
  show: PropTypes.number, //changes how many comments to show starting from the most recent
};

export default Comments;
