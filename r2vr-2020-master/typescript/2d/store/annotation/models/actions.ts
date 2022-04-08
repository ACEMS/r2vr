import { Annotation, Marker } from './Annotation';

export const NEW_IMAGE = 'NEW_IMAGE';
export const POST_ANNOTATION = 'POST_ANNOTATION';
export const UPDATE_ANNOTATION = 'UPDATE_ANNOTATION';

interface PushImageAction {
  type: typeof NEW_IMAGE;
  image: Pick<Annotation, 'imageId'>;
}

interface PostAnnotationAction {
  type: typeof POST_ANNOTATION;
  marker: Marker;
}

interface UpdateAnnotationAction {
  type: typeof UPDATE_ANNOTATION;
  marker: Marker;
}

export type AnnotationActionTypes =
  | PushImageAction
  | PostAnnotationAction
  | UpdateAnnotationAction;
