// TODO: consider refactoring as duplicated in postEvaluation (3d)
const numberAsWordLookup = {
  1: 'One',
  2: 'Two',
  3: 'Three',
  4: 'Four',
};

export const setOptionColor = (
  optionResponseNumber: Shared.QuestionResponseOption,
  colorHex: string
) => {
  const optionNumberAsWord = numberAsWordLookup[optionResponseNumber];
  document
    .getElementById(`option${optionNumberAsWord}Plane`)!
    .setAttribute('color', colorHex);
};

export const resetOptionColor = (colorHex: string) => {
  Object.values(numberAsWordLookup).forEach((optionNumberAsWord) => {
    document
      .getElementById(`option${optionNumberAsWord}Plane`)!
      .setAttribute('color', colorHex);
  });
};

export const setPostColor = (colorHex: string) => {
  document
    .getElementById('postPlane')!
    .setAttribute('color', colorHex);
};

export const resetPostColor = (colorHex: string) => {
  document
    .getElementById('postPlane')!
    .setAttribute('color', colorHex);
};
