import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';
import moment from 'moment';

//components
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import FontAwesomeButton from '../ui/FontAwesomeButton';
import EditProjectFormFields from '../forms/EditProjectFormFields';
import Comments from './Comments';
import { DisplayRow, ColumnGroup, ColumnTwoGroups } from './ProjectDisplayHelper';
import ProjectFooterNav from './ProjectFooterNav';

import useFormModal from '../hooks/useFormModal';

import * as api from '../../Api';
import * as Constants from '../../Constants';

const ProjectDetails = ({ match, showValidationErrorDialog }) => {
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
        .putProject(values.id, data)
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

  const formModal = useFormModal('Project', <EditProjectFormFields />, handleEditProjectFormSubmit, {
    saveCheck: true,
    size: 'lg',
  });

  const onEditClicked = (projectId) => {
    formModal.openForm(Constants.FORM_TYPE.EDIT, { projectId });
  };

  const commentFilter = (commentType = '') => {
    return data.notes.filter((note) => note.noteType === commentType);
  };

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <ProjectFooterNav projectId={data.id} />
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
          <ColumnTwoGroups name="Project Number" label={data.projectNumber} helper="projectNumber" strong />
          <ColumnTwoGroups name="Project Name" label={data.projectName} helper="projectName" strong />
        </DisplayRow>
        <DisplayRow>
          <ColumnTwoGroups name="MoTI Region" label={data.region.name} />
          <ColumnTwoGroups name="Nearest Town" label={data.nearstTwnLkup?.codeName} helper="nearstTwnLkupId" />
        </DisplayRow>
        <DisplayRow>
          <ColumnTwoGroups
            name="RC Number"
            label={data.rcLkup?.codeValueText}
            hoverTitle={data.rcLkup?.codeName}
            helper="rcLkupId"
          />
          <ColumnTwoGroups name="Project Manager" label={data.projectMgrLkup?.codeName} helper={'projectMgrLkupId'} />
        </DisplayRow>
        <DisplayRow>
          <ColumnTwoGroups
            name="Capital Index"
            label={`${data.capIndxLkup?.codeValueText}`}
            hoverTitle={`${data.capIndxLkup?.codeName}`}
            helper="capIndxLkupId"
          />
          <ColumnTwoGroups name="Project Completed?" label={data.endDate ? 'Yes' : 'No'} helper="endDate" />
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

      {formModal.formElement}
    </React.Fragment>
  );
};

export default connect(null, { showValidationErrorDialog })(ProjectDetails);
