/*
========================================================
            INSERCION DE DATOS
========================================================
*/

INSERT INTO ciudades (nombre_ciudad) VALUES
('Guatemala'),
('Mixco'),
('Villa Nueva'),
('Escuintla');

INSERT INTO sedes (nombre_sede, ciudad_id) VALUES
('GYM Zona 1', 1),
('GYM Mixco', 2),
('GYM Villa Nueva', 3),
('GYM Escuintla', 4);

INSERT INTO especialidades_entrenadores (nombre_especialidad) VALUES
('Musculacion'),
('CrossFit'),
('Cardio'),
('Funcional'),
('Powerlifting');

INSERT INTO entrenadores (nombre_entrenador, especialidad_id) VALUES
('Carlos Ramirez', 1),
('Ana Lopez', 2),
('Miguel Castillo', 3),
('Sofia Morales', 4),
('Diego Perez', 5);

INSERT INTO planes_entrenamiento (plan_entrenamiento) VALUES
('Plan de perdida de peso'),
('Plan de hipertrofia'),
('Plan de resistencia'),
('Plan funcional'),
('Plan de fuerza');

INSERT INTO socios (nombres, apellidos, telefono) VALUES
('Juan', 'Perez', '55510001'),
('Maria', 'Lopez', '55510002'),
('Pedro', 'Gonzalez', '55510003'),
('Ana', 'Martinez', '55510004'),
('Luis', 'Ramirez', '55510005'),
('Sofia', 'Hernandez', '55510006'),
('Carlos', 'Morales', '55510007'),
('Laura', 'Castillo', '55510008');

INSERT INTO socio_plan_entrenamiento
(socio_id, plan_entrenamiento_id, entrenador_id, sede_id)
VALUES
(1, 2, 1, 1),
(2, 1, 3, 2),
(3, 5, 5, 3),
(4, 4, 4, 1),
(5, 2, 1, 2),
(6, 3, 3, 4),
(7, 5, 5, 3),
(8, 4, 4, 1);