import { Entity } from 'aframe';

import { store } from '../store/rootStore';

import postAnnotation from '../async/annotation/post';
import updateAnnotation from '../async/annotation/update';
import {
  boundPostAnnotation,
  boundUpdateAnnotation,
} from '../store/annotation/AnnotationAction';

import { AnnotationData } from '../models/AnnotationData';
import { CoralBinary } from '../models/CoralBinary';
import { Marker } from '../store/annotation/models/Annotation';

const save = (markerId: number, coralBinary: CoralBinary) => {
  const state = store.getState();
  const { name } = state.userReducer;
  if (name === '') return;
  const { filename, stringId } = state.imageReducer;
  // eslint-disable-next-line @typescript-eslint/camelcase
  const { observation_number } = state.observationReducer;

  const marker = <Entity>document.getElementById(`markerContainer${markerId}`)!;

  let data: AnnotationData;

  if (marker.getAttribute('marked') === 'false') {
    const markerX = marker.getAttribute('position').x;
    const markerY = marker.getAttribute('position').y;

    // If marker has not yet been annotated set 'marked' to true
    // This will be used to identify if it is a POST or PUT request
    marker.setAttribute('marked', 'true');

    // Set POST data
    data = {
      image_file: filename,
      image_id: stringId,
      is_coral: coralBinary,
      observation_number,
      observer: name,
      site: +markerId,
      x: markerX,
      y: markerY,
    };
    // eslint-disable-next-line @typescript-eslint/no-use-before-define
    postAnnotation(data);
    const annotatedMarker: Marker = {
      id: data.site,
      isCoral: coralBinary,
    };
    boundPostAnnotation(annotatedMarker);
    console.log(88, annotatedMarker);
  } else {
    // If annotation exists 'marked' => Set PUT data
    data = {
      image_id: stringId,
      observation_number,
      site: +markerId,
    };
    // eslint-disable-next-line @typescript-eslint/no-use-before-define
    updateAnnotation(data, coralBinary);
  }
  const annotatedMarker: Marker = {
    id: data.site,
    isCoral: coralBinary,
  };
  boundUpdateAnnotation(annotatedMarker);
};

export default save;
