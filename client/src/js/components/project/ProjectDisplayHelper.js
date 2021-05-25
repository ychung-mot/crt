import React from 'react';
import { Col, Row } from 'reactstrap';
import MouseoverTooltip from '../ui/MouseoverTooltip';
import ReactMarkdown from 'react-markdown';
import gfm from 'remark-gfm';

import { HELPER_TEXT } from '../helpers/helperText';

export const DisplayRow = ({ children }) => {
  return (
    <Row>
      <Col>{children}</Col>
    </Row>
  );
};

export const DisplayMultiRow = ({ children }) => {
  //Takes multiple children and splits them evenly in a row
  return (
    <Row>
      {React.Children.map(children, (child, i) => (
        <Col>{child}</Col>
      ))}
    </Row>
  );
};

export const ColumnGroup = ({ name, label, helper, hoverTitle, ...props }) => {
  let { sm = 3 } = props;
  return (
    <Row>
      <Col className="mt-2 font-weight-bold" sm={sm}>
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{HELPER_TEXT[helper]}</MouseoverTooltip>}
      </Col>
      <Col className="mt-2" sm={12 - sm} title={hoverTitle} style={{ cursor: hoverTitle ? 'help' : 'auto' }}>
        <ConditionalWrapper condition={props.strong} wrapper={(children) => <strong>{children}</strong>}>
          {label ? label : 'None'}
        </ConditionalWrapper>
      </Col>
    </Row>
  );
};

export const ColumnGroupWithMarkdown = ({ name, label, helper, ...props }) => {
  let { sm = 3 } = props;
  return (
    <Row>
      <Col className="mt-2 font-weight-bold" sm={sm}>
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{HELPER_TEXT[helper]}</MouseoverTooltip>}
      </Col>
      <Col className="mt-2 markdown__container-overflow" sm="9">
        {label ? (
          <ReactMarkdown linkTarget="_blank" plugins={[gfm]}>
            {label}
          </ReactMarkdown>
        ) : (
          ''
        )}
      </Col>
    </Row>
  );
};

//helper components
const ConditionalWrapper = ({ condition, children, wrapper }) => {
  return condition ? wrapper(children) : children;
};
