CREATE TABLE memos
( id SERIAL NOT NULL,
  title VARCHAR(32) NOT NULL,
  content VARCHAR(140) NOT NULL,
  PRIMARY KEY(id));