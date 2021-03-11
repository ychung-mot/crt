import React, { useEffect, useState } from 'react';
import queryString from 'query-string';
import * as Yup from 'yup';
import { useLocation } from 'react-router-dom';

//components
import { Row, Col, Button } from 'reactstrap';
import { Formik, Form, Field } from 'formik';
import Authorize from './fragments/Authorize';
import MaterialCard from './ui/MaterialCard';
import UIHeader from './ui/UIHeader';
import MultiDropdownField from './ui/MultiDropdownField';
import SingleDropdownField from './ui/SingleDropdownField';
import DataTableWithPaginaionControl from './ui/DataTableWithPaginaionControl';
import SubmitButton from './ui/SubmitButton';
import useSearchData from './hooks/useSearchData';
import useFormModal from './hooks/useFormModal';
import PageSpinner from './ui/PageSpinner';

import * as Constants from '../Constants';
import * as api from '../Api';

const defaultSearchFormValues = {
  searchText: '',
  statusId: [Constants.ACTIVE_STATUS.ACTIVE],
  codeSet: 'accomplishment',
};

const defaultSearchOptions = {
  searchText: '',
  isActive: true,
  codeSet: 'accomplishment',
  dataPath: Constants.API_PATHS.CODE_TABLE,
};

const formikInitialValues = {
  searchText: '',
  isActive: ['active'],
  codeSet: 0,
};

const validationSchema = Yup.object({
  searchText: Yup.string().max(32).trim(),
  codeSet: Yup.number().required(),
});

const isActive = [
  { id: 'active', name: 'Active' },
  { id: 'inactive', name: 'Inactive' },
];

const tableColumns = [
  { heading: 'Code Value^', key: 'codeValueText', nosort: true },
  { heading: 'Code Description', key: 'codeName', nosort: true },
  { heading: 'Order Number', key: 'displayOrder', nosort: true },
  { heading: 'Status', key: 'isActive', badge: { active: 'Active', inactive: 'Inactive' }, nosort: true },
];

//temporary fix to create codeTableList POC

const codeTableAdd = (nameList) => {
  let codeTablesList = [];

  for (let each in nameList) {
    codeTablesList.push({ id: parseInt(each), name: nameList[each] });
  }

  return codeTablesList;
};

const codeTables = codeTableAdd([
  `Accomplishment`,
  `Capital Index`,
  `Contractor`,
  `Economic Region`,
  `Electoral District`,
  `Elements`,
  `Fiscal Year`,
  'Funding Type',
  'Highway',
  'Nearest Town',
  'Phase',
  'Program',
  'Program Category',
  'Quantity',
  'RC Number',
  'Service Line',
]);

const CodeTableAdmin = (props) => {
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
      statusId: isActive[0].id,
    });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearchFormSubmit = (values) => {
    const searchText = values.searchText.trim() || null;
    let isActive = null;
    if (values.isActive.length === 1) {
      isActive = values.isActive[0] === 'active';
    }

    let codeSet = codeTables.find((set) => set.id === values.codeSet).name.toLowerCase();
    codeSet = codeSet.replace(/\s/g, '_');

    const options = {
      ...searchData.searchOptions,
      isActive,
      searchText,
      codeSet: codeSet,
      pageNumber: 1,
    };
    searchData.updateSearchOptions(options);
  };

  const handleSearchFormReset = () => {
    setSearchInitialValues(defaultSearchFormValues);
    searchData.refresh(true);
  };

  const onDeleteClicked = () => {
    console.log('delete');
  };

  const onEditClicked = () => {
    console.log('edit');
  };

  const data = Object.values(searchData.data).map((values) => ({
    ...values,
  }));

  return (
    <React.Fragment>
      <MaterialCard>
        <UIHeader>Code Table Management</UIHeader>
        <Formik
          initialValues={formikInitialValues}
          validationSchema={validationSchema}
          enableReinitialize={true}
          onSubmit={(values) => handleSearchFormSubmit(values)}
          onReset={handleSearchFormReset}
        >
          {(formikProps) => (
            <Form>
              <Row form>
                <Col>
                  <SingleDropdownField {...formikProps} items={codeTables} defaultTitle="Choose Type" name="codeSet" />
                </Col>
                <Col>
                  <Field type="text" name="searchText" placeholder="Search" className="form-control" />
                </Col>
                <Col>
                  <MultiDropdownField {...formikProps} items={isActive} name="isActive" title="Status" />
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
      <Authorize requires={Constants.PERMISSIONS.CODE_W}>
        <Row>
          <Col>
            <Button
              size="sm"
              color="secondary"
              className="float-right mb-3 ml-2"
              onClick={() => console.log('SET ORDER')}
            >
              Set Order
            </Button>
            <Button size="sm" color="primary" className="float-right mb-3" onClick={() => console.log('OPEN ME')}>
              Add New
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
              deletable
              editPermissionName={Constants.PERMISSIONS.PROJECT_W}
              onEditClicked={onEditClicked}
              onDeleteClicked={onDeleteClicked}
              onHeadingSortClicked={searchData.handleHeadingSortClicked}
            />
          )}
          {searchData.data.length <= 0 && <div>No records found</div>}
        </MaterialCard>
      )}
    </React.Fragment>
  );
};

export default CodeTableAdmin;
