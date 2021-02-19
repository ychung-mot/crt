import React from 'react';
import { Col, Row } from 'reactstrap';
import MouseoverTooltip from '../ui/MouseoverTooltip';
import ReactMarkdown from 'react-markdown';
import gfm from 'remark-gfm';

import { PROJECT_HELPER_TEXT } from '../project/ProjectHelperText';

export const DisplayRow = ({ children }) => {
  return <Row>{children}</Row>;
};

export const ColumnGroup = ({ name, label, helper }) => {
  return (
    <>
      <Col className="mt-2 font-weight-bold" sm="3">
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{PROJECT_HELPER_TEXT[helper]}</MouseoverTooltip>}
      </Col>
      <Col className="mt-2" sm="9">
        {label ? label : 'None'}
      </Col>
    </>
  );
};

export const ColumnGroupWithMarkdown = ({ name, label, helper }) => {
  return (
    <>
      <Col className="mt-2 font-weight-bold" sm="3">
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{PROJECT_HELPER_TEXT[helper]}</MouseoverTooltip>}
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

export const ColumnTwoGroups = ({ name, label, helper }) => {
  return (
    <>
      <Col className="mt-2 font-weight-bold" sm="3">
        {name}
        {helper && <MouseoverTooltip id={`project-details__${helper}`}>{PROJECT_HELPER_TEXT[helper]}</MouseoverTooltip>}
      </Col>
      <Col className="mt-2" sm="3">
        {label ? label : 'None'}
      </Col>
    </>
  );
};
