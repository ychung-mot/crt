import React from 'react';
import { connect } from 'react-redux';
import { BrowserRouter, Route, Switch, Redirect } from 'react-router-dom';
import { Container } from 'reactstrap';
import { toast } from 'react-toastify';

import 'react-dates/initialize';
import 'react-dates/lib/css/_datepicker.css';

import 'react-toastify/dist/ReactToastify.css';

import AuthorizedRoute from './components/fragments/AuthorizedRoute';
import Main from './components/Main';
import Footer from './components/fragments/Footer';
import Header from './components/fragments/Header';
import UserAdmin from './components/UserAdmin';
import RoleAdmin from './components/RoleAdmin';
import Version from './components/Version';
import ApiAccess from './components/ApiAccess';
import ErrorBoundary from './components/ErrorBoundary';

import addIconsToLibrary from './fontAwesome';
import * as Constants from './Constants';

import '../scss/app.scss';

toast.configure({
  position: 'bottom-center',
  autoClose: 2000,
  hideProgressBar: true,
  closeOnClick: true,
  pauseOnHover: true,
  draggable: true,
});

const App = ({ currentUser }) => {
  addIconsToLibrary();

  return (
    <Main>
      <BrowserRouter>
        <React.Fragment>
          <Header />
          <Container>
            <ErrorBoundary>
              <Switch>{Routes(currentUser)}</Switch>
            </ErrorBoundary>
          </Container>
          <Footer />
        </React.Fragment>
      </BrowserRouter>
    </Main>
  );
};

const NoMatch = () => {
  return <p>404</p>;
};

const Unauthorized = () => {
  return <p>Unauthorized</p>;
};

const Routes = (currentUser) => {
  return AdminRoutes(currentUser);
};

const defaultPath = (currentUser) => {
  if (currentUser.permissions?.includes(Constants.PERMISSIONS.USER_R)) return Constants.PATHS.ADMIN_USERS;

  if (currentUser.permissions?.includes(Constants.PERMISSIONS.ROLE_R)) return Constants.PATHS.ADMIN_ROLES;

  return Constants.PATHS.UNAUTHORIZED;
};

const getLastVistedPath = (currentUser) => {
  const lastVisitedPath = localStorage.getItem('lastVisitedPath');

  if (lastVisitedPath) return lastVisitedPath;

  return defaultPath(currentUser);
};

const CommonRoutes = () => {
  return (
    <Switch>
      <Route path={Constants.PATHS.API_ACCESS} exact component={ApiAccess} />
      <Route path={Constants.PATHS.VERSION} exact component={Version} />
      <Route path={Constants.PATHS.UNAUTHORIZED} exact component={Unauthorized} />
      <Route path="*" component={NoMatch} />
    </Switch>
  );
};

const AdminRoutes = (currentUser) => {
  return (
    <Switch>
      <Route path={Constants.PATHS.HOME} exact>
        <Redirect to={getLastVistedPath(currentUser)} />
      </Route>
      <AuthorizedRoute path={Constants.PATHS.ADMIN_USERS} requires={Constants.PERMISSIONS.USER_R}>
        <Route path={Constants.PATHS.ADMIN_USERS} exact component={UserAdmin} />
      </AuthorizedRoute>
      <AuthorizedRoute path={Constants.PATHS.ADMIN_ROLES} requires={Constants.PERMISSIONS.ROLE_R}>
        <Route path={Constants.PATHS.ADMIN_ROLES} exact component={RoleAdmin} />
      </AuthorizedRoute>
      {CommonRoutes()}
    </Switch>
  );
};

const mapStateToProps = (state) => {
  return {
    currentUser: state.user.current,
  };
};

export default connect(mapStateToProps, null)(App);
