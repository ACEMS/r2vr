import { ImageActionTypes } from './models/actions';

const defaultState: string = '';

export const imageReducer = (
  state = defaultState,
  action: ImageActionTypes
): string => {
  switch (action.type) {
    case 'GET_IMAGE':
      const nextImageName = action.imageName;
      return nextImageName;

    default:
      return state;
  }
};
