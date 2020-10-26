import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import {
  EVALUATION,
  POST_EVALUATION,
  UPDATE_EVALUATION,
  NEW_EVALUATION,
} from './models/actions';
import {
  EvaluationResponse,
  QuestionResponse,
} from './models/EvaluationResponse';

// TODO: check if needed - should last hovered evaluation be somewhere else?
const evaluationResponseIntersection = (
  res: Pick<EvaluationResponse, 'lastHoveredOption'>
): AppActions => {
  return {
    type: EVALUATION,
    res,
  };
};

const postEvaluation = (questionResponse: QuestionResponse): AppActions => {
  return {
    type: POST_EVALUATION,
    questionResponse,
  };
};

const updateEvaluation = (questionResponse: QuestionResponse): AppActions => {
  return {
    type: UPDATE_EVALUATION,
    questionResponse,
  };
};

const newEvaluation = (): AppActions => {
  return {
    type: NEW_EVALUATION,
  };
};

export const boundEvaluationResponseIntersection = (res: EvaluationResponse) =>
  store.dispatch(evaluationResponseIntersection(res));

export const boundPostEvaluation = (questionResponse: QuestionResponse) =>
  store.dispatch(postEvaluation(questionResponse));

export const boundUpdateEvaluation = (questionResponse: QuestionResponse) =>
  store.dispatch(updateEvaluation(questionResponse));

export const boundNewEvaluation = () => store.dispatch(newEvaluation());
