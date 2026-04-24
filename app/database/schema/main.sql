-- Create ENUM type for user status
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'suspended');

-- Users table
CREATE TABLE users (
    id VARCHAR(24) PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    status user_status DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create an index for frequently queried columns
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- Roles table
CREATE TABLE roles (
    id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Roles (junction table)
CREATE TABLE user_roles (
    id VARCHAR(24) PRIMARY KEY,
    user_id VARCHAR(20) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id VARCHAR(20) NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, role_id)
);

-- Create indexes for foreign keys
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);


CREATE TABLE proveedores(
	id varchar(16) PRIMARY KEY,
	name varchar (16),
	RFC varchar (12) unique,
	legalName varchar(250),
	legalAddress varchar (250),
	active boolean
);

CREATE TABLE color(
	id varchar(16) PRIMARY KEY,
	name varchar(40),
	primaryColorCode varchar(6),
	secondaryColoir varchar(6)
);

CREATE TABLE talla(
	id varchar(16) PRIMARY KEY,
	size varchar (5),
	chest NUMERIC(5,2),
	length NUMERIC(5,2),
	gender char(1)
);
CREATE TABLE playera(
	id varchar(16) PRIMARY KEY,
	name varchar (160),
	ASIN varchar (16) unique,
	material varchar(30),
	idProveedor varchar(16), 
	FOREIGN KEY  (idProveedor) REFERENCES proveedores(id)
);
CREATE TABLE estampado(
	id varchar(16) PRIMARY KEY,
	name varchar (160),
	UnitaryPrice numeric (8,2),
	material varchar(40),
	heigth NUMERIC(5,2),
	width NUMERIC(5,2)
);

Create TABLE product (
	id varchar(16) PRIMARY KEY,
	playeraId varchar(16),
	FOREIGN KEY (playeraId) REFERENCES playera(id)
);

CREATE TABLE playera_color(
	playeraId varchar(16),
	colorId varchar(16),
	PRIMARY KEY (playeraId,colorId),
	FOREIGN KEY (playeraId) REFERENCES playera(id),
	FOREIGN KEY (colorId) REFERENCES color(id)
);
CREATE TABLE playera_talla(
	playeraId varchar(16),
	tallaId varchar(16),
	PRIMARY KEY (playeraId,tallaId),
	FOREIGN KEY (playeraId) REFERENCES playera(id),
	FOREIGN KEY (tallaId) REFERENCES talla(id)
);

CREATE TABLE product_estampado(
	productId varchar(16),
	estampadoId varchar(16),
	PRIMARY KEY (productId,estampadoId),
	FOREIGN KEY (productId) REFERENCES product(id),
	FOREIGN KEY (estampadoId) REFERENCES estampado(id)
);