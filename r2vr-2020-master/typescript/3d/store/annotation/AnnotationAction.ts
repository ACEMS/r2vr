import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import {
  NEW_IMAGE,
  POST_ANNOTATION,
  UPDATE_ANNOTATION,
} from './models/actions';

const pushNewImage = (image: Shared.ImageFile): AppActions => {
  return {
    type: NEW_IMAGE,
    image,
  };
};

const postAnnotation = (marker: Shared.Marker): AppActions => {
  return {
    type: POST_ANNOTATION,
    marker,
  };
};

const updateAnnotation = (marker: Shared.Marker): AppActions => {
  return {
    type: UPDATE_ANNOTATION,
    marker,
  };
};

export const boundPushNewImage = (image: Shared.ImageFile) =>
  store.dispatch(pushNewImage(image));

export const boundPostAnnotation = (marker: Shared.Marker) =>
  store.dispatch(postAnnotation(marker));

export const boundUpdateAnnotation = (marker: Shared.Marker) =>
  store.dispatch(updateAnnotation(marker));
