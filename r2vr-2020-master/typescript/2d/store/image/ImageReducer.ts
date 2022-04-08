import { ImageActionTypes } from './models/actions';
import { Image } from './models/Image';

const defaultState: Image = { filename: '', stringId: '', isAnnotated: false };

// eslint-disable-next-line import/prefer-default-export
export const imageReducer = (
  state = defaultState,
  action: ImageActionTypes
): Image => {
  switch (action.type) {
    case 'GET_IMAGE':
      return { ...action.image };

    default:
      return state;
  }
};
