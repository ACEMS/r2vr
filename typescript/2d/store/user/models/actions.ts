import { User } from './User';

export const GET_USER = 'GET_USER';

interface UserAction {
  type: typeof GET_USER;
  user: User;
}

export type UserActionTypes = UserAction;
