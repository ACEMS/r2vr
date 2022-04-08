import { createStore, combineReducers, applyMiddleware } from 'redux';
import thunk, { ThunkMiddleware } from 'redux-thunk';
import { logger } from 'redux-logger';

import { annotationReducer } from './annotation/AnnotationReducer';
import { colorsReducer } from './colors/ColorsReducer';
import { evaluationReducer } from './evaluation/EvaluationReducer';
import { imageReducer } from './image/ImageReducer';
import { metaDataReducer } from './metadata/MetaDataReducer';
import { userReducer } from './user/UserReducer';

import { AppActions } from './models/actions';

const rootReducer = combineReducers({
  annotationReducer,
  colorsReducer,
  evaluationReducer,
  imageReducer,
  metaDataReducer,
  userReducer,
});

export type AppState = ReturnType<typeof rootReducer>;

export const store = createStore(
  rootReducer,
  applyMiddleware(thunk as ThunkMiddleware<AppState, AppActions>, logger)
);
