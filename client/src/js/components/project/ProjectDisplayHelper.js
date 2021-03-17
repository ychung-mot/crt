import React from 'react';
import { Col, Row } from 'reactstrap';
import MouseoverTooltip from '../ui/MouseoverTooltip';
import ReactMarkdown from 'react-markdown';
import gfm from 'remark-gfm';

import { HELPER_TEXT } from '../helpers/helperText';

export const DisplayRow = ({ children }) => {
  return <Row>{children}</Row>;
};

export const ColumnGroup = ({ name, label, helper, hoverTitle, ...props }) => {
  let { sm = 2 } = props;
  return (
    <>
      <Col className="mt-2 font-weight-bold" sm={sm}>
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{HELPER_TEXT[helper]}</MouseoverTooltip>}
      </Col>
      <Col className="mt-2" sm="9" title={hoverTitle} style={{ cursor: hoverTitle ? 'help' : 'auto' }}>
        {label ? label : 'None'}
      </Col>
    </>
  );
};

export const ColumnGroupWithMarkdown = ({ name, label, helper, ...props }) => {
  let { sm = 3 } = props;
  return (
    <>
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
    </>
  );
};

export const ColumnTwoGroups = ({ name, label, helper, hoverTitle, ...props }) => {
  let { sm = 2 } = props;
  return (
    <>
      <Col className="mt-2 font-weight-bold" sm={sm}>
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{HELPER_TEXT[helper]}</MouseoverTooltip>}
      </Col>
      <Col className="mt-2" sm="3" title={hoverTitle} style={{ cursor: hoverTitle ? 'help' : 'auto' }}>
        {label ? label : 'None'}
      </Col>
    </>
  );
};
