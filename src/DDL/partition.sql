/*
========================================================
        PARTICIONAMIENTO DE TABLAS EN MYSQL
        Base de datos: registro_gimnasio
========================================================

*/

USE registro_gimnasio;

DROP TABLE IF EXISTS historial_asignaciones;

CREATE TABLE historial_asignaciones (
    historial_id BIGINT AUTO_INCREMENT,
    socio_id INT NOT NULL,
    plan_entrenamiento_id INT NOT NULL,
    entrenador_id INT NOT NULL,
    sede_id INT NOT NULL,
    fecha_asignacion DATE NOT NULL,

    PRIMARY KEY (historial_id, fecha_asignacion)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(fecha_asignacion)) (
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p2027 VALUES LESS THAN (2028),
    PARTITION p2028 VALUES LESS THAN (2029),
    PARTITION p_futuro VALUES LESS THAN MAXVALUE
);


/*
========================================================
INSERTAR DATOS DE PRUEBA
========================================================
*/

INSERT INTO historial_asignaciones
(socio_id, plan_entrenamiento_id, entrenador_id, sede_id, fecha_asignacion)
VALUES
(1, 2, 1, 1, '2026-01-15'),
(2, 1, 3, 2, '2026-03-10'),
(3, 5, 5, 3, '2026-06-20'),
(4, 4, 4, 1, '2027-02-05'),
(5, 2, 1, 2, '2027-08-18'),
(6, 3, 3, 4, '2028-01-22'),
(7, 5, 5, 3, '2028-11-12'),
(8, 4, 4, 1, '2029-04-03');


/*
========================================================
CONSULTAR LA TABLA
========================================================
*/

SELECT *
FROM historial_asignaciones
ORDER BY fecha_asignacion;


/*
========================================================
VER LAS PARTICIONES CREADAS
========================================================
*/

SELECT
    TABLE_NAME,
    PARTITION_NAME,
    PARTITION_METHOD,
    PARTITION_EXPRESSION,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'registro_gimnasio'
  AND TABLE_NAME = 'historial_asignaciones';


/*
========================================================
CONSULTAR UNA PARTICION ESPECIFICA
========================================================
*/

SELECT *
FROM historial_asignaciones PARTITION (p2026);


