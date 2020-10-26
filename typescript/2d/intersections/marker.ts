import { store } from '../store/rootStore';

import boundMarkerIntersection from '../store/marker/MarkerAction';

import selectMenuOption from './menu-options';

// Determines if the marker is hovered
const handleMarkerIntersection = (): void => {
  const { observationReducer, intersectionReducer } = store.getState();

  // Prevents annotation points being marked if missing observation_number data
  const observationNumber = observationReducer.observation_number;
  const intersectedElId = intersectionReducer[0]?.id;
  // TODO: check markers on edge
  if (
    [0, -1].includes(observationNumber) ||
    intersectedElId === 'canvas2d' ||
    intersectionReducer.length === 0 ||
    intersectedElId.includes('option')
  ) {
    return;
  }
  // TODO - Refactor evaluation question + responses out into separate reducer
  // and check and return above for this marker handler
  // Look for the string 'option' for the intersected id

  const matches = intersectedElId.match(/(\d+)/);

  // Parse the string to a number so the corresponding ID can be used
  // return +matches[0];
  if (matches) {
    const markerId = <number>+matches[0];

    boundMarkerIntersection({ id: markerId, isHovered: true });
    selectMenuOption();
  }
};

export default handleMarkerIntersection;
