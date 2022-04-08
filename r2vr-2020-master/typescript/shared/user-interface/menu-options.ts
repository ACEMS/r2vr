import { Entity } from 'aframe';

type Display = 'hide' | 'show';

const displayMenuOptions = (
  markerId: number,
  display: Display = 'hide'
): void => {
  const coralOption = document.getElementById(
    `menuCoral${markerId}`
  )! as Entity;
  const notCoralOption = document.getElementById(
    `menuNotCoral${markerId}`
  )! as Entity;

  if (display === 'show') {
    coralOption.setAttribute('visible', 'true');
    notCoralOption.setAttribute('visible', 'true');
  } else {
    coralOption.setAttribute('visible', 'false');
    notCoralOption.setAttribute('visible', 'false');
  }
};

export default displayMenuOptions;
