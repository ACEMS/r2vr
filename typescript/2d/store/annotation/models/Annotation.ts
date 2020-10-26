import { CoralBinary } from '../../../models/CoralBinary';

export type Marker = { id: number; isCoral: CoralBinary };

export interface Annotation {
  isImageAnnotated: boolean;
  imageNumber: number;
  imageId: string;
  markers: Marker[];
}
