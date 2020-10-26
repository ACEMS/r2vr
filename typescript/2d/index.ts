import { Scene, Entity } from 'aframe';

import { store } from './store/rootStore';

import {
  boundFetchLastObservationNumber,
  boundIncrementObservationNumber,
} from './store/observation/ObservationAction';
import { boundPushNewImage } from './store/annotation/AnnotationAction';
import boundGetImage from './store/image/ImageAction';
import boundGetUser from './store/user/UserAction';
import boundIntersection from './store/intersection/IntersectionAction';
import boundMarkerIntersection from './store/marker/MarkerAction';
import {
  boundPostEvaluation,
  boundUpdateEvaluation,
  boundNewEvaluation,
} from './store/evaluation/EvaluationAction';

import { Annotation, Marker } from './store/annotation/models/Annotation';
import { Image } from './store/image/models/Image';
import { User } from './store/user/models/User';

import getImage from './helpers/image';

import displayMenuOptions from './user-interface/menu-options';
import handleMarkerIntersection from './intersections/marker';
import handleEvaluationIntersection from './intersections/evaluation';
import {
  setOptionColor,
  resetOptionsColor,
} from './user-interface/evaluation-option-color';
import { QuestionResponseOption } from './store/evaluation/models/EvaluationResponse';
import saveEvaluation from './helpers/evaluation/save';

// Observe canvas for image changes
document.addEventListener('DOMContentLoaded', () => {
  console.log('index2d.ts');
  // TODO: consider refactoring to image reducer
  const imageIds: Pick<Annotation, 'imageId'>[] = [];
  const name = document.getElementById('user')!.className;
  const user = {
    name,
  };
  boundGetUser(user);
  const initialImage: Image = getImage();
  boundGetImage(initialImage);
  // TODO: push initial image to array in Annotation
  const initialImageId = (initialImage.stringId as unknown) as Pick<
    Annotation,
    'imageId'
  >;
  imageIds.push(initialImageId);
  console.log(66, imageIds);

  boundPushNewImage(initialImageId);

  const mutationObserver = new MutationObserver(() => {
    const newImage: Image = getImage();
    boundGetImage(newImage);
    // reset intersection and marker reducers
    boundIntersection([]); // Empty array of entities
    boundMarkerIntersection({ id: 0, isHovered: false }); // default
    // set markers as not marked
    // TODO: refactor
    for (let i = 1; i <= 20; i++) {
      let marker = <Entity>document.getElementById(`markerContainer${i}`)!;
      marker.setAttribute('marked', false);
    }
    // TODO: set previous observation to annotated
    const imageId = (newImage.stringId as unknown) as Pick<
      Annotation,
      'imageId'
    >;
    // console.log(789, `${imageId} in ${imageIds}:`, imageIds.includes(imageId));
    if (!imageIds.includes(imageId)) {
      imageIds.push(imageId);
      console.log(66, imageIds);

      boundPushNewImage(imageId);
      // TODO: push unique images to array in Annotation
      boundIncrementObservationNumber();
    }
    // TODO: else, for the first time, set last (3rd) image isAnnotated: true
  });

  mutationObserver.observe(document.getElementById('canvas2d')!, {
    attributes: true,
    attributeFilter: ['src'],
  });

  const mutationObserverEvaluation = new MutationObserver(() => {
    console.log('New question detected');
    const postPlane = document.getElementById('postPlane')!;
    postPlane.setAttribute('option-selected', 'false');
    postPlane.setAttribute('annotated', 'false');
    boundNewEvaluation();
  });

  mutationObserverEvaluation.observe(
    document.getElementById('questionPlaneText')!,
    {
      attributes: true,
      attributeFilter: ['value'],
    }
  );
});

const render = () => {
  return store.getState();
};

boundFetchLastObservationNumber().then(() => boundIncrementObservationNumber());

render();

store.subscribe(render);

// Handles an intersected annotation point
AFRAME.registerComponent('intersection', {
  /* eslint-disable-next-line func-names, object-shorthand */
  init: function () {
    // Listen for an intersection between the ray-caster and entities
    this.el.addEventListener('raycaster-intersection', (e: any) => {
      if (e) {
        const intersectedEntities: Entity[] = e.detail.els;
        if (intersectedEntities.length < 3) {
          boundIntersection(intersectedEntities);
          // const intersectedElId = intersectedEntities[0]?.id;
          handleMarkerIntersection();
          handleEvaluationIntersection();
        }
      }
    });
  },
});

AFRAME.registerComponent('coral-cover-2d-buttons', {
  /* eslint-disable-next-line func-names, object-shorthand */
  init: function () {
    // Select DOM element with button controls i.e. the scene
    const controlsEl = <Scene>document.querySelector('[button-controls]');

    // Detect buttons selected in WebVR
    controlsEl.addEventListener('buttondown', () => {
      // If button selected and marker hovered => display menu options
      const state = store.getState();
      // TODO: Refactor below
      const {
        lastHoveredOption,
        evaluations,
        questionNumber,
      } = state.evaluationReducer;
      const { id, isHovered } = state.markerReducer;
      const intersectionReducer = state.intersectionReducer;
      const lastIntersectedElId = intersectionReducer[0]?.id;

      const postPlane = document.getElementById('postPlane')!;

      // TODO: potentially remove boundary from check
      if (
        lastIntersectedElId &&
        lastIntersectedElId.includes(`option${lastHoveredOption}`)
      ) {
        let isAnyOptionSelected = postPlane.getAttribute('option-selected');
        if (isAnyOptionSelected === 'false') {
          console.log(3, 'OPTION SELECTED');
          setOptionColor(lastHoveredOption);
          postPlane.setAttribute('option-selected', 'true');
          boundPostEvaluation({
            questionNumber: questionNumber as number,
            responseOption: lastHoveredOption as QuestionResponseOption,
          });
        } else {
          console.log(2, 'OPTION UPDATED');
          resetOptionsColor();
          setOptionColor(lastHoveredOption);
          boundUpdateEvaluation({
            questionNumber: questionNumber as number,
            responseOption: lastHoveredOption as QuestionResponseOption,
          });
        }
      } else if (
        lastHoveredOption !== 0 &&
        lastIntersectedElId &&
        lastIntersectedElId.includes(`post`)
      ) {
        // TODO: check 1-4
        const lastHoveredOptionString = `option${lastHoveredOption}Plane`;
        saveEvaluation(lastHoveredOptionString);
      }
      // TODO: Refactor above

      if (isHovered) {
        // Marker is hovered thus must have a corresponding ID
        displayMenuOptions(id, true);
      } else {
        // If button clicked but not hovering a marker => intersected elements not a marker thus not of interest hence and empty array is set
        boundIntersection([]);
      }
    });
  },
});

/* WebSocket */

AFRAME.registerComponent('r2vr-message-router', {
  schema: {
    host: { type: 'string', default: 'localhost' },
    port: { type: 'number', default: 8080 },
  },

  init: function () {
    var ws = new WebSocket('ws://' + this.data.host + ':' + this.data.port);

    ws.onopen = function () {
      console.log(
        'r2vr-message-router: Established connection with server session.'
      );
    };

    ws.onmessage = function (msg: any) {
      console.log(msg);
      const payload = JSON.parse(msg.data);
      // Assume payload is a list of events
      payload.map((r2vr_message: any) => {
        let target = <any>'';
        if (r2vr_message.id) {
          target = <Entity>document.querySelector('#' + r2vr_message.id);
          console.log(77, target, r2vr_message.id);
        }
        if (r2vr_message.class == 'event') {
          target.emit(
            r2vr_message.message.eventName,
            r2vr_message.message.eventDetail,
            r2vr_message.message.bubbles
          );
        } else if (r2vr_message.class == 'update') {
          console.log(555, target, r2vr_message.id, r2vr_message.component);
          target.setAttribute(
            r2vr_message.component,
            r2vr_message.attributes,
            r2vr_message.replaces_component
          );
        } else if (r2vr_message.class == 'check') {
          const state = store.getState();
          // find current image annotations
          const allAnnotatedImages = state.annotationReducer;
          const currentImageId = state.imageReducer.stringId;
          // TODO: refactor, check if needed
          // for (let i = 1; i <= 20; i++) {
          //   let marker = <Entity>(
          //     document.getElementById(`markerContainer${i}`)!
          //   );
          //   marker.setAttribute('visible', false);
          // }

          const getImage = allAnnotatedImages.find(
            (image) => image.imageId === currentImageId
          );

          const imageNumber = getImage!.imageNumber;

          const userAnnotations =
            state.annotationReducer[imageNumber - 1].markers;
          console.log(
            334,
            r2vr_message.imageId,
            r2vr_message.goldStandard,
            userAnnotations,
            imageNumber
          );
          // TODO: refactor to UI
          // returns array of markers (Marker[])
          // if wrong or unannotated
          const incorrectResults = r2vr_message.goldStandard.filter(
            ({ id: id1, isCoral: isCoral1 }: Marker) =>
              !userAnnotations.some(
                ({ id: id2, isCoral: isCoral2 }: Marker) =>
                  id2 === id1 && isCoral1 === isCoral2
              )
          );

          const correctResults = r2vr_message.goldStandard.filter(
            ({ id: id1, isCoral: isCoral1 }: Marker) =>
              userAnnotations.some(
                ({ id: id2, isCoral: isCoral2 }: Marker) =>
                  id2 === id1 && isCoral1 === isCoral2
              )
          );

          incorrectResults.forEach((incorrectMarker: Marker) => {
            document
              .getElementById(`markerCircumference${incorrectMarker.id}`)!
              .setAttribute('color', '#FF0000');
            document
              .getElementById(`markerContainer${incorrectMarker.id}`)!
              .setAttribute('visible', 'true');
          });

          correctResults.forEach((correctMarker: Marker) => {
            document
              .getElementById(`markerCircumference${correctMarker.id}`)!
              .setAttribute('color', '#00FF00');
            document
              .getElementById(`markerContainer${correctMarker.id}`)!
              .setAttribute('visible', 'true');
          });

          // TODO: refactor above
        } else if (r2vr_message.class == 'remove_component') {
          target.removeAttribute(r2vr_message.component);
        } else if (r2vr_message.class == 'remove_entity') {
          target.removeFromParent();
          target.parentNode.removeChild(target);
        } else if (r2vr_message.class == 'remove_entity_class') {
          var els = <any>(
            document.getElementsByClassName(`${r2vr_message.className}`)
          );
          if (els.length === 0) {
            throw new Error(
              `${r2vr_message.className} does not pertain to the class of any DOM elements.`
            );
          }
          while (els[0]) {
            els[0].parentNode.removeChild(els[0]);
          }
        } else if (r2vr_message.class == 'add_entity') {
          console.log(r2vr_message.tag);
          const validEntities = [
            'box',
            'camera',
            'circle',
            'cone',
            'cursor',
            'curvedimage',
            'cylinder',
            'dodecahedron',
            'gltf-model',
            'icosahedron',
            'image',
            'light',
            'link',
            'obj-model',
            'octahedron',
            'plane',
            'ring',
            'sky',
            'sound',
            'sphere',
            'tetrahedron',
            'text',
            'torus-knot',
            'torus',
            'triangle',
            'video',
            'videosphere',
          ];
          const isValidEntity = validEntities.includes(r2vr_message.tag);
          if (!isValidEntity) {
            throw new Error(
              `${r2vr_message.tag} is not a primitive A-Frame entity.`
            );
          }
          var parentEl = <any>document.querySelector('a-scene');
          if (r2vr_message.parentEntityId) {
            parentEl = document.querySelector(
              `#${r2vr_message.parentEntityId}`
            );
          }
          if (!parentEl) {
            throw new Error(
              `${r2vr_message.parentEntityId} does not pertain to the ID of a DOM element.`
            );
          }
          var entityEl = document.createElement(`a-${r2vr_message.tag}`);
          console.log(entityEl);
          entityEl.id = r2vr_message.id;
          if (r2vr_message.className) {
            entityEl.classList.add(`${r2vr_message.className}`);
          }
          parentEl.appendChild(entityEl);
        } else {
          throw new Error(
            'r2vr-message-router received a message of unknown class.'
          );
        }
      });
    };
    function handle_r_server_message(event: any) {
      ws.send(event.detail);
    }

    this.el.addEventListener('r_server_message', handle_r_server_message);
  },
});
