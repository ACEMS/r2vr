import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import {
  NEW_IMAGE,
  POST_ANNOTATION,
  UPDATE_ANNOTATION,
} from './models/actions';
import { Annotation, Marker } from './models/Annotation';

const pushNewImage = (image: Pick<Annotation, 'imageId'>): AppActions => {
  return {
    type: NEW_IMAGE,
    image,
  };
};

const postAnnotation = (marker: Marker): AppActions => {
  return {
    type: POST_ANNOTATION,
    marker,
  };
};

const updateAnnotation = (marker: Marker): AppActions => {
  return {
    type: UPDATE_ANNOTATION,
    marker,
  };
};

export const boundPushNewImage = (image: Pick<Annotation, 'imageId'>) =>
  store.dispatch(pushNewImage(image));

export const boundPostAnnotation = (marker: Marker) =>
  store.dispatch(postAnnotation(marker));

export const boundUpdateAnnotation = (marker: Marker) =>
  store.dispatch(updateAnnotation(marker));
