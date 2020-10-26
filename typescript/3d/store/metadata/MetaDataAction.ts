import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { GET_METADATA } from './models/actions';

const getMetaData = (metaData: Shared.MetaData): AppActions => {
  return {
    type: GET_METADATA,
    metaData,
  };
};

const boundGetMetaData = (metaData: Shared.MetaData) =>
  store.dispatch(getMetaData(metaData));

export default boundGetMetaData;
