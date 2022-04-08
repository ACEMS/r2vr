import { MetaDataActionTypes } from './models/actions';

const defaultState: Shared.MetaDataDefault = {
  module: '',
  annotationType: '',
};

export const metaDataReducer = (
  state = defaultState,
  action: MetaDataActionTypes
): Shared.MetaData | Shared.MetaDataDefault => {
  switch (action.type) {
    case 'GET_METADATA':
      return { ...action.metaData };

    default:
      return state;
  }
};
