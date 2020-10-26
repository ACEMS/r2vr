import { store } from '../store/rootStore';

export const getMarkers = (): Shared.Marker[] => {
  const state = store.getState();
  const { annotationReducer } = state;
  return annotationReducer[annotationReducer.length - 1].markers;
};
