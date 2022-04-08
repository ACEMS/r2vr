import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { GET_IMAGE } from './models/actions';
import { Image } from './models/Image';

const getImage = (image: Image): AppActions => {
  return {
    type: GET_IMAGE,
    image,
  };
};

const boundGetImage = (image: Image) => store.dispatch(getImage(image));

export default boundGetImage;
