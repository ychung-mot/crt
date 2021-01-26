import React, { useEffect, useState } from 'react';

import SingleDropdownField from '../ui/SingleDropdownField';
import SingleDateField from '../ui/SingleDateField';
import PageSpinner from '../ui/PageSpinner';
import { Row, Col } from 'reactstrap';

import * as api from '../../Api';

const ProjectDetails = ({ match }) => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState({});

  useEffect(() => {
    api.getProject(match.params.id).then((response) => {
      setData(response.data);
      setLoading(false);
      console.log(response.data);
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (loading) return <PageSpinner />;

  //display output helper functions
  const DisplayRow = ({ children }) => {
    return <Row>{children}</Row>;
  };

  const ColumnGroup = ({ name, label, helper }) => {
    return (
      <>
        <Col className="mt-2 font-weight-bold" sm="3">
          {name}
        </Col>
        <Col className="mt-2" sm="3">
          {label ? label : 'None'}
        </Col>
      </>
    );
  };

  return (
    <React.Fragment>
      <DisplayRow>
        <ColumnGroup name="Project Number" label={data.projectNumber} />
        <ColumnGroup name="Project Name" label={data.projectName} />
      </DisplayRow>
      <DisplayRow>
        <ColumnGroup name="Project Description" label={data.description} />
      </DisplayRow>
      <DisplayRow>
        <ColumnGroup name="Project Scope" label={data.scope} />
      </DisplayRow>
      <DisplayRow>
        <ColumnGroup name="Capital Index" label={`${data.capIndxLkup.id} - ${data.capIndxLkup.name}`} />
      </DisplayRow>
      <DisplayRow>
        <ColumnGroup name="MoTI Region" label={data.region.name} />
        <ColumnGroup name="Project Manager" label={`${data.projectMgr.firstName} ${data.projectMgr.lastName}`} />
      </DisplayRow>
      <DisplayRow>
        <ColumnGroup name="Nearest Town" label={data.nearstTwnLkupId} />
        <ColumnGroup name="RC Number" label={data.rcLkupId} />
      </DisplayRow>
      <DisplayRow>
        <ColumnGroup name="Project End Date" label={data.endDate} />
      </DisplayRow>
    </React.Fragment>
  );
};

export default ProjectDetails;
