import { Marker } from './Marker';

export const MARKER = 'MARKER';

interface MarkerAction {
  type: typeof MARKER;
  marker: Marker;
}

export type MarkerActionTypes = MarkerAction;
