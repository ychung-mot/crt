import React, { useState, useEffect } from 'react';

import { useLocation } from 'react-router-dom';
import { connect } from 'react-redux';
import { Row, Col, Button } from 'reactstrap';
import { Formik, Form, Field } from 'formik';
import queryString from 'query-string';
import * as Yup from 'yup';

import Authorize from './fragments/Authorize';
import MaterialCard from './ui/MaterialCard';
import UIHeader from './ui/UIHeader';
import MultiDropdownField from './ui/MultiDropdownField';
import AddUserWizard from './forms/AddUserWizard';
import DataTableWithPaginaionControl from './ui/DataTableWithPaginaionControl';
import SubmitButton from './ui/SubmitButton';
import PageSpinner from './ui/PageSpinner';
import useSearchData from './hooks/useSearchData';
import useFormModal from './hooks/useFormModal';
import EditUserFormFields from './forms/EditUserFormFields';

import { showValidationErrorDialog } from '../redux/actions';

import * as Constants from '../Constants';
import * as api from '../Api';
import { buildStatusIdArray } from '../utils';

const defaultSearchFormValues = {
  searchText: '',
  statusId: [Constants.ACTIVE_STATUS.ACTIVE],
};

const defaultSearchOptions = {
  searchText: '',
  isActive: true,
  dataPath: Constants.API_PATHS.USER,
};

const tableColumns = [
  { heading: 'First Name', key: 'firstName' },
  { heading: 'Last Name', key: 'lastName' },
  { heading: 'User ID', key: 'username' },
  { heading: 'Email', key: 'email' },
  { heading: 'Region', key: 'region' },
  { heading: 'Active', key: 'isActive', nosort: true },
];

const validationSchema = Yup.object({
  username: Yup.string().required('Required').max(32).trim(),
  userRoleIds: Yup.array().required('Require at least one role'),
});

const UserAdmin = ({ userStatuses, showValidationErrorDialog, userRegions }) => {
  const location = useLocation();
  const searchData = useSearchData(defaultSearchOptions);
  const [searchInitialValues, setSearchInitialValues] = useState(defaultSearchFormValues);
  const [addUserWizardIsOpen, setAddUserWizardIsOpen] = useState(false);

  // Run on load, parse URL query params
  useEffect(() => {
    const params = queryString.parse(location.search);

    const options = {
      ...defaultSearchOptions,
      ...params,
    };

    searchData.updateSearchOptions(options);

    const searchText = options.searchText || '';

    setSearchInitialValues({
      ...searchInitialValues,
      searchText,
      statusId: buildStatusIdArray(options.isActive),
    });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearchFormSubmit = (values) => {
    const searchText = values.searchText.trim() || null;

    let isActive = null;
    if (values.statusId.length === 1) {
      isActive = values.statusId[0] === 'ACTIVE';
    }

    const options = {
      ...searchData.searchOptions,
      isActive,
      searchText,
      pageNumber: 1,
    };
    searchData.updateSearchOptions(options);
  };

  const handleSearchFormReset = () => {
    setSearchInitialValues(defaultSearchFormValues);
    searchData.refresh(true);
  };

  const onEditClicked = (userId) => {
    formModal.openForm(Constants.FORM_TYPE.EDIT, { userId });
  };

  const onDeleteClicked = (userId, endDate) => {
    api.deleteUser(userId, endDate).then(() => searchData.refresh());
  };

  const handleAddUserWizardClose = (refresh) => {
    if (refresh === true) {
      searchData.refresh();
    }

    setAddUserWizardIsOpen(false);
  };

  const handleEditFormSubmit = (values) => {
    if (!formModal.submitting) {
      formModal.setSubmitting(true);

      api
        .putUser(values.id, values)
        .then(() => {
          formModal.closeForm();
          searchData.refresh();
        })
        .catch((error) => showValidationErrorDialog(error.response.data))
        .finally(() => formModal.setSubmitting(false));
    }
  };

  const formModal = useFormModal(
    'User',
    <EditUserFormFields validationSchema={validationSchema} />,
    handleEditFormSubmit
  );

  const data = Object.values(searchData.data).map((user) => ({
    ...user,
  }));

  return (
    <React.Fragment>
      <MaterialCard>
        <UIHeader>User Management</UIHeader>
        {/* temporary fix adding userregions into intiial values for formik until search function is complete */}
        <Formik
          initialValues={{ ...searchInitialValues, userRegions: [] }}
          enableReinitialize={true}
          onSubmit={(values) => handleSearchFormSubmit(values)}
          onReset={handleSearchFormReset}
        >
          {(formikProps) => (
            <Form>
              <Row form>
                <Col>
                  <MultiDropdownField {...formikProps} items={userRegions} name="userRegions" title="Regions" />
                </Col>
                <Col>
                  <Field
                    type="text"
                    name="searchText"
                    placeholder="User Id/Name/Organization"
                    className="form-control"
                  />
                </Col>
                <Col>
                  <MultiDropdownField {...formikProps} items={userStatuses} name="statusId" title="User Status" />
                </Col>
                <Col>
                  <div className="float-right">
                    <SubmitButton className="mr-2" disabled={searchData.loading} submitting={searchData.loading}>
                      Search
                    </SubmitButton>
                    <Button type="reset">Reset</Button>
                  </div>
                </Col>
              </Row>
            </Form>
          )}
        </Formik>
      </MaterialCard>
      <Authorize requires={Constants.PERMISSIONS.USER_W}>
        <Row>
          <Col>
            <Button size="sm" color="primary" className="float-right mb-3" onClick={() => setAddUserWizardIsOpen(true)}>
              Add User
            </Button>
          </Col>
        </Row>
      </Authorize>
      {searchData.loading && <PageSpinner />}
      {!searchData.loading && (
        <MaterialCard>
          {data.length > 0 && (
            <DataTableWithPaginaionControl
              dataList={data}
              tableColumns={tableColumns}
              searchPagination={searchData.pagination}
              onPageNumberChange={searchData.handleChangePage}
              onPageSizeChange={searchData.handleChangePageSize}
              editable
              editPermissionName={Constants.PERMISSIONS.USER_W}
              onEditClicked={onEditClicked}
              onDeleteClicked={onDeleteClicked}
              onHeadingSortClicked={searchData.handleHeadingSortClicked}
            />
          )}
          {searchData.data.length <= 0 && <div>No records found</div>}
        </MaterialCard>
      )}
      {formModal.formElement}
      {addUserWizardIsOpen && (
        <AddUserWizard
          isOpen={addUserWizardIsOpen}
          toggle={handleAddUserWizardClose}
          validationSchema={validationSchema}
        />
      )}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    userStatuses: Object.values(state.user.statuses),
    //hard coded regions for now until API is set up. state.user.regions
    userRegions: [
      { id: 'HQ', name: 'Headquarters' },
      { id: 'NR', name: 'Nothern Region' },
      { id: 'SR', name: 'Southern Region' },
      { id: 'SCR', name: 'Southern Coast Region' },
    ],
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(UserAdmin);
