import { AnnotationActionTypes } from './models/actions';
import { Annotation } from './models/Annotation';

const defaultState: Annotation[] = [
  // { isImageAnnotated: false, imageNumber: 0, imageId: 'img0', markers: [] },
];

// eslint-disable-next-line import/prefer-default-export
export const annotationReducer = (
  state = defaultState,
  action: AnnotationActionTypes
): Annotation[] => {
  const annotationArrayLength = state.length;
  switch (action.type) {
    case 'NEW_IMAGE':
      const nextImageState = {
        isImageAnnotated: false,
        imageNumber: annotationArrayLength,
        imageId: action.image,
        markers: [],
      };
      const previousState = [...state];
      if (previousState.length >= 1) {
        previousState[annotationArrayLength - 1].isImageAnnotated = true;
      }
      nextImageState.imageNumber++;
      return <Annotation[]>[...previousState, nextImageState];

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
