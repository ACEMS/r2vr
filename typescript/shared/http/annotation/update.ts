// NOTE: DEPRECATED

// import { URL } from '@shared/http/url';

// import {
//   setMarkerColor
// } from '@shared/user-interface/marker-color';

// const updateAnnotation = async (
//   data: Shared.AnnotationData,
//   coralBinary: Shared.CoralBinary
// ) => {
//   const annotatedMarker = document.getElementById(
//     `markerCircumference${data.site}`
//   );

//   if (
//     annotatedMarker?.getAttribute('color') === coral &&
//     coralBinary === 1
//   ) {
//     console.log('Coral is already selected!');
//     return;
//   }
//   if (
//     annotatedMarker?.getAttribute('color') === notCoral &&
//     coralBinary === 0
//   ) {
//     console.log('Not coral is already selected!');
//     return;
//   }

//   try {
//     const markerIdPromise = await fetch(`${URL}/3d/find-marker-id`, {
//       method: 'POST',
//       body: JSON.stringify(data),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     });
//     // Note: 201 not included as no resource created from this POST
//     if (![200].includes(markerIdPromise.status)) {
//       throw new Error('Unable to find the ID of the corresponding marker!');
//     }

//     const markerIdJSONPromise = await markerIdPromise.json();

//     const markerId = markerIdJSONPromise.id;

//     const updateData = {
//       is_coral: coralBinary,
//       id: markerId,
//     };

//     const updatedResponse = await fetch(
//       `${URL}/3d/update`,

//       {
//         method: 'PUT',
//         body: JSON.stringify(updateData),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       }
//     );
//     if (![200].includes(updatedResponse.status)) {
//       throw new Error('Unable to update annotation!');
//     }
//     setMarkerColor(data.site, updateData.is_coral);
//     console.log('updatedResponse:', updatedResponse);
//   } catch (err) {
//     throw new Error(`${err} - Unable to update annotation`);
//   }
// };

// export default updateAnnotation;
