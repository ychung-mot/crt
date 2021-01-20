import React, { useState, useEffect } from 'react';
import { connect } from 'react-redux';

import PageSpinner from './ui/PageSpinner';
import ErrorDialogModal from './ui/ErrorDialogModal';

import { fetchCurrentUser, fetchUserStatuses, fetchRegions } from '../redux/actions';

const Main = ({ errorDialog, children, fetchCurrentUser, fetchUserStatuses, fetchRegions }) => {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([fetchCurrentUser(), fetchUserStatuses(), fetchRegions()]).then(() => setLoading(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <React.Fragment>
      {loading ? <PageSpinner /> : children}
      {errorDialog.show && <ErrorDialogModal isOpen={errorDialog.show} {...errorDialog} />}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    errorDialog: state.errorDialog,
  };
};

export default connect(mapStateToProps, {
  fetchCurrentUser,
  fetchUserStatuses,
  fetchRegions,
})(Main);
