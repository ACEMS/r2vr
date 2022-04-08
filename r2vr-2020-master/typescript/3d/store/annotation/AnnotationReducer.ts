import { AnnotationActionTypes } from './models/actions';

const defaultState: Shared.Annotation[] = [];

export const annotationReducer = (
  state = defaultState,
  action: AnnotationActionTypes
): Shared.Annotation[] => {
  const annotationArrayLength = state.length;
  switch (action.type) {
    case 'NEW_IMAGE':
      const nextImageState = {
        image: {
          extension: action.image.extension,
          fullName: action.image.fullName,
          name: action.image.name,
          isAnnotated: false,
          uniqueNumberId: annotationArrayLength,
        },
        markers: [],
      };

      const previousState = [...state];
      if (previousState.length >= 1) {
        previousState[annotationArrayLength - 1].image.isAnnotated = true;
      }
      nextImageState.image.uniqueNumberId++;

      return [...previousState, nextImageState];

    case 'POST_ANNOTATION':
      const nextState = [...state];
      nextState[annotationArrayLength - 1].markers.push(action.marker);
      return nextState;

    case 'UPDATE_ANNOTATION':
      const updateState = [...state];
      const latestImageMarkers = updateState[annotationArrayLength - 1].markers;
      const foundIndex = latestImageMarkers.findIndex(
        (marker) => marker.id === action.marker.id
      );
      latestImageMarkers[foundIndex] = action.marker;

      return updateState;

    default:
      return state;
  }
};
