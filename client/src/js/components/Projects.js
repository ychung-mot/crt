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

import { showValidationErrorDialog } from '../redux/actions';

import * as Constants from '../Constants';

const defaultSearchFormValues = { searchText: '', regions: [], projectMgr: [], isInProgress: [] };

const defaultSearchOptions = {
  searchText: '',
  isInProgress: true,
  dataPath: Constants.API_PATHS.PROJECTS,
  regions: '',
};

const tableColumns = [
  { heading: 'Region^', key: 'region' },
  { heading: 'Project^', key: 'projectName' },
  { heading: 'Planning Targets^', key: 'planningTargets' },
  { heading: 'Location and Ratios^', key: 'locationRation' },
  { heading: '', key: 'isInProgress', nosort: true },
];

const formikInitialValues = {
  searchText: '',
  regions: [],
  projectMgr: [],
  isInProgress: [],
};

//temporary fix hardcode project status
const isInProgress = [
  { id: 'inProgress', name: 'In Progress' },
  { id: 'complete', name: 'Completed' },
];

const Projects = ({ currentUser }) => {
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

  //handle search form submit goes here

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
      regions: values.regions.join(',') || null,
      projectMgr: values.projectMgr.join(',') || null,
      pageNumber: 1,
    };
    searchData.updateSearchOptions(options);
  };

  const handleSearchFormReset = () => {
    setSearchInitialValues(defaultSearchFormValues);
    searchData.refresh(true);
  };

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
                  <MultiDropdownField {...formikProps} items={currentUser.regions} name="regions" title="Regions" />
                </Col>
                <Col>
                  <Field type="text" name="searchText" placeholder="Keyword" className="form-control" />
                </Col>
                <Col>
                  {/* Temporary fix, wait for projectManager api and change items */}
                  <MultiDropdownField
                    {...formikProps}
                    items={currentUser.regions}
                    name="projectMgr"
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
      <Authorize requires={Constants.PERMISSIONS.USER_W}>
        <Row>
          <Col>
            <Button size="sm" color="primary" className="float-right mb-3" onClick={() => alert('create MODAL')}>
              Add Project
            </Button>
          </Col>
        </Row>
      </Authorize>
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    currentUser: state.user.current,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(Projects);
