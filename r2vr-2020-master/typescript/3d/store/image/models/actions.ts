export const GET_IMAGE = 'GET_IMAGE';

interface ImageAction {
  type: typeof GET_IMAGE;
  imageName: string;
}

export type ImageActionTypes = ImageAction;
