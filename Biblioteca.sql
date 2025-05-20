CREATE DATABASE IF NOT EXISTS Biblioteca;
USE Biblioteca;

-- crear tabla Rol
CREATE TABLE Rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- crear tabla usuarios
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo_electronico VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    id_rol INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol) -- llave foranea hacia rol
);

-- Crear tabla de Libros
CREATE TABLE Libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    cantidad_disponible INT NOT NULL DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Crear tabla de prestamos
CREATE TABLE Prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario), -- llave foranea hacia usuario
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro) -- llave foranea hacia libro
);

-- creacion de tabla Devolución
CREATE TABLE Devolucion (
    id_devolucion INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    fecha_devolucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo) -- llave foranea hacia prestamo
);

select * from Devolucion;

-----------------------------------------------------------------------------------
-- INSERCION DE DATOS
-----------------------------------------------------------------------------------
USE Biblioteca;

-- inserción de roles
INSERT INTO Rol (nombre, descripcion) VALUES 
('lector', 'Usuario que puede pedir libros prestados'),
('admin', 'Administrador del sistema'),
('bibliotecario', 'Encargado de gestionar los préstamos');
select id_rol from Rol where nombre = 'lector';
select * from Rol;

-- inserción de usuarios
INSERT INTO Usuario
	(nombre, correo_electronico, telefono, id_rol)
VALUES 
	('Juan Pérez', 'juanperez@correo.com', '555-1234', 1),
	('Ana García', 'anagarcia@correo.com', '555-5678', 2),
	('Carlos Sánchez', 'carlossanchez@correo.com', '555-8765', 3);
INSERT INTO Usuario 
	(nombre, correo_electronico, telefono, id_rol)
VALUES 
	('María López', 'maria.lopez@correo.com', '555-1122', 1),
	('Pedro Martínez', 'pedro.martinez@correo.com', '555-2233', 1),
	('Laura Fernández', 'laura.fernandez@correo.com', '555-3344', 1),
	('Luis Gómez', 'luis.gomez@correo.com', '555-4455', 1),
	('Marta Rodríguez', 'marta.rodriguez@correo.com', '555-5566', 1);
select * from Usuario;
select * from Usuario where id_rol = 1;


-- inserción de Libros
INSERT INTO Libro 
	(titulo, autor, cantidad_disponible, estado)
VALUES 
	('Aprendiendo Python', 'Eric Matthes', 10, 'activo'),
	('JavaScript: The Good Parts', 'Douglas Crockford', 8, 'activo'),
	('Clean Code', 'Robert C. Martin', 5, 'activo'),
	('Eloquent JavaScript', 'Marijn Haverbeke', 7, 'activo'),
	('The Pragmatic Programmer', 'Andrew Hunt y David Thomas', 6, 'activo');
Select * from Libro;
select id_usuario from Usuario where id_rol = 1;


-- insercion de prestamos
INSERT INTO Prestamo 
	(id_usuario, id_libro, fecha_prestamo)
VALUES 
	(7, 1, '2025-05-10'),  
	(1, 1, '2025-05-12'),           
	(9, 3, '2025-05-13'), 
	(8, 2, '2025-05-14'),           
	(10, 4, '2025-05-15'); 
select * from Prestamo;


-- devolver un prestamo
INSERT INTO Devolucion
	(id_prestamo)
VALUES
	(3);
select * from Devolucion;

-----------------------------------------------------------------------------------
-- CONSULTAS
-----------------------------------------------------------------------------------
-- TAREA
-- Listar la lista de devoluciones de manera descendente
select * from Devolucion order by fecha_devolucion DESC;

-- que usuarios han devuelto sus libros
-- por id de usuario, nombre, titulo del libro y la fecha de devolucion
-- de manera descendente
select u.id_usuario, u.nombre, l.titulo, d.fecha_devolucion from Usuario u
    INNER JOIN Prestamo p 
    ON p.id_usuario = u.id_usuario
    INNER JOIN Libro l 
    ON l.id_libro = p.id_libro
    INNER JOIN Devolucion d
    ON d.id_prestamo = p.id_prestamo
    WHERE d.id_prestamo = p.id_prestamo
    order by d.fecha_devolucion DESC;
    
-- que usuarios no han devuelto sus libros
select u.id_usuario, u.nombre, l.titulo, p.fecha_prestamo from Usuario u
    INNER JOIN Prestamo p 
    ON p.id_usuario = u.id_usuario
    INNER JOIN Libro l 
    ON l.id_libro = p.id_libro
    LEFT JOIN Devolucion d  -- SE UTILIZA LEFT JOIN PORQUE PRIORIZA LA TABLA PADRE EN ESTE CASO ES LA QUE QUEREMOS CONSULTAR
    ON d.id_prestamo = p.id_prestamo
    WHERE d.id_devolucion is null
    order by d.fecha_devolucion desc;




