import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

//components
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';
import { Button, Container, Row, Col } from 'reactstrap';
import { Link } from 'react-router-dom';
import SingleDropdown from '../ui/SingleDropdown';
import EditFinTargetFormFields from '../forms/EditFinTargetFormFields';
import EditQtyAccmpFormFields from '../forms/EditQtyAccmpFormFields';

import useFormModal from '../hooks/useFormModal';
import * as api from '../../Api';
import * as Constants from '../../Constants';

const ProjectPlan = ({ match, history, fiscalYears, showValidationErrorDialog, projectSearchHistory }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  const [fiscalYearsFilter, setFiscalYearsFilter] = useState('ALL');
  const [qtyOrAccmpFilter, setqtyOrAccmpFIlter] = useState('ALL');

  useEffect(() => {
    api
      .getProjectPlan(match.params.id)
      .then((response) => {
        setData(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const finTargetTableColumns = [
    { heading: 'Fiscal Year', key: 'fiscalYear', nosort: true },
    { heading: 'Project Phase', key: 'projectPhase', nosort: true },
    { heading: 'Element', key: 'element', nosort: true },
    { heading: 'Type', key: 'forecastType', nosort: true },
    { heading: 'Amount', key: 'amount', nosort: true },
    { heading: 'Description', key: 'description', nosort: true },
  ];

  const qaTableColumns = [
    { heading: 'Fiscal Year', key: 'fiscalYear', nosort: true },
    { heading: 'Accomplishment/Quantity', key: 'qtyAccmpType', nosort: true },
    { heading: 'Forecast', key: 'forecast', nosort: true },
    { heading: 'Schedule7', key: 'schedule7', nosort: true },
    { heading: 'Actual', key: 'actual', nosort: true },
    { heading: 'Comment', key: 'comment', nosort: true },
  ];

  //temporary fix hard code quantity and accomplishments
  const qtyAccmpArray = [
    { id: 'ALL', name: 'Show All' },
    { id: 'ACCOMPLISHMENT', name: 'Accomplishment' },
    { id: 'QUANTITY', name: 'Quantity' },
  ];

  //Financial Target edit, delete, put, post functions.
  const onFinTargetEditClicked = (finTargetId) => {
    finTargetsFormModal.openForm(Constants.FORM_TYPE.EDIT, { finTargetId, projectId: data.id });
  };

  const onFinTargetDeleteClicked = (finTargetid) => {
    api.deleteFinTarget(data.id, finTargetid).then(() => {
      refreshData();
    });
  };

  const addFinTargetClicked = () => {
    finTargetsFormModal.openForm(Constants.FORM_TYPE.ADD);
  };

  const handleEditFinTargetFormSubmit = (values, formType) => {
    if (!finTargetsFormModal.submitting) {
      finTargetsFormModal.setSubmitting(true);
      if (formType === Constants.FORM_TYPE.ADD) {
        api
          .postFinTarget(data.id, values)
          .then(() => {
            finTargetsFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => finTargetsFormModal.setSubmitting(false));
      } else if (formType === Constants.FORM_TYPE.EDIT) {
        api
          .putFinTarget(data.id, values.id, values)
          .then(() => {
            finTargetsFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => finTargetsFormModal.setSubmitting(false));
      }
    }
  };

  //Quantity Accomplishments edit, delete, put, post functions.
  const onQAEditClicked = (qtyAccmpId) => {
    qtyAccmpFormModal.openForm(Constants.FORM_TYPE.EDIT, { qtyAccmpId, projectId: data.id });
  };

  const onQADeleteClicked = (qtyAccmpId) => {
    api.deleteQtyAccmp(data.id, qtyAccmpId).then(() => refreshData());
  };

  const addQAClicked = () => {
    qtyAccmpFormModal.openForm(Constants.FORM_TYPE.ADD);
  };

  const handleEditQtyAccmptFormSubmit = (values, formType) => {
    if (!qtyAccmpFormModal.submitting) {
      qtyAccmpFormModal.setSubmitting(true);
      if (formType === Constants.FORM_TYPE.ADD) {
        api
          .postQtyAccmp(data.id, values)
          .then(() => {
            qtyAccmpFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => qtyAccmpFormModal.setSubmitting(false));
      } else if (formType === Constants.FORM_TYPE.EDIT) {
        api
          .putQtyAccmp(data.id, values.id, values)
          .then(() => {
            qtyAccmpFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => qtyAccmpFormModal.setSubmitting(false));
      }
    }
  };

  //filter helper functions
  const onFiscalYearFilterChange = (fiscalId) => {
    const result =
      fiscalYears.find((fiscalYearItem) => {
        return fiscalYearItem.id === fiscalId;
      })?.codeName || 'ALL';
    setFiscalYearsFilter(result);
  };

  const onQtyAccmpFilterChange = (qtyAccmpName) => {
    setqtyOrAccmpFIlter(qtyAccmpName);
  };

  const displayAfterYearFilter = (items) => {
    let filteredResult = items;
    if (fiscalYearsFilter === 'ALL') {
      return filteredResult;
    } else {
      return filteredResult.filter((items) => items.fiscalYear === fiscalYearsFilter);
    }
  };

  const displayAfterQtyAccmpsFilter = (items) => {
    let filteredResult = items;
    if (qtyOrAccmpFilter === 'ALL') {
      return filteredResult;
    } else {
      return filteredResult.filter((items) => items.qtyAccmpType === qtyOrAccmpFilter);
    }
  };

  const refreshData = () => {
    api
      .getProjectPlan(data.id)
      .then((response) => {
        setData(response.data);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
  };

  const finTargetsFormModal = useFormModal(
    'Financial Planning Targets',
    <EditFinTargetFormFields />,
    handleEditFinTargetFormSubmit,
    true
  );

  const qtyAccmpFormModal = useFormModal(
    'Quantities and Accomplishments',
    <EditQtyAccmpFormFields />,
    handleEditQtyAccmptFormSubmit,
    true
  );

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <UIHeader>Project {data.id} Details</UIHeader>
      <MaterialCard>
        <UIHeader>
          <Container>
            <Row>
              <Col xs="auto">Financial Planning Targets</Col>
              <Col xs={3}>
                <SingleDropdown
                  items={[{ id: 'ALL', name: 'Show All' }].concat(fiscalYears)}
                  handleOnChange={onFiscalYearFilterChange}
                  defaultTitle="Show All"
                />
              </Col>
              <Col>
                <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
                  <Button color="primary" className="float-right" onClick={addFinTargetClicked}>
                    + Add
                  </Button>
                </Authorize>
              </Col>
            </Row>
          </Container>
        </UIHeader>
        <DataTableControl
          dataList={displayAfterYearFilter(data.finTargets)}
          tableColumns={finTargetTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={onFinTargetEditClicked}
          onDeleteClicked={onFinTargetDeleteClicked}
        />
      </MaterialCard>
      <MaterialCard>
        <UIHeader>
          <Container>
            <Row>
              <Col xs="auto">Quantities/Accomplishments</Col>
              <Col xs={3}>
                <SingleDropdown items={qtyAccmpArray} handleOnChange={onQtyAccmpFilterChange} defaultTitle="Show All" />
              </Col>
              <Col>
                <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
                  <Button color="primary" className="float-right" onClick={addQAClicked}>
                    + Add
                  </Button>
                </Authorize>
              </Col>
            </Row>
          </Container>
        </UIHeader>
        <DataTableControl
          dataList={displayAfterQtyAccmpsFilter(displayAfterYearFilter(data.qtyAccmps))}
          tableColumns={qaTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={onQAEditClicked}
          onDeleteClicked={onQADeleteClicked}
        />
      </MaterialCard>
      <div className="text-right">
        <Link to={`${Constants.API_PATHS.PROJECTS}/${data.id}`}>
          <Button color="secondary">{'< Project Details'}</Button>
        </Link>
        <Button color="primary" onClick={() => alert('temporary fix link to next section')}>
          Continue
        </Button>
        <Button color="secondary" onClick={() => history.push(projectSearchHistory)}>
          Close
        </Button>
      </div>
      {finTargetsFormModal.formElement}
      {qtyAccmpFormModal.formElement}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    fiscalYears: state.codeLookups.fiscalYears,
    projectSearchHistory: state.projectSearchHistory.projectSearch,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectPlan);
