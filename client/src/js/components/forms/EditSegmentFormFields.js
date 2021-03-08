import React, { useEffect, useState, useRef } from 'react';
import _ from 'lodash';

import { Button } from 'reactstrap';
import PageSpinner from '../ui/PageSpinner';

import * as Constants from '../../Constants';
import * as api from '../../Api';

function EditSegmentFormFields({ closeForm, projectId, refreshData }) {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    window.addEventListener('message', addEventListenerCloseForm);

    return removeEventListenerCloseForm;
  });

  const myIframe = useRef(null);

  //event functions

  const addEventListenerCloseForm = (event) => {
    if (event.data.message === 'closeForm' && event.origin === `${window.location.protocol}//${window.location.host}`) {
      setLoading(true);

      //convert route data into groups of 2. Represents lon and lat coordinates.
      let data = _.chunk(event.data.route, 2);
      let description = event.data.description;

      api
        .postSegment(projectId, { route: data, description })
        .then(() => {
          setLoading(false);
          refreshData();
          closeForm();
        })
        .catch((error) => {
          console.log(error);
        });
    }
  };

  const removeEventListenerCloseForm = () => {
    window.removeEventListener('message', addEventListenerCloseForm);
  };

  //helper functions

  const dirtyCheck = () => {
    // check if iFrame form is empty. if it's dirty we should ask user to confirm leaving
    let myForm = myIframe.current.contentWindow.document.forms['simple-router-form'];
    var dirtyFlag = false;

    for (let i = 0; i < myForm.elements.length; i++) {
      let fieldValue = myForm.elements[i].value;
      if (fieldValue) {
        dirtyFlag = true;
      }
    }

    return dirtyFlag;
  };

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <iframe
        className="w-100"
        style={{ height: '800px' }}
        src={`${Constants.PATHS.TWM}`}
        name="myIframe"
        id="myIframe"
        title="map"
        ref={myIframe}
      />
      <Button className="float-right mb-2" onClick={closeForm}>
        Cancel
      </Button>
      <Button onClick={dirtyCheck}>Test</Button>
    </React.Fragment>
  );
}

export default EditSegmentFormFields;
