/*
========================================================
            INSERCION DE REGISTROS EN TABLAS
========================================================
*/

USE registro_gimnasio;

INSERT INTO ciudades (nombre_ciudad)
VALUES
('Madrid');

INSERT INTO sedes (nombre_sede, ciudad_id)
VALUES
('Sede Central Madrid', 1),
('Sede Norte Madrid', 1);

INSERT INTO socios (nombres, apellidos, telefono)
VALUES
('Ana', 'Pérez', '555-1234'),
('Luis', 'Gómez', '555-5678'),
('Carla', 'Ruíz', '555-9012');

INSERT INTO especialidades_entrenadores (nombre_especialidad)
VALUES
('Yoga'),
('Musculación'),
('Funcional'),
('Boxeo');

INSERT INTO entrenadores (nombre_entrenador, especialidad_id)
VALUES
('Carlos', 1),
('Marta', 2),
('Iván', 3),
('Diego', 4);

INSERT INTO planes_entrenamiento (plan_entrenamiento)
VALUES
('Yoga'),
('Pesas'),
('CrossFit'),
('Boxeo');

INSERT INTO socio_plan_entrenamiento
(
    socio_id,
    plan_entrenamiento_id,
    entrenador_id,
    sede_id
)
VALUES
(1, 1, 1, 1),
(1, 2, 2, 1),
(2, 3, 3, 2),
(3, 2, 2, 1),
(3, 4, 4, 1);
