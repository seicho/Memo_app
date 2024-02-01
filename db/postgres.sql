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

insert into users (username, created_at, updated_at)  values ('sample user', date '2023-11-30', date '2023-11-30');
insert into users (username, created_at, updated_at)  values ('test', date '2023-11-30', date '2023-11-30');

insert into memos (user_id, title, body, created_at, updated_at) values ('1', 'this is a sample', 'sample is simple', date '2023-12-1', date '2023-12-1');