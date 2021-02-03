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

import { showValidationErrorDialog } from '../redux/actions';

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
  { heading: 'Project', key: 'projectNumber', link: { path: '/projects', idKey: 'id' } },
  { heading: 'Planning Targets', key: 'planningTargets', nosort: true },
  { heading: 'Tender Details', key: 'tenderDetails', nosort: true },
  { heading: 'Location and Ratios', key: 'locationRation', nosort: true },
  { heading: '', key: 'isInProgress', nosort: true, badge: { active: 'In-Progress', inactive: 'Completed' } },
];

//temporary fix hardcode project status
const isInProgress = [
  { id: 'inProgress', name: 'In Progress' },
  { id: 'complete', name: 'Completed' },
];

const formikInitialValues = {
  searchText: '',
  regionIds: [],
  projectManagerIds: [],
  isInProgress: [isInProgress[0].id],
};

const Projects = ({ currentUser, projectMgr }) => {
  if (currentUser.isProjectMgr) {
    defaultSearchOptions.projectManagerIds = currentUser.id;
    formikInitialValues.projectManagerIds = [currentUser.id];
  }

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

  const handleSearchFormSubmit = (values) => {
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

  const formModal = useFormModal('Project', <EditProjectFormFields />, handleAddProjectFormSubmit, true);

  const data = Object.values(searchData.data).map((projects) => ({
    ...projects,
  }));

  return (
    <React.Fragment>
      <MaterialCard>
        <UIHeader>Projects</UIHeader>
        <Formik
          initialValues={formikInitialValues}
          enableReinitialize={true}
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
                    placeholder="Keyword"
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
                    <Button type="reset">Reset</Button>
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
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(Projects);
