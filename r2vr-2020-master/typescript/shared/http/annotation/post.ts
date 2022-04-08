// NOTE: DEPRECATED: shared post.ts/update.ts is for 2D as of 22/9/2020

// import { URL } from '@shared/http/url';

// import { setMarkerColor } from '@shared/user-interface/marker-color';

// const postAnnotation = async (data: Shared.AnnotationData) => {
//   try {
//     const response = await fetch(`${URL}/3d`, {
//       method: 'POST',
//       body: JSON.stringify(data),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     });
//     if (![200, 201].includes(response.status)) {
//       throw new Error('Unable to post annotation!');
//     }

//     setMarkerColor(data.site, <Shared.CoralBinary>data.is_coral);

//     console.log('Request complete! response:', response, response.status);
//   } catch (err) {
//     throw new Error(`${err} - Unable to post annotation!`);
//   }
// };

// export default postAnnotation;
