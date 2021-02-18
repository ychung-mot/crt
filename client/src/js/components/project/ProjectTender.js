import React, { useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { showValidationErrorDialog } from '../../redux/actions';
import NumberFormat from 'react-number-format';

//components
import Authorize from '../fragments/Authorize';
import MaterialCard from '../ui/MaterialCard';
import UIHeader from '../ui/UIHeader';
import PageSpinner from '../ui/PageSpinner';
import DataTableControl from '../ui/DataTableControl';
import { Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import EditTenderFormFields from '../forms/EditTenderFormFields';
import { DisplayRow, ColumnGroup, ColumnTwoGroups } from './ProjectDisplayHelper';
import FontAwesomeButton from '../ui/FontAwesomeButton';

import useFormModal from '../hooks/useFormModal';
import moment from 'moment';
import * as api from '../../Api';
import * as Constants from '../../Constants';
import EditAnnouncementFormFields from '../forms/EditAnnouncementFormFields';

const ProjectTender = ({ match, history, showValidationErrorDialog, projectSearchHistory }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  useEffect(() => {
    api
      .getProjectTender(match.params.id)
      .then((response) => {
        let dateFormattedResponse = { ...response.data, tenders: changeDateFormat(response.data.tenders) };
        setData(dateFormattedResponse);
        setLoading(false);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const projectTenderTableColumns = [
    { heading: 'Tender #', key: 'tenderNumber', nosort: true },
    { heading: 'Planned Date', key: 'plannedDate', nosort: true },
    { heading: 'Actual Date', key: 'actualDate', nosort: true },
    { heading: 'Tender Value', key: 'tenderValue', currency: true, nosort: true },
    { heading: 'Winning Contractor', key: 'winningCntrctr', nosort: true },
    { heading: 'Winning Bid', key: 'bidValue', currency: true, nosort: true },
    { heading: 'Comment', key: 'comment', nosort: true },
  ];

  const onTenderEditClicked = (tenderId) => {
    tendersFormModal.openForm(Constants.FORM_TYPE.EDIT, { tenderId, projectId: data.id });
  };

  const onTenderDeleteClicked = (tenderId) => {
    api
      .deleteTender(data.id, tenderId)
      .then(() => {
        refreshData();
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
  };

  const addTenderClicked = () => {
    tendersFormModal.openForm(Constants.FORM_TYPE.ADD);
  };

  const handleEditTenderFormSubmit = (values, formType) => {
    if (!tendersFormModal.submitting) {
      tendersFormModal.setSubmitting(true);
      if (formType === Constants.FORM_TYPE.ADD) {
        api
          .postTender(data.id, values)
          .then(() => {
            tendersFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => tendersFormModal.setSubmitting(false));
      } else if (formType === Constants.FORM_TYPE.EDIT) {
        api
          .putTender(data.id, values.id, values)
          .then(() => {
            tendersFormModal.closeForm();
            refreshData();
          })
          .catch((error) => {
            console.log(error.response);
            showValidationErrorDialog(error.response.data);
          })
          .finally(() => tendersFormModal.setSubmitting(false));
      }
    }
  };

  const handleAnnouncementEditFormClick = (projectId) => {
    announcementFormModal.openForm(Constants.FORM_TYPE.EDIT, { projectId: projectId });
  };

  const handleAnnouncementEditFormSubmit = (values) => {
    if (!tendersFormModal.submitting) {
      announcementFormModal.setSubmitting(true);
      api
        .putProject(values.id, { ...values })
        .then(() => {
          announcementFormModal.closeForm();
          refreshData();
        })
        .catch((error) => {
          console.log(error.response);
          showValidationErrorDialog(error.response.data);
        })
        .finally(() => announcementFormModal.setSubmitting(false));
    }
  };

  const refreshData = () => {
    api
      .getProjectTender(data.id)
      .then((response) => {
        let dateFormattedResponse = { ...response.data, tenders: changeDateFormat(response.data.tenders) };
        setData(dateFormattedResponse);
      })
      .catch((error) => {
        console.log(error.response);
        showValidationErrorDialog(error.response.data);
      });
  };

  const changeDateFormat = (tenderArray) => {
    let changedTenderArray = tenderArray.map((tender) => {
      return {
        ...tender,
        plannedDate:
          tender.plannedDate === null ? null : moment(tender.plannedDate).format(Constants.DATE_DISPLAY_FORMAT),
        actualDate: tender.actualDate === null ? null : moment(tender.actualDate).format(Constants.DATE_DISPLAY_FORMAT),
      };
    });

    return changedTenderArray;
  };

  const tendersFormModal = useFormModal('Tender Details', <EditTenderFormFields />, handleEditTenderFormSubmit, true);
  const announcementFormModal = useFormModal(
    'Announcement Details',
    <EditAnnouncementFormFields />,
    handleAnnouncementEditFormSubmit,
    true
  );

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <UIHeader>
        <MaterialCard>{data.projectNumber} </MaterialCard>{' '}
      </UIHeader>

      <MaterialCard>
        <UIHeader>
          Project Tender Details{' '}
          <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
            <Button color="primary" className="float-right" onClick={addTenderClicked}>
              + Add
            </Button>
          </Authorize>
        </UIHeader>
        <DataTableControl
          dataList={data.tenders}
          tableColumns={projectTenderTableColumns}
          editable
          deletable
          editPermissionName={Constants.PERMISSIONS.PROJECT_W}
          onEditClicked={onTenderEditClicked}
          onDeleteClicked={onTenderDeleteClicked}
        />
      </MaterialCard>
      <MaterialCard>
        <UIHeader>
          Public Project Information
          <Authorize requires={Constants.PERMISSIONS.PROJECT_W}>
            <FontAwesomeButton
              icon="edit"
              className="float-right"
              onClick={() => handleAnnouncementEditFormClick(data.id)}
              title="Edit Record"
              iconSize="lg"
            />
          </Authorize>
        </UIHeader>
        <DisplayRow>
          <ColumnTwoGroups
            name="Announcement Value"
            label={<NumberFormat value={data?.anncmentValue} prefix="$" thousandSeparator={true} displayType="text" />}
          />
          <ColumnTwoGroups
            name="C-035 Value"
            label={<NumberFormat value={data?.c035Value} prefix="$" thousandSeparator={true} displayType="text" />}
          />
        </DisplayRow>
        <DisplayRow>
          <ColumnGroup name="Annoucement Comment" label={data?.anncmentComment} />
        </DisplayRow>
      </MaterialCard>
      <div className="text-right">
        <Link to={`${Constants.PATHS.PROJECTS}/${data.id}${Constants.PATHS.PROJECT_PLAN}`}>
          <Button color="secondary">{'< Project Planning'}</Button>
        </Link>
        <Button color="primary" onClick={() => alert('temporary fix link to next section')}>
          Continue
        </Button>
        <Button color="secondary" onClick={() => history.push(projectSearchHistory)}>
          Close
        </Button>
      </div>
      {tendersFormModal.formElement}
      {announcementFormModal.formElement}
    </React.Fragment>
  );
};

const mapStateToProps = (state) => {
  return {
    projectSearchHistory: state.projectSearchHistory.projectSearch,
  };
};

export default connect(mapStateToProps, { showValidationErrorDialog })(ProjectTender);
