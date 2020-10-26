import { MarkerActionTypes } from './models/actions';
import { Marker } from './models/Marker';

const defaultState: Marker = { id: 0, isHovered: false };

// eslint-disable-next-line import/prefer-default-export
export const markerReducer = (
  state = defaultState,
  action: MarkerActionTypes
): Marker => {
  switch (action.type) {
    case 'MARKER':
      return { ...action.marker };

    default:
      return state;
  }
};
