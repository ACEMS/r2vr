declare namespace Shared {
  export interface File {
    extension: string;
    fullName: string;
    name: string;
  }
  export interface ImageFile extends File {
    isAnnotated: boolean;
    uniqueNumberId: number;
  }
}
