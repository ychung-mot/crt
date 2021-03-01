import React, { useState, useEffect } from 'react';

import { useLocation } from 'react-router-dom';
import { connect } from 'react-redux';
import { Row, Col, Button } from 'reactstrap';
import { Formik, Form, Field } from 'formik';
import queryString from 'query-string';

//components
import Authorize from './fragments/Authorize';
import MaterialCard from './ui/MaterialCard';
import UIHeader from './ui/UIHeader';
import MultiDropdownField from './ui/MultiDropdownField';
import DataTableWithPaginaionControl from './ui/DataTableWithPaginaionControl';
import SubmitButton from './ui/SubmitButton';
import PageSpinner from './ui/PageSpinner';
import useSearchData from './hooks/useSearchData';
import useFormModal from './hooks/useFormModal';
import EditProjectFormFields from '../components/forms/EditProjectFormFields';

import {
  showValidationErrorDialog,
  setProjectSearchHistory,
  setProjectSearchFormikValues,
  resetProjectSearchFormikValues,
} from '../redux/actions';

import * as Constants from '../Constants';
import * as api from '../Api';

const defaultSearchFormValues = { searchText: '', regionIds: [], projectManagerIds: [], isInProgress: [] };

const defaultSearchOptions = {
  searchText: '',
  isInProgress: true,
  dataPath: Constants.API_PATHS.PROJECTS,
  regionIds: '',
};

const tableColumns = [
  { heading: 'Region', key: 'regionId' },
  {
    heading: 'Project',
    key: 'projectNumber',
    link: { path: `${Constants.PATHS.PROJECTS}/:id`, key: 'projectNumber' },
  },
  {
    heading: 'Planning Targets',
    key: 'projectValue',
    link: {
      path: `${Constants.PATHS.PROJECTS}/:id${Constants.PATHS.PROJECT_PLAN}`,
      key: 'projectValue',
      heading: 'Planning Targets',
    },
    currency: true,
    nosort: true,
  },
  {
    heading: 'Tender Details',
    key: 'tenderDetails',
    link: {
      path: `${Constants.PATHS.PROJECTS}/:id${Constants.PATHS.PROJECT_TENDER}`,
      key: 'winningContractorName',
      heading: 'Tender Details',
    },
    nosort: true,
  },
  { heading: 'Location and Ratios', key: 'locationRatios', nosort: true },
  { heading: '', key: 'isInProgress', nosort: true, badge: { active: 'In-Progress', inactive: 'Completed' } },
];

let formikInitialValues = {
  searchText: '',
  regionIds: [],
  projectManagerIds: [],
  isInProgress: ['inProgress'],
};

//temporary fix hardcode project status
const isInProgress = [
  { id: 'inProgress', name: 'In Progress' },
  { id: 'complete', name: 'Completed' },
];

const Projects = ({
  currentUser,
  projectMgr,
  setProjectSearchHistory,
  setProjectSearchFormikValues,
  resetProjectSearchFormikValues,
  showValidationErrorDialog,
  reduxFormikValues,
}) => {
  const location = useLocation();
  const searchData = useSearchData(defaultSearchOptions);
  const [searchInitialValues, setSearchInitialValues] = useState(defaultSearchFormValues);

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
    });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    setProjectSearchHistory(location.pathname + location.search);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [`${location.search}`]);

  const handleSearchFormSubmit = (values) => {
    setProjectSearchFormikValues(values);
    const searchText = values.searchText.trim() || null;
    let isInProgress = null;
    if (values.isInProgress.length === 1) {
      isInProgress = values.isInProgress[0] === 'inProgress';
    }

    const options = {
      ...searchData.searchOptions,
      isInProgress,
      searchText,
      regionIds: values.regionIds.join(',') || null,
      projectManagerIds: values.projectManagerIds.join(',') || null,
      pageNumber: 1,
    };
    searchData.updateSearchOptions(options);
  };

  const handleSearchFormReset = () => {
    setSearchInitialValues(defaultSearchFormValues);
    resetProjectSearchFormikValues();
    searchData.refresh(true);
  };

  const onDeleteClicked = (projectId, endDate) => {
    api.deleteProject(projectId, endDate).then(() => searchData.refresh());
  };

  const handleAddProjectFormSubmit = (values, formType) => {
    if (!formModal.submitting) {
      formModal.setSubmitting(true);
      api
        .postProject(values)
        .then(() => {
          formModal.closeForm();
          searchData.refresh();
        })
        .catch((error) => {
          console.log(error.response);
          showValidationErrorDialog(error.response.data);
        })
        .finally(() => formModal.setSubmitting(false));
    }
  };

  const formModal = useFormModal('Project', <EditProjectFormFields />, handleAddProjectFormSubmit, { saveCheck: true });

  const data = Object.values(searchData.data).map((projects) => ({
    ...projects,
  }));

  return (
    <React.Fragment>
      <MaterialCard>
        <UIHeader>Projects</UIHeader>
        <Formik
          initialValues={reduxFormikValues}
          enableReinitialize={false}
          onSubmit={(values) => handleSearchFormSubmit(values)}
          onReset={handleSearchFormReset}
        >
          {(formikProps) => (
            <Form>
              <Row form>
                <Col>
                  <MultiDropdownField {...formikProps} items={currentUser.regions} name="regionIds" title="Regions" />
                </Col>
                <Col>
                  <Field
                    type="text"
                    name="searchText"
                    placeholder="Number/Name/Description/Scope"
                    className="form-control"
                    title="Searches Project Number, Name, Description and Scope fields"
                  />
                </Col>
                <Col>
                  <MultiDropdownField
                    {...formikProps}
                    items={projectMgr}
                    name="projectManagerIds"
                    title="Project Manager"
                    searchable
                  />
                </Col>
                <Col>
                  <MultiDropdownField {...formikProps} items={isInProgress} name="isInProgress" title="Status" />
                </Col>
                <Col>
                  <div className="float-right">
                    <SubmitButton className="mr-2" disabled={searchData.loading} submitting={searchData.loading}>
                      Search
                    </SubmitButton>
                    <Button
                      type="reset"
                      onClick={() => {
                        //needed to reset form if formik initial values are not the default values
                        formikProps.resetForm({ values: formikInitialValues });
                      }}
                    >
                      Reset
                    </Button>
                  </div>
                </Col>
              </Row>
            </Form>
          )}
        </Formik>
      </MaterialCard>
      <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
        <Row>
          <Col>
            <Button
              size="sm"
              color="primary"
              className="float-right mb-3"
              onClick={() => formModal.openForm(Constants.FORM_TYPE.ADD)}
            >
              Add Project
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
              deletable
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              onDeleteClicked={onDeleteClicked}
              onHeadingSortClicked={searchData.handleHeadingSortClicked}
            />
          )}
          {searchData.data.length <= 0 && <div>No records found</div>}
        </MaterialCard>
      )}
      {formModal.formElement}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    currentUser: state.user.current,
    projectMgr: Object.values(state.user.projectMgr),
    reduxFormikValues: state.projectSearchHistory.reduxFormikValues,
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    showValidationErrorDialog: (error) => dispatch(showValidationErrorDialog(error)),
    setProjectSearchHistory: (url) => dispatch(setProjectSearchHistory(url)),
    setProjectSearchFormikValues: (values) => dispatch(setProjectSearchFormikValues(values)),
    resetProjectSearchFormikValues: () => dispatch(resetProjectSearchFormikValues()),
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(Projects);
