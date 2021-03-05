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
import EditElectoralDistrictFormFields from '../forms/EditElectoralDistrictFormFields';
import EditServiceAreaFormFields from '../forms/EditServiceAreaFormFields';
import EditDistrictFormFields from '../forms/EditDistrictFormFields';
import EditEconomicRegionFormFields from '../forms/EditEconomicRegionFormFields';

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

  //ratios

  const highwayTableColumns = [
    { heading: 'Highway', key: 'ratioRecordName', nosort: true },
    { heading: 'Ratios', key: 'ratio', nosort: true },
  ];

  const electoralDistrictTableColumns = [
    { heading: 'Electoral District', key: 'ratioRecordName', nosort: true },
    { heading: 'Ratios', key: 'ratio', nosort: true },
  ];

  const economicRegionTableColumns = [
    { heading: 'Economic Region', key: 'ratioRecordName', nosort: true },
    { heading: 'Ratios', key: 'ratio', nosort: true },
  ];

  const serviceAreaTableColumns = [
    { heading: 'Service Area', key: 'serviceAreaName', nosort: true },
    { heading: 'Ratios', key: 'ratio', nosort: true },
  ];

  const districtTableColumns = [
    { heading: 'District', key: 'districtName', nosort: true },
    { heading: 'Ratios', key: 'ratio', nosort: true },
  ];

  //TO REFRACTOR OUT====================================================================
  const RatioTable = ({
    title,
    ratioTypeName,
    tableColumns,
    editPermissionName,
    formModalFields,
    handleFormSubmit,
    projectId,
    dataList = [],
    ...props
  }) => {
    const myHandleFormSubmit = (values, formType) => {
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
            .putRatio(projectId, values.id, values)
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

    const onAddClicked = () => {
      formModal.openForm(Constants.FORM_TYPE.ADD, { ratioTypeName: ratioTypeName });
    };

    const onEditClicked = (ratioId) => {
      formModal.openForm(Constants.FORM_TYPE.EDIT, { ratioId, projectId });
    };

    const onDeleteClicked = (ratioId) => {
      api
        .deleteRatio(projectId, ratioId)
        .then(() => {
          refreshData();
        })
        .catch((error) => console.log(error));
    };

    const formModal = useFormModal(title, formModalFields, myHandleFormSubmit, { saveCheck: true });

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
          dataList={dataList}
          tableColumns={tableColumns}
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
  //TO REFRACTOR OUT====================================================================

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
          <Col xs={4}>
            <RatioTable
              title="Electoral Districts"
              ratioTypeName="Electoral District"
              dataList={ratiosData.electoralDistrict}
              projectId={data.id}
              tableColumns={electoralDistrictTableColumns}
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              formModalFields={<EditElectoralDistrictFormFields />}
              refreshData={refreshData}
            />
          </Col>
          <Col xs={4}>
            <RatioTable
              title="Highways"
              ratioTypeName="Highway"
              dataList={ratiosData.highway}
              projectId={data.id}
              tableColumns={highwayTableColumns}
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              formModalFields={<EditHighwayFormFields />}
              refreshData={refreshData}
            />
          </Col>
          <Col xs={4}>
            <RatioTable
              title="Service Areas"
              ratioTypeName="Service Area"
              dataList={ratiosData.serviceArea}
              projectId={data.id}
              tableColumns={serviceAreaTableColumns}
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              formModalFields={<EditServiceAreaFormFields />}
              refreshData={refreshData}
            />
          </Col>
        </Row>
        <Row>
          <Col xs={4}>
            <RatioTable
              title="Districts"
              ratioTypeName="District"
              dataList={ratiosData.district}
              projectId={data.id}
              tableColumns={districtTableColumns}
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              formModalFields={<EditDistrictFormFields />}
              refreshData={refreshData}
            />
          </Col>
          <Col xs={4}>
            <RatioTable
              title="Economic Regions"
              ratioTypeName="Economic Region"
              dataList={ratiosData.economicRegion}
              projectId={data.id}
              tableColumns={economicRegionTableColumns}
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              formModalFields={<EditEconomicRegionFormFields />}
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
