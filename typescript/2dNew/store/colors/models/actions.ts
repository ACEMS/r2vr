export const GET_COLORS = 'GET_COLORS';

interface CustomColorsAction {
  type: typeof GET_COLORS;
  customColors: Shared.CustomColors;
}

export type CustomColorsActionTypes = CustomColorsAction;
