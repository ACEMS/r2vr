import { Entity } from 'aframe';

export const INTERSECTION = 'INTERSECTION';

interface IntersectionAction {
  type: typeof INTERSECTION;
  els: Entity[];
}

export type IntersectionActionTypes = IntersectionAction;
