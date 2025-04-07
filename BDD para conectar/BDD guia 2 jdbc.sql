create database if not exists bdd2jdbc;
use bdd2jdbc;

CREATE TABLE alumnos (
    id INTEGER PRIMARY KEY auto_increment,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    edad INTEGER NOT NULL,
    email varchar(100) UNIQUE NOT NULL
);

CREATE TABLE direcciones (
	id INTEGER PRIMARY KEY auto_increment,
	calle varchar(50) NOT NULL,
	altura INTEGER NOT NULL,
	alumno_id INTEGER NOT NULL,
	FOREIGN KEY (alumno_id) REFERENCES alumnos(id) ON DELETE CASCADE
);


INSERT INTO alumnos (nombre, apellido, edad, email) VALUES
('Pedro', 'Gutierrez', 21, 'pedro@email.com'),
('Matias', 'Lopez', 22, 'matias@email.com'),
('Sofia', 'Martinez', 20, 'sofia@email.com'),
('Martin', 'Gabilan', 19, 'martin@email.com'),
('Camila', 'Rossi', 23, 'camila@email.com');

INSERT INTO direcciones (calle, altura, alumno_id) VALUES
('Av. Siempre Viva', '742', 1),
('Calle Falsa', '123', 2),
('Boulevard Central', '456', 3),
('Av. Libertador', '789', 4),
('San Martín', '101',5);