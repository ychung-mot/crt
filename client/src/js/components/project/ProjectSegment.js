import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';
import _ from 'lodash';

import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';
import { Button, Container, Row, Col } from 'reactstrap';
import { Link } from 'react-router-dom';
import EditSegmentFormFields from '../forms/EditSegmentFormFields';
import EditHighwayFormFields from '../forms/EditHighwayFormFields';

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
  const [ratiosData, setRatiosData] = useState({});

  useEffect(() => {
    api
      .getProjectLocations(match.params.id)
      .then((response) => {
        setData(response.data);
        setRatiosData(groupRatios(response.data?.ratios));
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
  const onDeleteSegmentClicked = (segmentId) => {
    api
      .deleteSegment(data.id, segmentId)
      .then(() => {
        refreshData();
      })
      .catch((error) => {
        console.log(error);
      });
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

  //ratios highways
  const addHighwayClicked = () => {
    console.log('clicked');
  };
  const editHighwayClicked = () => {
    console.log('edit');
  };
  const deleteHighwayClicked = () => {
    console.log('delete');
  };

  const handleEditHighwayFormSubmit = (values, formType) => {
    console.log(values);
    console.log(formType);
  };

  const highwayTableColumns = [
    { heading: 'Highway', key: 'ratioRecordName', nosort: true },
    { heading: 'Ratios', key: 'ratio', nosort: true },
  ];

  const RatioTable = ({
    title,
    onDeleteClicked,
    tableColumns,
    editPermissionName,
    formModalFields,
    handleFormSubmit,
    projectId,
    ...props
  }) => {
    const myHandleFormSubmit = (values, formType) => {
      console.log(values);
      if (!formModal.submitting) {
        formModal.setSubmitting(true);
        if (formType === Constants.FORM_TYPE.ADD) {
          api
            .postRatio(projectId, values)
            .then(() => {
              formModal.closeForm();
              refreshData();
            })
            .catch((error) => {
              console.log(error.response);
              showValidationErrorDialog(error.response.data);
            })
            .finally(() => formModal.setSubmitting(false));
        } else if (formType === Constants.FORM_TYPE.EDIT) {
          api
            .putTender(data.id, values.id, values)
            .then(() => {
              formModal.closeForm();
              refreshData();
            })
            .catch((error) => {
              console.log(error.response);
              showValidationErrorDialog(error.response.data);
            })
            .finally(() => formModal.setSubmitting(false));
        }
      }
    };

    const formModal = useFormModal(title, formModalFields, myHandleFormSubmit, { saveCheck: true });

    const onAddClicked = () => {
      formModal.openForm(Constants.FORM_TYPE.ADD);
    };

    const onEditClicked = (ratioId) => {
      formModal.openForm(Constants.FORM_TYPE.EDIT, { ratioId, projectId: projectId });
    };

    return (
      <Container>
        <UIHeader>
          <Row>
            <Col xs="auto">{title}</Col>
            <Col>
              <Authorize requires={editPermissionName}>
                <Button color="primary" className="float-right" onClick={onAddClicked}>
                  + Add
                </Button>
              </Authorize>
            </Col>
          </Row>
        </UIHeader>
        <DataTableControl
          dataList={ratiosData.highway}
          tableColumns={highwayTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={onEditClicked}
          onDeleteClicked={onDeleteClicked}
        />
        {formModal.formElement}
      </Container>
    );
  };

  //helper functions

  const refreshData = () => {
    api
      .getProjectLocations(match.params.id)
      .then((response) => {
        setData(response.data);
        setRatiosData(groupRatios(response.data?.ratios));
      })
      .catch((error) => {
        console.log(error);
        showValidationErrorDialog(error.response.data);
      });
  };

  const groupRatios = (ratios = []) => {
    //takes array of ratios and returns an Object grouped by Ratio Record Type.

    const camelCaseConvert = (item = {}) => {
      let keyName = ratioRecordTypes.find((ratioType) => ratioType.id === item.ratioRecordTypeLkupId).codeName;
      keyName = `${keyName[0].toLowerCase()}${keyName.slice(1, keyName.length)}`;
      keyName = keyName.replace(/\b \b/g, '');

      return keyName;
    };

    let groupedRatios = _.groupBy(ratios, camelCaseConvert);

    return groupedRatios;
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
          onDeleteClicked={onDeleteSegmentClicked}
        />
      </MaterialCard>
      <MaterialCard>
        <UIHeader>
          <Row>
            <Col xs="auto">{'Project Ratios'}</Col>
          </Row>
        </UIHeader>
        <Row>
          <Col xs={5}>
            <RatioTable
              title="Highways"
              projectId={data.id}
              tableColumns={highwayTableColumns}
              onAddClicked={addHighwayClicked}
              onDeleteClicked={deleteHighwayClicked}
              onEditClicked={editHighwayClicked}
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              formModalFields={<EditHighwayFormFields />}
              handleFormSubmit={handleEditHighwayFormSubmit}
              refreshData={refreshData}
            />
          </Col>
        </Row>
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
