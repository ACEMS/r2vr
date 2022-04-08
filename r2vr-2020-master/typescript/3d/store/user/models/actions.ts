export const GET_USER = 'GET_USER';

interface UserAction {
  type: typeof GET_USER;
  user: Shared.User;
}

export type UserActionTypes = UserAction;
