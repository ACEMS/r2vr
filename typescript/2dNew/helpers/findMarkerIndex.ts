import { store } from '../store/rootStore';

const getMarkerIndex = (markerId: number): number => {
  const state = store.getState();
  const { annotationReducer } = state;
  const latestImageMarkers =
    annotationReducer[annotationReducer.length - 1].markers;
  return latestImageMarkers.findIndex((marker) => marker.id === markerId);
};

export default getMarkerIndex;
