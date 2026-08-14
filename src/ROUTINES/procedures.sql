USE registro_gimnasio;

/*
========================================================
            IF / THEN / ELSE
========================================================
*/
DROP PROCEDURE IF EXISTS sp_estado_plan_socio;
DELIMITER //
CREATE PROCEDURE sp_estado_plan_socio(IN p_socio_id INT)
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_cantidad
    FROM socio_plan_entrenamiento
    WHERE socio_id = p_socio_id;
    
    IF v_cantidad = 0 THEN
        SELECT 'El socio no tiene un plan de entrenamiento asignado' AS mensaje;
    ELSE
        SELECT 'El socio tiene un plan de entrenamiento asignado' AS mensaje;
    END IF;
END //
DELIMITER ;

CALL sp_estado_plan_socio(1);

/*
========================================================
                    CASE
========================================================
*/
DROP PROCEDURE IF EXISTS sp_clasificar_socio;
DELIMITER //
CREATE PROCEDURE sp_clasificar_socio(IN p_socio_id INT)
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_cantidad
    FROM socio_plan_entrenamiento
    WHERE socio_id = p_socio_id;
    
    CASE
        WHEN v_cantidad = 0 THEN SELECT 'SIN PLAN' AS categoria;
        WHEN v_cantidad = 1 THEN SELECT 'PLAN ACTIVO' AS categoria;
        ELSE SELECT 'MULTIPLES PLANES' AS categoria;
    END CASE;
END //
DELIMITER ;

CALL sp_clasificar_socio(1);

/*
========================================================
                    WHILE
========================================================
*/
DROP PROCEDURE IF EXISTS sp_insertar_ciudades_while;
DELIMITER //
CREATE PROCEDURE sp_insertar_ciudades_while()
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    
    WHILE v_contador <= 3 DO
        INSERT INTO ciudades (nombre_ciudad)
        VALUES (CONCAT('Ciudad Prueba ', v_contador));
        SET v_contador = v_contador + 1;
    END WHILE;
END //
DELIMITER ;

CALL sp_insertar_ciudades_while();

/*
========================================================
            REPEAT (Corregido con Cursor)
========================================================
*/
DROP PROCEDURE IF EXISTS sp_recorrer_socios_repeat;
DELIMITER //
CREATE PROCEDURE sp_recorrer_socios_repeat()
BEGIN
    DECLARE v_id INT;
    DECLARE v_nombre VARCHAR(120);
    DECLARE v_done INT DEFAULT 0;
    
    -- 1. Declarar el cursor
    DECLARE cur_socios CURSOR FOR SELECT socio_id, nombres FROM socios;
    -- 2. Declarar qué hacer cuando no haya más registros
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    OPEN cur_socios;
    
    REPEAT
        FETCH cur_socios INTO v_id, v_nombre;
        IF NOT v_done THEN
            SELECT CONCAT('Socio ID: ', v_id, ' - Nombre: ', v_nombre) AS informacion;
        END IF;
    UNTIL v_done 
    END REPEAT;
    
    CLOSE cur_socios;
END //
DELIMITER ;

CALL sp_recorrer_socios_repeat();

/*
========================================================
            LOOP (Corregido con Cursor)
========================================================
*/
DROP PROCEDURE IF EXISTS sp_recorrer_socios_loop;
DELIMITER //
CREATE PROCEDURE sp_recorrer_socios_loop()
BEGIN
    DECLARE v_nombre VARCHAR(120);
    DECLARE v_done INT DEFAULT 0;
    
    DECLARE cur_socios CURSOR FOR SELECT nombres FROM socios;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    OPEN cur_socios;
    
    recorrido: LOOP
        FETCH cur_socios INTO v_nombre;
        
        -- Si ya no hay datos, salir del LOOP
        IF v_done THEN
            LEAVE recorrido;
        END IF;
        
        SELECT CONCAT('Socio encontrado: ', v_nombre) AS resultado;
    END LOOP recorrido;
    
    CLOSE cur_socios;
END //
DELIMITER ;

CALL sp_recorrer_socios_loop();

/*
========================================================
                    PARAMETRO IN
========================================================
*/
DROP PROCEDURE IF EXISTS sp_buscar_socio;
DELIMITER //
CREATE PROCEDURE sp_buscar_socio(IN p_socio_id INT)
BEGIN
    SELECT socio_id, nombres, apellidos, telefono
    FROM socios
    WHERE socio_id = p_socio_id;
END //
DELIMITER ;

CALL sp_buscar_socio(3);

/*
========================================================
                    PARAMETRO OUT
========================================================
*/
DROP PROCEDURE IF EXISTS sp_contar_socios;
DELIMITER //
CREATE PROCEDURE sp_contar_socios(OUT p_total_socios INT)
BEGIN
    SELECT COUNT(*) INTO p_total_socios
    FROM socios;
END //
DELIMITER ;

CALL sp_contar_socios(@total);
SELECT @total AS total_socios;

/*
========================================================
                    PARAMETRO INOUT
========================================================
*/
DROP PROCEDURE IF EXISTS sp_incrementar_contador_socios;
DELIMITER //
CREATE PROCEDURE sp_incrementar_contador_socios(INOUT p_contador INT)
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total FROM socios;
    
    SET p_contador = p_contador + v_total;
END //
DELIMITER ;

SET @contador = 10;
CALL sp_incrementar_contador_socios(@contador);
SELECT @contador AS contador_final;

/*
========================================================
        MANEJO DE ERRORES - CODIGO ESPECIFICO
========================================================
*/
DROP PROCEDURE IF EXISTS sp_insertar_socio;
DELIMITER //
CREATE PROCEDURE sp_insertar_socio(IN p_nombres VARCHAR(120), IN p_apellidos VARCHAR(120), IN p_telefono VARCHAR(20))
BEGIN
    -- Manejador para error 1062 (Duplicate entry)
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT 'ERROR 1062: El telefono ya esta registrado' AS mensaje;
    END;
    
    INSERT INTO socios (nombres, apellidos, telefono)
    VALUES (p_nombres, p_apellidos, p_telefono);
    
    SELECT 'Socio registrado correctamente' AS mensaje;
END //
DELIMITER ;

/*
========================================================
        MANEJO DE ERRORES - TRANSACCION
========================================================
*/
DROP PROCEDURE IF EXISTS sp_asignar_plan;
DELIMITER //
CREATE PROCEDURE sp_asignar_plan(
    IN p_socio_id INT,
    IN p_plan_id INT,
    IN p_entrenador_id INT,
    IN p_sede_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: La transaccion fue cancelada debido a un error de base de datos' AS mensaje;
    END;
    
    START TRANSACTION;
        INSERT INTO socio_plan_entrenamiento (socio_id, plan_entrenamiento_id, entrenador_id, sede_id)
        VALUES (p_socio_id, p_plan_id,  p_entrenador_id, p_sede_id);
    COMMIT; 
    
    SELECT 'Plan asignado correctamente' AS mensaje;
END //
DELIMITER ;