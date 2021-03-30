import React from 'react';
import { NavLink as RRNavLink } from 'react-router-dom';

//components
import { Nav, NavLink, NavItem } from 'reactstrap';

import * as Constants from '../../Constants';

function ProjectFooterNav({ projectId }) {
  const exactPathMatch = (match) => {
    return match && match.isExact;
  };

  return (
    <div className="d-flex flex-row-reverse">
      <Nav pills>
        <NavItem className="bg-secondary">
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}`}
            isActive={exactPathMatch}
            className={'text-light'}
            activeClassName={'bg-primary'}
          >
            Details
          </NavLink>
        </NavItem>
        <NavItem className="bg-secondary">
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}${Constants.PATHS.PROJECT_PLAN}`}
            isActive={exactPathMatch}
            className={'text-light'}
            activeClassName={'bg-primary'}
          >
            Financial Plan
          </NavLink>
        </NavItem>
        <NavItem className="bg-secondary">
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}${Constants.PATHS.PROJECT_TENDER}`}
            isActive={exactPathMatch}
            className={'text-light'}
            activeClassName={'bg-primary'}
          >
            Tender
          </NavLink>
        </NavItem>
        <NavItem className="bg-secondary">
          <NavLink
            tag={RRNavLink}
            to={`${Constants.PATHS.PROJECTS}/${projectId}${Constants.PATHS.PROJECT_SEGMENT}`}
            isActive={exactPathMatch}
            className={'text-light'}
            activeClassName={'bg-primary'}
          >
            Segment
          </NavLink>
        </NavItem>
        <NavItem className="bg-danger ">
          <NavLink tag={RRNavLink} className="text-light" to={`${Constants.PATHS.PROJECTS}`} isActive={exactPathMatch}>
            Close
          </NavLink>
        </NavItem>
      </Nav>
    </div>
  );
}

export default ProjectFooterNav;
