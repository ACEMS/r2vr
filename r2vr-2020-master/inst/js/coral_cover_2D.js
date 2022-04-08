document.addEventListener('DOMContentLoaded', e => {
  // Init for GET request
  let last_observation_number;
  // Init for DELETE request
  // seperate variables to avoid incrementation errors
  let last_observation_number_for_delete;

  // Get image file and image id
  const canvas_2d = document.getElementById('canvas2d');
  image_file = canvas_2d
    .getAttribute('class')
    .split('/')
    .pop();
  image_id = image_file.split('.')[0];

  // Select all markers (invisible circle within ring)
  const markers = document.querySelectorAll('.marker');
  // Select name from invisible entity
  const user = document.getElementById('user').className;
  // Choose colors
  coralColor = '#FF95BC';
  notCoralColor = '#969696';

  // Get DOM label to update with latest value from DB
  const difficultyCircle = document.getElementById('resetPage');
  const difficultyLabel = document.getElementById('difficultyLabel');

  // getDifficulty(difficultyCircle, difficultyLabel);
  imageDifficultyExists(image_id, difficultyCircle, difficultyLabel);

  // Update UI to image new image difficulty
  document.getElementById('resetPage').addEventListener('click', () => {
    // GET image difficulty
    imageDifficultyExists(image_id, difficultyCircle, difficultyLabel);
  });

  // Refresh button - annotate again
  const reset = document.getElementById('reset');
  reset.addEventListener('click', () => {
    window.location.reload();
  });

  // Checks if marker has color i.e. not white
  isMarkerAnnotated = bool => {
    return bool !== '#ffffff';
  };

  // GET latest record observation number
  fetch('http://localhost:3000/last-observation-number', {
    method: 'GET',
    headers: {
      Accept: 'application/json'
    }
  })
    .then(res => {
      res.json().then(res => {
        last_observation_number = res[0].observation_number;
        initMarkers();
      });
    })
    .catch(err => {
      console.log(err);
    });

  function initMarkers() {
    // Init every marker with its own event listeners
    markers.forEach(marker => {
      // Get ID number of marker
      const markerId = marker.id.replace('marker', '');
      // Select menu options based on the marker ID
      const markerMenuCoral = document.querySelector(`#menuCoral${markerId}`);
      const markerMenuNotCoral = document.querySelector(
        `#menuNotCoral${markerId}`
      );
      // Set ID for the markers' ring circumference (ring)
      marker.previousElementSibling.setAttribute(
        'id',
        `markerContainer${markerId}`
      );

      // Check if posted i.e. marker already annotated
      let isPosted = false;

      // Fire function if deselect markers button called
      document
        .getElementById('deselectMarkers')
        .addEventListener('click', () => {
          // Set isPosted back to false
          isPosted = false;

          // Determine color of all markers and deselect
          let allMarkers = document.querySelectorAll('.marker');
          let allMarkerColors = [];

          allMarkers.forEach(marker => {
            allMarkerColors.push(
              marker.previousElementSibling.getAttribute('color')
            );
            marker.previousElementSibling.setAttribute('color', '#ffffff');
          });
          // Check if any marker has been annotated
          if (allMarkerColors.some(isMarkerAnnotated)) {
            // TODO: Consider refactoring GET request
            // GET latest record observation number
            fetch('http://localhost:3000/last-observation-number', {
              method: 'GET',
              headers: {
                Accept: 'application/json'
              }
            })
              .then(res => {
                res.json().then(res => {
                  last_observation_number_for_delete =
                    res[0].observation_number;
                  // DELETE markers from db for last observation number
                  fetch(
                    `http://localhost:3000/annotated-image/${last_observation_number_for_delete}`,
                    {
                      method: 'DELETE',
                      headers: {
                        'Content-Type': 'application/json'
                      }
                    }
                  )
                    .then(res => {
                      console.log('Request complete! response:', res);
                    })
                    .catch(err => {
                      console.log(err);
                    });
                });
              })
              .catch(err => {
                console.log(err);
              });
          }
        });

      // Marker Event Listener mousedown
      marker.addEventListener('mousedown', () => {
        let markerX = marker.getAttribute('position').x;
        let markerY = marker.getAttribute('position').y;
        markerMenuCoral.setAttribute('visible', true);
        markerMenuNotCoral.setAttribute('visible', true);

        // Only fire event listener for options if new selection
        isAnnotated = false;
        coralSelected = false;
        notCoralSelected = false;

        saveData = coralBinary => {
          let data = {
            image_id: image_id,
            image_file: image_file,
            site: +markerId,
            x: markerX,
            y: markerY,
            observation_number: last_observation_number + 1,
            observer: user,
            is_coral: coralBinary
          };
          // PUT data: If marker already annotated and coral selected
          let dataForMarkerId = {
            image_id: image_id,
            observation_number: last_observation_number + 1,
            site: +markerId
          };
          // POST data: If not annotated then coral selected
          // PUT if marker already annotated else POST
          if (isPosted && (coralSelected || notCoralSelected)) {
            console.log('PUT');
            // If annotation exists, get its ID
            fetch('http://localhost:3000/get-marker-id', {
              method: 'POST',
              body: JSON.stringify(dataForMarkerId),
              headers: {
                'Content-Type': 'application/json'
              }
            })
              .then(res => {
                res.json().then(res => {
                  let updateMarker = {
                    is_coral: coralBinary,
                    id: res[0].id
                  };
                  // Update annotation with ID so marker is coral
                  fetch('http://localhost:3000/update-annotation', {
                    method: 'PUT',
                    body: JSON.stringify(updateMarker),
                    headers: {
                      'Content-Type': 'application/json'
                    }
                  })
                    .then(res => {
                      console.log('Updated annotation', res);
                    })
                    .catch(err => {
                      console.log(err);
                    });
                });
              })
              .catch(err => {
                console.log(err);
              });
          } else {
            isPosted = true;
            console.log('POST');
            fetch('http://localhost:3000/gs', {
              method: 'POST',
              body: JSON.stringify(data),
              headers: {
                'Content-Type': 'application/json'
              }
            })
              .then(res => {
                console.log('Request complete! response:', res);
              })
              .catch(err => {
                console.log(err);
              });
          }
        };
        // Coral option selected event listener
        markerMenuCoral.addEventListener('mouseenter', () => {
          if (!isAnnotated || !coralSelected) {
            // Set boolean flags
            isAnnotated = true;
            coralSelected = true;
            notCoralSelected = false;
            // Annotate marker container (ring) with apt colour
            marker.previousElementSibling.setAttribute('color', coralColor);
            // Save annotation to database: isCoral = 1 (coral)
            saveData(1);
          }
        });
        // Not coral option selected event listener
        markerMenuNotCoral.addEventListener('mouseenter', () => {
          if (!isAnnotated || !notCoralSelected) {
            // Set boolean flags
            isAnnotated = true;
            coralSelected = false;
            notCoralSelected = true;
            // Annotate marker container (ring) with apt colour
            marker.previousElementSibling.setAttribute('color', notCoralColor);
            // Save annotation to database: isCoral = 0 (coral)
            saveData(0);
          }
        });
      });
      // Marker Event Listener mouseup
      marker.addEventListener('mouseup', () => {
        markerMenuCoral.setAttribute('visible', false);
        markerMenuNotCoral.setAttribute('visible', false);
      });
    });
  }
});

getDifficulty = (difficultyCircle, difficultyLabel) => {
  fetch(`http://localhost:3000/image-difficulty/${image_id}`, {
    method: 'GET',
    headers: {
      Accept: 'application/json'
    }
  })
    .then(res => {
      res.json().then(res => {
        if (res[0].is_easy === 1) {
          console.log('easy');
          difficultyCircle.setAttribute('color', '#22BB33');
          difficultyLabel.setAttribute('value', 'Difficulty to classify: easy');
        } else if (res[0].is_moderate === 1) {
          console.log('moderate');
          difficultyCircle.setAttribute('color', '#FFA500');
          difficultyLabel.setAttribute(
            'value',
            'Difficulty to classify: moderate'
          );
        } else {
          console.log('hard');
          difficultyCircle.setAttribute('color', '#BB2124');
          difficultyLabel.setAttribute('value', 'Difficulty to classify: hard');
        }
      });
    })
    .catch(err => {
      console.log(err);
    });
};

imageDifficultyExists = (imageId, difficultyCircle, difficultyLabel) => {
  fetch(`http://localhost:3000/image-difficulty`, {
    method: 'GET',
    headers: {
      Accept: 'application/json'
    }
  })
    .then(res => {
      res.json().then(res => {
        let isImageAnnotated = [];
        res.forEach(image => {
          isImageAnnotated.push(image.image_id === +imageId);
        });
        checkAnnotation = bool => {
          return bool === true;
        };
        if (isImageAnnotated.some(checkAnnotation)) {
          this.getDifficulty(difficultyCircle, difficultyLabel);
        }
      });
    })
    .catch(err => {
      console.log(err);
    });
};
