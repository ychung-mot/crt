import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';
import { Link } from 'react-router-dom';

//components
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import { Button } from 'reactstrap';
import FontAwesomeButton from '../ui/FontAwesomeButton';
import EditProjectFormFields from '../forms/EditProjectFormFields';
import Comments from './Comments';
import { DisplayRow, ColumnGroup, ColumnTwoGroups } from './ProjectDisplayHelper';

import useFormModal from '../hooks/useFormModal';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const ProjectDetails = ({ match, history, showValidationErrorDialog, projectSearchHistory }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState({});

  useEffect(() => {
    api
      .getProject(match.params.id)
      .then((response) => {
        setData(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
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
              onClick={() => onEditClicked(data.id)}
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
          <ColumnTwoGroups name="Nearest Town" label={data.nearstTwnLkup?.codeName} helper="nearstTwnLkupId" />
          <ColumnTwoGroups name="RC Number" label={data.rcLkup?.codeName} helper="rcLkupId" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Project End Date" label={data.endDate} helper="endDate" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Project Description" label={data.description} helper="description" />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Project Scope" label={data.scope} helper="scope" />
        </DisplayRow>
      </MaterialCard>
      <Comments
        title="Status Comments"
        dataList={commentFilter('STATUS')}
        noteType="STATUS"
        projectId={data.id}
        show={1}
      />
      <Comments title="EMR Comments" dataList={commentFilter('EMR')} noteType="EMR" projectId={data.id} show={1} />

      <div className="text-right">
        <Link to={`${Constants.API_PATHS.PROJECTS}/${data.id}${Constants.API_PATHS.PROJECT_PLAN}`}>
          <Button color="primary">Continue</Button>
        </Link>
        <Button color="secondary" onClick={() => history.push(projectSearchHistory)}>
          Close
        </Button>
      </div>

      {formModal.formElement}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    projectSearchHistory: state.projectSearchHistory.projectSearch,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectDetails);
