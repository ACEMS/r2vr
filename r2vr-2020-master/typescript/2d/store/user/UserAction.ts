import { store } from '../rootStore';

import { AppActions } from '../models/actions';

import { GET_USER } from './models/actions';
import { User } from './models/User';

const getUser = (user: User): AppActions => {
  return {
    type: GET_USER,
    user,
  };
};

const boundGetUser = (user: User) => store.dispatch(getUser(user));

export default boundGetUser;
