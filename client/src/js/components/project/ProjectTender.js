import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

//components
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';
import SingleDropdown from '../ui/SingleDropdown';
import { Button, Container, Row, Col } from 'reactstrap';
import { Link } from 'react-router-dom';
import EditTenderFormFields from '../forms/EditTenderFormFields';
import EditQtyAccmpFormFields from '../forms/EditQtyAccmpFormFields';

import useFormModal from '../hooks/useFormModal';
import moment from 'moment';
import * as api from '../../Api';
import * as Constants from '../../Constants';

const ProjectTender = ({ match, history, fiscalYears, showValidationErrorDialog, projectSearchHistory }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  const [qtyOrAccmpFilter, setqtyOrAccmpFilter] = useState('ALL');
  const [fiscalYearsFilter, setFiscalYearsFilter] = useState('ALL');

  useEffect(() => {
    api
      .getProjectTender(match.params.id)
      .then((response) => {
        let data = response.data;
        data = {
          ...data,
          qtyAccmps: sortByFiscalYear(data.qtyAccmps),
          tenders: changeDateFormat(response.data.tenders),
        };

        setData(data);
        setLoading(false);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const projectTenderTableColumns = [
    { heading: 'Tender #', key: 'tenderNumber', nosort: true },
    { heading: 'Planned Date', key: 'plannedDate', nosort: true },
    { heading: 'Actual Date', key: 'actualDate', nosort: true },
    { heading: 'Tender Value', key: 'tenderValue', currency: true, nosort: true },
    { heading: 'Winning Contractor', key: 'winningCntrctr', nosort: true },
    { heading: 'Winning Bid', key: 'bidValue', currency: true, nosort: true },
    { heading: 'Comment', key: 'comment', nosort: true },
  ];

  const qaTableColumns = [
    { heading: 'Fiscal Year', key: 'fiscalYear', nosort: true },
    { heading: 'Accomplishment/Quantity', key: 'qtyAccmpName', nosort: true },
    { heading: 'Forecast', key: 'forecast', thousandSeparator: true, nosort: true },
    { heading: 'Schedule7', key: 'schedule7', thousandSeparator: true, nosort: true },
    { heading: 'Actual', key: 'actual', thousandSeparator: true, nosort: true },
    { heading: 'Comment', key: 'comment', nosort: true },
  ];

  //temporary fix hard code quantity and accomplishments
  const qtyAccmpArray = [
    { id: 'ALL', name: 'Show All Qty/Accmp' },
    { id: 'ACCOMPLISHMENT', name: 'Accomplishment' },
    { id: 'QUANTITY', name: 'Quantity' },
  ];

  //Tender edit, delete, put, post functions.
  const onTenderEditClicked = (tenderId) => {
    tendersFormModal.openForm(Constants.FORM_TYPE.EDIT, { tenderId, projectId: data.id });
  };

  const onTenderDeleteClicked = (tenderId) => {
    api
      .deleteTender(data.id, tenderId)
      .then(() => {
        refreshData();
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
  };

  const addTenderClicked = () => {
    tendersFormModal.openForm(Constants.FORM_TYPE.ADD);
  };

  const handleEditTenderFormSubmit = (values, formType) => {
    if (!tendersFormModal.submitting) {
      tendersFormModal.setSubmitting(true);
      if (formType === Constants.FORM_TYPE.ADD) {
        api
          .postTender(data.id, values)
          .then(() => {
            tendersFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => tendersFormModal.setSubmitting(false));
      } else if (formType === Constants.FORM_TYPE.EDIT) {
        api
          .putTender(data.id, values.id, values)
          .then(() => {
            tendersFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => tendersFormModal.setSubmitting(false));
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

  //helper functions

  const onQtyAccmpFilterChange = (qtyAccmpName) => {
    setqtyOrAccmpFilter(qtyAccmpName);
  };

  const onFiscalYearFilterChange = (fiscalId) => {
    const result =
      fiscalYears.find((fiscalYearItem) => {
        return fiscalYearItem.id === fiscalId;
      })?.codeName || 'ALL';
    setFiscalYearsFilter(result);
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

  const sortFunctionQtyAccmps = (a, b) => {
    let displayOrderYearA = fiscalYears.find((year) => year.codeName === a.fiscalYear).displayOrder;
    let displayOrderYearB = fiscalYears.find((year) => year.codeName === b.fiscalYear).displayOrder;

    return displayOrderYearA - displayOrderYearB;
  };

  const sortByFiscalYear = (items = []) => {
    return items.sort(sortFunctionQtyAccmps);
  };

  const refreshData = () => {
    api
      .getProjectTender(data.id)
      .then((response) => {
        let data = response.data;
        data = {
          ...data,
          qtyAccmps: sortByFiscalYear(data.qtyAccmps),
          tenders: changeDateFormat(response.data.tenders),
        };

        setData(data);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
  };

  const changeDateFormat = (tenderArray) => {
    let changedTenderArray = tenderArray.map((tender) => {
      return {
        ...tender,
        plannedDate:
          tender.plannedDate === null ? null : moment(tender.plannedDate).format(Constants.DATE_DISPLAY_FORMAT),
        actualDate: tender.actualDate === null ? null : moment(tender.actualDate).format(Constants.DATE_DISPLAY_FORMAT),
      };
    });

    return changedTenderArray;
  };

  const tendersFormModal = useFormModal('Tender Details', <EditTenderFormFields />, handleEditTenderFormSubmit, {
    saveCheck: true,
  });
  const qtyAccmpFormModal = useFormModal(
    'Quantities and Accomplishments',
    <EditQtyAccmpFormFields />,
    handleEditQtyAccmptFormSubmit,
    { saveCheck: true }
  );

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <UIHeader>
        <MaterialCard>{data.projectNumber} </MaterialCard>{' '}
      </UIHeader>

      <MaterialCard>
        <UIHeader>
          <Container>
            <Row>
              <Col xs="auto">Project Tender Details</Col>
              <Col>
                <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
                  <Button color="primary" className="float-right" onClick={addTenderClicked}>
                    + Add
                  </Button>
                </Authorize>
              </Col>
            </Row>
          </Container>
        </UIHeader>
        <DataTableControl
          dataList={data.tenders}
          tableColumns={projectTenderTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={onTenderEditClicked}
          onDeleteClicked={onTenderDeleteClicked}
        />
      </MaterialCard>
      <MaterialCard>
        <UIHeader>
          <Container>
            <Row>
              <Col xs="auto">Quantities/Accomplishments</Col>
              <Col xs={3}>
                <SingleDropdown
                  items={qtyAccmpArray}
                  handleOnChange={onQtyAccmpFilterChange}
                  defaultTitle="Show All Qty/Accmp"
                />
              </Col>
              <Col xs={3}>
                <SingleDropdown
                  items={[{ id: 'ALL', name: 'Show All Fiscal Years' }].concat(fiscalYears)}
                  handleOnChange={onFiscalYearFilterChange}
                  defaultTitle="Show All Fiscal Years"
                />
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
        <Link to={`${Constants.PATHS.PROJECTS}/${data.id}${Constants.PATHS.PROJECT_PLAN}`}>
          <Button color="secondary">{'< Project Planning'}</Button>
        </Link>
        <Link to={`${Constants.PATHS.PROJECTS}/${data.id}${Constants.PATHS.PROJECT_SEGMENT}`}>
          <Button color="primary">Continue</Button>
        </Link>
        <Button color="secondary" onClick={() => history.push(projectSearchHistory)}>
          Close
        </Button>
      </div>
      {tendersFormModal.formElement}
      {qtyAccmpFormModal.formElement}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    projectSearchHistory: state.projectSearchHistory.projectSearch,
    fiscalYears: state.codeLookups.fiscalYears,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectTender);
