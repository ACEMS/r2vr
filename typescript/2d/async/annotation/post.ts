import { setMarkerColor } from '../../user-interface/marker-color';

import { AnnotationData } from '../../models/AnnotationData';
import { CoralBinary } from '../../models/CoralBinary';

const postAnnotation = async (data: AnnotationData) => {
  try {
    const response = await fetch(
      'https://r2vr.herokuapp.com/annotated-image/post-response',
      {
        method: 'POST',
        body: JSON.stringify(data),
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
    if (![200, 201].includes(response.status)) {
      throw new Error('Unable to post annotation!');
    }

    setMarkerColor(data.site, <CoralBinary>data.is_coral);

    console.log('Request complete! response:', response, response.status);
  } catch (err) {
    throw new Error(`${err} - Unable to post annotation!`);
  }
};

export default postAnnotation;
