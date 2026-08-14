USE registro_gimnasio;

/*
TRIGGER: verificar disponibilidad de entrenador antes de asignación
*/

USE registro_gimnasio;

DELIMITER //

CREATE TRIGGER tr_asignacion_entrenador
BEFORE INSERT ON socio_plan_entrenamiento
FOR EACH ROW
BEGIN
    DECLARE v_asignaciones INT;

    SELECT COUNT(*)
    INTO v_asignaciones
    FROM socio_plan_entrenamiento
    WHERE entrenador_id = NEW.entrenador_id
      AND sede_id = NEW.sede_id;

    IF v_asignaciones > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El entrenador no está disponible en esta sede.';
    END IF;
END//

DELIMITER ;

INSERT INTO socio_plan_entrenamiento
(socio_id, plan_entrenamiento_id, entrenador_id, sede_id)
VALUES
(1, 1, 2, 1);