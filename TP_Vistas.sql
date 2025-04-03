create database TP_Vistas;
use TP_Vistas;



-- Tabla Clientes
CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    ciudad VARCHAR(50),
    email VARCHAR(50)
);

-- Tabla Productos
CREATE TABLE Productos (
    producto_id INT PRIMARY KEY,
    nombre_producto VARCHAR(50),
    categoria VARCHAR(50),
    precio DECIMAL(10, 2)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY,
    cliente_id INT,
    fecha_pedido DATE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- Tabla Detalle_Pedido
CREATE TABLE Detalle_Pedido (
    detalle_id INT PRIMARY KEY,
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- Insertar registros en Clientes
INSERT INTO Clientes (cliente_id, nombre, apellido, ciudad, email) VALUES
(1, 'Ana', 'García', 'Madrid', 'ana.garcia@email.com'),
(2, 'Juan', 'Pérez', 'Barcelona', 'juan.perez@email.com'),
(3, 'María', 'López', 'Madrid', 'maria.lopez@email.com'),
(4, 'Carlos', 'Ruiz', 'Valencia', 'carlos.ruiz@email.com');

-- Insertar registros en Productos
INSERT INTO Productos (producto_id, nombre_producto, categoria, precio) VALUES
(1, 'Laptop', 'Electrónicos', 1200.00),
(2, 'Tablet', 'Electrónicos', 300.00),
(3, 'Libro', 'Libros', 25.00),
(4, 'Smartphone', 'Electrónicos', 800.00);

-- Insertar registros en Pedidos
INSERT INTO Pedidos (pedido_id, cliente_id, fecha_pedido) VALUES
(1, 1, '2023-10-26'),
(2, 1, '2023-11-10'),
(3, 2, '2023-11-05'),
(4, 3, '2023-10-28'),
(5, 4, '2023-11-15');

-- Insertar registros en Detalle_Pedido
INSERT INTO Detalle_Pedido (detalle_id, pedido_id, producto_id, cantidad) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 2, 4, 1),
(4, 3, 3, 3),
(5, 4, 1, 1),
(6, 5, 2, 2),
(7, 5, 4, 1);

INSERT INTO Clientes (cliente_id,nombre, apellido, ciudad, email)
VALUES (9,'Juan', 'Pérez', 'Madrid', 'juan.perez@email.com');


-- EJERCICIO 1 
-- Crear la vista
CREATE or replace VIEW clientes_por_ciudad AS 
SELECT 
    cliente_id, nombre, apellido, ciudad, email
FROM Clientes 
WHERE ciudad = 'Madrid'
WITH CHECK OPTION;

SELECT * FROM clientes_por_ciudad;



-- EJERCICIO 2 
create or replace view resumen_ventas_categoria as 
select
	p.categoria,
    sum(dp.cantidad) as Suma_de_Cantidades
    from Productos p
    inner join Detalle_Pedido dp ON dp.producto_id = p.producto_id
    group by p.categoria;
    
select * from resumen_ventas_categoria;



-- EJERCICIO 3 
create or replace view clientes_total_pedidos as 
select concat(c.nombre, '', c.apellido) as Cliente,
	   count(p.pedido_id) as Cantidad_Pedidos
       from Clientes c 
       left join Pedidos p ON p.cliente_id = c.cliente_id
       group by Cliente;
	
select * from clientes_total_pedidos;



-- EJECICIO 4 
CREATE OR REPLACE VIEW productos_mas_vendidos_ciudad AS
 SELECT c.ciudad, p.nombre_producto, SUM(dp.cantidad) AS total_vendido
 FROM Clientes c
 JOIN Pedidos pe ON c.cliente_id = pe.cliente_id
 JOIN Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
 JOIN Productos p ON dp.producto_id = p.producto_id
 GROUP BY c.ciudad, p.nombre_producto;
select * from productos_mas_vendidos_ciudad;



-- EJERCICIO 5 
create or replace view ingresos_por_mes as
select 
	 date_format(pe.fecha_pedido, '%Y%m') as mes_anio,
     sum(dp.cantidad * pr.precio) as total_ingresos
from Pedidos pe
join Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
join Productos pr ON dp.producto_id = pr.producto_id
group by mes_anio;

select * from ingresos_por_mes;



-- EJERCICIO 6 
create or replace view productos_electronicos as
select 
	* 
    from Productos 
    where categoria = 'Electrónicos';
    
CREATE OR REPLACE VIEW ventas_electronicos AS
SELECT 
    pe.pedido_id,
    pe.fecha_pedido,
    c.cliente_id,
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    peo.producto_id,
    peo.nombre_producto,
    dp.cantidad,
    dp.cantidad * peo.precio AS total_venta
FROM Pedidos pe
JOIN Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
JOIN productos_electronicos peo ON dp.producto_id = peo.producto_id
JOIN Clientes c ON pe.cliente_id = c.cliente_id
WITH LOCAL CHECK OPTION;

select * from ventas_electronicos;



-- EJERCICIO 7 
CREATE OR REPLACE VIEW ventas_electronicos AS
SELECT 
    pe.pedido_id,
    pe.fecha_pedido,
    c.cliente_id,
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    peo.producto_id,
    peo.nombre_producto,
    dp.cantidad,
    dp.cantidad * peo.precio AS total_venta
FROM Pedidos pe
JOIN Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
JOIN productos_electronicos peo ON dp.producto_id = peo.producto_id
JOIN Clientes c ON pe.cliente_id = c.cliente_id
WITH cascaded CHECK OPTION;



-- EJERCICIO 8 
CREATE OR REPLACE VIEW clientes_productos_favoritos AS
SELECT 
    c.cliente_id,
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    p.nombre_producto AS producto_favorito
FROM Clientes c
JOIN Pedidos pe ON c.cliente_id = pe.cliente_id
JOIN Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
JOIN Productos p ON dp.producto_id = p.producto_id
WHERE dp.cantidad = (
    -- Subconsulta que encuentra la cantidad máxima comprada por este cliente
    SELECT MAX(total_comprado) 
    FROM (
        SELECT pe.cliente_id, dp.producto_id, SUM(dp.cantidad) AS total_comprado
        FROM Pedidos pe
        JOIN Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
        GROUP BY pe.cliente_id, dp.producto_id
    ) AS compras
    WHERE compras.cliente_id = c.cliente_id
)
GROUP BY c.cliente_id, p.nombre_producto
ORDER BY c.cliente_id;
select * from clientes_productos_favoritos;


-- EJERCICIO 9
CREATE OR REPLACE VIEW clientes_pedidos_recientes AS
SELECT 
    c.cliente_id,
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    (SELECT MAX(pe.fecha_pedido) 
     FROM Pedidos pe 
     WHERE pe.cliente_id = c.cliente_id) AS fecha_pedido_mas_reciente
FROM Clientes c;


CREATE OR REPLACE VIEW clientes_pedidos_recientes AS
SELECT 
    c.cliente_id,
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    pe.fecha_pedido AS fecha_pedido_mas_reciente,
    p.nombre_producto AS producto_mas_reciente
FROM Clientes c
JOIN Pedidos pe ON c.cliente_id = pe.cliente_id
JOIN Detalle_Pedido dp ON pe.pedido_id = dp.pedido_id
JOIN Productos p ON dp.producto_id = p.producto_id
WHERE pe.fecha_pedido = (
    -- Subconsulta que encuentra la fecha más reciente de pedido de cada cliente
    SELECT MAX(pe2.fecha_pedido) 
    FROM Pedidos pe2 
    WHERE pe2.cliente_id = c.cliente_id
)
ORDER BY c.cliente_id;







-- -------------------------------------------------------- INDICES ----------------------------------------------------------


-- EJERCICIO 10
CREATE INDEX idx_ciudad ON Clientes (Ciudad);
select 
	nombre,
    email
    from Clientes
    where ciudad = 'Madrid';


-- EJERCICIO 11 
create index idx_ej11 ON Pedidos (cliente_id, fecha_pedido);
select
	c.nombre,
    count(p.pedido_id) as Cant_Pedidos
    from Clientes c
    join Pedidos p ON p.cliente_id = c.cliente_id
    where p.fecha_pedido between '2025-01-01' and '2025-12-31'
    group by c.nombre;
    
    
    
-- EJERCICIO 12 
create unique index idx_ej12 ON Productos (producto_id);
INSERT INTO Productos (producto_id, nombre_producto, categoria, precio) VALUES (1,'fdsfs','Electronicos', 432);


-- EJERCICIO 13 
																-- Indice de texto para buscar informacion con palabras claves 
create fulltext index idx_ej13 on Productos (nombre_producto,categoria);
select 
	nombre_producto,
    categoria 
    from Productos 
    where  match(nombre_producto,categoria) against ('Laptop');


-- EJERCICIO 14 
create index idx_ej14 ON vvvvvvvvvvvvvvvvvvv   (producto_id, fecha 
