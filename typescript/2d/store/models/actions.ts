import { AnnotationActionTypes } from '../annotation/models/actions';
import { EvaluationActionTypes } from '../evaluation/models/actions';
import { ImageActionTypes } from '../image/models/actions';
import { IntersectionActionTypes } from '../intersection/models/actions';
import { MarkerActionTypes } from '../marker/models/actions';
import { ObservationActionTypes } from '../observation/models/actions';
import { UserActionTypes } from '../user/models/actions';

export type AppActions =
  | AnnotationActionTypes
  | EvaluationActionTypes
  | ImageActionTypes
  | IntersectionActionTypes
  | MarkerActionTypes
  | ObservationActionTypes
  | UserActionTypes;
