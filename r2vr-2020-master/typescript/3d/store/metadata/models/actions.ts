export const GET_METADATA = 'GET_METADATA';

interface MetaDataAction {
  type: typeof GET_METADATA;
  metaData: Shared.MetaData;
}

export type MetaDataActionTypes = MetaDataAction;
