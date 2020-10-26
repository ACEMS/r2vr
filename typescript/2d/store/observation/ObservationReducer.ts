import { ObservationActionTypes } from './models/actions';
import { ObservationNumber } from './models/ObservationNumber';

const defaultState: ObservationNumber = { observation_number: 0 };

// eslint-disable-next-line import/prefer-default-export
export const observationReducer = (
  state = defaultState,
  action: ObservationActionTypes
): ObservationNumber => {
  const nextState = {
    observation_number: state.observation_number,
  };
  switch (action.type) {
    case 'FETCH_LAST_OBSERVATION_NUMBER_PENDING':
      return { ...state };

    case 'FETCH_LAST_OBSERVATION_NUMBER_FULFILLED':
      return { ...action.observation_number };

    case 'FETCH_LAST_OBSERVATION_NUMBER_REJECTED':
      return { ...action.observation_number };

    case 'INCREMENT_OBSERVATION_NUMBER':
      nextState.observation_number = state.observation_number + 1;
      return nextState;

    default:
      return state;
  }
};
