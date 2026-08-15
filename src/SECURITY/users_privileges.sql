/*
========================================================
        CREACION DE USUARIOS Y PRIVILEGIOS
        Base de datos: registro_gimnasio
========================================================
*/

USE registro_gimnasio;


/*
========================================================
1. CREAR USUARIO DE CONSULTA
========================================================
*/

CREATE USER IF NOT EXISTS 'gym_consulta'@'localhost'
IDENTIFIED BY 'GymConsulta_2026!';


/*
========================================================
2. ASIGNAR PERMISOS DE CONSULTA
========================================================
*/

GRANT SELECT
ON registro_gimnasio.*
TO 'gym_consulta'@'localhost';


/*
========================================================
3. VER PRIVILEGIOS DE UN USUARIO
========================================================
*/

SHOW GRANTS FOR 'gym_consulta'@'localhost';


/*
========================================================
4. CREACION DE USUARIO ADMINISTRADOR
========================================================
*/

CREATE USER IF NOT EXISTS 'gym_admin'@'localhost'
IDENTIFIED BY 'GymAdmin_2026!';


/*
========================================================
5. ASIGNAR TODOS LOS PRIVILEGIOS SOBRE EL GYM
========================================================
*/

GRANT ALL PRIVILEGES
ON registro_gimnasio.*
TO 'gym_admin'@'localhost';


/*
========================================================
6. VER PRIVILEGIOS DEL ADMINISTRADOR
========================================================
*/

SHOW GRANTS FOR 'gym_admin'@'localhost';


/*
========================================================
7. USUARIO CON PERMISOS ESPECIFICOS SOBRE UNA TABLA
========================================================
*/

CREATE USER IF NOT EXISTS 'gym_operador'@'localhost'
IDENTIFIED BY 'GymOperador_2026!';

GRANT SELECT, INSERT
ON registro_gimnasio.socios
TO 'gym_operador'@'localhost';

SHOW GRANTS FOR 'gym_operador'@'localhost';


/*
========================================================
8. PRIVILEGIOS SOBRE COLUMNAS
========================================================
*/

CREATE USER IF NOT EXISTS 'gym_reporte'@'localhost'
IDENTIFIED BY 'GymReporte_2026!';

GRANT SELECT (
    socio_id,
    nombres,
    apellidos
)
ON registro_gimnasio.socios
TO 'gym_reporte'@'localhost';

SHOW GRANTS FOR 'gym_reporte'@'localhost';


/*
========================================================
9. PRIVILEGIOS SOBRE COLUMNAS PARA UPDATE
========================================================
*/

GRANT UPDATE (telefono)
ON registro_gimnasio.socios
TO 'gym_reporte'@'localhost';


/*
========================================================
10. COMPROBAR PRIVILEGIOS
========================================================
*/

SHOW GRANTS FOR 'gym_reporte'@'localhost';


/*
========================================================
11. APLICAR CAMBIOS DE PRIVILEGIOS
========================================================
*/

FLUSH PRIVILEGES;
