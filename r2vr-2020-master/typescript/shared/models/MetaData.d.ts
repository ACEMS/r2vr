declare namespace Shared {
  export type MetaDataModule = '2d' | '3d';
  export type MetaDataAnnotationType = 'training' | 'testing';

  export interface MetaData {
    module: MetaDataModule;
    annotationType: MetaDataAnnotationType;
  }
  export interface MetaDataDefault {
    module: MetaDataModule | '';
    annotationType: MetaDataAnnotationType | '';
  }
}
