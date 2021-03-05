import React from 'react';
import { showValidationErrorDialog } from '../../redux/actions';
import PropTypes from 'prop-types';

import Authorize from '../fragments/Authorize';
import UIHeader from '../ui/UIHeader';
import DataTableControl from '../ui/DataTableControl';
import { Button, Container, Row, Col } from 'reactstrap';

import useFormModal from '../hooks/useFormModal';
import * as api from '../../Api';
import * as Constants from '../../Constants';

const RatioTable = ({ title, ratioTypeName, tableColumns, formModalFields, projectId, dataList = [], refreshData }) => {
  const myHandleFormSubmit = (values, formType) => {
    if (!formModal.submitting) {
      formModal.setSubmitting(true);
      if (formType === Constants.FORM_TYPE.ADD) {
        api
          .postRatio(projectId, values)
          .then(() => {
            formModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => formModal.setSubmitting(false));
      } else if (formType === Constants.FORM_TYPE.EDIT) {
        api
          .putRatio(projectId, values.id, values)
          .then(() => {
            formModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => formModal.setSubmitting(false));
      }
    }
  };

  const onAddClicked = () => {
    formModal.openForm(Constants.FORM_TYPE.ADD, { ratioTypeName: ratioTypeName });
  };

  const onEditClicked = (ratioId) => {
    formModal.openForm(Constants.FORM_TYPE.EDIT, { ratioId, projectId });
  };

  const onDeleteClicked = (ratioId) => {
    api
      .deleteRatio(projectId, ratioId)
      .then(() => {
        refreshData();
      })
      .catch((error) => console.log(error));
  };

  const formModal = useFormModal(title, formModalFields, myHandleFormSubmit, { saveCheck: true });

  return (
    <Container>
      <UIHeader>
        <Row>
          <Col xs="auto">{title}</Col>
          <Col>
            <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
              <Button color="primary" className="float-right" onClick={onAddClicked}>
                + Add
              </Button>
            </Authorize>
          </Col>
        </Row>
      </UIHeader>
      <DataTableControl
        dataList={dataList}
        tableColumns={tableColumns}
        editable
        deletable
        editPermissionName={Constants.PERMISSIONS.PROJECT_W}
        onEditClicked={onEditClicked}
        onDeleteClicked={onDeleteClicked}
      />
      {formModal.formElement}
    </Container>
  );
};

export default RatioTable;

RatioTable.propTypes = {
  title: PropTypes.string.isRequired, //title for the dialog
  ratioTypeName: PropTypes.string.isRequired, //used to grab ratioRecordTypeLkupId in the FormFields
  projectId: PropTypes.number.isRequired,
  tableColumns: PropTypes.arrayOf(
    PropTypes.shape({
      heading: PropTypes.string.isRequired,
      key: PropTypes.string.isRequired,
      nosort: PropTypes.bool,
      badge: PropTypes.shape({
        //badge will show active/inactive string based on boolean value
        active: PropTypes.string.isRequired,
        inactive: PropTypes.string.isRequired,
      }),
      //link will be the url path of where you want to go. ie. /projects/:id <- will look at dataList item for id attribute
      link: PropTypes.shape({
        path: PropTypes.string,
        key: PropTypes.string, //will display what is in item[key]. Key takes precedence over heading.
        heading: PropTypes.string, //will display this string if item[key] doesn't exist.
      }),
      currency: PropTypes.bool, //if true then format values as currency
      thousandSeparator: PropTypes.bool, //if true then format values with thousand comma separators
    })
  ).isRequired,
  formModalFields: PropTypes.element.isRequired, //these will be displayed when dialog opens
  refreshData: PropTypes.func.isRequired, //used to refresh page when data is changed
};
