CREATE USER airbnb_user;

CREATE DATABASE airbnb;
GRANT ALL PRIVILEGES ON DATABASE airbnb TO airbnb_user;

SET search_path TO airbnb;


CREATE TABLE IF NOT EXISTS listings(
    id serial PRIMARY KEY, 

);

CREATE TABLE IF NOT EXISTS crime(
    id serial PRIMARY KEY
);