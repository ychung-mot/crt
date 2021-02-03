import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';

//components
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import MouseoverTooltip from '../ui/MouseoverTooltip';
import { Row, Col, Button } from 'reactstrap';
import FontAwesomeButton from '../ui/FontAwesomeButton';
import EditProjectFormFields from '../forms/EditProjectFormFields';
import Comments from './Comments';

import useFormModal from '../hooks/useFormModal';

import * as api from '../../Api';
import * as Constants from '../../Constants';
import { PROJECT_HELPER_TEXT } from '../project/ProjectHelperText';

const ProjectDetails = ({ match, history, showValidationErrorDialog }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState({});

  useEffect(() => {
    api.getProject(match.params.id).then((response) => {
      setData(response.data);
      setLoading(false);
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleEditProjectFormSubmit = (values) => {
    if (!formModal.submitting) {
      formModal.setSubmitting(true);
      api
        .putProject(values.id, values)
        .then(() => {
          formModal.closeForm();
          setLoading(true);
          api.getProject(match.params.id).then((response) => {
            setData(response.data);
            setLoading(false);
          });
        })
        .catch((error) => {
          console.log(error.response);
          showValidationErrorDialog(error.response.data);
        })
        .finally(() => formModal.setSubmitting(false));
    }
  };

  const formModal = useFormModal('Project', <EditProjectFormFields />, handleEditProjectFormSubmit, true);

  const onEditClicked = (projectId) => {
    formModal.openForm(Constants.FORM_TYPE.EDIT, { projectId });
  };

  const commentFilter = (commentType = '') => {
    return data.notes.filter((note) => note.noteType === commentType);
  };

  //display row helper functions
  const DisplayRow = ({ children }) => {
    return <Row>{children}</Row>;
  };

  const ColumnGroup = ({ name, label, helper }) => {
    return (
      <>
        <Col className="mt-2 font-weight-bold" sm="3">
          {name}
          {helper && (
            <MouseoverTooltip id={`project-details__${helper}`}>{PROJECT_HELPER_TEXT[helper]}</MouseoverTooltip>
          )}
        </Col>
        <Col className="mt-2" sm="9">
          {label ? label : 'None'}
        </Col>
      </>
    );
  };

  const ColumnTwoGroups = ({ name, label, helper }) => {
    return (
      <>
        <Col className="mt-2 font-weight-bold" sm="3">
          {name}
          {helper && (
            <MouseoverTooltip id={`project-details__${helper}`}>{PROJECT_HELPER_TEXT[helper]}</MouseoverTooltip>
          )}
        </Col>
        <Col className="mt-2" sm="3">
          {label ? label : 'None'}
        </Col>
      </>
    );
  };
  //end display helpers

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <MaterialCard>
        <UIHeader>
          Project Details{' '}
          <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
            <FontAwesomeButton
              icon="edit"
              className="float-right"
              onClick={() => onEditClicked(match.params.id)}
              title="Edit Record"
              iconSize="lg"
            />
          </Authorize>
        </UIHeader>
        <DisplayRow>
          <ColumnTwoGroups name="Project Number" label={data.projectNumber} helper="projectNumber" />
          <ColumnTwoGroups name="Project Name" label={data.projectName} helper="projectName" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Project Description" label={data.description} helper="description" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Project Scope" label={data.scope} helper="scope" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Capital Index" label={`${data.capIndxLkup.name}`} helper="capIndxLkupId" />
        </DisplayRow>
        <DisplayRow>
          <ColumnTwoGroups name="MoTI Region" label={data.region.name} />
          <ColumnTwoGroups
            name="Project Manager"
            label={data.projectMgr && `${data.projectMgr.firstName} ${data.projectMgr.lastName}`}
            helper={'projectMgrId'}
          />
        </DisplayRow>
        <DisplayRow>
          <ColumnTwoGroups name="Nearest Town" label={data.nearstTwnLkupId} helper="nearstTwnLkupId" />
          <ColumnTwoGroups name="RC Number" label={data.rcLkupId} helper="rcLkupId" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Project End Date" label={data.endDate} helper="endDate" />
        </DisplayRow>
      </MaterialCard>
      <Comments
        title="Status Comments"
        dataList={commentFilter('STATUS')}
        noteType="STATUS"
        projectId={match.params.id}
        show={1}
      />
      <Comments
        title="EMR Comments"
        dataList={commentFilter('EMR')}
        noteType="EMR"
        projectId={match.params.id}
        show={1}
      />

      <div className="text-right">
        <Button color="primary" onClick={() => alert('temporary fix link to next section')}>
          Continue
        </Button>
        <Button color="secondary" onClick={() => history.goBack()}>
          Close
        </Button>
      </div>

      {formModal.formElement}
    </React.Fragment>
  );
};

export default connect(null, { showValidationErrorDialog })(ProjectDetails);
