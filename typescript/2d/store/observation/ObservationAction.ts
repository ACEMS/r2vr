import { Dispatch } from 'redux';

import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import {
  FETCH_LAST_OBSERVATION_NUMBER_PENDING,
  FETCH_LAST_OBSERVATION_NUMBER_FULFILLED,
  FETCH_LAST_OBSERVATION_NUMBER_REJECTED,
  INCREMENT_OBSERVATION_NUMBER,
} from './models/actions';

import { ObservationNumber } from './models/ObservationNumber';

const requestLastObservationNumber = (): AppActions => {
  return {
    type: FETCH_LAST_OBSERVATION_NUMBER_PENDING,
    observation_number: { observation_number: 0 },
  };
};
const returnLastObservationNumber = (json: ObservationNumber): AppActions => {
  return {
    type: FETCH_LAST_OBSERVATION_NUMBER_FULFILLED,
    observation_number: { ...json },
  };
};

const errorLastObservationNumber = (): AppActions => {
  return {
    type: FETCH_LAST_OBSERVATION_NUMBER_REJECTED,
    observation_number: { observation_number: -1 },
  };
};

const incrementObservationNumber = (): AppActions => {
  return {
    type: INCREMENT_OBSERVATION_NUMBER,
  };
};

export function fetchLastObservationNumber() {
  return (dispatch: Dispatch) => {
    dispatch(requestLastObservationNumber());

    let hasErrored = false;

    return fetch(
      'https://r2vr.herokuapp.com/annotated-image/last-observation-number'
    )
      .then(
        (response) => response.json(),
        (error) => {
          hasErrored = true;
          console.log(error);
          dispatch(errorLastObservationNumber());
        }
      )
      .then((json) => {
        if (!hasErrored) {
          dispatch(returnLastObservationNumber(json));
        }
      });
  };
}

export const boundFetchLastObservationNumber = () =>
  store.dispatch(fetchLastObservationNumber());

export const boundIncrementObservationNumber = () =>
  store.dispatch(incrementObservationNumber());
