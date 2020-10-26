declare namespace Shared {
  export interface AnnotationData {
    image_file?: string;
    image_id: string;
    is_coral?: CoralBinary;
    observation_number: number;
    observer?: string;
    site: number;
    x?: number;
    y?: number;
  }
}
