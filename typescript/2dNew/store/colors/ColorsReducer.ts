import { CustomColorsActionTypes } from './models/actions';

const defaultState: Shared.CustomColors = {
  coral: '#FF95BC',
  notCoral: '#B8B27B',
  plane: '#FFFFFF',
  correct: '#00FF00',
  incorrect: '#FF0000',
  evaluationSelection: '#00FF00',
};

export const colorsReducer = (
  state = defaultState,
  action: CustomColorsActionTypes
): Shared.CustomColors => {
  switch (action.type) {
    case 'GET_COLORS':
      return { ...action.customColors };

    default:
      return state;
  }
};
