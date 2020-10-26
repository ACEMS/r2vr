import { createStore, combineReducers, applyMiddleware } from 'redux';
import thunk, { ThunkMiddleware } from 'redux-thunk';
// eslint-disable-next-line import/no-extraneous-dependencies
import { logger } from 'redux-logger';

import { annotationReducer } from './annotation/AnnotationReducer';
import { evaluationReducer } from './evaluation/EvaluationReducer';
import { imageReducer } from './image/ImageReducer';
import { intersectionReducer } from './intersection/IntersectionReducer';
import { markerReducer } from './marker/MarkerReducer';
import { observationReducer } from './observation/ObservationReducer';
import { userReducer } from './user/UserReducer';

import { AppActions } from './models/actions';

const rootReducer = combineReducers({
  annotationReducer,
  evaluationReducer,
  imageReducer,
  intersectionReducer,
  markerReducer,
  observationReducer,
  userReducer,
});

export type AppState = ReturnType<typeof rootReducer>;

export const store = createStore(
  rootReducer,
  applyMiddleware(thunk as ThunkMiddleware<AppState, AppActions>, logger)
);
