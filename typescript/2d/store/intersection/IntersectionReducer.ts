import { Entity } from 'aframe';

import { IntersectionActionTypes } from './models/actions';

const defaultState: Entity[] = [];

// eslint-disable-next-line import/prefer-default-export
export const intersectionReducer = (
  state = defaultState,
  action: IntersectionActionTypes
): Entity[] => {
  switch (action.type) {
    case 'INTERSECTION':
      return { ...action.els };

    default:
      return state;
  }
};
