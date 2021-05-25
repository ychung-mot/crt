import React, { useState } from 'react';
import { Popover, PopoverBody } from 'reactstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import PropTypes from 'prop-types';

const MouseoverTooltip = (props) => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <React.Fragment>
      <FontAwesomeIcon
        id={props.id}
        icon={props.icon}
        className={`fa-color-${props.color} ml-1 mr-1 position-absolute`}
        onMouseOver={() => setIsOpen(true)}
        onMouseOut={() => setIsOpen(false)}
        style={{ cursor: 'pointer' }}
      />
      <Popover placement="top" isOpen={isOpen} target={props.id}>
        <PopoverBody>{props.children}</PopoverBody>
      </Popover>
    </React.Fragment>
  );
};

MouseoverTooltip.propTypes = {
  id: PropTypes.string.isRequired,
  icon: PropTypes.string,
  color: PropTypes.oneOf(['primary', 'success', 'danger', 'warning']), //4 colors primary, success, danger, warning
};

MouseoverTooltip.defaultProps = {
  icon: 'question-circle',
  color: 'primary',
};

export default MouseoverTooltip;
