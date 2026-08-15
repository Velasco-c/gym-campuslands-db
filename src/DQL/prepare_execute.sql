/*
========================================================
        PREPARE / EXECUTE / DEALLOCATE
        Base de datos: registro_gimnasio
========================================================
*/

USE registro_gimnasio;


/*
========================================================
1. CONSULTA DINAMICA DE SOCIOS POR ID
========================================================
*/

SET @sql = '
    SELECT socio_id, nombres, apellidos, telefono
    FROM socios
    WHERE socio_id = ?
';

PREPARE stmt FROM @sql;

SET @socio_id = 3;

EXECUTE stmt USING @socio_id;

DEALLOCATE PREPARE stmt;


/*
========================================================
2. CONSULTA DINAMICA CON ORDER BY
========================================================
*/

SET @columna = 'nombres';

SET @sql = CONCAT(
    'SELECT socio_id, nombres, apellidos, telefono ',
    'FROM socios ',
    'ORDER BY ', @columna
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


/*
========================================================
3. CONSULTA DINAMICA DE ENTRENADORES POR ESPECIALIDAD
========================================================
*/

SET @sql = '
    SELECT
        e.entrenador_id,
        e.nombre_entrenador,
        ee.nombre_especialidad
    FROM entrenadores AS e
    INNER JOIN especialidades_entrenadores AS ee
        ON ee.especialidad_id = e.especialidad_id
    WHERE ee.nombre_especialidad = ?
';

PREPARE stmt FROM @sql;

SET @especialidad = 'Musculacion';

EXECUTE stmt USING @especialidad;

DEALLOCATE PREPARE stmt;
