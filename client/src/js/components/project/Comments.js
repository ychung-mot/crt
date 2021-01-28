import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';

//components
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import DataTableControl from '../ui/DataTableControl';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';

import moment from 'moment';

const Comments = ({ title, dataList, show = 1 }) => {
  const [modalExpand, setModalExpand] = useState(false);
  const [modalAdd, setModalAdd] = useState(false);
  const [data, setData] = useState([]);

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

  return (
    <MaterialCard>
      <UIHeader>{title}</UIHeader>
      <DataTableControl dataList={data.slice(show * -1)} tableColumns={tableColumns} />
      <div className="text-right">
        <Button color="primary" onClick={toggleShowAddModal}>
          Add
        </Button>
        <Button color="primary" onClick={toggleShowAllModal}>
          Expand
        </Button>
      </div>
      <Modal isOpen={modalExpand} toggle={toggleShowAllModal}>
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
      <Modal isOpen={modalAdd} toggle={toggleShowAddModal}>
        <ModalHeader toggle={toggleShowAddModal}>Add {title}</ModalHeader>
        <ModalBody>Adding comment</ModalBody>
        <ModalFooter>
          <div className="text-right">
            <Button color="primary" onClick={toggleShowAddModal}>
              Close
            </Button>
          </div>
        </ModalFooter>
      </Modal>
    </MaterialCard>
  );
};

Comments.propTypes = {
  dataList: PropTypes.arrayOf(PropTypes.shape({})).isRequired,
  title: PropTypes.string.isRequired,
  show: PropTypes.number, //changes how many comments to show starting from the most recent
};

export default Comments;
