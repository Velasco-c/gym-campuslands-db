/*
========================================================
            CREACION DE BASES DE DATOS
========================================================
*/

DROP DATABASE IF EXISTS registro_gimnasio;
CREATE DATABASE registro_gimnasio;
USE registro_gimnasio;

/*
========================================================
            CREACION DE TABLAS
========================================================
*/

CREATE TABLE socios (
    socio_id INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(120) NOT NULL,
    apellidos VARCHAR(120) NOT NULL,
    telefono VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE ciudades (
    ciudad_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ciudad VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE sedes (
    sede_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(120) NOT NULL,
    ciudad_id INT NOT NULL,

    CONSTRAINT fk_sede_ciudad
        FOREIGN KEY (ciudad_id)
        REFERENCES ciudades(ciudad_id)

) ENGINE=InnoDB;

CREATE TABLE especialidades_entrenadores (
    especialidad_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_especialidad VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE entrenadores (
    entrenador_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_entrenador VARCHAR(120) NOT NULL,
    especialidad_id INT NOT NULL,

    CONSTRAINT fk_entrenador_especialidad
        FOREIGN KEY (especialidad_id)
        REFERENCES especialidades_entrenadores(especialidad_id)

) ENGINE=InnoDB;

CREATE TABLE planes_entrenamiento (
    plan_entrenamiento_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_entrenamiento VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE socio_plan_entrenamiento (
    socio_plan_entrenamiento_id INT AUTO_INCREMENT PRIMARY KEY,
    socio_id INT NOT NULL,
    plan_entrenamiento_id INT NOT NULL,
    entrenador_id INT NOT NULL,
    sede_id INT NOT NULL,

    CONSTRAINT fk_spe_socio
        FOREIGN KEY (socio_id)
        REFERENCES socios(socio_id),

    CONSTRAINT fk_spe_plan
        FOREIGN KEY (plan_entrenamiento_id)
        REFERENCES planes_entrenamiento(plan_entrenamiento_id),

    CONSTRAINT fk_spe_entrenador
        FOREIGN KEY (entrenador_id)
        REFERENCES entrenadores(entrenador_id),

    CONSTRAINT fk_spe_sede
        FOREIGN KEY (sede_id)
        REFERENCES sedes(sede_id)

) ENGINE=InnoDB;
