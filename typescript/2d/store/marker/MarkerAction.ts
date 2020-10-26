import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { MARKER } from './models/actions';
import { Marker } from './models/Marker';

const markerIntersection = (marker: Marker): AppActions => {
  return {
    type: MARKER,
    marker,
  };
};

const boundMarkerIntersection = (marker: Marker) =>
  store.dispatch(markerIntersection(marker));

export default boundMarkerIntersection;
