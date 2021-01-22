import React from 'react';

const ProjectDetails = ({ match }) => {
  return <div>Project Details {match.params.id}</div>;
};

export default ProjectDetails;
