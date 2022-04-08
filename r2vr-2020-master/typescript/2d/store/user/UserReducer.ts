import { UserActionTypes } from './models/actions';
import { User } from './models/User';

const defaultState: User = { name: '' };

// eslint-disable-next-line import/prefer-default-export
export const userReducer = (
  state = defaultState,
  action: UserActionTypes
): User => {
  switch (action.type) {
    case 'GET_USER':
      return { ...action.user };

    default:
      return state;
  }
};
