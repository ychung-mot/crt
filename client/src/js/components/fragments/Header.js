import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import {
  Button,
  Container,
  Collapse,
  Navbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
} from 'reactstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import NavLinkWithMatch from '../ui/NavLinkWithMatch';
import Authorize from '../fragments/Authorize';

import * as Keycloak from '../../Keycloak';
import * as Constants from '../../Constants';
import * as api from '../../Api';

const Header = ({ currentUser }) => {
  const location = useLocation();
  const [collapsed, setCollapsed] = useState(true);
  const [version, setVersion] = useState(null);

  useEffect(() => {
    api.getVersion().then((response) => setVersion(response.data.environment.toLowerCase()));
  }, []);

  useEffect(() => {
    localStorage.setItem('lastVisitedPath', location.pathname);
  }, [location.pathname]);

  const toggleNavbar = () => {
    setCollapsed(!collapsed);
  };

  const hideNavbar = () => {
    setCollapsed(true);
  };

  return (
    <header className="mb-3">
      <Navbar expand="lg" className="navbar-dark">
        <Container>
          <NavbarBrand tag={Link} onClick={hideNavbar} to="/">
            <img
              className="img-fluid d-none d-md-inline-block"
              src={`${process.env.PUBLIC_URL}/images/bcid-logo-rev-en.svg`}
              width="181"
              height="44"
              alt="B.C. Government Logo"
            />
            <img
              className="img-fluid d-md-none"
              src={`${process.env.PUBLIC_URL}/images/bcid-symbol-rev.svg`}
              width="64"
              height="44"
              alt="B.C. Government Logo"
            />
          </NavbarBrand>
          <div className="navbar-brand">MoTI Capital and Rehabilitation Tracking</div>
          <NavbarBrand tag={Link} onClick={hideNavbar} to="/">
            <img
              className="img-fluid d-inline-block ml-2"
              src={`${process.env.PUBLIC_URL}/images/cart-logo.png`}
              width="64"
              height="44"
              alt="CaRT Logo"
            />
          </NavbarBrand>
          <NavbarToggler onClick={toggleNavbar} />
          {/* <Collapse> is needed to keep justify-content: space-between maintain correct spacing */}
          <Collapse isOpen={!collapsed} navbar />
        </Container>
      </Navbar>
      <Navbar expand="lg" className={`navbar-dark main-nav ${version}`}>
        <Container>
          <Collapse isOpen={!collapsed} navbar>
            <Nav className="navbar-nav">
              <React.Fragment>
                <Authorize requires={Constants.PERMISSIONS.PROJECT_R}>
                  <NavLinkWithMatch hideNavbar={hideNavbar} to={Constants.PATHS.PROJECTS} text="Projects" />
                </Authorize>
              </React.Fragment>
              <UncontrolledDropdown nav inNavbar>
                <Authorize requires={Constants.PERMISSIONS.EXPORT_R}>
                  <DropdownToggle nav caret>
                    Reports
                  </DropdownToggle>
                  <DropdownMenu>
                    {/* temporary fix requires the actual path  */}

                    <DropdownItem tag={Link} to={'//www.google.com'} target="_blank">
                      Dashboard
                    </DropdownItem>

                    <DropdownItem tag={Link} to={'//www.google.com'} target="_blank">
                      Paginated
                    </DropdownItem>
                  </DropdownMenu>
                </Authorize>
              </UncontrolledDropdown>
              <UncontrolledDropdown nav inNavbar>
                <DropdownToggle nav caret>
                  Admin
                </DropdownToggle>
                <DropdownMenu>
                  <Authorize requires={Constants.PERMISSIONS.USER_R}>
                    <DropdownItem tag={Link} to={Constants.PATHS.ADMIN_USERS}>
                      Users
                    </DropdownItem>
                  </Authorize>
                  <Authorize requires={Constants.PERMISSIONS.ROLE_R}>
                    <DropdownItem tag={Link} to={Constants.PATHS.ADMIN_ROLES}>
                      Roles and Permissions
                    </DropdownItem>
                  </Authorize>
                  <Authorize requires={Constants.PERMISSIONS.CODE_R}>
                    <DropdownItem tag={Link} to={Constants.PATHS.ADMIN_CODE_TABLES}>
                      Code Tables
                    </DropdownItem>
                  </Authorize>
                  <Authorize requires={Constants.PERMISSIONS.CODE_R}>
                    <DropdownItem tag={Link} to={Constants.PATHS.ADMIN_ELEMENTS}>
                      Elements
                    </DropdownItem>
                  </Authorize>
                  <Authorize requires={Constants.PERMISSIONS.API_W}>
                    <DropdownItem tag={Link} to={Constants.PATHS.API_ACCESS}>
                      API Access
                    </DropdownItem>
                  </Authorize>
                  <DropdownItem tag={Link} to={Constants.PATHS.VERSION}>
                    Version
                  </DropdownItem>
                </DropdownMenu>
              </UncontrolledDropdown>
            </Nav>
            <Nav className="navbar-nav ml-auto">
              <NavItem>
                <Button color="link" onClick={() => Keycloak.logout()}>
                  <FontAwesomeIcon icon="user" /> {`${currentUser.username},  Logout`}
                </Button>
              </NavItem>
            </Nav>
          </Collapse>
        </Container>
      </Navbar>
    </header>
  );
};

const mapStateToProps = (state) => {
  return {
    currentUser: state.user.current,
  };
};

export default connect(mapStateToProps, null)(Header);
