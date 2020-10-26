import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import {
  SELECT_EVALUATION,
  CHANGE_EVALUATION,
  POST_EVALUATION,
  NEW_EVALUATION,
} from './models/actions';

const selectEvaluation = (
  evaluationResponse: Shared.QuestionResponseOption
): AppActions => {
  return {
    type: SELECT_EVALUATION,
    evaluationResponse,
  };
};

const changeEvaluation = (
  evaluationResponse: Shared.QuestionResponseOption
): AppActions => {
  return {
    type: CHANGE_EVALUATION,
    evaluationResponse,
  };
};

const postEvaluation = (): AppActions => {
  return {
    type: POST_EVALUATION,
  };
};

const newEvaluation = (): AppActions => {
  return {
    type: NEW_EVALUATION,
  };
};

export const boundSelectEvaluation = (
  evaluationResponse: Shared.QuestionResponseOption
) => store.dispatch(selectEvaluation(evaluationResponse));

export const boundChangeEvaluation = (
  evaluationResponse: Shared.QuestionResponseOption
) => store.dispatch(changeEvaluation(evaluationResponse));

export const boundPostEvaluation = () => store.dispatch(postEvaluation());

export const boundNewEvaluation = () => store.dispatch(newEvaluation());
