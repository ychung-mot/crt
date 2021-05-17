import React from 'react';

function CalculatorLoadingIcon({ width, height }) {
  return (
    <div>
      <svg width={width} height={height} viewBox="0 0 128 163" fill="none" xmlns="http://www.w3.org/2000/svg">
        <title>Calculator Loading Icon</title>
        <rect width="128" height="163" rx="10" ry="10" fill="#a9a9a9" />
        <line id="Line 1" x1="1" y1="43" x2="127" y2="43" stroke="black" stroke-width="2" />
        <path
          d="M117 1H11C5.47715 1 1 5.47715 1 11V152C1 157.523 5.47715 162 11 162H117C122.523 162 127 157.523 127 152V11C127 5.47715 122.523 1 117 1Z"
          stroke="black"
          stroke-width="2"
        />
        <rect class="svg__loading-container" x="18.5" y="11.5" width="90" height="21" fill="#C4C4C4" stroke="black" />
        <rect class="svg__loading-bar" x="20" y="13" width="87" height="18" fill="#2E8540" />
        <g id="buttonGroup">
          <rect
            class="svg__button-group"
            x="18"
            y="56"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="52"
            y="56"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="87"
            y="56"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="18"
            y="92"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="52"
            y="92"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="87"
            y="92"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="18"
            y="128"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="52"
            y="128"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
          <rect
            class="svg__button-group"
            x="87"
            y="128"
            width="22"
            height="22"
            fill="black"
            stroke="black"
            stroke-linejoin="bevel"
          />
        </g>
      </svg>
    </div>
  );
}

export default CalculatorLoadingIcon;
