import { EvaluationActionTypes } from './models/actions';
import {
  EvaluationResponse,
  QuestionResponse,
} from './models/EvaluationResponse';

const defaultState: EvaluationResponse = {
  lastHoveredOption: 0,
  questionNumber: 1,
  evaluations: [],
};

// eslint-disable-next-line import/prefer-default-export
export const evaluationReducer = (
  state = defaultState,
  action: EvaluationActionTypes
): EvaluationResponse => {
  const evaluationArrayLength = state.evaluations?.length || 0;
  switch (action.type) {
    case 'EVALUATION':
      const nextState = { ...state };
      nextState.lastHoveredOption = action.res.lastHoveredOption;
      return nextState;

    case 'POST_EVALUATION':
      const postState = { ...state } as EvaluationResponse;
      postState.evaluations?.push(action.questionResponse);
      return postState;

    case 'UPDATE_EVALUATION':
      const updateState = { ...state } as EvaluationResponse;
      // Update should only be called if response already posted
      const latestEvaluations = updateState.evaluations!;
      latestEvaluations[evaluationArrayLength - 1] = action.questionResponse;

      return updateState;

    case 'NEW_EVALUATION':
      const newState = { ...state } as EvaluationResponse;
      newState.questionNumber!++;

      return newState;

    default:
      return state;
  }
};
