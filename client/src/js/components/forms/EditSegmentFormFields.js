import React, { useEffect, useState } from 'react';
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

  //event functions

  const addEventListenerCloseForm = (event) => {
    if (event.data.message === 'closeForm' && event.origin === `${window.location.protocol}//${window.location.host}`) {
      setLoading(true);

      //convert route data into groups of 2. Represents lon and lat coordinates.
      let data = _.chunk(event.data.route, 2);

      api
        .postSegment(projectId, { route: data })
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

  if (loading) return <PageSpinner />;

  return (
    <React.Fragment>
      <iframe
        className="w-100"
        style={{ height: '800px' }}
        src={`${Constants.PATHS.TWM}`}
        name="myiframe"
        title="map"
      />
      <Button className="float-right mb-2" onClick={closeForm}>
        Cancel
      </Button>
    </React.Fragment>
  );
}

export default EditSegmentFormFields;
