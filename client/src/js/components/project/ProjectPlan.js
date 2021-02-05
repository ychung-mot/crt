import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

//components
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const ProjectPlan = ({ match, fiscalYears, showValidationErrorDialog }) => {
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

  const finPlanTableColumns = [
    { heading: 'Fiscal Year', key: 'fiscalYear', noSort: true },
    { heading: 'Project Phase', key: 'projectPhase', noSort: true },
    { heading: 'Element', key: 'element', noSort: true },
    { heading: 'Type', key: 'forecastType', noSort: true },
    { heading: 'Amount', key: 'amount', noSort: true },
    { heading: 'Description', key: 'description', noSort: true },
  ];

  const qaTableColumns = [
    { heading: 'Fiscal Year', key: 'fiscalYear', noSort: true },
    { heading: 'Accomplishment/Quantity', key: 'qtyAccmpType', noSort: true },
    { heading: 'Forecast', key: 'forecast', noSort: true },
    { heading: 'Schedule7', key: 'schedule7', noSort: true },
    { heading: 'Actual', key: 'actual', noSort: true },
    { heading: 'Comment', key: 'comment', noSort: true },
  ];

  //temporary fix will make real edit and delete functions
  const onFinPlanEditClicked = (id) => {
    console.log(`Fin Plan edit project ${id}`);
  };

  const onFinPlanDeleteClicked = (id, endDate) => {
    console.log(`Fin Plan delete project ${id}`);
  };

  const onQAEditClicked = (id) => {
    console.log(`QA edit project ${id}`);
  };

  const onQADeleteClicked = (id, endDate) => {
    console.log(`QA delete project ${id}`);
  };

  //end temporary fix edit and delete functions

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <UIHeader>Project {data.id} Details</UIHeader>
      <MaterialCard>
        <UIHeader>Financial Planning Targets</UIHeader>
        <DataTableControl
          dataList={data.finTargets}
          tableColumns={finPlanTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={onFinPlanEditClicked}
          onDeleteClicked={onFinPlanDeleteClicked}
        />
      </MaterialCard>
      <MaterialCard>
        <UIHeader>Quantities/Accomplishments</UIHeader>
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
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    fiscalYears: state.codeLookups.fiscalYears,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectPlan);
