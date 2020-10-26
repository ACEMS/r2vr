import { UserActionTypes } from './models/actions';

const defaultState: Shared.User = { name: '' };

export const userReducer = (
  state = defaultState,
  action: UserActionTypes
): Shared.User => {
  switch (action.type) {
    case 'GET_USER':
      return { ...action.user };

    default:
      return state;
  }
};
