import { store } from '../store/rootStore';

// import { URL } from '@shared/http/url'; // TODO dotenv?
// const url = 'http://localhost:3000/api';
const url = 'https://r2vr.herokuapp.com/api';

const numberAsWordLookup = {
  1: 'One',
  2: 'Two',
  3: 'Three',
  4: 'Four',
};

// document
//   .getElementById(`option${optionNumberAsWord}Plane`)!
//   .setAttribute('color', EVALUATION_RESPONSE_COLOR);

const postEvaluation = async () => {
  const { evaluationReducer, userReducer } = store.getState();
  const { evaluations } = evaluationReducer;
  const evaluationsLength = evaluations.length;
  const evaluation = evaluations[evaluationsLength - 1];
  const user = userReducer.name;

  const optionNumberAsWord = numberAsWordLookup[evaluation.selectedOption];

  const questionEl = document.getElementById('questionPlaneText')!;
  const question = questionEl.getAttribute('value');
  const answerEl = document.getElementById(`option${optionNumberAsWord}Text`)!;
  const answer = answerEl.getAttribute('value');

  const data = {
    observer: user,
    question: question,
    response: answer,
  };
  console.log(5, data);
  try {
    // TODO url
    const response = await fetch(`${url}/2d/evaluation`, {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (![200, 201].includes(response.status)) {
      throw new Error('Unable to post evaluation!');
    }
  } catch (err) {
    throw new Error(`${err} - Unable to post evaluation!`);
  }
};

export default postEvaluation;
