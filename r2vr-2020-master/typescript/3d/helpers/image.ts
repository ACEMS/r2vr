import { store } from '../store/rootStore';
import { boundPushNewImage } from '../store/annotation/AnnotationAction';
import boundGetImage from '../store/image/ImageAction';

import postAnnotations from '../http/postAnnotations';

export const getImage = (): Shared.ImageFile => {
  const canvas = document.getElementById('canvas')!;
  // The image filename is found through its class
  // Note: the class will be updated when the next image is called via the R console through a websocket connection between R2VR and the browser
  const fullName = canvas.getAttribute('class')!.split('/').pop() as string;
  const nameAndExtension = fullName.split('.');
  const [name, extension] = nameAndExtension;

  const state = store.getState();
  const { annotationReducer } = state;
  const currentImageNumber = annotationReducer.length;

  const imageFile: Shared.ImageFile = {
    fullName,
    name,
    extension,
    isAnnotated: false,
    uniqueNumberId: currentImageNumber,
  };
  return imageFile;
};

export const imageObserver = () => {
  // Push initial image to annotated images state
  const annotatedImages: Array<string> = [];
  const initialImage: Shared.ImageFile = getImage();
  const initialImageName = initialImage.name;
  let initialImageReselectionCount = 0;
  annotatedImages.push(initialImageName);
  boundGetImage(initialImageName);
  // Detect image src changes and push to state
  const mutationObserver = new MutationObserver(() => {
    const newImage: Shared.ImageFile = getImage();
    const newImageName = newImage.name;
    boundGetImage(newImageName);
    // Determine if the initial image is re-selected
    let isInitialImageReselected = newImageName === initialImageName;
    // Indicate the first occurrence of the initial image being selected
    if (isInitialImageReselected) {
      initialImageReselectionCount++;
    }
    // Only post the first time the initial image is re-selected=> e.g. check(1)
    const postLastImage =
      isInitialImageReselected && initialImageReselectionCount === 1;
    // Post annotated image
    if (!annotatedImages.includes(newImageName) && !postLastImage) {
      postAnnotations();
      annotatedImages.push(newImageName);
      boundPushNewImage(newImage);
    } else if (postLastImage) {
      postAnnotations();
    }
  });

  mutationObserver.observe(document.getElementById('canvas')!, {
    attributes: true,
    attributeFilter: ['src'],
  });
};
