import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { GET_USER } from './models/actions';

const getUser = (user: Shared.User): AppActions => {
  return {
    type: GET_USER,
    user,
  };
};

const boundGetUser = (user: Shared.User) => store.dispatch(getUser(user));

export default boundGetUser;
