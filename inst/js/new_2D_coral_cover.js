// Determines the hover state of the marker of interest
let isMarkerHovered = false;

// Determines if the coral option is selected
let isCoralSelected = false;

// Determines if the not coral option is selected
let isNotCoralSelected = false;

// els: array of intersected entities => initialize to an empty array
let els = [];

// Choose colors of menu options
const CORAL_COLOR = '#FF95BC';
const NOT_CORAL_COLOR = '#969696';

// Assign a global variable for the id for the selected marker so it is in scope for the AFRAME registered component
let selectedMarkerId;

// Assign a global variable for the user
let user;

// Assign a global variable for the initial image
let initialImage;

// TODO: consider declaring multiple variables
let lastObservationNumber;

// TODO: comment
let allImages;

// TODO comment
let hasLastObservationNumberBeenRetrieved = false;

// Get the user name entered in R once DOM loaded
document.addEventListener('DOMContentLoaded', () => {
  // Retrieve the last recorded observation number
  setLastObservationNumber();

  user = document.getElementById('user').className;
  initialImage = getImageFilenameAndId();
  // TODO: comment
  allImages = [
    {
      imgId: initialImage.imageId,
      isAnnotated: false,
    },
  ];
});

// WebVR button handler: 2D coral cover
AFRAME.registerComponent('coral-cover-2d-buttons', {
  init: function () {
    // Select DOM element with button controls i.e. the scene
    let controlsEl = document.querySelector('[button-controls]');

    // Add event listener to the scene to detect buttons clicked in WebVR
    controlsEl.addEventListener('buttondown', () => {
      // If button clicked and marker hovered => display menu options
      if (isMarkerHovered) {
        // Marker is hovered thus must have a corresponding ID
        displayMenuOptions(selectedMarkerId, true);
      } else {
        // If button clicked but not hovering a marker => intersected elements not a marker thus not of interest hence and empty array is set
        els = [];
      }
    });
  },
});

// Handles an intersected annotation point
AFRAME.registerComponent('intersection', {
  init: function () {
    // Listen for an intersection between the ray-caster and entities
    this.el.addEventListener('raycaster-intersection', (e) => {
      if (e) {
        // In the event an intersection occurs => set the array of intersection elements
        els = e.detail.els;

        // TODO: Check comment
        // Expecting: `#markerCircumference${x}` and/or `#marker${x}`
        // TODO: Check for points near each other => make points unable to overlap
        if (els.length > 2) {
          return (els = []);
        }
        // Determine if the marker is intersected iff expected result occurred
        handleMarkerIntersection();
      }
    });
  },
});

// Determines if the marker is hovered
handleMarkerIntersection = () => {
  // Prevents annotation points being marked if missing data
  if (!lastObservationNumber) {
    return;
  }

  // Get the marker ID number for the intersected marker
  let markerId = getMarkerId();

  console.log('Last intersected element ID', els[0].id); // rm

  els[0].id.replace(els[0].id, markerId);

  // // Check if intersected element is the marker itself or a menu option
  if (
    els.some(
      (el) =>
        el.id === `marker${markerId}` ||
        el.id === `markerCircumference${markerId}` ||
        el.id === `menuCoral${markerId}` ||
        el.id === `menuNotCoral${markerId}` ||
        el.id === `coralText${markerId}` ||
        el.id === `notCoralText${markerId}`
    )
  ) {
    // Note: Menu options made visible in 'coral-cover-2d-buttons' custom AFRAME component => requires a button to be pressed to show options
    isMarkerHovered = true;

    // Determine if the the coral option is selected
    isCoralIntersected();

    // Determine if the not coral option is selected
    isNotCoralIntersected();
  } else {
    // Marker no longer hovered
    isMarkerHovered = false;

    // Menu options no longer need to be visible
    displayMenuOptions(markerId);
  }
};

isCoralIntersected = () => {
  // Get the marker id number for the selected marker
  let markerId = getMarkerId();

  // Set the global selected marker ID
  selectedMarkerId = markerId;

  // If an intersected entity is the coral menu
  if (
    els.some(
      (el) =>
        el.id === `menuCoral${markerId}` || el.id === `coralText${markerId}`
    )
  ) {
    // Save annotation to database: isCoral = 1 (coral)
    saveData(markerId, 1);

    // Update UI color to indicate coral is selected
    // document
    //   .getElementById(`markerCircumference${markerId}`)
    //   .setAttribute('color', CORAL_COLOR);

    // Hide menu options
    displayMenuOptions(markerId);
  }
};

// TODO: potentially not set color until after HTTP request completes
isNotCoralIntersected = () => {
  // Get the marker id number for the selected marker

  let markerId = getMarkerId();

  // If an intersected entity is the not coral menu
  if (
    els.some(
      (el) =>
        el.id === `menuNotCoral${markerId}` ||
        el.id === `notCoralText${markerId}`
    )
  ) {
    // Save annotation to database: isNotCoral = 0 (not coral)
    saveData(markerId, 0);

    // Update UI color to indicate not coral is selected
    // document
    //   .getElementById(`markerCircumference${markerId}`)
    //   .setAttribute('color', NOT_CORAL_COLOR);

    // Hide menu options
    displayMenuOptions(markerId);
  }
};

displayMenuOptions = (id, bool = false) => {
  if (bool) {
    // Menu options are now visible
    document.getElementById(`menuCoral${id}`).setAttribute('visible', true);
    document.getElementById(`menuNotCoral${id}`).setAttribute('visible', true);
  } else {
    // Marker no longer hovered
    isMarkerHovered = false;

    // Menu options no longer need to be visible
    document.getElementById(`menuCoral${id}`).setAttribute('visible', false);
    document.getElementById(`menuNotCoral${id}`).setAttribute('visible', false);
  }
};

// Set the image filename for the image being annotated
getImageFilenameAndId = () => {
  // Get the canvas that images will be rendered on
  const canvas2D = document.getElementById('canvas2d');

  // The image filename is found through its class
  // Note: the class will be updated when the next image is called
  let imageFilename = canvas2D.getAttribute('class').split('/').pop();

  // TODO?: set image_file and image_id globally

  // The image ID can be found by removing the file extension
  let imageId = imageFilename.split('.')[0];

  // return both the imageFilename and the image ID
  // Note: same as { imageFilename: imageFilename, ... }
  return {
    imageFilename,
    imageId,
  };
};

getMarkerId = () => {
  // Extract the ID number of the element selected iff menu option is intersected

  // els[0].id exists since all entities that relate to being a marker also have a corresponding ID  associated with it

  // Regular Expression captures the digits associated with the ID
  let matches = els[0].id.match(/(\d+)/);

  // Parse the string to a number so the corresponding ID can be used
  return +matches[0];
};

// // //

// increment observation number if new image

// TODO: consider breaking into set data and save data
saveData = (markerId, coralBinary) => {
  // Set the image ID
  let img = getImageFilenameAndId();
  let imgFilename = img.imageFilename;
  let imgId = img.imageId;

  let lastAnnotatedImage = allImages[allImages.length - 1];
  console.log('last annotated image: ', lastAnnotatedImage); // rm
  let lastImage = lastAnnotatedImage.imgId;

  // let isLastImageAnnotated = lastAnnotatedImage.isAnnotated; // TODO

  if (lastImage !== imgId) {
    // the last image has thus been annotated
    allImages[allImages.length - 1].isAnnotated = true;

    // increment the last observation number
    lastObservationNumber++;

    // if the annotated image is not the same as new image
    // add it to the array => this image is not yet annotated
    allImages.push({
      imgId: imgId,
      isAnnotated: false,
    });
    console.log('allImages: ', allImages);
  }

  let marker = document.getElementById(`markerContainer${markerId}`);

  let data;

  if (marker.getAttribute('marked') === 'false') {
    let markerX = marker.getAttribute('position').x;
    let markerY = marker.getAttribute('position').y;
    console.log(markerX, markerY);

    console.log('not marked');
    marker.setAttribute('marked', true);

    // set data
    data = {
      image_id: imgId,
      image_file: imgFilename,
      site: +markerId,
      x: markerX,
      y: markerY,
      observation_number: lastObservationNumber + 1, // TODO CHECK
      observer: user,
      is_coral: coralBinary,
    };
    console.log('data: ', data);

    postAnnotation(data);
  } else {
    console.log('is marked');
    // If annotation exists (is-marked) new url and data for PUT end point
    // set data

    data = {
      image_id: imgId,
      observation_number: lastObservationNumber + 1,
      site: +markerId,
    };
    console.log('data: ', data);
    updateAnnotation(data, coralBinary); // TODO: look into incl. in data
  }
};

// TODO: consider refactoring to async await
setLastObservationNumber = () => {
  // GET latest record observation number
  fetch('https://r2vr.herokuapp.com/annotated-image/last-observation-number', {
    method: 'GET',
    headers: {
      Accept: 'application/json',
    },
  })
    .then((res) => {
      if (res.status !== 200) {
        throw new Error('Unable to retrieve last observation number!');
      }
      res.json().then((res) => {
        lastObservationNumber = res.observation_number;
      });
    })
    .catch((err) => {
      throw new Error(`${err} - Unable to retrieve last observation number!`);
    });
};

postAnnotation = async (data) => {
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

    setMarkerColor(data.site, data.is_coral);

    console.log('Request complete! response:', response, response.status);
  } catch (err) {
    throw new Error(`${err} - Unable to post annotation!`);
  }
};

updateAnnotation = async (data, coralBinary) => {
  let annotatedMarker = document.getElementById(
    `markerCircumference${data.site}`
  );

  if (
    annotatedMarker.getAttribute('color') === CORAL_COLOR &&
    coralBinary === 1
  ) {
    console.log('Coral is already selected!');
    return;
  }
  if (
    annotatedMarker.getAttribute('color') === NOT_CORAL_COLOR &&
    coralBinary === 0
  ) {
    console.log('Not coral is already selected!');
    return;
  }

  try {
    let markerId = await fetch(
      'https://r2vr.herokuapp.com/annotated-image/find-marker-id',
      {
        method: 'POST',
        body: JSON.stringify(data),
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
    // Note: 201 not included as no resource created from this POST
    if (![200].includes(markerId.status)) {
      throw new Error('Unable to find the ID of the corresponding marker!');
    }

    markerId = await markerId.json();
    markerId = markerId.id;

    updateData = {
      is_coral: coralBinary,
      id: markerId,
    };

    let updatedResponse = await fetch(
      'https://r2vr.herokuapp.com/annotated-image/update-response',
      {
        method: 'PUT',
        body: JSON.stringify(updateData),
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
    if (![200].includes(updatedResponse.status)) {
      throw new Error('Unable to update annotation!');
    }
    setMarkerColor(data.site, updateData.is_coral);
    console.log('updatedResponse:', updatedResponse);
  } catch (err) {
    throw new Error(`${err} - Unable to update annotation`);
  }
};

setMarkerColor = (marker, coralBinary) => {
  // Select corresponding Marker Circumference from DOM
  let markerCircumference = document.getElementById(
    `markerCircumference${marker}`
  );
  // Set appropriate color
  coralBinary === 1
    ? markerCircumference.setAttribute('color', CORAL_COLOR)
    : markerCircumference.setAttribute('color', NOT_CORAL_COLOR);
};
