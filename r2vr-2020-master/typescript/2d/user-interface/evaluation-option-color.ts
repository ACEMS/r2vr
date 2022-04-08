export const EVALUATION_OPTION_COLOR = '#00FF00';

export const setOptionColor = (optionResponseNumber: number) => {
  document
    .getElementById(`option${optionResponseNumber}Plane`)!
    .setAttribute('color', 'green');
};

export const resetOptionsColor = () => {
  // TODO: refactor so 4 is dynamic
  for (let option = 1; option <= 4; option++) {
    document
      .getElementById(`option${option}Plane`)!
      .setAttribute('color', '#FFFFFF');
  }
};
