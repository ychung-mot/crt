import React from 'react';
import { connect } from 'react-redux';
import { NavLink as RRNavLink } from 'react-router-dom';

//components
import { Nav, NavLink, NavItem } from 'reactstrap';

import * as Constants from '../../Constants';

function ProjectFooterNav({ projectSearchHistory, projectId }) {
  const exactPathMatch = (match) => {
    return match && match.isExact;
  };

  return (
    <div className="d-flex flex-row-reverse">
      <Nav tabs>
        <NavItem>
          <NavLink tag={RRNavLink} to={`${Constants.PATHS.PROJECTS}/${projectId}`} isActive={exactPathMatch}>
            Details
          </NavLink>
        </NavItem>
        <NavItem>
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}${Constants.PATHS.PROJECT_PLAN}`}
            isActive={exactPathMatch}
          >
            Plan
          </NavLink>
        </NavItem>
        <NavItem>
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}${Constants.PATHS.PROJECT_TENDER}`}
            isActive={exactPathMatch}
          >
            Tender
          </NavLink>
        </NavItem>
        <NavItem>
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}${Constants.PATHS.PROJECT_SEGMENT}`}
            isActive={exactPathMatch}
          >
            Segment
          </NavLink>
        </NavItem>
        <NavItem>
          <NavLink tag={RRNavLink} to={projectSearchHistory} isActive={exactPathMatch}>
            Close
          </NavLink>
        </NavItem>
      </Nav>
    </div>
  );
}

const mapStateToProps = (state) => {
  return {
    projectSearchHistory: state.projectSearchHistory.projectSearch,
  };
};

export default connect(mapStateToProps, null)(ProjectFooterNav);
