import React, { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

import { Button } from 'reactstrap';

import * as Constants from '../../Constants';

function EditSegmentFormFields({ closeForm, ...rest }) {
  let location = useLocation();
  console.log('hi');
  console.log(location.pathname);

  useEffect(() => {
    window.addEventListener('message', addEventListenerCloseForm);

    return removeEventListenerCloseForm;
  });

  const addEventListenerCloseForm = (event) => {
    if (event.data === 'closeForm' && event.origin === 'http://localhost:3000') {
      console.log(event);
      closeForm();
    }
  };

  const removeEventListenerCloseForm = () => {
    window.removeEventListener('message', addEventListenerCloseForm);
  };

  return (
    <React.Fragment>
      <div>Make sure you have TWM running on live server on PORT:5500</div>

      <iframe className="w-100" style={{ height: '800px' }} src={Constants.PATHS.TWM} name="myiframe" title="map" />
      <Button className="float-right mb-2" onClick={closeForm}>
        Cancel
      </Button>
    </React.Fragment>
  );
}

export default EditSegmentFormFields;
