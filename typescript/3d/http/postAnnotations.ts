import { store } from '../store/rootStore';

// import { URL } from '@shared/http/url'; // TODO dotenv?
// const url = 'http://localhost:3000/api';
const url = 'https://r2vr.herokuapp.com/api';

const postAnnotation = async (annotation: Api.Annotation) => {
  const metaData = store.getState().metaDataReducer;
  const { module, annotationType } = metaData;
  try {
    const response = await fetch(`${url}/${module}/${annotationType}`, {
      method: 'POST',
      body: JSON.stringify(annotation),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (![200, 201].includes(response.status)) {
      throw new Error('Unable to post annotations!');
    }
    // TODO: reset markers UI to white ? Check if done in R
    console.log(response.status, '- Request complete! response:', response);
  } catch (err) {
    throw new Error(`${err} - Unable to post annotation!`);
  }
};

const postAnnotations = () => {
  const state = store.getState();
  const { annotationReducer, userReducer } = state;
  const imageAnnotations = annotationReducer[annotationReducer.length - 1];
  const { fullName, name, extension } = imageAnnotations.image;
  const allImageAnnotations = imageAnnotations.markers;
  const user = userReducer.name;

  const uuid = user + '-' + new Date().toISOString();

  allImageAnnotations.forEach((marker) => {
    const { id, isCoral, x, y, z } = marker;
    const annotation: Api.Annotation = {
      image_file_name: fullName,
      image_file_id: name,
      image_file_extension: extension,
      site: id,
      x,
      y,
      z,
      is_coral: isCoral,
      observer: user,
      observation_id: uuid,
    };
    postAnnotation(annotation);
  });
};

export default postAnnotations;
