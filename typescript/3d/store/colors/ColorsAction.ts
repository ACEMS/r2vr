import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { GET_COLORS } from './models/actions';

const getCustomColors = (customColors: Shared.CustomColors): AppActions => {
  return {
    type: GET_COLORS,
    customColors,
  };
};

const boundGetCustomColors = (customColors: Shared.CustomColors) =>
  store.dispatch(getCustomColors(customColors));

export default boundGetCustomColors;
