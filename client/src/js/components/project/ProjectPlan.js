import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

//components
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';
import { Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import EditFinTargetFormFields from '../forms/EditFinTargetFormFields';

import useFormModal from '../hooks/useFormModal';
import * as api from '../../Api';
import * as Constants from '../../Constants';

const ProjectPlan = ({ match, history, fiscalYears, showValidationErrorDialog, projectSearchHistory }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

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

  //temporary fix will make real edit and delete functions
  const onFinTargetEditClicked = (finTargetId) => {
    formModal.openForm(Constants.FORM_TYPE.EDIT, { finTargetId, projectId: data.id });
  };

  const onFinTargetDeleteClicked = (id, endDate) => {
    console.log(`Fin Plan delete project ${id}`);
  };

  const addFinTargetClicked = () => {
    formModal.openForm(Constants.FORM_TYPE.ADD);
  };

  const onQAEditClicked = (id) => {
    console.log(`QA edit project ${id}`);
  };

  const onQADeleteClicked = (id, endDate) => {
    console.log(`QA delete project ${id}`);
  };

  const addQAClicked = () => {
    console.log('adding new quantity/accomplishment');
  };

  //end temporary fix edit and delete functions

  const handleEditFinTargetFormSubmit = (values) => {
    console.log(`submitting ${values}`);
  };

  const formModal = useFormModal(
    'Financial Planning Targets',
    <EditFinTargetFormFields />,
    handleEditFinTargetFormSubmit,
    true
  );

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <UIHeader>Project {data.id} Details</UIHeader>
      <MaterialCard>
        <UIHeader>
          Financial Planning Targets
          <Button color="primary" className="float-right" onClick={addFinTargetClicked}>
            + Add
          </Button>
        </UIHeader>
        <DataTableControl
          dataList={data.finTargets}
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
          Quantities/Accomplishments{' '}
          <Button color="primary" className="float-right" onClick={addQAClicked}>
            + Add
          </Button>
        </UIHeader>
        <DataTableControl
          dataList={data.qtyAccmps}
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
      {formModal.formElement}
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
