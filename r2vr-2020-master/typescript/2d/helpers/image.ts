import { Image } from '../store/image/models/Image';

const getImage = (): Image => {
  const canvas2D = document.getElementById('canvas2d')!;
  // The image filename is found through its class
  // Note: the class will be updated when the next image is called via the R console through a websocket connection between R2VR and the browser

  const imgFilename = <string>canvas2D.getAttribute('class')!.split('/').pop();

  // The image ID can be found by removing the file extension
  const imgStringId = imgFilename!.split('.')[0];

  const img: Image = {
    filename: imgFilename,
    stringId: imgStringId,
    isAnnotated: false,
  };

  return img;
};

export default getImage;
