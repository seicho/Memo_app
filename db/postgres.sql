create table users (
  id SERIAL PRIMARY KEY,
  username text NOT NULL UNIQUE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

create table memos (
  id SERIAL PRIMARY KEY,
  user_id integer REFERENCES users (id),
  title text,
  body text,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
