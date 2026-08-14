USE registro_gimnasio;
/*
========================================================
                CONSULTA AVANZADA - IN
========================================================
*/
SELECT sede_id, nombre_sede, ciudad_id
FROM sedes
WHERE ciudad_id IN (1, 2, 3);

SELECT nombre_sede
FROM sedes
WHERE ciudad_id IN (
    SELECT ciudad_id 
    FROM ciudades
    WHERE nombre_ciudad IN ('Guatemala', 'Mixco')
);

/*
========================================================
                CONSULTA AVANZADA - INNER JOIN
========================================================
*/
SELECT 
    s.socio_id, 
    CONCAT(s.nombres, ' ', s.apellidos) AS socio, 
    p.plan_entrenamiento, 
    e.nombre_entrenador, 
    ee.nombre_especialidad, 
    se.nombre_sede, 
    c.nombre_ciudad
FROM socio_plan_entrenamiento spe
INNER JOIN socios s ON spe.socio_id = s.socio_id
INNER JOIN planes_entrenamiento p ON spe.plan_entrenamiento_id = p.plan_entrenamiento_id
INNER JOIN entrenadores e ON spe.entrenador_id = e.entrenador_id
INNER JOIN especialidades_entrenadores ee ON e.especialidad_id = ee.especialidad_id
INNER JOIN sedes se ON spe.sede_id = se.sede_id
INNER JOIN ciudades c ON se.ciudad_id = c.ciudad_id;

/*
========================================================
            CONSULTA AVANZADA - AGREGACION
========================================================
*/
SELECT p.plan_entrenamiento, COUNT(spe.socio_id) AS cantidad_socios
FROM planes_entrenamiento p
INNER JOIN socio_plan_entrenamiento spe ON p.plan_entrenamiento_id = spe.plan_entrenamiento_id
GROUP BY p.plan_entrenamiento
ORDER BY cantidad_socios DESC;

/*
========================================================
        CONSULTA AVANZADA - ENTRENADORES
========================================================
*/
SELECT 
    e.nombre_entrenador, 
    ee.nombre_especialidad, 
    COUNT(spe.socio_id) AS socios_asignados
FROM entrenadores e
INNER JOIN especialidades_entrenadores ee ON e.especialidad_id = ee.especialidad_id
INNER JOIN socio_plan_entrenamiento spe ON e.entrenador_id = spe.entrenador_id
GROUP BY e.entrenador_id, e.nombre_entrenador, ee.nombre_especialidad
ORDER BY socios_asignados DESC;