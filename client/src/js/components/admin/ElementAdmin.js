import React, { useEffect, useState } from 'react';
import queryString from 'query-string';
import * as Yup from 'yup';
import { useLocation } from 'react-router-dom';
import { connect } from 'react-redux';

//components
import { Row, Col, Button } from 'reactstrap';
import { Formik, Form, Field } from 'formik';
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import MultiDropdownField from '../ui/MultiDropdownField';
import DataTableWithPaginaionControl from '../ui/DataTableWithPaginaionControl';
import SubmitButton from '../ui/SubmitButton';
import useSearchData from '../hooks/useSearchData';
import useFormModal from '../hooks/useFormModal';
import PageSpinner from '../ui/PageSpinner';
import EditElementFormFields from '../forms/EditElementFormFields';

import { showValidationErrorDialog } from '../../redux/actions';

import * as Constants from '../../Constants';
import * as api from '../../Api';

const isActive = [
  { id: 'active', name: 'Active' },
  { id: 'inactive', name: 'Inactive' },
];

const tableColumns = [
  { heading: 'Element', key: 'code' },
  { heading: 'Description', key: 'description' },
  { heading: 'Program Category', key: 'programCategory', labelHoverText: { key: 'programCategoryName' }, nosort: true },
  { heading: 'Program', key: 'program', labelHoverText: { key: 'programName' }, nosort: true },
  { heading: 'Service Line', key: 'serviceLine', labelHoverText: { key: 'serviceLineName' }, nosort: true },
  { heading: 'Order Number', key: 'displayOrder' },
  { heading: 'Status', key: 'isActive', badge: { active: 'Active', inactive: 'Inactive' }, nosort: true },
];

const ElementAdmin = ({ showValidationErrorDialog, elements }) => {
  //fields for default search, formik fields and helper functions
  const defaultSearchFormValues = {
    searchText: '',
    statusId: [Constants.ACTIVE_STATUS.ACTIVE],
  };

  const defaultSearchOptions = {
    searchText: '',
    isActive: true,
    dataPath: Constants.API_PATHS.ELEMENTS_SEARCH,
  };

  const formikInitialValues = {
    searchText: '',
    isActive: ['active'],
  };

  const validationSchema = Yup.object({
    searchText: Yup.string().max(32).trim(),
  });

  const location = useLocation();
  const searchData = useSearchData(defaultSearchOptions);

  //Hooks
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

  const onDeleteClicked = (elementId, endDate, permanentDelete) => {
    if (permanentDelete) {
      api
        .deleteElement(elementId)
        .then(() => searchData.refresh())
        .catch((error) => {
          showValidationErrorDialog(error.response.data);
          console.log(error);
        });
    } else if (permanentDelete === false) {
      debugger;
      api
        .getElement(elementId)
        .then((response) => {
          let data = { ...response.data, isActive: !response.data.isActive };
          api.putElement(elementId, data).then(() => searchData.refresh());
        })
        .catch((error) => {
          showValidationErrorDialog(error.response.data);
          console.log(error);
        });
    }
  };

  const onEditClicked = (elementId) => {
    formModal.openForm(Constants.FORM_TYPE.EDIT, { elementId });
  };

  const onAddClicked = () => {
    formModal.openForm(Constants.FORM_TYPE.ADD, {
      defaultDisplayOrder: searchData.pagination.totalCount * 10 + 10,
    });
  };

  const handleCodeSetFormSubmit = (values, formType) => {
    if (formType === Constants.FORM_TYPE.ADD) {
      api
        .postElement(values)
        .then(() => {
          formModal.closeForm();
          searchData.refresh();
        })
        .catch((error) => {
          showValidationErrorDialog(error.response.data);
          console.log(error);
        });
    } else if (formType === Constants.FORM_TYPE.EDIT) {
      api
        .putElement(values.id, values)
        .then(() => {
          formModal.closeForm();
          searchData.refresh();
        })
        .catch((error) => {
          showValidationErrorDialog(error.response.data);
          console.log(error);
        });
    }
  };

  const data = Object.values(searchData.data).map((values) => ({
    ...values,
  }));

  const formModal = useFormModal(`Element`, <EditElementFormFields />, handleCodeSetFormSubmit);

  return (
    <React.Fragment>
      <MaterialCard>
        <UIHeader>Elements Management</UIHeader>
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
                <Col xs={3}>
                  <Field
                    type="text"
                    name="searchText"
                    placeholder="Search"
                    className="form-control"
                    title="Searches through element, description, program category, program and service line."
                  />
                </Col>
                <Col xs={3}>
                  <MultiDropdownField {...formikProps} items={isActive} name="isActive" title="Status" />
                </Col>
                <Col>
                  <div className="float-right">
                    <SubmitButton
                      className="mr-2"
                      disabled={searchData.loading}
                      submitting={searchData.loading}
                      title={'Search'}
                    >
                      Search
                    </SubmitButton>
                    <Button type="reset" title={'Reset Search'}>
                      Reset
                    </Button>
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
            <Authorize requires={Constants.PERMISSIONS.CODE_W}>
              <Button
                size="sm"
                color="primary"
                className="float-right mb-3"
                onClick={onAddClicked}
                title={'Add New Element'}
              >
                {`Add New Element`}
              </Button>
            </Authorize>
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
              editPermissionName={Constants.PERMISSIONS.CODE_W}
              onEditClicked={onEditClicked}
              onDeleteClicked={onDeleteClicked}
              onHeadingSortClicked={searchData.handleHeadingSortClicked}
              easyDelete
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
    elements: state.lookups.elements,
  };
};
export default connect(mapStateToProps, { showValidationErrorDialog })(ElementAdmin);
