import { gql } from '../types';

export const PostFragment = gql(`
  fragment PostFields on Post {
    content
  }
`)