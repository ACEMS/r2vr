import { Entity } from 'aframe';

import postEvaluation from '../../async/evaluation/post';
import { store } from '../../store/rootStore';

const saveEvaluation = (postResponse: string) => {
  const postPlane = <Entity>document.getElementById(`postPlane`)!;

  const state = store.getState();
  const { name } = state.userReducer;

  let data: any;

  const evaluationQuestionEl = <Entity>(
    document.getElementById(`questionPlaneText`)!
  );
  const evaluationQuestion = evaluationQuestionEl.getAttribute('value');
  let evaluationResponse: string;

  console.log(22, postResponse);

  if (postResponse === 'option1Plane') {
    const option1TextEl = <Entity>document.getElementById(`option1Text`)!;
    evaluationResponse = option1TextEl.getAttribute('value');
  } else if (postResponse === 'option2Plane') {
    const option2TextEl = <Entity>document.getElementById(`option2Text`)!;
    evaluationResponse = option2TextEl.getAttribute('value');
  } else if (postResponse === 'option3Plane') {
    const option3TextEl = <Entity>document.getElementById(`option3Text`)!;
    evaluationResponse = option3TextEl.getAttribute('value');
  } else {
    const option4TextEl = <Entity>document.getElementById(`option4Text`)!;
    evaluationResponse = option4TextEl.getAttribute('value');
  }

  if (evaluationResponse && postPlane.getAttribute('annotated') === 'false') {
    postPlane.setAttribute('annotated', 'true');
    data = {
      observer: name,
      question: evaluationQuestion,
      response: evaluationResponse,
    };
    console.log('POST', data);
    postEvaluation(data);
  } else {
    data = {
      observer: name,
      response: evaluationResponse,
    };
    console.log('PUT', data);
    //  updateResponse(data);
  }
};

export default saveEvaluation;
