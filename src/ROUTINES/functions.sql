USE registro_gimnasio;

/*
========================================================
1. FUNCION SIMPLE
   CALCULAR COMISION DEL ENTRENADOR
========================================================
*/

DROP FUNCTION IF EXISTS fn_calcular_comision_entrenador;

DELIMITER //

CREATE FUNCTION fn_calcular_comision_entrenador(
    p_monto DECIMAL(10,2),
    p_porcentaje DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN ROUND(p_monto * (p_porcentaje / 100), 2);
END//

DELIMITER ;

-- Prueba:
SELECT fn_calcular_comision_entrenador(5000.00, 10.00)
AS comision;


/*
========================================================
2. FUNCION QUE UTILIZA CONDICIONES
   CLASIFICAR ENTRENADOR SEGUN SUS SOCIOS ASIGNADOS
========================================================
*/

DROP FUNCTION IF EXISTS fn_clasificar_entrenador;

DELIMITER //

CREATE FUNCTION fn_clasificar_entrenador(
    p_entrenador_id INT
)
RETURNS VARCHAR(30)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_total
    FROM socio_plan_entrenamiento
    WHERE entrenador_id = p_entrenador_id;

    IF v_total = 0 THEN
        RETURN 'SIN SOCIOS';
    ELSEIF v_total <= 2 THEN
        RETURN 'CARGA BAJA';
    ELSEIF v_total <= 4 THEN
        RETURN 'CARGA MEDIA';
    ELSE
        RETURN 'CARGA ALTA';
    END IF;
END//

DELIMITER ;

-- Prueba:
SELECT
    entrenador_id,
    nombre_entrenador,
    fn_clasificar_entrenador(entrenador_id) AS categoria
FROM entrenadores;


/*
========================================================
3. FUNCION CON BUCLE / ESTRUCTURA ITERATIVA
   CONTAR SOCIOS MEDIANTE CURSOR + LOOP
========================================================
*/

DROP FUNCTION IF EXISTS fn_contar_socios_loop;

DELIMITER //

CREATE FUNCTION fn_contar_socios_loop(
    p_entrenador_id INT
)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_socio_id INT;
    DECLARE v_total INT DEFAULT 0;
    DECLARE v_fin BOOLEAN DEFAULT FALSE;

    DECLARE cur_socios CURSOR FOR
        SELECT socio_id
        FROM socio_plan_entrenamiento
        WHERE entrenador_id = p_entrenador_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_fin = TRUE;

    OPEN cur_socios;

    recorrido: LOOP
        FETCH cur_socios INTO v_socio_id;

        IF v_fin THEN
            LEAVE recorrido;
        END IF;

        SET v_total = v_total + 1;
    END LOOP recorrido;

    CLOSE cur_socios;

    RETURN v_total;
END//

DELIMITER ;

-- Prueba:
SELECT
    entrenador_id,
    nombre_entrenador,
    fn_contar_socios_loop(entrenador_id) AS socios_asignados
FROM entrenadores;


/*
========================================================
4. FUNCION QUE ACCEDE A DATOS DE LA BASE
========================================================
*/

DROP FUNCTION IF EXISTS fn_nombre_entrenador;

DELIMITER //

CREATE FUNCTION fn_nombre_entrenador(
    p_entrenador_id INT
)
RETURNS VARCHAR(120)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_nombre VARCHAR(120);

    SELECT nombre_entrenador
    INTO v_nombre
    FROM entrenadores
    WHERE entrenador_id = p_entrenador_id;

    RETURN v_nombre;
END//

DELIMITER ;

-- Prueba:
SELECT
    socio_id,
    nombres,
    apellidos,
    fn_nombre_entrenador(entrenador_id) AS entrenador
FROM socios
INNER JOIN socio_plan_entrenamiento USING (socio_id);


/*
========================================================
5. FUNCION NO DETERMINISTICA
========================================================
*/

DROP FUNCTION IF EXISTS fn_generar_codigo_gym;

DELIMITER //

CREATE FUNCTION fn_generar_codigo_gym()
RETURNS VARCHAR(40)
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT(
        'GYM-',
        DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'),
        '-',
        LPAD(FLOOR(RAND() * 100000), 5, '0')
    );
END//

DELIMITER ;

-- Prueba:
SELECT fn_generar_codigo_gym() AS codigo_1;
SELECT fn_generar_codigo_gym() AS codigo_2;


/*
========================================================
6. FUNCION CON MANEJO DE ERRORES
========================================================
*/

DROP FUNCTION IF EXISTS fn_validar_entrenador;

DELIMITER //

CREATE FUNCTION fn_validar_entrenador(
    p_entrenador_id INT
)
RETURNS VARCHAR(120)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_nombre VARCHAR(120);

    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: El entrenador indicado no existe.';
    END;

    SELECT nombre_entrenador
    INTO v_nombre
    FROM entrenadores
    WHERE entrenador_id = p_entrenador_id;

    RETURN v_nombre;
END//

DELIMITER ;

-- Prueba correcta:
SELECT fn_validar_entrenador(1) AS entrenador;
