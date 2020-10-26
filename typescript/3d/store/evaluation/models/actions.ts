export const SELECT_EVALUATION = 'SELECT_EVALUATION';
export const CHANGE_EVALUATION = 'CHANGE_EVALUATION';
export const POST_EVALUATION = 'POST_EVALUATION';
export const NEW_EVALUATION = 'NEW_EVALUATION';

interface SelectEvaluationAction {
  type: typeof SELECT_EVALUATION;
  evaluationResponse: Shared.QuestionResponseOption;
}

interface ChangeEvaluationAction {
  type: typeof CHANGE_EVALUATION;
  evaluationResponse: Shared.QuestionResponseOption;
}

interface PostEvaluationAction {
  type: typeof POST_EVALUATION;
}

interface NewEvaluationAction {
  type: typeof NEW_EVALUATION;
}

export type EvaluationActionTypes =
  | SelectEvaluationAction
  | ChangeEvaluationAction
  | PostEvaluationAction
  | NewEvaluationAction;
