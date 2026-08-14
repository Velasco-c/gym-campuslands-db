USE registro_gimnasio;

/*
EVENTO: reporte diario - cantidad de socios por entrenador
*/
CREATE TABLE IF NOT EXISTS reporte_socios_por_entrenador (
    entrenador_id INT NOT NULL,
    nombre_entrenador VARCHAR(120) NOT NULL,
    cantidad_socios INT NOT NULL
);

DELIMITER //

CREATE EVENT IF NOT EXISTS reporte
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    TRUNCATE TABLE reporte_socios_por_entrenador;
    INSERT INTO reporte_socios_por_entrenador (
        entrenador_id,
        nombre_entrenador,
        cantidad_socios)
    SELECT
        e.entrenador_id,
        e.nombre_entrenador,
        COUNT(sp.socio_id)
    FROM socio_plan_entrenamiento AS sp
    INNER JOIN entrenadores AS e
        ON e.entrenador_id = sp.entrenador_id
    GROUP BY
        e.entrenador_id,
        e.nombre_entrenador;
END//
DELIMITER ;
SELECT * FROM reporte_socios_por_entrenador;
