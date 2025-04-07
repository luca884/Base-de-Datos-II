create database TP_Trigger;
-- drop database TP_Trigger;
use Tp_Trigger;

drop table AuditoriaGeneral;
CREATE TABLE AuditoriaGeneral (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tabla VARCHAR(50),
    tipo_accion VARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'
    fecha_hora DATETIME,
    usuario VARCHAR(50) 
);


CREATE TABLE Clientes (
ClienteID INT PRIMARY KEY,
Nombre VARCHAR(50),
Apellido VARCHAR(50),
Email VARCHAR(100),
Telefono VARCHAR(15)
);
CREATE TABLE Pedidos (
PedidoID INT PRIMARY KEY,
FechaPedido DATE,
ClienteID INT,
PrecioTotal DECIMAL(10,2),
FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);
CREATE TABLE Productos (
ProductoID INT PRIMARY KEY,
NombreProducto VARCHAR(100),
Precio DECIMAL(10, 2),
stock int
);

CREATE TABLE DetallesPedido (
DetalleID INT PRIMARY KEY,
PedidoID INT,
ProductoID INT,
Cantidad INT,
FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
INSERT INTO Clientes (ClienteID, Nombre, Apellido, Email, Telefono)
VALUES
(1, 'Juan', 'Pérez', 'juan@email.com', '123-456-7890'),
(2, 'María', 'Gómez', 'maria@email.com', '987-654-3210'),
(3, 'Carlos', 'López', 'carlos@email.com', '555-123-4567');
INSERT INTO Productos (ProductoID, NombreProducto, Precio)
VALUES
(101, 'Producto 1', 10.99),
(102, 'Producto 2', 19.99),
(103, 'Producto 3', 5.99);
INSERT INTO Pedidos (PedidoID, FechaPedido, ClienteID)
VALUES
(1001, '2023-10-15', 1),
(1002, '2023-10-16', 2),
(1003, '2023-10-17',3),
(1004, '2023-10-18',1);
INSERT INTO DetallesPedido (DetalleID, PedidoID, ProductoID, Cantidad)
VALUES
(2001, 1001, 101, 2),
(2002, 1001, 102, 1),
(2003, 1002, 103, 3),
(2004, 1003, 101, 1),
(2005, 1003, 103, 2),
(2006, 1004, 102, 2);



-- 1. Crear un trigger para auditar inserciones en la tabla Clientes.
DELIMITER //
create trigger log_Clientes_Insert
after insert ON Clientes
for each row 
begin	
	Insert into AuditoriaGeneral
    (nombre_tabla, tipo_accion ,fecha_hora, usuario ) 
    values 
    ('Clientes', 'Insert',now(),'admin');
end;
// DELIMITER ;
-- 2. Crear un trigger para auditar actualizaciones en la tabla Clientes.
DELIMITER //
create trigger log_Clientes_Update
after update ON Clientes
for each row
begin 
	Insert into AuditoriaGeneral
    (nombre_tabla, tipo_accion, fecha_hora, usuario)
    values 
    ('Clientes', 'Update', now(),'raul');
end ;
// DELIMITER ;
-- 3. Crear un trigger para auditar eliminaciones en la tabla Clientes.
DELIMITER // 
create trigger log_Clientes_Delete
after delete ON Clientes
for each row 
begin 
	Insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
    values
    ('Clientes','Delete', now(), 'augusto');
end ;
// DELIMITER ;
-- 4. Crear un trigger para actualizar el precio total en la tabla Pedidos.
DELIMITER //
create trigger actPrecioPedidos
after insert ON DetallesPedido
for each row
begin
	declare total decimal(10,2);
    
    select sum(dp.Cantidad * p.Precio) into total
    from DetallesPedido dp
    join Pedido p on dp.ProductoID = p.ProductoID
    where dp.PedidoID = new.PedidoID;
    
    update Pedidos 
    set PrecioTotal = total
    where PedidoID = new.PedidoID;
end;
// DELIMITER ;
-- 5. Crear un trigger para validar la cantidad de productos en la tabla DetallesPedido.
DELIMITER //
create trigger valCant
before insert ON DetallesPedido
for each row
begin
	if new.Cantidad <= 0 then
    signal sqlstate '45000'
    set message_text = 'Valor invalido';
    end if;
end ;
// delimiter ;
-- 6. Crear un trigger para actualizar el precio de un producto en la tabla Productos.
delimiter // 
create trigger actProducto
before update ON Productos
for each row
begin
	if new.Precio <> old.Precio then
	set new.Precio = new.Precio;
    end if;
end ;
// delimiter ;
-- 7. Crear un trigger para auditar inserciones en la tabla Pedidos.
delimiter //
create trigger InsPedidos
after insert ON Pedidos
for each row
begin
	insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
    values
    ('Pedidos', 'Insert', now(), 'hola mundo');
end ;
// delimiter ;
-- 8. Crear un trigger para auditar actualizaciones en la tabla Pedidos.
delimiter //
create trigger upPedidos
after update on Pedidos
for each row
begin 
	insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
	values
    ('Pedidos', 'Update', now(), 'María');
end ;
// delimiter ;
-- 9. Crear un trigger para auditar eliminaciones en la tabla Pedidos.
delimiter //
create trigger delPedidos
after delete ON Pedidos
for each row 
begin 
	insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
	value 
    ('Pedidos', 'Delete', now(), 'juan');
end ;
// delimiter ;
-- 10. Crear un trigger para actualizar el stock de productos en la tabla Productos.

-- 			QUE TENGO QUE HACER

-- 11. Crear un trigger para validar el email en la tabla Clientes.
delimiter //
create trigger valEmailClientes
before insert ON Clientes
for each row
begin 
	if new.Email not like '%@%.%' then 
    signal sqlstate '45001'
    set message_text = 'Email invalido';
    end if;
end ;
// delimiter ;
-- 12. Crear un trigger para auditar inserciones en la tabla Productos.
delimiter //
create trigger insProductos
after insert ON Productos
for each row
begin
	insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
	value 
    ('Productos','Insert', now(), 'Leandro');
end ;
// delimiter ;
-- 13. Crear un trigger para auditar actualizaciones en la tabla Productos.
delimiter //
create trigger upProductos
after update ON Productos
for each row
begin 
	insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
	value 
    ('Productos', 'Update', now(), 'Leonardo');
end;
// delimiter ;
-- 14. Crear un trigger para auditar eliminaciones en la tabla Productos.
delimiter //
create trigger delProductos 
after delete ON Productos
for each row 
begin
	insert into AuditoriaGeneral( nombre_tabla ,tipo_accion, fecha_hora, usuario)
	value 
    ('Productos', 'Delete', now(), 'oda');
end ;
// delimiter ;
-- 15. Crear un trigger para actualizar el stock de productos en la tabla Productos al 
-- eliminar un detalle de pedido.
delimiter //
 create trigger ej15
 after delete ON DetallesPedido
 for each row 
 begin 	
	update  Productos
    set stock = stock + old.Cantidad
    where ProductoID = old.ProductoID;
end ;
// delimiter ;
	







