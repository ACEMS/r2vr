import { EvaluationActionTypes } from './models/actions';

const defaultState: Shared.EvaluationResponse = {
  isCurrentOptionSelected: false,
  isCurrentOptionSubmitted: false,
  evaluations: [],
};

export const evaluationReducer = (
  state = defaultState,
  action: EvaluationActionTypes
): Shared.EvaluationResponse => {
  let evaluationNumber = state.evaluations.length;
  switch (action.type) {
    case 'SELECT_EVALUATION':
      evaluationNumber++;
      const nextState = { ...state };
      const evaluationResponse = action.evaluationResponse;
      const selectedEvaluation: Shared.QuestionResponse = {
        questionNumber: evaluationNumber,
        selectedOption: evaluationResponse,
      };
      nextState.isCurrentOptionSelected = true;
      nextState.isCurrentOptionSubmitted = false;
      nextState.evaluations.push(selectedEvaluation);
      return nextState;

    case 'CHANGE_EVALUATION':
      const updateState = { ...state }; // as Shared.EvaluationResponse;
      const changedResponse = action.evaluationResponse;
      const changedEvaluation: Shared.QuestionResponse = {
        questionNumber: evaluationNumber,
        selectedOption: changedResponse,
      };
      updateState.evaluations[evaluationNumber - 1] = changedEvaluation;
      return updateState;

    case 'POST_EVALUATION':
      const postState = { ...state };
      postState.isCurrentOptionSubmitted = true;
      return postState;

    case 'NEW_EVALUATION':
      const newState = { ...state };
      newState.isCurrentOptionSelected = false;
      newState.isCurrentOptionSubmitted = false;
      return newState;

    default:
      return state;
  }
};
