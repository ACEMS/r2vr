import { EvaluationResponse, QuestionResponse } from './EvaluationResponse';

export const EVALUATION = 'EVALUATION';
export const POST_EVALUATION = 'POST_EVALUATION';
export const UPDATE_EVALUATION = 'UPDATE_EVALUATION';
export const NEW_EVALUATION = 'NEW_EVALUATION';

interface EvaluationAction {
  type: typeof EVALUATION;
  res: EvaluationResponse;
}

interface PostEvaluationAction {
  type: typeof POST_EVALUATION;
  questionResponse: QuestionResponse;
}

interface UpdateEvaluationAction {
  type: typeof UPDATE_EVALUATION;
  questionResponse: QuestionResponse;
}

interface NewEvaluationAction {
  type: typeof NEW_EVALUATION;
}

export type EvaluationActionTypes =
  | EvaluationAction
  | PostEvaluationAction
  | UpdateEvaluationAction
  | NewEvaluationAction;
