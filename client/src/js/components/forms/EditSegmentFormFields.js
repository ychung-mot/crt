import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

import { Button } from 'reactstrap';
import PageSpinner from '../ui/PageSpinner';

import * as Constants from '../../Constants';
import * as api from '../../Api';

function EditSegmentFormFields({ closeForm, ...rest }) {
  let { id: projectId } = useParams();

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    window.addEventListener('message', addEventListenerCloseForm);

    return removeEventListenerCloseForm;
  });

  //event functions

  const addEventListenerCloseForm = (event) => {
    if (event.data.message === 'closeForm' && event.origin === 'http://localhost:3000') {
      setLoading(true);

      api
        .postSegment(projectId, { route: event.data.route })
        .then(() => {
          setLoading(false);
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
