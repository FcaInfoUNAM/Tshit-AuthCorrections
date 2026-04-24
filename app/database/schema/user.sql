-- 1. Create the new user with a password
CREATE USER root WITH ENCRYPTED PASSWORD 'root';

-- 2. Create the database and set the new user as the owner
CREATE DATABASE tshit OWNER root;

-- 3. (Optional) Grant additional privileges if needed
GRANT ALL PRIVILEGES ON DATABASE tshit TO root;