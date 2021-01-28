import React, { useState } from 'react';
import PropTypes from 'prop-types';

//components
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import DataTableControl from '../ui/DataTableControl';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';

const Comments = ({ title, data, show = 1 }) => {
  const [modal, setModal] = useState(false);

  const tableColumns = [
    { heading: 'Date Added', key: 'noteDate', nosort: true },
    { heading: 'User', key: 'userId', nosort: true },
    { heading: 'Comment', key: 'comment', nosort: true },
  ];

  const toggleShowAllModal = () => setModal(!modal);

  return (
    <MaterialCard>
      <UIHeader>{title}</UIHeader>
      <DataTableControl dataList={data.slice(0, show)} tableColumns={tableColumns} />
      <Modal isOpen={modal} toggle={toggleShowAllModal}>
        <ModalHeader toggle={toggleShowAllModal}>{title} Comment History</ModalHeader>
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
      <div className="text-right">
        <Button color="primary">Add</Button>
        <Button color="primary" onClick={toggleShowAllModal}>
          Expand
        </Button>
      </div>
    </MaterialCard>
  );
};

Comments.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({})).isRequired,
  title: PropTypes.string.isRequired,
  show: PropTypes.number,
};

export default Comments;
