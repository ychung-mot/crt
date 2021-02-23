import React, { useEffect } from 'react';

function EditSegmentFormFields({ closeForm, ...rest }) {
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

      <iframe
        className="w-100"
        style={{ height: '800px' }}
        src={`http://localhost:3000/twm/`}
        name="myiframe"
        title="map"
      />
    </React.Fragment>
  );
}

export default EditSegmentFormFields;
