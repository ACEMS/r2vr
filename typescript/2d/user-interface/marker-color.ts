import { CoralBinary } from '../models/CoralBinary';

// Choose colors of menu options
export const CORAL_COLOR = '#FF95BC';
export const NOT_CORAL_COLOR = '#969696';

export const setMarkerColor = (marker: number, coralBinary: CoralBinary) => {
  // Select corresponding Marker Circumference from DOM
  const markerCircumference = document.getElementById(
    `markerCircumference${marker}`
  );
  // Set appropriate color
  if (coralBinary === 1) {
    markerCircumference?.setAttribute('color', CORAL_COLOR);
  } else {
    markerCircumference?.setAttribute('color', NOT_CORAL_COLOR);
  }
};
