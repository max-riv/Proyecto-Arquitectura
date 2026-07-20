
-- CREAR BASE DE DATOS

CREATE DATABASE AeroCasilleroDB;
GO

USE AeroCasilleroDB;
GO


-- TABLA CLIENTE

CREATE TABLE Cliente(
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NOT NULL,
    Direccion VARCHAR(250) NOT NULL
);


-- TABLA CASILLERO

CREATE TABLE Casillero(
    IdCasillero INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    Codigo VARCHAR(30) NOT NULL UNIQUE,
    DireccionMiami VARCHAR(200) NOT NULL,

    CONSTRAINT FK_Casillero_Cliente
        FOREIGN KEY(IdCliente)
        REFERENCES Cliente(IdCliente)
);

-- TABLA USUARIO

CREATE TABLE Usuario(
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Usuario VARCHAR(50) NOT NULL UNIQUE,
    Contrasena VARCHAR(255) NOT NULL
);


-- TABLA ESTADO ENVIO

CREATE TABLE EstadoEnvio(
    IdEstado INT IDENTITY(1,1) PRIMARY KEY,
    NombreEstado VARCHAR(50) NOT NULL
);


-- TABLA METODO ENTREGA

CREATE TABLE MetodoEntrega(
    IdMetodo INT IDENTITY(1,1) PRIMARY KEY,
    NombreMetodo VARCHAR(50) NOT NULL
);


-- TABLA ENVIO

CREATE TABLE Envio(
    IdEnvio INT IDENTITY(1,1) PRIMARY KEY,
    IdEstado INT NOT NULL,
    IdMetodo INT NOT NULL,
    ValorCIF DECIMAL(10,2) NOT NULL,
    Impuestos DECIMAL(10,2) NOT NULL,
    PesoFacturable DECIMAL(10,2) NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Envio_Estado
        FOREIGN KEY(IdEstado)
        REFERENCES EstadoEnvio(IdEstado),

    CONSTRAINT FK_Envio_MetodoEntrega
        FOREIGN KEY(IdMetodo)
        REFERENCES MetodoEntrega(IdMetodo)
);


-- TABLA PAQUETE

CREATE TABLE Paquete(
    IdPaquete INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    IdEnvio INT NOT NULL,
    Tracking VARCHAR(50) NOT NULL UNIQUE,
    PesoReal DECIMAL(10,2) NOT NULL,
    PesoVolumetrico DECIMAL(10,2) NOT NULL,
    PesoFacturable DECIMAL(10,2) NOT NULL,
    Alto DECIMAL(10,2) NOT NULL,
    Ancho DECIMAL(10,2) NOT NULL,
    Largo DECIMAL(10,2) NOT NULL,
    Estado VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Paquete_Cliente
        FOREIGN KEY(IdCliente)
        REFERENCES Cliente(IdCliente),

    CONSTRAINT FK_Paquete_Envio
        FOREIGN KEY(IdEnvio)
        REFERENCES Envio(IdEnvio)
);

-- TABLA FACTURA

CREATE TABLE Factura(
    IdFactura INT IDENTITY(1,1) PRIMARY KEY,
    IdEnvio INT NOT NULL,
    NumeroFactura VARCHAR(30) NOT NULL UNIQUE,
    Subtotal DECIMAL(10,2) NOT NULL,
    IVA DECIMAL(10,2) NOT NULL,
    DAI DECIMAL(10,2) NOT NULL,
    Total DECIMAL(10,2) NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Factura_Envio
        FOREIGN KEY(IdEnvio)
        REFERENCES Envio(IdEnvio)
);


-- TABLA DECLARACION ADUANERA

CREATE TABLE DeclaracionAduanera(
    IdDeclaracion INT IDENTITY(1,1) PRIMARY KEY,
    IdEnvio INT NOT NULL,
    NumeroDeclaracion VARCHAR(50) NOT NULL UNIQUE,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Declaracion_Envio
        FOREIGN KEY(IdEnvio)
        REFERENCES Envio(IdEnvio)
);

-- TABLA EXENCION

CREATE TABLE Exencion(
    IdExencion INT IDENTITY(1,1) PRIMARY KEY,
    IdEnvio INT NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Porcentaje DECIMAL(5,2) NOT NULL,

    CONSTRAINT FK_Exencion_Envio
        FOREIGN KEY(IdEnvio)
        REFERENCES Envio(IdEnvio)
);


-- INSERTAR CLIENTES

INSERT INTO Cliente (Nombre, Correo, Telefono, Direccion)
VALUES
('Juan Perez', 'juan@gmail.com', '8888-1111', 'Alajuela, Costa Rica'),
('Maria Rodriguez', 'maria@gmail.com', '8888-2222', 'San Jose, Costa Rica'),
('Carlos Jimenez', 'carlos@gmail.com', '8888-3333', 'Heredia, Costa Rica'),
('Ana Vargas', 'ana@gmail.com', '8888-4444', 'Cartago, Costa Rica');



-- INSERTAR CASILLEROS

INSERT INTO Casillero (IdCliente, Codigo, DireccionMiami)
VALUES
(1, 'CAS-JP001', '1234 NW 25th St, Miami FL'),
(2, 'CAS-MR002', '4567 SW 10th Ave, Miami FL'),
(3, 'CAS-CJ003', '8900 Biscayne Blvd, Miami FL'),
(4, 'CAS-AV004', '321 Ocean Drive, Miami FL');


-- INSERTAR USUARIOS


INSERT INTO Usuario (Nombre, Usuario, Contrasena)
VALUES
('Administrador Sistema', 'admin', 'admin123'),
('Carlos Soporte', 'csoporte', 'soporte123'),
('Maria Gestion', 'mgestion', 'gestion123');



-- INSERTAR ESTADOS DE ENVIO

INSERT INTO EstadoEnvio (NombreEstado)
VALUES
('Registrado'),
('En Miami'),
('En Transito'),
('En Aduana'),
('Entregado');



-- INSERTAR METODOS DE ENTREGA


INSERT INTO MetodoEntrega (NombreMetodo)
VALUES
('Aereo'),
('Maritimo'),
('Terrestre');


-- INSERTAR ENVIOS


INSERT INTO Envio 
(IdEstado, IdMetodo, ValorCIF, Impuestos, PesoFacturable)
VALUES
(1, 1, 150.00, 25.00, 3.50),
(2, 1, 300.00, 60.00, 5.20),
(3, 1, 500.00, 100.00, 8.00),
(4, 2, 800.00, 160.00, 12.50);



-- INSERTAR PAQUETES


INSERT INTO Paquete
(IdCliente, IdEnvio, Tracking, PesoReal, PesoVolumetrico,
 PesoFacturable, Alto, Ancho, Largo, Estado)
VALUES
(1, 1, 'TRK001ABC', 3.00, 3.50, 3.50, 20, 15, 30, 'Registrado'),

(2, 2, 'TRK002DEF', 4.50, 5.20, 5.20, 25, 20, 40, 'En Miami'),

(3, 3, 'TRK003GHI', 7.00, 8.00, 8.00, 30, 25, 50, 'En Transito'),

(4, 4, 'TRK004JKL', 10.00, 12.50, 12.50, 40, 30, 60, 'En Aduana');


-- INSERTAR FACTURAS


INSERT INTO Factura
(IdEnvio, NumeroFactura, Subtotal, IVA, DAI, Total)
VALUES
(1, 'FAC-0001', 150.00, 19.50, 5.50, 175.00),

(2, 'FAC-0002', 300.00, 39.00, 21.00, 360.00),

(3, 'FAC-0003', 500.00, 65.00, 35.00, 600.00),

(4, 'FAC-0004', 800.00, 104.00, 56.00, 960.00);


-- INSERTAR DECLARACIONES ADUANERAS


INSERT INTO DeclaracionAduanera
(IdEnvio, NumeroDeclaracion)
VALUES
(2, 'DECL-0001'),
(3, 'DECL-0002'),
(4, 'DECL-0003');



-- INSERTAR EXENCIONES


INSERT INTO Exencion
(IdEnvio, Tipo, Porcentaje)
VALUES
(1, 'Exento Educativo', 50.00),
(3, 'Tratado Comercial', 25.00),
(4, 'Importacion Especial', 10.00);








