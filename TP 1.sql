create database TP1;
use TP1;

---------------------------------------------
-- PARA EJERCICIOS 1 - 4


CREATE TABLE ejemplo_tabla (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

DELIMITER //
create procedure insertarEnTablaInexis(in nombre varchar(30))
BEGIN 
	declare  continue handler for sqlexception
    begin 
		select 'No se inserto correctamente' as mensaje;
	end;
    
	Insert into ejemplo_tabla(nombre) values (nombre);

	select 'Se ingreso correctamente' as mensaje;
END //
DELIMITER;

call insertarEnTablaInexis('luca');


DELIMITER // 
create procedure crearTablaExistente() -- se ejecuta pero me lanza el error la maquina y no el handler 
Begin 
	declare exit handler for sqlwarning
    begin 
		select 'Ya existe con una tabla con ese nombre' as mensaje;
	end;
    
    CREATE TABLE ejemplo_tabla (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
	);

	select 'Se creo la tabla correctamente' as mensaje;
    
END //
DELIMITER ;

call crearTablaExistente;


DELIMITER //

CREATE PROCEDURE seleccionarRegistrnexistent(IN id_select INT)  -- Siempre dice que encontro el id
BEGIN 
    DECLARE resultado INT;
    
    -- Manejo del error si no se encuentra el registro
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    BEGIN 
        SELECT 'No se encontró el ID seleccionado' AS mensaje;
    END;
    
    -- Intentar obtener el ID de la tabla (suponiendo que la tabla se llama 'ejemplo_tabla')
    SELECT id 
    FROM ejemplo_tabla
    WHERE id = id_select;
    
    -- Si encuentra el ID, muestra un mensaje
    SELECT 'Se encontró el ID seleccionado' AS mensaje;
    
END //

DELIMITER ;

call seleccionarRegistrnexistent(2);



DELIMITER //
create procedure manejoCombinado (in nombre_p varchar(20))
Begin 
	declare continue handler for sqlexception
    Begin 
		select 'No se pudo ingresar correctamente' as mensaje;
	End; 
		
        
	declare continue handler for sqlexception
    Begin 
		select 'Ya existe esta tabla' as mensaje; 
    End;
    
    insert into ejemplo_tabla(nombre) values (nombre_p);
    
    -- Intentar crear una tabla que ya existe
    CREATE TABLE ejemplo_tabla (
        id INT PRIMARY KEY,
        nombre VARCHAR(50)
    );
    
        

End //
DELIMITER ;








-- PARA EJERCICIOS 5 Y 6


CREATE TABLE socios (
    id_socio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE,
    direccion VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE planes (
    id_plan INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    duracion INT,
    precio DECIMAL(10, 2),
    servicios TEXT
);

CREATE TABLE actividades (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT,
    id_plan INT,
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio),
    FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
);



create 






