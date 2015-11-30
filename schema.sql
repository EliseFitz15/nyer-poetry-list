DROP TABLE IF EXISTS poems;

-- Define your schema here:

CREATE TABLE poems (
  id SERIAL PRIMARY KEY,
  title VARCHAR(500),
  author VARCHAR(500),
  body TEXT,
  url VARCHAR(500)
);
