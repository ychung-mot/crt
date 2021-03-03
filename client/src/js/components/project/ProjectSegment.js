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
  { heading: 'Segment start coordinates', key: 'startCoordinates', nosort: true },
  { heading: 'Segment end coordinates', key: 'endCoordinates', nosort: true },
];

function ProjectSegment({
  showValidationErrorDialog,
  ratioRecordTypes,
  history,
  match,
  projectSearchHistory,
  ...props
}) {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState({});

  useEffect(() => {
    api
      .getProjectLocations(match.params.id)
      .then((response) => {
        setData(response.data);
      })
      .catch((error) => {
        console.log(error);
        showValidationErrorDialog(error.response.data);
      })
      .finally(() => {
        setLoading(false);
      });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  //segment helper functions
  const editSegmentClicked = () => {
    console.log('hi');
  };
  const deleteSegmentClicked = (segmentId) => {
    console.log(segmentId);
    console.log(`projectId ${data.id}`);
    console.log('bye');
  };

  const addSegmentClicked = () => {
    segmentsFormModal.openForm(Constants.FORM_TYPE.ADD, { projectId: data.id, refreshData: refreshData });
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

  //helper functions

  const refreshData = () => {
    api
      .getProjectLocations(match.params.id)
      .then((response) => {
        setData(response.data);
      })
      .catch((error) => {
        console.log(error);
        showValidationErrorDialog(error.response.data);
      });
  };

  if (loading) {
    return <PageSpinner />;
  }

  return (
    <React.Fragment>
      <UIHeader>
        <MaterialCard>
          <Row>
            <Col xs="auto">{data.projectNumber}</Col>
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
          dataList={data.segments}
          tableColumns={segmentTableColumns}
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onDeleteClicked={deleteSegmentClicked}
        />
      </MaterialCard>
      <MaterialCard>
        <UIHeader>
          <Row>
            <Col xs="auto">{'Project Ratios'}</Col>
          </Row>
        </UIHeader>
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
    ratioRecordTypes: state.codeLookups.ratioRecordTypes,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectSegment);
