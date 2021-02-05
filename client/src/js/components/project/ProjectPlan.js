import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

//components
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';

import * as api from '../../Api';

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

  if (loading) return <PageSpinner />;

  return (
    <MaterialCard>
      <UIHeader>Project {match.params.id} Details</UIHeader>
    </MaterialCard>
  );
};

const mapStateToProps = (state) => {
  return {
    fiscalYears: state.codeLookups.fiscalYears,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectPlan);

// fetchFiscalYears
// fetchQuantities
// fetchAccomplishments
// fetchPhases
// fetchContractors
// fetchForecastTypes
