import { store } from '../store/rootStore';
import { boundEvaluationResponseIntersection } from '../store/evaluation/EvaluationAction';

// Determines if an evaluation response is hovered
const handleEvaluationIntersection = (): void => {
  const { observationReducer, intersectionReducer } = store.getState();

  // Prevents annotation points being marked if missing observation_number data
  const observationNumber = observationReducer.observation_number;

  const intersectedElId = intersectionReducer[0]?.id;

  // TODO: check markers on edge
  if (
    // [0, -1].includes(observationNumber) ||
    intersectionReducer[0]?.id === 'canvas2d' ||
    intersectionReducer.length === 0 ||
    intersectedElId.includes('marker')
  ) {
    return;
  }
  const matches = intersectedElId.match(/(\d+)/);

  if (matches && intersectedElId.includes('option')) {
    const optionResponseNumber = <number>+matches[0];
    boundEvaluationResponseIntersection({
      lastHoveredOption: optionResponseNumber,
    });
  }
};

export default handleEvaluationIntersection;
