import { Entity } from 'aframe';

import { store } from '../store/rootStore';

import boundMarkerIntersection from '../store/marker/MarkerAction';

import displayMenuOptions from '../user-interface/menu-options';

import save from '../helpers/save';

const selectMenuOption = (): void => {
  const state = store.getState();
  const { id } = state.markerReducer;
  const els = Object.values(state.intersectionReducer); // TODO: consider marker reducer instead
  // TODO refactor to includes menuCoral, coralText
  if (
    els.some(
      (el: Entity) => el.id === `menuCoral${id}` || el.id === `coralText${id}`
    )
  ) {
    save(id, 1);
    displayMenuOptions(id);
    boundMarkerIntersection({ id, isHovered: false });
  } else if (
    els.some(
      (el: Entity) =>
        el.id === `menuNotCoral${id}` || el.id === `notCoralText${id}`
    )
  ) {
    save(id, 0);
    displayMenuOptions(id);
    boundMarkerIntersection({ id, isHovered: false });
  } else if (
    !els.some(
      (el: Entity) =>
        el.id === `marker${id}` || el.id === `markerCircumference${id}`
    )
  ) {
    // TODO: potentially hide ALL menu options
    displayMenuOptions(id);
  } else {
  }
};

export default selectMenuOption;
