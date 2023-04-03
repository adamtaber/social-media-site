CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  user_id uuid DEFAULT uuid_generate_v4 (),
  displayname VARCHAR ( 50 ) NOT NULL,
  username VARCHAR ( 25 ) UNIQUE NOT NULL,
  email VARCHAR ( 255 ) UNIQUE NOT NULL,
  password VARCHAR ( 50 ) NOT NULL,
  created_on TIMESTAMP NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE user_followers (
  user_id uuid NOT NULL,
  follower_id uuid NOT NULL,
  PRIMARY KEY (user_id, follower_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (follower_id) REFERENCES users (user_id)
);

CREATE TABLE user_following (
  user_id uuid NOT NULL,
  following_id uuid NOT NULL,
  PRIMARY KEY (user_id, following_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (following_id) REFERENCES users (user_id)
);

CREATE TABLE posts (
  post_id uuid DEFAULT uuid_generate_v4 (),
  user_id uuid NOT NULL,
  content VARCHAR (500) NOT NULL,
  created_on TIMESTAMP NOT NULL,
  PRIMARY KEY (post_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE comments (
  comment_id uuid DEFAULT uuid_generate_v4 (),
  user_id uuid NOT NULL,
  post_id uuid,
  parent_comment_id uuid,
  content VARCHAR (250) NOT NULL,
  created_on TIMESTAMP NOT NULL,
  PRIMARY KEY (comment_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (post_id) REFERENCES posts (post_id),
  FOREIGN KEY (parent_comment_id) REFERENCES comments (comment_id),
  CONSTRAINT only_post_or_column
    CHECK ((post_id IS NULL) != (parent_comment_id IS NULL))
);

CREATE TABLE likes (
  like_id uuid DEFAULT uuid_generate_v4 (),
  user_id uuid NOT NULL,
  post_id uuid,
  comment_id uuid,
  created_on TIMESTAMP NOT NULL,
  PRIMARY KEY (like_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (post_id) REFERENCES posts (post_id),
  FOREIGN KEY (comment_id) REFERENCES comments (comment_id),
  CONSTRAINT only_post_or_column
    CHECK ((post_id IS NULL) != (comment_id IS NULL))
);

CREATE TABLE bookmarks (
  bookmark_id uuid DEFAULT uuid_generate_v4 (),
  user_id uuid NOT NULL,
  post_id uuid,
  comment_id uuid,
  created_on TIMESTAMP NOT NULL,
  PRIMARY KEY (bookmark_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (post_id) REFERENCES posts (post_id),
  FOREIGN KEY (comment_id) REFERENCES comments (comment_id),
  CONSTRAINT only_post_or_column
    CHECK ((post_id IS NULL) != (comment_id IS NULL))
);