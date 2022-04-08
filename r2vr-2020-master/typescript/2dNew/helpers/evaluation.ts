import { store } from '../store/rootStore';

import {
  resetOptionColor,
  resetPostColor,
} from '../../shared/user-interface/evaluation-color';
import { boundNewEvaluation } from '../store/evaluation/EvaluationAction';

export const evaluationObserver = () => {
  const mutationObserver = new MutationObserver(() => {
    const state = store.getState();
    const { plane } = state.colorsReducer;

    resetOptionColor(plane);
    resetPostColor(plane);
    boundNewEvaluation();
  });

  mutationObserver.observe(document.getElementById('questionPlaneText')!, {
    attributes: true,
    attributeFilter: ['value'],
  });
};
