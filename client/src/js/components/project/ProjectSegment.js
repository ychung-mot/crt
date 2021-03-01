import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';
import { Button, Container, Row, Col } from 'reactstrap';
import { Link } from 'react-router-dom';
import EditSegmentFormFields from '../forms/EditSegmentFormFields';

import useFormModal from '../hooks/useFormModal';
import * as api from '../../Api';
import * as Constants from '../../Constants';

const segmentTableColumns = [
  { heading: 'Segment#', key: 'segment', nosort: true },
  { heading: 'Segment start coordinates', key: 'segmentStart', nosort: true },
  { heading: 'Segment end coordinates', key: 'segmentEnd', nosort: true },
];

function ProjectSegment({ history, match, projectSearchHistory, ...props }) {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  //segment helper functions
  const editSegmentClicked = () => {
    console.log('hi');
  };
  const deleteSegmentClicked = () => {
    console.log('bye');
  };

  const addSegmentClicked = () => {
    segmentsFormModal.openForm(Constants.FORM_TYPE.ADD);
    console.log('add');
  };

  const handleEditSegmentFormSubmit = (values) => {
    console.log('submitting');
    console.log(values);
  };

  const segmentsFormModal = useFormModal('Segments', <EditSegmentFormFields />, handleEditSegmentFormSubmit, {
    size: 'xl',
    showModalHeader: false,
    showModalFooter: false,
  });

  if (loading) {
    return <PageSpinner />;
  }

  return (
    <React.Fragment>
      <UIHeader>
        <MaterialCard>
          <Row>
            <Col xs="auto">{'Project Title'}</Col>
          </Row>
        </MaterialCard>
      </UIHeader>

      <MaterialCard>
        <UIHeader>
          <Row>
            <Col xs="auto">{'Project Segments'}</Col>
            <Col>
              <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
                <Button color="primary" className="float-right" onClick={addSegmentClicked}>
                  + Add
                </Button>
              </Authorize>
            </Col>
          </Row>
        </UIHeader>
        <DataTableControl
          dataList={[]}
          tableColumns={segmentTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={editSegmentClicked}
          onDeleteClicked={deleteSegmentClicked}
        />
      </MaterialCard>
      <div className="text-right">
        {/* temporary fix replace match with data.id */}
        <Link to={`${Constants.PATHS.PROJECTS}/${match.params.id}${Constants.PATHS.PROJECT_TENDER}`}>
          <Button color="secondary">{'< Project Tender'}</Button>
        </Link>
        <Button color="primary" onClick={() => history.push(projectSearchHistory)}>
          Close
        </Button>
      </div>
      {segmentsFormModal.formElement}
    </React.Fragment>
  );
}

const mapStateToProps = (state) => {
  return {
    projectSearchHistory: state.projectSearchHistory.projectSearch,
  };
};

export default connect(mapStateToProps, null)(ProjectSegment);
