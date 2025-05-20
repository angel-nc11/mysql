-- ------------------------------------------------------------------------------------------------
-- CREACION DE TABLAS
-- ------------------------------------------------------------------------------------------------

-- Creacion de la base de datos
CREATE DATABASE IF NOT EXISTS tienda;
USE tienda;

-- Tabla para las sedes (tiendas)
CREATE TABLE Sede (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    activo BOOLEAN DEFAULT TRUE,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla para roles de usuario
CREATE TABLE Rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla para empleados
CREATE TABLE Empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    id_sede INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede) -- llave foranea para la tienda
);

-- Tabla para clientes
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    fcreate_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla para productos
CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_sede INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede) -- referencia para saber en que tienda esta el producto
);

-- Tabla para usuarios -- en este caso solo los empleados y administradoes pueden tener un usuario en la app
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    id_empleado INT NOT NULL UNIQUE,
    id_rol INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

-- Tabla para ventas
CREATE TABLE Venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_sede INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

-- Detalles de cada venta
CREATE TABLE DetalleVenta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- Tipos de pago (efectivo, tarjeta, transferencia)
CREATE TABLE TipoPago (
    id_tipo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pagos realizados en ventas
CREATE TABLE Pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_tipo_pago INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_tipo_pago) REFERENCES TipoPago(id_tipo_pago)
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(15),
    correo VARCHAR(100),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla Compra
CREATE TABLE Compra (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    id_empleado INT NOT NULL,
    id_sede INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

-- Tabla DetalleCompra
CREATE TABLE DetalleCompra (
    id_detalle_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);



-- ----------------------------------------------------------------------------------------------------------------------------------------
-- INSERCION DE DATOS 
-- -------------------------------------------------------------------------------------------------------------------------------------------
use tienda;
-- Insertar sede
INSERT INTO Sede (nombre, direccion, telefono) VALUES ('Electronics Store', 'Zona 10, Ciudad de Guatemala', '72301529');

-- Insertar roles
INSERT INTO Rol (nombre, descripcion) VALUES ('admin', 'Administrador del sistema');
INSERT INTO Rol (nombre, descripcion) VALUES ('vendedor', 'Vendedor de la tienda');

-- Insertar empleados
INSERT INTO Empleado (nombre, apellido, correo, telefono, id_sede) VALUES ('Juan', 'Perez', 'juanperez@electronics.gt', '83860031', 1);
INSERT INTO Empleado (nombre, apellido, correo, telefono, id_sede) VALUES ('Maria', 'Lopez', 'marialopez@electronics.gt', '73398721', 1);
INSERT INTO Empleado (nombre, apellido, correo, telefono, id_sede) VALUES ('Carlos', 'Gomez', 'carlosgomez@electronics.gt', '45763617', 1);

-- Insertar usuarios
INSERT INTO Usuario (username, password_hash, id_empleado, id_rol) VALUES ('admin', 'admin123', 1, 1);
INSERT INTO Usuario (username, password_hash, id_empleado, id_rol) VALUES ('vendedor1', 'vendedor1', 2, 2);
INSERT INTO Usuario (username, password_hash, id_empleado, id_rol) VALUES ('vendedor2', 'vendedor2', 3, 2);

-- insertar clientes
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Antonio', 'Morales', 'antonio.morales@gmail.com', '78540328');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Sergio', 'Flores', 'sergio.flores@gmail.com', '50730345');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Luis', 'Mendoza', 'luis.mendoza@gmail.com', '64720134');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Alberto', 'Ruiz', 'alberto.ruiz@gmail.com', '17744743');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Antonio', 'Chavez', 'antonio.chavez@gmail.com', '92150344');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Alejandro', 'Chavez', 'alejandro.chavez@gmail.com', '33376863');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Luis', 'Jimenez', 'luis.jimenez@gmail.com', '80753301');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Ramon', 'Navarro', 'ramon.navarro@gmail.com', '25747836');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Ernesto', 'Ortega', 'ernesto.ortega@gmail.com', '21233047');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Carlos', 'Pena', 'carlos.pena@gmail.com', '77619614');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Sergio', 'Gonzalez', 'sergio.gonzalez@gmail.com', '62030008');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Julio', 'Gonzalez', 'julio.gonzalez@gmail.com', '50559116');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Raul', 'Garcia', 'raul.garcia@gmail.com', '90191511');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Manuel', 'Pena', 'manuel.pena@gmail.com', '13022755');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Juan', 'Gonzalez', 'juan.gonzalez@gmail.com', '64150397');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Julio', 'Martinez', 'julio.martinez@gmail.com', '90513997');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Alberto', 'Garcia', 'alberto.garcia@gmail.com', '91995857');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Roberto', 'Silva', 'roberto.silva@gmail.com', '48192193');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Pablo', 'Vargas', 'pablo.vargas@gmail.com', '31300096');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Fernando', 'Gomez', 'fernando.gomez@gmail.com', '77271495');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Antonio', 'Garcia', 'antonio.garcia@gmail.com', '51489729');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Diego', 'Hernandez', 'diego.hernandez@gmail.com', '74430579');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Ernesto', 'Perez', 'ernesto.perez@gmail.com', '92281168');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Pedro', 'Mendoza', 'pedro.mendoza@gmail.com', '82333454');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Sergio', 'Sanchez', 'sergio.sanchez@gmail.com', '65071311');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Mario', 'Navarro', 'mario.navarro@gmail.com', '71595973');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Eduardo', 'Rodriguez', 'eduardo.rodriguez@gmail.com', '71903112');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Diego', 'Sanchez', 'diego.sanchez@gmail.com', '37497387');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Enrique', 'Fernandez', 'enrique.fernandez@gmail.com', '56090198');
INSERT INTO Cliente (nombre, apellido, correo, telefono) VALUES ('Eduardo', 'Navarro', 'eduardo.navarro@gmail.com', '89714776');
Select * from Cliente;

-- insertar proveedores
INSERT INTO Proveedor (nombre, contacto, telefono, correo) VALUES ('Pedro', 'Mora', '48046502', 'pedro.mora@gmail.com');
INSERT INTO Proveedor (nombre, contacto, telefono, correo) VALUES ('Ramon', 'Lopez', '88754794', 'ramon.lopez@gmail.com');
INSERT INTO Proveedor (nombre, contacto, telefono, correo) VALUES ('Luis', 'Jimenez', '87297609', 'luis.jimenez@gmail.com');
INSERT INTO Proveedor (nombre, contacto, telefono, correo) VALUES ('Francisco', 'Hernandez', '22264927', 'francisco.hernandez@gmail.com');
INSERT INTO Proveedor (nombre, contacto, telefono, correo) VALUES ('Luis', 'Castillo', '72099406', 'luis.castillo@gmail.com');

-- insertar productos
INSERT INTO Producto (nombre, descripcion, precio, stock, id_sede) VALUES
('iPhone 10', 'Smartphone Apple iPhone 10 con 64GB de almacenamiento', 7281.29, 25, 1),
('Licuadora', 'Licuadora Oster con 3 velocidades y vaso de vidrio', 4843.61, 88, 1),
('Laptop Lenovo', 'Laptop Lenovo con procesador Intel i5 y 8GB de RAM', 6958.15, 73, 1),
('Audífonos inalámbricos', 'Audífonos Bluetooth con cancelación de ruido', 3769.73, 72, 1),
('Smart TV 50"', 'Televisor inteligente Samsung de 50 pulgadas 4K', 3761.74, 49, 1),
('Mouse inalámbrico', 'Mouse inalámbrico Logitech con batería recargable', 5614.65, 1, 1),
('Teclado mecánico', 'Teclado mecánico RGB con switches Cherry MX', 3814.19, 82, 1),
('Impresora multifuncional', 'Impresora multifuncional HP con escáner y copiadora', 212.17, 82, 1),
('Disco duro externo 1TB', 'Disco duro externo Seagate de 1TB USB 3.0', 7143.23, 36, 1),
('Cámara digital', 'Cámara digital Canon con 20MP y zoom óptico 10x', 4569.52, 62, 1),
('Tablet Samsung', 'Tablet Samsung Galaxy Tab con pantalla de 10 pulgadas', 5056.03, 79, 1),
('Refrigeradora', 'Refrigeradora LG con tecnología inverter y dispensador de agua', 7200.81, 94, 1),
('Microondas', 'Microondas Panasonic con 1000W de potencia y grill', 784.02, 17, 1),
('Lavadora', 'Lavadora Whirlpool con capacidad de 18kg y múltiples programas', 8028.75, 26, 1),
('Secadora', 'Secadora Samsung con tecnología de secado rápido', 1976.9, 78, 1),
('Ventilador', 'Ventilador de pedestal con control remoto y 3 velocidades', 1645.81, 73, 1),
('Aire acondicionado', 'Aire acondicionado portátil con función de deshumidificación', 9308.64, 58, 1),
('Cafetera', 'Cafetera Nespresso con sistema de cápsulas y espumador de leche', 3376.8, 18, 1),
('Batidora', 'Batidora KitchenAid con 10 velocidades y accesorios incluidos', 4436.61, 64, 1),
('Horno eléctrico', 'Horno eléctrico Black+Decker con capacidad de 42 litros', 4363.89, 6, 1),
('Plancha de vapor', 'Plancha de vapor Philips con suela antiadherente', 3180.56, 26, 1),
('Freidora de aire', 'Freidora de aire Tefal con capacidad de 4 litros', 1767.36, 94, 1),
('Extractor de jugos', 'Extractor de jugos Hamilton Beach con motor de 800W', 1991.8, 38, 1),
('Parrilla eléctrica', 'Parrilla eléctrica George Foreman con superficie antiadherente', 4627.4, 62, 1),
('Reloj inteligente', 'Reloj inteligente Apple Watch con GPS y monitor de ritmo cardíaco', 9965.96, 89, 1),
('Altavoz Bluetooth', 'Altavoz Bluetooth JBL con sonido estéreo y batería de larga duración', 8860.32, 33, 1),
('Proyector', 'Proyector Epson con resolución Full HD y conectividad HDMI', 8615.46, 46, 1),
('Router WiFi', 'Router WiFi TP-Link con doble banda y alta velocidad', 8434.05, 6, 1),
('Cámara de seguridad', 'Cámara de seguridad IP con visión nocturna y detección de movimiento', 6869.03, 46, 1),
('Consola de videojuegos', 'Consola de videojuegos PlayStation 5 con mando inalámbrico', 7315.98, 78, 1),
('Juego de ollas', 'Juego de ollas T-fal con revestimiento antiadherente y tapas de vidrio', 4590.6, 48, 1),
('Set de cuchillos', 'Set de cuchillos de cocina Zwilling con bloque de madera', 3095.02, 29, 1),
('Aspiradora', 'Aspiradora Dyson sin bolsa con tecnología ciclónica', 4795.12, 76, 1),
('Humidificador', 'Humidificador ultrasónico con capacidad de 5 litros', 7608.75, 58, 1),
('Deshumidificador', 'Deshumidificador con capacidad de extracción de 20 litros por día', 6830.41, 46, 1),
('Calentador de agua', 'Calentador de agua eléctrico con capacidad de 50 litros', 5643.57, 62, 1),
('Ventilador de torre', 'Ventilador de torre con control remoto y temporizador', 1413.91, 58, 1),
('Purificador de aire', 'Purificador de aire con filtro HEPA y ionizador', 5317.71, 90, 1),
('Máquina de coser', 'Máquina de coser Singer con 32 puntadas y brazo libre', 4171.08, 7, 1),
('Cámara deportiva', 'Cámara deportiva GoPro con resolución 4K y resistencia al agua', 6907.59, 79, 1),
('Bicicleta estática', 'Bicicleta estática con monitor de ritmo cardíaco y resistencia ajustable', 5009.0, 55, 1),
('Cinta de correr', 'Cinta de correr con pantalla LCD y programas de entrenamiento', 3362.63, 65, 1),
('Máquina de remo', 'Máquina de remo con resistencia magnética y asiento ergonómico', 4080.99, 86, 1),
('Set de pesas', 'Set de pesas ajustables con barra y discos de diferentes pesos', 4832.11, 40, 1),
('Banco de ejercicios', 'Banco de ejercicios ajustable para entrenamiento de fuerza', 3793.07, 74, 1),
('Colchón', 'Colchón ortopédico con memoria de forma y funda lavable', 8873.71, 56, 1),
('Almohada', 'Almohada viscoelástica con soporte cervical y funda de bambú', 7000.46, 8, 1),
('Sábanas', 'Juego de sábanas de algodón egipcio con 800 hilos', 4636.0, 76, 1),
('Edredón', 'Edredón de plumas de ganso con funda de algodón', 2709.76, 58, 1),
('Toallas', 'Juego de toallas de baño de algodón suave y absorbente', 1353.09, 82, 1),
('Cortinas', 'Cortinas opacas con diseño moderno y ojales metálicos', 3541.67, 66, 1),
('Alfombra', 'Alfombra de área grande con diseño geométrico y base antideslizante', 1844.52, 91, 1),
('Lámpara de mesa', 'Lámpara de mesa con base de cerámica y pantalla de tela', 6222.29, 84, 1),
('Lámpara de pie', 'Lámpara de pie con brazo ajustable y luz LED', 9036.41, 11, 1),
('Espejo', 'Espejo de pared con marco de madera y diseño decorativo', 5984.73, 19, 1),
('Cuadro decorativo', 'Cuadro decorativo con impresión artística y marco de aluminio', 8365.14, 60, 1),
('Reloj de pared', 'Reloj de pared con diseño vintage y mecanismo silencioso', 6865.08, 74, 1),
('Estantería', 'Estantería de madera con 5 niveles y diseño moderno', 8919.04, 15, 1),
('Mesa de centro', 'Mesa de centro de vidrio templado con base de metal', 5443.12, 52, 1),
('Silla de oficina', 'Silla de oficina ergonómica con soporte lumbar y ruedas giratorias', 5444.53, 44, 1),
('Escritorio', 'Escritorio de madera con cajones y espacio para computadora', 3700.49, 21, 1),
('Sofá', 'Sofá de 3 plazas con tapizado de tela y cojines incluidos', 1991.86, 77, 1),
('Sillón reclinable', 'Sillón reclinable con mecanismo de inclinación y reposapiés', 7279.34, 16, 1),
('Mesa de comedor', 'Mesa de comedor de madera con capacidad para 6 personas', 2329.69, 69, 1),
('Sillas de comedor', 'Juego de sillas de comedor con tapizado de cuero sintético', 9594.36, 45, 1),
('Vitrina', 'Vitrina de vidrio con iluminación LED y estantes ajustables', 983.14, 7, 1),
('Barra de sonido', 'Barra de sonido Sony con subwoofer integrado y conectividad Bluetooth', 9501.2, 16, 1),
('Home theater', 'Sistema de home theater Bose con altavoces surround y subwoofer', 1364.3, 76, 1),
('Reproductor de Blu-ray', 'Reproductor de Blu-ray LG con conectividad WiFi y aplicaciones de streaming', 192.48, 20, 1),
('Control remoto universal', 'Control remoto universal con pantalla táctil y programación automática', 5194.64, 97, 1),
('Antena de TV', 'Antena de TV digital con amplificador de señal y recepción HD', 1436.18, 68, 1),
('Decodificador', 'Decodificador de TV con grabación de programas y guía electrónica', 9508.67, 28, 1),
('Reproductor de DVD', 'Reproductor de DVD Philips con puerto USB y reproducción de múltiples formatos', 2435.97, 72, 1),
('Cámara instantánea', 'Cámara instantánea Fujifilm con impresión de fotos en segundos', 8316.33, 88, 1),
('Teléfono fijo', 'Teléfono fijo Panasonic con identificador de llamadas y altavoz manos libres', 7641.32, 60, 1),
('Walkie talkie', 'Walkie talkie Motorola con alcance de 10 km y múltiples canales', 4414.66, 80, 1),
('Radio portátil', 'Radio portátil Sony con sintonizador digital y batería recargable', 7831.0, 83, 1),
('Grabadora de voz', 'Grabadora de voz Olympus con memoria de 4GB y micrófono integrado', 8929.0, 49, 1),
('Micrófono', 'Micrófono de condensador Blue Yeti con soporte ajustable y filtro pop', 3338.14, 53, 1),
('Teclado MIDI', 'Teclado MIDI Akai con 49 teclas y conectividad USB', 2157.44, 35, 1),
('Guitarra eléctrica', 'Guitarra eléctrica Fender con amplificador y accesorios incluidos', 9620.11, 12, 1),
('Batería electrónica', 'Batería electrónica Roland con pads sensibles y conectividad MIDI', 5381.69, 47, 1),
('Piano digital', 'Piano digital Yamaha con teclas contrapesadas y múltiples sonidos', 7198.27, 58, 1),
('Violín', 'Violín acústico con arco y estuche incluidos', 4414.98, 63, 1),
('Saxofón', 'Saxofón alto Yamaha con boquilla y estuche rígido', 928.11, 77, 1),
('Trompeta', 'Trompeta Bach con acabado en latón y estuche de transporte', 9834.43, 59, 1),
('Flauta', 'Flauta traversa Gemeinhardt con llaves plateadas y estuche rígido', 4369.68, 34, 1),
('Clarinete', 'Clarinete Buffet con boquilla y estuche de transporte', 9622.13, 98, 1),
('Armónica', 'Armónica Hohner con 10 agujeros y estuche de transporte', 8153.76, 33, 1),
('Acordeón', 'Acordeón Hohner con 48 bajos y estuche rígido', 148.87, 27, 1),
('Bajo eléctrico', 'Bajo eléctrico Ibanez con amplificador y accesorios incluidos', 8240.38, 7, 1),
('Ukelele', 'Ukelele Kala con cuerdas de nylon y estuche de transporte', 6186.66, 60, 1),
('Mandolina', 'Mandolina Washburn con acabado en madera y estuche rígido', 1952.51, 14, 1),
('Banjo', 'Banjo Deering con resonador y estuche de transporte', 7372.18, 15, 1),
('Timbal', 'Timbal LP con soporte ajustable y baquetas incluidas', 2955.3, 99, 1),
('Congas', 'Congas Meinl con soporte ajustable y baquetas incluidas', 1630.19, 81, 1),
('Bongos', 'Bongos Remo con soporte ajustable y baquetas incluidas', 1798.05, 51, 1),
('Maracas', 'Maracas LP con mango de madera y sonido auténtico', 4057.77, 52, 1),
('Pandereta', 'Pandereta Remo con parche de cuero y sonajas metálicas', 8341.49, 74, 1),
('Triángulo', 'Triángulo Meinl con baqueta y soporte incluido', 179.56, 97, 1),
('Castañuelas', 'Castañuelas LP con mango de madera y sonido auténtico', 3738.35, 21, 1),
('Xilófono', 'Xilófono Yamaha con teclas de madera y soporte ajustable', 6059.69, 26, 1),
('Vibráfono', 'Vibráfono Musser con teclas de metal y soporte ajustable', 235.31, 43, 1),
('Campanas tubulares', 'Campanas tubulares Adams con soporte ajustable y baquetas incluidas', 596.85, 59, 1),
('Glockenspiel', 'Glockenspiel Yamaha con teclas de metal y soporte ajustable', 2048.81, 37, 1),
('Caja china', 'Caja china LP con soporte ajustable y baquetas incluidas', 3097.72, 82, 1),
('Claves', 'Claves LP con mango de madera y sonido auténtico', 2709.88, 72, 1),
('Guiro', 'Guiro LP con mango de madera y sonido auténtico', 9248.71, 78, 1),
('Cabasa', 'Cabasa LP con mango de madera y sonido auténtico', 7458.82, 33, 1),
('Shekere', 'Shekere LP con mango de madera y sonido auténtico', 5474.45, 61, 1),
('Cajón', 'Cajón Meinl con parche de cuero y soporte ajustable', 8430.13, 67, 1),
('Djembe', 'Djembe Remo con parche de cuero y soporte ajustable', 6777.29, 60, 1),
('Tabla', 'Tabla Meinl con parche de cuero y soporte ajustable', 4500.67, 90, 1),
('Bodhran', 'Bodhran Remo con parche de cuero y soporte ajustable', 4039.89, 50, 1),
('Tambor', 'Tambor Remo con parche de cuero y soporte ajustable', 8065.74, 36, 1),
('Timbaletas', 'Timbaletas LP con soporte ajustable y baquetas incluidas', 4431.07, 93, 1),
('Batería acústica', 'Batería acústica Pearl con parches de cuero y soporte ajustable', 5998.25, 9, 1),
('Batería electrónica', 'Batería electrónica Roland con pads sensibles y conectividad MIDI', 6684.27, 48, 1);
select * from Producto;

-- INSERTAR VENTAS
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (4, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 56, 4, 5106.982234575538);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 8, 1, 5990.559711722899);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 82, 4, 2068.1734645084507);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 86, 5, 4819.021139070658);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 1, 2, 5558.654599159965);
UPDATE Venta SET total = 69903.59740173207 WHERE id_venta = 1;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (28, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 29, 5, 3296.1520882915893);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 11, 5, 1554.4930307301877);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 60, 2, 1420.6894851340949);
UPDATE Venta SET total = 27094.604565377074 WHERE id_venta = 2;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (1, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 6, 2, 1990.0069463021491);
UPDATE Venta SET total = 3980.0138926042982 WHERE id_venta = 3;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (17, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (4, 19, 1, 2963.025923921173);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (4, 3, 5, 93.47937373290422);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (4, 66, 3, 179.04165263827178);
UPDATE Venta SET total = 3967.5477505005097 WHERE id_venta = 4;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (4, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 71, 3, 3568.946341419169);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 18, 1, 1650.8947807582683);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 64, 1, 305.96110823163815);
UPDATE Venta SET total = 12663.694913247415 WHERE id_venta = 5;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (3, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 52, 1, 5635.8412699955215);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 52, 5, 2202.932916340565);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 38, 5, 3758.538202802496);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 36, 1, 5974.545784747691);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 14, 1, 1912.7321199283258);
UPDATE Venta SET total = 43330.47477038685 WHERE id_venta = 6;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (1, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 73, 4, 3875.9775096690164);
UPDATE Venta SET total = 15503.910038676066 WHERE id_venta = 7;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (24, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (8, 14, 4, 4255.030348242496);
UPDATE Venta SET total = 17020.121392969984 WHERE id_venta = 8;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (18, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 62, 3, 5389.330608971903);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 43, 5, 4152.1796101593245);
UPDATE Venta SET total = 36928.88987771233 WHERE id_venta = 9;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (21, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 34, 3, 4408.301220344915);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 76, 4, 4810.634258927134);
UPDATE Venta SET total = 32467.440696743284 WHERE id_venta = 10;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (11, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (11, 59, 4, 3606.5257112189324);
UPDATE Venta SET total = 14426.10284487573 WHERE id_venta = 11;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (25, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 82, 1, 1735.049937033745);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 77, 3, 2222.0514978666947);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 99, 5, 3087.2158400538324);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 36, 5, 596.1735535436817);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 50, 5, 4514.1914797938625);
UPDATE Venta SET total = 49389.108797590714 WHERE id_venta = 12;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (16, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (13, 74, 1, 98.0401957172175);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (13, 64, 5, 716.794132082439);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (13, 61, 3, 5212.898519271628);
UPDATE Venta SET total = 19320.706413944295 WHERE id_venta = 13;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (29, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (14, 80, 1, 954.8395403688676);
UPDATE Venta SET total = 954.8395403688676 WHERE id_venta = 14;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (4, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (15, 3, 4, 1855.6371759947522);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (15, 90, 3, 1895.9293006277628);
UPDATE Venta SET total = 13110.336605862296 WHERE id_venta = 15;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (26, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (16, 75, 2, 1137.623001204575);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (16, 17, 4, 1755.2306349579756);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (16, 97, 1, 5061.852835180504);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (16, 24, 5, 5310.074163461921);
UPDATE Venta SET total = 40908.39219473116 WHERE id_venta = 16;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (24, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 38, 3, 1828.8027741034543);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 94, 1, 4368.119170912181);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 93, 3, 333.73137782015755);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 52, 4, 2800.0615919008096);
UPDATE Venta SET total = 22055.967994286257 WHERE id_venta = 17;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (25, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 79, 1, 311.40119813708645);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 42, 2, 5018.423721040458);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 85, 4, 2814.4817834209657);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 22, 2, 680.7692194702951);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 89, 4, 5905.626921780478);
UPDATE Venta SET total = 46590.22189996437 WHERE id_venta = 18;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (6, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 70, 3, 89.9555599178693);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 47, 1, 3086.371391475977);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 24, 1, 4646.205532997743);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 9, 2, 312.42674411516396);
UPDATE Venta SET total = 8627.297092457657 WHERE id_venta = 19;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (18, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 20, 2, 4211.35815623265);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 59, 2, 3524.361877286354);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 91, 3, 3972.715600019774);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 22, 1, 2364.528096459001);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 67, 4, 4988.2179767846055);
UPDATE Venta SET total = 49706.98687069475 WHERE id_venta = 20;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (11, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 21, 2, 3821.7991254002363);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 60, 3, 4918.061894945794);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 13, 1, 1897.080530838599);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 33, 2, 1651.77161496119);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 32, 4, 2304.76166574846);
UPDATE Venta SET total = 36817.45435939267 WHERE id_venta = 21;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (12, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (22, 74, 1, 3806.723763527233);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (22, 54, 4, 1077.1523129077);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (22, 79, 1, 4907.254158788086);
UPDATE Venta SET total = 13022.587173946118 WHERE id_venta = 22;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (22, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 11, 3, 734.392906448636);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 26, 4, 5680.611579067028);
UPDATE Venta SET total = 24925.625035614023 WHERE id_venta = 23;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (22, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (24, 40, 2, 3004.725573533269);
UPDATE Venta SET total = 6009.451147066538 WHERE id_venta = 24;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (14, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (25, 83, 4, 599.3042797964479);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (25, 22, 5, 557.1680646872558);
UPDATE Venta SET total = 5183.05744262207 WHERE id_venta = 25;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (28, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (26, 82, 3, 5516.833895112149);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (26, 25, 3, 2214.120679148237);
UPDATE Venta SET total = 23192.863722781156 WHERE id_venta = 26;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (4, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 88, 5, 3488.5267560421785);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 87, 4, 3426.86870314167);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 7, 3, 2667.254607438043);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 65, 4, 1658.6248533982484);
UPDATE Venta SET total = 45786.37182868469 WHERE id_venta = 27;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (23, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (28, 51, 1, 2422.973744674781);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (28, 6, 2, 4624.955509077745);
UPDATE Venta SET total = 11672.88476283027 WHERE id_venta = 28;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (20, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (29, 61, 2, 2160.2941558544203);
UPDATE Venta SET total = 4320.588311708841 WHERE id_venta = 29;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (2, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (30, 29, 3, 3303.4229966362573);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (30, 37, 1, 4292.62465279755);
UPDATE Venta SET total = 14202.89364270632 WHERE id_venta = 30;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (23, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (31, 1, 1, 3540.8670183910567);
UPDATE Venta SET total = 3540.8670183910567 WHERE id_venta = 31;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (28, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 57, 2, 4022.3979198801558);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 11, 1, 5929.114820250167);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 8, 4, 5973.1938568355135);
UPDATE Venta SET total = 37866.68608735253 WHERE id_venta = 32;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (19, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (33, 45, 3, 3259.40931941229);
UPDATE Venta SET total = 9778.22795823687 WHERE id_venta = 33;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (1, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 100, 3, 1689.7028728609537);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 55, 1, 1586.7573773289716);
UPDATE Venta SET total = 6655.865995911832 WHERE id_venta = 34;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (17, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 33, 2, 1484.975888003521);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 37, 4, 1276.7407418594985);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 94, 3, 2902.5846040523443);
UPDATE Venta SET total = 16784.668555602067 WHERE id_venta = 35;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (4, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (36, 64, 3, 1397.360568085754);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (36, 13, 4, 4601.427929646087);
UPDATE Venta SET total = 22597.793422841612 WHERE id_venta = 36;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (23, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 95, 1, 3497.8310297071803);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 77, 1, 4144.281473608137);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 77, 1, 3008.0806978805576);
UPDATE Venta SET total = 10650.193201195874 WHERE id_venta = 37;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (26, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 37, 2, 755.7086013266229);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 19, 5, 3143.4451312598717);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 53, 2, 4407.656551198652);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 91, 3, 2674.810910976987);
UPDATE Venta SET total = 34068.38869428087 WHERE id_venta = 38;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (20, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (39, 57, 5, 2335.925186302698);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (39, 26, 3, 1711.6581433337994);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (39, 43, 4, 3608.2528656248905);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (39, 68, 3, 4909.736420263843);
UPDATE Venta SET total = 45976.82108480598 WHERE id_venta = 39;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (14, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (40, 33, 2, 4090.6911093608956);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (40, 86, 5, 5874.6564070728355);
UPDATE Venta SET total = 37554.66425408597 WHERE id_venta = 40;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (4, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (41, 45, 1, 830.0304949884851);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (41, 99, 3, 4420.948061977901);
UPDATE Venta SET total = 14092.874680922187 WHERE id_venta = 41;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (6, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 84, 2, 4114.910121108358);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 76, 2, 2473.7190791211237);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 69, 4, 2162.1310606775014);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 88, 4, 5673.934861219651);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 54, 1, 1843.6886725294949);
UPDATE Venta SET total = 46365.210760577065 WHERE id_venta = 42;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (21, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (43, 19, 3, 2278.3553062645556);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (43, 74, 3, 4523.544253968153);
UPDATE Venta SET total = 20405.698680698122 WHERE id_venta = 43;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (11, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 62, 5, 5968.726616055802);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 87, 3, 2918.0184007211246);
UPDATE Venta SET total = 38597.68828244238 WHERE id_venta = 44;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (29, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 18, 4, 2052.3348965733653);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 65, 4, 2490.8348963431667);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 27, 1, 1884.8015422736687);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 72, 5, 646.9804667554868);
UPDATE Venta SET total = 23292.38304771723 WHERE id_venta = 45;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (28, 3, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 50, 4, 4645.668778469088);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 38, 4, 5738.624494958814);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 45, 5, 3490.7781950961426);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 74, 4, 4538.657198724692);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 78, 2, 3683.681349739445);
UPDATE Venta SET total = 84513.05556356997 WHERE id_venta = 46;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (27, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (47, 63, 5, 3852.522670993634);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (47, 1, 2, 3624.815986684137);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (47, 43, 3, 5615.630679117572);
UPDATE Venta SET total = 43359.13736568916 WHERE id_venta = 47;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (23, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 88, 3, 2743.8455924400782);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 26, 4, 506.7975225994276);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 31, 2, 4585.693853887175);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 67, 5, 5613.215996684006);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 38, 5, 5732.111504898962);
UPDATE Venta SET total = 76156.75208340713 WHERE id_venta = 48;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (28, 1, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (49, 92, 1, 2375.7225767101936);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (49, 42, 2, 3596.5858120522216);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (49, 8, 4, 3256.845040664859);
UPDATE Venta SET total = 22596.274363474073 WHERE id_venta = 49;
INSERT INTO Venta (id_cliente, id_empleado, id_sede, total) VALUES (18, 2, 1, 0);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 12, 5, 5035.148032269837);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 30, 1, 1802.7116266773828);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 33, 1, 1376.7108835272231);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 45, 1, 2791.560253030954);
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 4, 3, 1040.8858594361195);
UPDATE Venta SET total = 34269.38050289311 WHERE id_venta = 50;
SELECT * FROM Venta;


-- COMPRAS-- Insertar compras
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 3, 1, 7183.27);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 1, 1, 7281.32);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 1, 1, 7298.19);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 1, 1, 5056.31);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 3, 1, 5079.46);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 3, 1, 9097.68);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 1, 1, 7642.46);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 3, 1, 3596.98);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 3, 1, 3012.3);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 1, 1, 8486.81);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 1, 1, 3355.66);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 1, 1, 4776.31);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 1, 1, 2142.4);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 2, 1, 9525.19);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 3, 1, 9893.49);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 3, 1, 7634.84);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 2, 1, 9221.18);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 2, 1, 3195.19);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 3, 1, 4342.73);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 2, 1, 1970.55);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 1, 1, 4957.75);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 3, 1, 6152.1);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 2, 1, 5048.17);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 1, 1, 5306.71);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 2, 1, 2676.56);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 3, 1, 7672.39);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 3, 1, 6415.55);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 3, 1, 3451.74);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 3, 1, 3732.58);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 1, 1, 7148.45);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 3, 1, 1348.48);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 2, 1, 2725.6);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 3, 1, 5477.37);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 2, 1, 3587.35);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 1, 1, 1668.63);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 3, 1, 5991.34);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 2, 1, 2809.98);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 1, 1, 8727.26);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 1, 1, 2537.48);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 2, 1, 2932.78);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 2, 1, 3895.88);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 1, 1, 2483.4);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 3, 1, 7362.68);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (3, 3, 1, 3624.95);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 2, 1, 8869.91);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (1, 1, 1, 3827.56);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (4, 2, 1, 2712.98);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (2, 2, 1, 6837.74);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 3, 1, 9639.6);
INSERT INTO Compra (id_proveedor, id_empleado, id_sede, total) VALUES (5, 1, 1, 5302.56);

-- Insertar detalles de compra
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (1, 80, 4, 233.24);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (2, 5, 8, 84.52);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (3, 53, 19, 430.42);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (4, 12, 6, 113.81);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (5, 25, 15, 143.22);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (6, 28, 20, 109.39);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (7, 69, 9, 71.38);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (8, 24, 11, 97.78);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (9, 73, 6, 428.49);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (10, 64, 8, 195.71);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (11, 97, 10, 400.08);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (12, 40, 13, 147.13);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (13, 5, 5, 191.32);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (14, 92, 7, 423.34);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (15, 26, 20, 361.57);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (16, 22, 10, 441.98);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (17, 12, 2, 159.86);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (18, 79, 3, 471.73);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (19, 16, 19, 181.64);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (20, 52, 13, 298.6);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (21, 28, 10, 314.36);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (22, 21, 16, 351.23);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (23, 49, 12, 174.52);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (24, 21, 16, 380.63);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (25, 26, 16, 178.71);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (26, 1, 12, 175.62);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (27, 75, 18, 310.95);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (28, 78, 9, 207.75);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (29, 44, 13, 417.37);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (30, 65, 2, 373.01);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (31, 97, 15, 340.15);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (32, 17, 5, 352.17);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (33, 71, 13, 255.09);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (34, 63, 6, 99.63);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (35, 20, 13, 488.38);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (36, 88, 18, 420.52);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (37, 27, 13, 60.8);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (38, 57, 13, 318.43);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (39, 85, 20, 95.18);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (40, 14, 2, 217.7);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (41, 23, 12, 134.73);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (42, 8, 6, 472.56);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (43, 69, 1, 464.16);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (44, 99, 8, 217.51);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (45, 78, 17, 123.87);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (46, 91, 2, 486.93);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (47, 77, 19, 59.44);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (48, 63, 16, 108.95);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (49, 48, 5, 104.96);
INSERT INTO DetalleCompra (id_compra, id_producto, cantidad, precio_unitario) VALUES (50, 13, 7, 217.01);

INSERT INTO TipoPago (nombre, descripcion) VALUES ('Efectivo', 'Pago en efectivo');
INSERT INTO TipoPago (nombre, descripcion) VALUES ('Tarjeta', 'Pago con tarjeta de crédito/débito');
INSERT INTO TipoPago (nombre, descripcion) VALUES ('Transferencia', 'Pago por transferencia bancaria');

INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (1, 3, 5094.338426201423);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (2, 2, 5328.869922594297);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (3, 1, 4171.860408559325);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (4, 2, 2325.5809727825294);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (5, 2, 2654.2067957587356);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (6, 3, 4226.902248906353);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (7, 2, 1817.8901790001466);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (8, 1, 1364.6701469774225);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (9, 2, 2435.0883203550047);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (10, 3, 1532.5948530739795);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (11, 3, 5992.92321791339);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (12, 2, 257.6419978346681);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (13, 3, 5837.619139344627);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (14, 2, 1437.5930187010317);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (15, 2, 4513.0038577984515);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (16, 1, 4394.495850556729);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (17, 2, 351.90184505502);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (18, 3, 4911.884574659299);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (19, 2, 1280.1335044975574);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (20, 2, 849.4319281974942);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (21, 1, 5481.927306925645);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (22, 2, 3160.829760417181);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (23, 2, 5004.86983502474);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (24, 3, 5909.5989834960465);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (25, 1, 4949.961854615535);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (26, 1, 1735.3717701900391);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (27, 2, 1948.6225702669972);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (28, 3, 4609.2552292630235);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (29, 1, 807.2527578246214);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (30, 3, 963.1715592447104);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (31, 3, 5089.989279593678);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (32, 1, 2585.378581487344);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (33, 2, 3346.121811610804);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (34, 3, 3958.991372554939);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (35, 3, 1133.6589554974535);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (36, 3, 2231.009526167042);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (37, 1, 2568.1550527428485);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (38, 1, 5400.320716118846);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (39, 1, 2667.457260416042);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (40, 1, 4967.485468630983);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (41, 3, 5055.5427125583865);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (42, 1, 803.1088074992285);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (43, 1, 4156.186542201378);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (44, 3, 3797.8323990119393);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (45, 1, 1507.646138728325);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (46, 1, 3173.2688160181883);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (47, 3, 1858.3458876193718);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (48, 2, 3000.1385538251966);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (49, 1, 5585.151494508999);
INSERT INTO Pago (id_venta, id_tipo_pago, monto) VALUES (50, 2, 4251.28490319634);


-- ----------------------------------------------------------------------------------------------
-- CONSULTAS
-- ----------------------------------------------------------------------------------------------

-- TAREA
-- mostrar los ulrimas 10 compras (productos, quin hizo la compra)
-- mostrar las ultimas 10 ventas (producto, quin compro y vendio)

-- Ultimas 10 compras realizadas
select e.nombre as Empleado, c.id_compra as Compra, p.nombre as Producto, d.cantidad as Cantidad 
 from (select id_compra from Compra order by id_compra desc limit 10)uc 
 INNER JOIN Compra c ON uc.id_compra = c.id_compra
 inner join DetalleCompra d ON c.id_compra = d.id_compra
 INNER JOIN Producto p  ON d.id_producto = p.id_producto
 INNER JOIN Empleado e  ON c.id_empleado = e.id_empleado;
 
-- Ultimas 10 ventas realizadas
select c.nombre as Cliente, v.id_venta as Venta, p.nombre as Producto, e.nombre as Empleado from 
	(select id_venta from Venta order by id_venta desc limit 10)uv
	INNER JOIN Venta v ON uv.id_venta = v.id_venta
	INNER JOIN DetalleVenta d ON v.id_venta = d.id_venta
    INNER JOIN Producto p ON d.id_producto = p.id_producto
    INNER JOIN Cliente c ON v.id_cliente = c.id_cliente
    INNER JOIN Empleado e ON v.id_empleado = e.id_empleado;
 