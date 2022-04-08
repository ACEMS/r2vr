import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { GET_IMAGE } from './models/actions';

const getImage = (image: string): AppActions => {
  return {
    type: GET_IMAGE,
    imageName: image,
  };
};

const boundGetImage = (image: string) => store.dispatch(getImage(image));

export default boundGetImage;
