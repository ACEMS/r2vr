export const NEW_IMAGE = 'NEW_IMAGE';
export const POST_ANNOTATION = 'POST_ANNOTATION';
export const UPDATE_ANNOTATION = 'UPDATE_ANNOTATION';

interface PushImageAction {
  type: typeof NEW_IMAGE;
  image: Shared.ImageFile;
}

interface PostAnnotationAction {
  type: typeof POST_ANNOTATION;
  marker: Shared.Marker;
}

interface UpdateAnnotationAction {
  type: typeof UPDATE_ANNOTATION;
  marker: Shared.Marker;
}

export type AnnotationActionTypes =
  | PushImageAction
  | PostAnnotationAction
  | UpdateAnnotationAction;
