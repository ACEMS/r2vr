import { Entity } from 'aframe';

import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { INTERSECTION } from './models/actions';

const intersection = (els: Entity[]): AppActions => {
  return {
    type: INTERSECTION,
    els,
  };
};

const boundIntersection = (els: Entity[]) => store.dispatch(intersection(els));

export default boundIntersection;
