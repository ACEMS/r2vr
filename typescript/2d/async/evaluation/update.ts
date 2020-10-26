// const updateEvaluation = async (
//   data: any
// ) => {
//   const annotatedMarker = document.getElementById(
//     `markerCircumference${data.site}`
//   );

//   try {
//     const markerIdPromise = await fetch(
//       'https://r2vr.herokuapp.com/annotated-image/find-marker-id',
//       {
//         method: 'POST',
//         body: JSON.stringify(data),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       }
//     );
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
//       'https://r2vr.herokuapp.com/annotated-image/update-response',
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
//     console.log('updatedResponse:', updatedResponse);
//   } catch (err) {
//     throw new Error(`${err} - Unable to update annotation`);
//   }
// };
