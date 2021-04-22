import React, { useState, useEffect } from 'react';

import { useLocation } from 'react-router-dom';
import { connect } from 'react-redux';
import { Row, Col, Button } from 'reactstrap';
import { Formik, Form, Field } from 'formik';
import queryString from 'query-string';
import moment from 'moment';

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

import { showValidationErrorDialog, updateProjectsSearch } from '../redux/actions';

import * as Constants from '../Constants';
import * as api from '../Api';

const defaultSearchFormValues = { searchText: '', regionIds: [], projectManagerIds: [], isInProgress: ['inProgress'] };

const defaultSearchOptions = {
  searchText: '',
  isInProgress: true,
  dataPath: Constants.API_PATHS.PROJECTS,
  regionIds: '',
};

const dataPath = Constants.API_PATHS.PROJECTS;

const tableColumns = [
  { heading: 'Region', key: 'regionId' },
  {
    heading: 'Project',
    key: 'projectNumber',
    link: { path: `${Constants.PATHS.PROJECTS}/:id`, key: 'projectNumber', title: 'See project details' },
  },
  {
    heading: 'Planning Targets',
    key: 'projectValue',
    link: {
      path: `${Constants.PATHS.PROJECTS}/:id${Constants.PATHS.PROJECT_PLAN}`,
      key: 'projectValue',
      heading: 'Planning Targets',
      title: 'See financial planning and public project information',
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
      title: 'See tender details and Qty/Accomplishments',
    },
    nosort: true,
  },
  {
    heading: 'Location and Ratios',
    key: 'locationRatios',
    link: {
      path: `${Constants.PATHS.PROJECTS}/:id${Constants.PATHS.PROJECT_SEGMENT}`,
      heading: 'Ratios',
      title: 'See ratios and segments',
    },
    nosort: true,
  },
  { heading: '', key: 'isInProgress', nosort: true, badge: { active: 'Active', inactive: 'Closed' } },
];

//temporary fix hardcode project status
const isInProgress = [
  { id: 'inProgress', name: 'Active' },
  { id: 'complete', name: 'Closed' },
];

const Projects = ({ currentUser, projectMgrs, searchOptions, showValidationErrorDialog, updateProjectsSearch }) => {
  const location = useLocation();

  const searchData = useSearchData(defaultSearchOptions, updateProjectsSearch);
  const [searchInitialValues, setSearchInitialValues] = useState(null);

  const buildFormikValuesFromSearchOptions = ({ searchText, regionIds, projectManagerIds, isInProgress }) => {
    if (!regionIds || regionIds === '') {
      regionIds = [];
    } else {
      regionIds = regionIds.split(',').map(Number);
    }

    if (!projectManagerIds || projectManagerIds === '') {
      projectManagerIds = [];
    } else {
      projectManagerIds = projectManagerIds.split(',').map(Number);
    }

    if (isInProgress === true) {
      isInProgress = ['inProgress'];
    } else if (isInProgress === false) {
      isInProgress = ['complete'];
    } else {
      isInProgress = ['inProgress', 'complete'];
    }

    const values = {
      searchText: searchText || '',
      regionIds,
      projectManagerIds,
      isInProgress,
    };
    return values;
  };

  const buildSearchOptionsFromFormikValues = (values) => {
    const searchText = values.searchText.trim() || null;

    let isInProgress = null;
    if (values.isInProgress.length === 1) {
      isInProgress = values.isInProgress[0] === 'inProgress';
    }

    const options = {
      dataPath,
      isInProgress,
      searchText,
      regionIds: values.regionIds.join(',') || null,
      projectManagerIds: values.projectManagerIds.join(',') || null,
    };

    if (searchData) {
      return { ...searchData.searchOptions, ...options };
    }

    return options;
  };

  // Run on load, parse URL query params
  useEffect(() => {
    const params = queryString.parse(location.search);

    let options = {};

    if (location.search !== '') {
      options = {
        ...defaultSearchOptions,
        ...params,
      };
    } else if (searchOptions) {
      options = {
        ...defaultSearchOptions,
        ...searchOptions,
      };
    }

    searchData.updateSearchOptions(options);

    const searchText = options.searchText || '';

    setSearchInitialValues({
      ...buildFormikValuesFromSearchOptions(options),
      searchText,
    });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearchFormSubmit = (values) => {
    searchData.updateSearchOptions({ ...buildSearchOptionsFromFormikValues(values), pageNumber: 1 });
  };

  const handleSearchFormReset = () => {
    setSearchInitialValues(defaultSearchFormValues);
    searchData.refresh(true);
  };

  const onDeleteClicked = (projectId, endDate) => {
    api.deleteProject(projectId, endDate).then(() => searchData.refresh());
  };

  const handleAddProjectFormSubmit = (values, formType) => {
    //required to convert boolean complete to a date/null for the backend
    let data;
    if (values.endDate === true) {
      data = { ...values, endDate: moment().format(Constants.DATE_DISPLAY_FORMAT) };
    } else {
      data = { ...values, endDate: null };
    }

    if (!formModal.submitting) {
      formModal.setSubmitting(true);
      api
        .postProject(data)
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

  const formModal = useFormModal('Project', <EditProjectFormFields />, handleAddProjectFormSubmit, {
    saveCheck: true,
    size: 'lg',
  });

  const data = Object.values(searchData.data).map((projects) => ({
    ...projects,
  }));

  return (
    searchInitialValues && (
      <React.Fragment>
        <MaterialCard>
          <UIHeader>Projects</UIHeader>
          <Formik
            initialValues={searchInitialValues}
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
                      placeholder="Number/Name/Description/Scope"
                      className="form-control"
                      title="Searches Project Number, Name, Description and Scope fields"
                    />
                  </Col>
                  <Col>
                    <MultiDropdownField
                      {...formikProps}
                      items={projectMgrs}
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
                easyDelete
                disableHoverText={'Close/Activate Project'}
                deleteButtonDefaultText={'Close Project'}
                deleteButtonAltText={'Activate Project'}
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
    )
  );
};

const mapStateToProps = (state) => {
  return {
    currentUser: state.user.current,
    projectMgrs: Object.values(state.codeLookups.projectMgrs),
    searchOptions: state.search.projects,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog, updateProjectsSearch })(Projects);
