import { Image } from './Image';

export const GET_IMAGE = 'GET_IMAGE';

interface ImageAction {
  type: typeof GET_IMAGE;
  image: Image;
}

export type ImageActionTypes = ImageAction;
