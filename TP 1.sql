create database TP1_LucaBdd2;
use TP1_LucaBdd2;

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

-- call crearTablaExistente;


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



DELIMITER //
create procedure ertarActividad(in id_socio_p int, in id_plan_p int)
Begin
	declare id1 int;
    declare id2 int;

	declare exit handler for sqlexception
    begin 
		select 'El id socio/plan no existe' AS Mensaje;
	end;
   select id_plan into id1 from planes where id_plan = id_plan_p;
   select id_socio into id2 from socios where id_socio = id_socio_p;
	if exists (SELECT 1 FROM PLANES, SOCIOS WHERE ID_PLAN = ID_PLAN_P AND ID_SOCIO = ID_SOCIO_P) THEN
	insert into actividades (id_socio, id_plan) values (id2, id1);
    select 'Se ingreso correctamente la actividad' as mensaje;
    end if;

END // 
DELIMITER ;

call ertarActividad(2,1);

insert into planes (nombre,duracion,precio,servicios) values ('basquet', 1 , 323432, 'fdsfsf');
insert into socios (nombre,apellido,fecha_nacimiento, direccion, telefono) values ('luca', 'mariño', 432, 'fsdfsd', 4234234); 

select * from socios;
select * from actividades;



DELIMITER // 
create procedure registro(in id_p int)
Begin 
	declare continue handler for not found
    Begin 
		select 'NO se encontro el id' as mensaje;
	end;

	select * from socios where id_socio = id_p; 

end // 
DELIMITER ;
drop procedure registro;
call registro(2);




DELIMITER //

DELIMITER //
drop procedure registrarSocioConPlan; -- NO RESULTO
CREATE PROCEDURE registrarSocioConPlan(IN nombre_p VARCHAR(50),IN apellido_p VARCHAR(50),IN fecha_nacimiento_p DATE,
IN direccion_p VARCHAR(100),IN telefono_p VARCHAR(20),IN id_plan_p INT)
BEGIN
    DECLARE socio_id INT;
    DECLARE mensaje_error VARCHAR(255);
    

END //

DELIMITER ;


CALL registrarSocioConPlan('Juan','Pérez','1990-05-15','savio' ,'123456789',1);




drop procedure actualizarPlanYRegistrarActividad;
DELIMITER // 
CREATE PROCEDURE actualizarPlanYRegistrarActividad(in id_plan_p int, in precio_p double, in id_socio_p int,in id_actividad_p int )
Begin
	declare exit handler for sqlexception
    begin 
		rollback;
        select 'Se a cancelado la actualizacion' as mensaje;
	end;

    if(select 1 from planes where id_planes = id_plan_p) then
		update planes
        set precio = precio_p
        where id_plan = id_plan_p;
	else 
		rollback;
        select 'No existe ese plan ' as mensaje;
		LEAVE actualizarPlanYRegistrarActividad;
    end if;
    
    
    if (id_socio_p is null and id_actividad_p is null) then
		rollback; 
        select 'ID socio/Actividad no existen ' as mensaje;
        LEAVE proc_block;
	end if;
	
    insert into actividades(id_socio, id_plan) values (id_socio_p,id_actividad_p);
    commit;
    
    select 'Se han realizado todos los cambios' as mensaje; 
        

proc_block : End //
DELIMITER ;



DELIMITER //
CREATE procedure eliminarSocioYActividades(in id_socio_p int ) 
Begin 
	bloque : Begin
	declare exit handler for sqlexception
    Begin 
		rollback;
        select 'Se produjo un error ' as mensaje;
	end;
    
    START transaction;
    IF NOT EXISTS (SELECT 1 FROM socios WHERE id_socio = id_socio_p) THEN
		rollback;
        select 'El socio no existe ' as mensaje;
		leave bloque;
	END IF;
     
    delete from actividades where id_socio = id_socio_p;
	DELETE from socios where id_socio = id_socio_p;
    
    commit;
    select 'Se elimino todo correctamente ' as mensaje;

	end bloque ;
end // 
DELIMITER ;

-- para usar LEAVE etiquetar el codigo en un bloque y a lo ultimo pone end bloque ; y funciona 
	