declare namespace Shared {
  export type Marker = {
    id: number;
    isCoral: Shared.CoralBinary;
    x: number;
    y: number;
    z?: number;
  };

  export type AnnotatedMarker = {
    id: number;
    isCoral: Shared.CoralBinary;
  };

  export interface Annotation {
    image: Shared.ImageFile;
    markers: Marker[];
  }
}

declare namespace Api {
  export interface Annotation {
    image_file_name: string;
    image_file_id: string;
    image_file_extension: string;
    site: number;
    x: number;
    y: number;
    z?: number;
    is_coral: Shared.CoralBinary;
    observer: string;
    observation_id: string;
  }
}
