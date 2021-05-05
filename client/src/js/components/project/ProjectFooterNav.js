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
    //different zIndex needed. Default bootstrap makes it appear over nav items.
    <div className="sticky-top d-flex justify-content-end" style={{ zIndex: 999 }}>
      <Nav pills>
        <NavItem className="bg-secondary" title={'Go to Project Details'}>
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
        <NavItem className="bg-secondary" title={'Go to Project Plan'}>
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
        <NavItem className="bg-secondary" title={'Go to Project Tenders'}>
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
        <NavItem className="bg-secondary" title={'Go to Project Segments'}>
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
        <NavItem className="bg-danger" title={'Return to Project Search'}>
          <NavLink tag={RRNavLink} className="text-light" to={`${Constants.PATHS.PROJECTS}`} isActive={exactPathMatch}>
            Close
          </NavLink>
        </NavItem>
      </Nav>
    </div>
  );
}

export default ProjectFooterNav;
