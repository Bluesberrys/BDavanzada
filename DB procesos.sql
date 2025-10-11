CONNECT SYS AS SYSDBA
-- 090322

CREATE TABLESPACE UNAM DATAFILE 'D:/Projects/BDavanzada/UNAM.DBF' SIZE 5M;

CREATE USER BLUE IDENTIFIED BY 090322 DEFAULT TABLESPACE UNAM;

GRANT CONNECT, CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, UNLIMITED TABLESPACE TO BLUE;

CREATE USER APOLLO IDENTIFIED BY 090322 DEFAULT TABLESPACE UNAM;

GRANT CONNECT, CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, UNLIMITED TABLESPACE TO APOLLO;

CONNECT BLUE
-- 090322

SELECT * FROM CAT;

CREATE TABLE AREA (
    ID_MATERIA VARCHAR(3) PRIMARY KEY,
    DESCRIPCION_MATERIA VARCHAR(30)
);

CREATE TABLE CURSO (
    NUM_CURSO VARCHAR(10) PRIMARY KEY,
    NOMBRE_CURSO VARCHAR(30),
    CREDITOS VARCHAR(2)
);

CREATE TABLE ESTUDIANTE (
    ID_ESTUDIANTE VARCHAR(4) PRIMARY KEY,
    APELLIDO VARCHAR(15),
    NOMBRE VARCHAR(15),
    INICIAL CHAR(1),
    ID_MATERIA VARCHAR(3),
    CONSTRAINT A_AREA
    FOREIGN KEY (ID_MATERIA) REFERENCES AREA(ID_MATERIA)
);

CREATE TABLE INSCRIPCION (
    ID_ESTUDIANTE VARCHAR(4),
    NUM_CURSO VARCHAR(10),
    FECHA_FIN DATE,
    PRIMARY KEY (ID_ESTUDIANTE, NUM_CURSO),
    CONSTRAINT A_CURSO
    FOREIGN KEY (NUM_CURSO) REFERENCES CURSO(NUM_CURSO),
    CONSTRAINT A_ESTUDIANTE
    FOREIGN KEY (ID_ESTUDIANTE) REFERENCES ESTUDIANTE(ID_ESTUDIANTE)
);

insert all
    INTO AREA VALUES ('MAT', 'Matematicas')
    INTO AREA VALUES ('FIl', 'Filosofia')
    INTO AREA VALUES ('ING', 'Literatura inglesa')
    INTO AREA VALUES ('MUS', 'Musica')
    INTO AREA VALUES ('CC', 'Ciencias de la computacion')
    INTO CURSO VALUES ('MAT0011', 'Matematicas discretas', '12')
    INTO CURSO VALUES ('MAT0027', 'Calculo I', '12')
    INTO CURSO VALUES ('ING0010', 'Ingles Clasico', '8')
    INTO CURSO VALUES ('FIL0010', 'Introduccion a la filosofia', '8')
    INTO CURSO VALUES ('CC00010', 'Lenguajes de programacion', '10')
    INTO CURSO VALUES ('SOC0102', 'Ascenso del hombre', '8')
    INTO CURSO VALUES ('MUS0002', 'Origen del Jazz', '8')
    INTO CURSO VALUES ('ING0101', 'Shakespeare II', '8')
    INTO ESTUDIANTE VALUES ('2907', 'Lopez', 'Jacobo', 'R', 'MAT')
    INTO ESTUDIANTE VALUES ('4019', 'Perez', 'Jenny', 'L', 'FIl')
    INTO ESTUDIANTE VALUES ('5145', 'Santana', 'Luis', 'M', 'ING')
    INTO ESTUDIANTE VALUES ('6132', 'Morrison', 'Javier', 'Q', 'MUS')
    INTO ESTUDIANTE VALUES ('7810', 'Martinez', 'Ricardo', 'E', 'CC')
    INTO ESTUDIANTE VALUES ('8966', 'Juarez', 'Samantha', 'L', 'ING')
    INTO INSCRIPCION VALUES ('2907', 'MAT0011', '01/08/15')
    INTO INSCRIPCION VALUES ('2907', 'MAT0027', '30/04/15')
    INTO INSCRIPCION VALUES ('2907', 'ING0010', '30/12/15')
    INTO INSCRIPCION VALUES ('4019', 'FIL0010', '30/04/15')
    INTO INSCRIPCION VALUES ('4019', 'CC00010', '30/04/15')
    INTO INSCRIPCION VALUES ('5145', 'SOC0102', '01/08/15')
    INTO INSCRIPCION VALUES ('6132', 'MUS0002', '30/04/15')
    INTO INSCRIPCION VALUES ('6132', 'SOC0102', '01/08/15')
    INTO INSCRIPCION VALUES ('8966', 'ING0010', '30/04/15')
    INTO INSCRIPCION VALUES ('8966', 'ING0101', '01/08/15')
    SELECT * FROM dual;

SELECT * FROM AREA;
SELECT * FROM CURSO;
SELECT * FROM ESTUDIANTE;
SELECT * FROM INSCRIPCION;

CREATE OR REPLACE PROCEDURE CONSULTA (
    V_CODIGO IN ESTUDIANTE.ID_ESTUDIANTE%TYPE,
    V_APELLIDO OUT ESTUDIANTE.APELLIDO%TYPE,
    V_NOMBRE OUT ESTUDIANTE.NOMBRE%TYPE,
    V_AREA_MATERIA OUT AREA.ID_MATERIA%TYPE
)
IS
BEGIN
    SELECT APELLIDO, NOMBRE, ID_MATERIA
    INTO V_APELLIDO, V_NOMBRE, V_AREA_MATERIA
    FROM ESTUDIANTE
    WHERE ID_ESTUDIANTE = V_CODIGO;
END CONSULTA;
/

VARIABLE G_APELLIDO VARCHAR2(15);
VARIABLE G_NOMBRE VARCHAR2(15);
VARIABLE G_AREA_MATERIA VARCHAR2(3);

EXECUTE CONSULTA ('2907', :G_APELLIDO, :G_NOMBRE, :G_AREA_MATERIA);

PRINT G_APELLIDO;
PRINT G_NOMBRE;
PRINT G_AREA_MATERIA;



CREATE OR REPLACE PROCEDURE formato_tel (
    v_Telefono IN OUT VARCHAR2
)
    IS
    BEGIN
        v_Telefono := '(' || SUBSTR(v_Telefono, 1, 3) || ') ' || SUBSTR(v_Telefono, 4, 3) || '-' || SUBSTR(v_Telefono, 7, 4);
    END formato_tel;
/

VARIABLE g_telefono VARCHAR2(15);

BEGIN
    :g_telefono := '8006330575';
END;
/

EXECUTE formato_tel(:g_telefono);

PRINT g_telefono;



SELECT
    ESTUDIANTE.NOMBRE,
    ESTUDIANTE.APELLIDO,
    AREA.DESCRIPCION_MATERIA,
    CURSO.NOMBRE_CURSO,
    INSCRIPCION.FECHA_FIN
FROM ESTUDIANTE
JOIN AREA ON ESTUDIANTE.ID_MATERIA = AREA.ID_MATERIA
JOIN INSCRIPCION  ON ESTUDIANTE.ID_ESTUDIANTE = INSCRIPCION.ID_ESTUDIANTE
JOIN CURSO ON INSCRIPCION.NUM_CURSO = CURSO.NUM_CURSO;



CREATE OR REPLACE PROCEDURE lectura IS
    CURSOR TABLA_VIRTUAL IS
        SELECT * FROM ESTUDIANTE;
        ARREGLO TABLA_VIRTUAL%ROWTYPE;
BEGIN
    OPEN TABLA_VIRTUAL;
    FETCH TABLA_VIRTUAL INTO ARREGLO;
    WHILE TABLA_VIRTUAL%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Apellido: ' || ARREGLO.APELLIDO || ' Nombre: ' || ARREGLO.NOMBRE);
        FETCH TABLA_VIRTUAL INTO ARREGLO;
    END LOOP;
    CLOSE TABLA_VIRTUAL;
END;
/


set serveroutput on;

EXECUTE lectura;


CREATE OR REPLACE PROCEDURE CURSOR_FLOOP IS
    CURSOR CR_LOOP IS
        SELECT * FROM CURSO;
        V_RECEPTORA CR_LOOP%ROWTYPE;
BEGIN
    FOR V_RECEPTORA IN CR_LOOP LOOP
        DBMS_OUTPUT.PUT_LINE(CR_LOOP%ROWCOUNT || ' ' || V_RECEPTORA.NOMBRE_CURSO);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE PARAMETROS(v_ap IN Varchar)
AS
    CURSOR CR_parametro (v_Apellido IN Varchar2)
    IS
        SELECT * FROM ESTUDIANTE WHERE APELLIDO = v_Apellido;
        V_RECEPTORA CR_parametro%ROWTYPE;
BEGIN
    FOR V_RECEPTORA IN CR_parametro(v_ap) LOOP
        DBMS_OUTPUT.PUT_LINE(V_RECEPTORA.NOMBRE);
    END LOOP;
END;
/

EXEC PARAMETROS('Lopez');

-- Desarrollar un procedimiento que muestra los cursos en que esté inscrito un alumno cuyo id, sea recibido como parámetro.
-- El procedimiento deberá mostrar:
-- El alumno Nombre apellido está inscrito en los cursos siguientes:
-- Numero de curso 1 Nombre curso 1 Créditos 1
-- Numero de curso 2 Nombre curso 2 Créditos 2
-- Numero de curso N Nombre curso N Créditos N
CREATE OR REPLACE PROCEDURE INSCRITO(V_ID IN VARCHAR2) AS
    CURSOR CR_INSCRITO (V_ID_ESTUDIANTE IN VARCHAR2) IS
        SELECT CURSO.NUM_CURSO, CURSO.NOMBRE_CURSO, CURSO.CREDITOS
        FROM CURSO
        JOIN INSCRIPCION ON CURSO.NUM_CURSO = INSCRIPCION.NUM_CURSO
        WHERE INSCRIPCION.ID_ESTUDIANTE = V_ID_ESTUDIANTE;
    V_RECEPTORA CR_INSCRITO%ROWTYPE;
    V_NOMBRE ESTUDIANTE.NOMBRE%TYPE;
    V_APELLIDO ESTUDIANTE.APELLIDO%TYPE;
BEGIN
    SELECT NOMBRE, APELLIDO INTO V_NOMBRE, V_APELLIDO
    FROM ESTUDIANTE
    WHERE ID_ESTUDIANTE = V_ID;
    DBMS_OUTPUT.PUT_LINE('El alumno ' || V_NOMBRE || ' ' || V_APELLIDO || ' esta inscrito en los cursos siguientes:');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    FOR V_RECEPTORA IN CR_INSCRITO(V_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('Numero de curso: ' || V_RECEPTORA.NUM_CURSO || ' Nombre curso: ' || V_RECEPTORA.NOMBRE_CURSO || ' Creditos: ' || V_RECEPTORA.CREDITOS);
    END LOOP;
END;
/

EXEC INSCRITO('2907');



CREATE OR REPLACE TRIGGER INSERCION
    AFTER INSERT ON CLIENTES
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Se ha insertado un nuevo cliente');
END;
/

INSERT INTO CLIENTES VALUES ('C1', 'Juan Perez', 1000);
INSERT INTO CLIENTES VALUES ('C2', 'Maria Lopez', 2000);



CREATE OR REPLACE TRIGGER AUDITAR_CLIENTES
AFTER UPDATE ON CLIENTES
FOR EACH ROW
BEGIN
    INSERT INTO AUDITOR VALUES ('ANTERIOR: ' || :OLD.LIMITE || ' NUEVO: ' || :NEW.LIMITE);
END;
/

CREATE TABLE AUDITOR (
    CAMBIO VARCHAR(50)
);

UPDATE CLIENTES SET LIMITE = 1500 WHERE CODIGO = 'C1';
UPDATE CLIENTES SET LIMITE = 2500 WHERE CODIGO = 'C2';

SELECT * FROM AUDITOR;



-- CREATE OR REPLACE VIEW Clientes_Estados AS
--     SELECT CODIGO, NOMBRE, LIMITE, ESTADO, NOMBRE_ESTADO
--     FROM CLIENTES, ESTADOS
--     WHERE CLIENTES.ESTADO = ESTADOS.CODIGO_ESTADO;
-- /

CREATE TABLE CLIENTES (
    CODIGO VARCHAR(2) PRIMARY KEY,
    NOMBRE VARCHAR(15),
    LIMITE NUMBER(8,2),
    ESTADO VARCHAR(2)
);

CREATE TABLE ESTADOS (
    CODIGO_ESTADO VARCHAR(2) PRIMARY KEY,
    NOMBRE_ESTADO VARCHAR(15)
);


DROP TABLE CLIENTES;
DROP TABLE ESTADOS;
PURGE RECYCLEBIN;


INSERT INTO ESTADOS VALUES ('01','Queretaro');
INSERT INTO ESTADOS VALUES ('02','San Luis Potosi');
INSERT INTO ESTADOS VALUES ('03','Coahuila');
INSERT INTO ESTADOS VALUES ('04','Durango');
INSERT INTO ESTADOS VALUES ('05','Guanajuato');
INSERT INTO ESTADOS VALUES ('06','Tamaulipas');
INSERT INTO CLIENTES VALUES ('14', 'Juan Perez', 1000, '01');
INSERT INTO CLIENTES VALUES ('15', 'Maria Lopez', 2000, '02');
INSERT INTO CLIENTES VALUES ('16', 'Pedro Martinez', 3000, '03');

SELECT * FROM Clientes_Estados;
SELECT * FROM AUDITOR;


CREATE OR REPLACE TRIGGER SUSTITUCION
INSTEAD OF DELETE OR INSERT
ON Clientes_Estados
FOR EACH ROW
BEGIN
    IF DELETING THEN
        INSERT INTO AUDITOR VALUES ('Borrado ' || :OLD.LIMITE);
    END IF;
    IF INSERTING THEN
        INSERT INTO AUDITOR VALUES ('Insertado ' || :NEW.LIMITE);
    END IF;
END;
/

DELETE FROM Clientes_Estados WHERE CODIGO = '14';

INSERT INTO Clientes_Estados VALUES ('17', 'Ana Garcia', 4000, '02', 'San Luis Potosi');


GRANT ADMINISTER DATABASE TRIGGER TO BLUE;

CREATE TABLE CONEXIONES (
    USUARIO VARCHAR2(50),
    MOMENTO DATE,
    EVENTO VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER EJEMPLO
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO CONEXIONES VALUES (ORA_LOGIN_USER, SYSTIMESTAMP, ORA_SYSEVENT);
END;
/



CREATE OR REPLACE PROCEDURE EJEMPLO IS
V_APELLIDO ESTUDIANTE.APELLIDO%TYPE;
BEGIN
    SELECT APELLIDO INTO v_Apellido
    FROM ESTUDIANTE
    WHERE APELLIDO = 'Samantha';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se arrojaron datos: NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Demasiados registros');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error no previsto');
END;
/

EXEC EJEMPLO;

SELECT TEXT FROM ALL_SOURCE WHERE NAME = 'EJEMPLO';


DECLARE 
    EXCEPCION_DE_EDAD EXCEPTION;
    EDAD NUMBER;
BEGIN
    EDAD:=179;
    RAISE EXCEPCION_DE_EDAD;
EXCEPTION 
    WHEN EXCEPCION_DE_EDAD THEN 
        DBMS_OUTPUT.PUT_LINE('!No es posible!');
END;
/

-- usando parametros inserte los datos de tres nuevos estudiantes en la tabla estudiantes
-- si el estudiante ya existe crear (previamente) una tabla llamada ERR con las columnas: numero y descripcion, e insertar una breve descripcion del error 
-- si algun dato es de mayor longitud, introducir una breve descripcion en ERR
-- cualquier otro error no considerado, insertar una breve descripcion en ERR

CREATE TABLE ERR (
    NUMERO NUMBER,
    DESCRIPCION VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE INSERTAR_ESTUDIANTE(
    P_ID_ESTUDIANTE IN VARCHAR2, 
    P_APELLIDO IN VARCHAR2, 
    P_NOMBRE IN VARCHAR2, 
    P_INICIAL IN CHAR, 
    P_ID_MATERIA IN VARCHAR2
)
IS
    DUPLICATE_ENTRY EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUPLICATE_ENTRY, -00001);
BEGIN
    BEGIN
        INSERT INTO ESTUDIANTE (ID_ESTUDIANTE, APELLIDO, NOMBRE, INICIAL, ID_MATERIA)
        VALUES (P_ID_ESTUDIANTE, P_APELLIDO, P_NOMBRE, P_INICIAL, P_ID_MATERIA);
    EXCEPTION
        WHEN DUPLICATE_ENTRY THEN
            INSERT INTO ERR (NUMERO, DESCRIPCION) VALUES (1, 'Estudiante ya existe: ' || P_ID_ESTUDIANTE);
        WHEN VALUE_ERROR THEN
            INSERT INTO ERR (NUMERO, DESCRIPCION) VALUES (1, 'Dato demasiado largo para: ' || P_ID_ESTUDIANTE);
        WHEN OTHERS THEN
            INSERT INTO ERR (NUMERO, DESCRIPCION) VALUES (1, 'Error desconocido para: ' || P_ID_ESTUDIANTE);
    END;
END;
/ 

EXEC INSERTAR_ESTUDIANTE('2907', 'Lopez', 'Jacobo', 'R', 'MAT');
EXEC INSERTAR_ESTUDIANTE('4019', 'Perez', 'Jenny', 'L', 'FIl');
EXEC INSERTAR_ESTUDIANTE('5145', 'Santana', 'Luis', 'M', 'ING');

SELECT * FROM ESTUDIANTE;
SELECT * FROM ERR;

CREATE OR REPLACE FUNCTION Lee_Id_Materia
(V_ID_ESTUDIANTE IN ESTUDIANTE.ID_ESTUDIANTE%TYPE)
    RETURN VARCHAR2
IS
    V_MATERIA ESTUDIANTE.ID_MATERIA%TYPE;
BEGIN
    SELECT ID_MATERIA INTO V_MATERIA
    FROM ESTUDIANTE
    WHERE ID_ESTUDIANTE = V_ID_ESTUDIANTE;
    RETURN V_MATERIA;
    END;
/

//START Lee_Id_Materia
VARIABLE G_MATERIA VARCHAR2(3)
EXECUTE :G_MATERIA :=Lee_Id_Materia('4019')
PRINT G_MATERIA

SELECT Lee_Id_Materia('4019') FROM DUAL;


-- crear funcion de calculadora que reciba dos numeros y un operador y regrese el resultado
-- si el operador no es valido, regresar un error
-- si se intenta dividir entre cero, regresar un error

CREATE OR REPLACE FUNCTION calculadora
(V_NUM1 IN NUMBER, V_NUM2 IN NUMBER, V_OPERADOR IN VARCHAR2)
    RETURN NUMBER
IS
    V_RESULTADO NUMBER;
BEGIN
    CASE V_OPERADOR
        WHEN '+' THEN V_RESULTADO := V_NUM1 + V_NUM2;
        WHEN '-' THEN V_RESULTADO := V_NUM1 - V_NUM2;
        WHEN '*' THEN V_RESULTADO := V_NUM1 * V_NUM2;
        WHEN '/' THEN
            IF V_NUM2 = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'No se puede dividir entre cero');
            ELSE
                V_RESULTADO := V_NUM1 / V_NUM2;
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Operador no valido');
    END CASE;
    RETURN V_RESULTADO;
END;
/

VARIABLE g_numero NUMBER;
EXECUTE :g_numero:=calculadora(1, 2, '+');
PRINT g_numero;
EXECUTE :g_numero:=calculadora(2, 3, '-');
PRINT g_numero;
EXECUTE :g_numero:=calculadora(4, 5, '*');
PRINT g_numero;
EXECUTE :g_numero:=calculadora(6, 2, '/');
PRINT g_numero;


CREATE OR REPLACE PACKAGE LEER_ALUMNO
AS
TYPE DATOS_ESTUDIANTE IS
RECORD
(
NUMERO_ESTUDIANTE ESTUDIANTE.ID_ESTUDIANTE%TYPE,
NOMBRE_ESTUDIANTE ESTUDIANTE.NOMBRE%TYPE,
NUMERO_MATERIA ESTUDIANTE.ID_MATERIA%TYPE
);
PROCEDURE LEE_ESTUDIANTE(NUM_ALUM ESTUDIANTE.ID_ESTUDIANTE%TYPE);
END LEER_ALUMNO;
/

CREATE OR REPLACE PACKAGE BODY LEER_ALUMNO
AS
DATOS_ALUMNO DATOS_ESTUDIANTE; 
PROCEDURE MUESTRA_ESTUDIANTE;  
PROCEDURE LEE_ESTUDIANTE(NUM_ALUM ESTUDIANTE.ID_ESTUDIANTE%TYPE)
IS
BEGIN
SELECT ID_ESTUDIANTE,NOMBRE,ID_MATERIA
INTO DATOS_ALUMNO
FROM ESTUDIANTE
WHERE ID_ESTUDIANTE=NUM_ALUM;
MUESTRA_ESTUDIANTE;
END;
PROCEDURE MUESTRA_ESTUDIANTE
IS
BEGIN
DBMS_OUTPUT.PUT_LINE(
DATOS_ALUMNO.NUMERO_ESTUDIANTE|| ' ' ||
DATOS_ALUMNO.NOMBRE_ESTUDIANTE|| ' ' ||
DATOS_ALUMNO.NUMERO_MATERIA
);
END MUESTRA_ESTUDIANTE;
END LEER_ALUMNO;
/



CREATE TABLE Articulos (
    CODIGO VARCHAR2(10),
    DESCRIPCION VARCHAR2(80),
    PRECIO NUMBER(8,2),
    COD_ALMACEN NUMBER(5),
    PRIMARY KEY (CODIGO)
);

INSERT ALL 
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('SBP0025HA2', 'Healthy pizza crust made from cauliflower', 5.99, '38947')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('1P2Z1A30F4', 'Lightweight and portable picnic table for outdoor use.', 49.99, '92879')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('DEK6150ER1', 'Eco-friendly meal prep containers for healthy eating.', 18.99, '49243')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('3KSA6J9Z36', 'Compact coffee grinder for fresh ground coffee beans.', 22.99, '76423')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('QY8K63WGFB', 'Extra soft electric blanket with adjustable heat settings.', 59.99, '55959')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('LSFIL50U37', 'A blend of nuts, seeds, and spices for a healthy snack.', 4.29, '06968')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('O1E20F5VC4', 'Convenient feeder that adjusts to your pet''s height.', 39.99, '84708')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('8200XLW7HR', 'A frozen meal featuring quinoa and mixed vegetables, ready to heat and eat.', 5.99, '33440')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('DX88P0O66I', 'Mesh drying rack for preserving herbs and flowers.', 22.99, '00979')
    into Articulos (CODIGO, DESCRIPCION, PRECIO, COD_ALMACEN) values ('6W1731WL06', 'Creamy chia pudding made with coconut milk and topped with mango.', 3.49, '77606')
 SELECT * FROM dual;

-- Desarrolle un procedimiento en el que se use cursores y un paquete y, mediante una lectura secuencial, copie en una segunda tabla, todos los datos cuyo precio sea mayor a o igual a un parametro enviado al procedimiento.
-- En una tercera tabla copie todos los datos que sean menores a ese parametro.
-- Una vez que recorra toda la tabla, muestre el mensaje "Fin del proceso" mediente el uso de excepciones.

CREATE OR REPLACE PACKAGE PROCESO_ARTICULOS
AS
    PROCEDURE COPIA_ARTICULOS(V_PRECIO NUMBER);
END PROCESO_ARTICULOS;
/

CREATE OR REPLACE PACKAGE BODY PROCESO_ARTICULOS
AS
    CURSOR C_ARTICULOS IS
        SELECT * FROM ARTICULOS;
        V_ARTICULO C_ARTICULOS%ROWTYPE;
    CURSOR C_ARTICULOS_MAYORES IS
        SELECT * FROM ARTICULOS WHERE PRECIO >= V_PRECIO;
        V_ARTICULO_MAYOR C_ARTICULOS_MAYORES%ROWTYPE;
    CURSOR C_ARTICULOS_MENORES IS
        SELECT * FROM ARTICULOS WHERE PRECIO < V_PRECIO;
        V_ARTICULO_MENOR C_ARTICULOS_MENORES%ROWTYPE;
        V_CONTADOR_MAYORES NUMBER := 0;
        V_CONTADOR_MENORES NUMBER := 0;
BEGIN
    OPEN C_ARTICULOS;
    LOOP
        FETCH C_ARTICULOS INTO V_ARTICULO;
        EXIT WHEN C_ARTICULOS%NOTFOUND;
        
        IF V_ARTICULO.PRECIO >= V_PRECIO THEN
            V_CONTADOR_MAYORES := V_CONTADOR_MAYORES + 1;
            INSERT INTO ARTICULOS_MAYORES VALUES (V_ARTICULO.CODIGO, V_ARTICULO.DESCRIPCION, V_ARTICULO.PRECIO, V_ARTICULO.COD_ALMACEN);
        ELSE
            V_CONTADOR_MENORES := V_CONTADOR_MENORES + 1;
            INSERT INTO ARTICULOS_MENORES VALUES (V_ARTICULO.CODIGO, V_ARTICULO.DESCRIPCION, V_ARTICULO.PRECIO, V_ARTICULO.COD_ALMACEN);
        END IF;
    END LOOP;
    CLOSE C_ARTICULOS;
    DBMS_OUTPUT.PUT_LINE('Articulos mayores a ' || V_PRECIO || ': ' || V_CONTADOR_MAYORES);
    DBMS_OUTPUT.PUT_LINE('Articulos menores a ' || V_PRECIO || ': ' || V_CONTADOR_MENORES);
    DBMS_OUTPUT.PUT_LINE('Fin del proceso');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error no previsto');
END PROCESO_ARTICULOS;
/

EXECUTE PROCESO_ARTICULOS.COPIA_ARTICULOS(10);

-- 1. Creación de Usuarios
CREATE USER USER1 IDENTIFIED BY password1 DEFAULT TABLESPACE UNAM;
CREATE USER USER2 IDENTIFIED BY password2 DEFAULT TABLESPACE UNAM;

-- 2. Creación de Roles
CREATE ROLE Update_area;
CREATE ROLE Update_curso;

-- 3. Asignación de Privilegios a los Roles
GRANT UPDATE ON AREA TO Update_area;
GRANT UPDATE ON CURSO TO Update_curso;

-- 4. Asignación de Roles a Usuarios
GRANT Update_area TO USER1;
GRANT Update_curso TO USER2;

-- 5. Privilegios Adicionales para Usuarios
GRANT INSERT ON INSCRIPCION TO USER1;
GRANT UPDATE (APELLIDO, NOMBRE) ON ESTUDIANTE TO USER1;
GRANT SELECT ON INSCRIPCION TO USER2;
GRANT UPDATE ON ESTUDIANTE TO USER2;

CONNECT USER1/password1@UNAM

-- 6. Inserción de Datos en la Tabla CURSO
INSERT INTO CURSO (NUM_CURSO, NOMBRE_CURSO, CREDITOS) VALUES
('MUS003', 'Rossini overturas', '3'),
('MUS004', 'Tchaikovsky III', '3'),
('ING0007', 'Etimologías', '2'),
('MAT0021', 'Algebra básica', '4'),
('BIOS001', 'Introducción a la Biología', '3'),
('BIOS002', 'Desarrollo humano', '3'),
('HUM0001', 'Interacciones sociales', '2'),
('HUM0002', 'Evolución de la palabra', '2');

-- 7. Inserción de Nuevas Áreas
INSERT INTO AREA (ID_MATERIA, DESCRIPCION_MATERIA) VALUES
('BIO', 'Biológicas'),
('HUM', 'Humanidades');

-- 8. Inserción de Nuevos Estudiantes
INSERT INTO ESTUDIANTE (ID_ESTUDIANTE, APELLIDO, NOMBRE, INICIAL, ID_MATERIA) VALUES
('1001', 'Gonzalez', 'Ana', 'A', 'BIO'),
('1002', 'Martinez', 'Luis', 'L', 'HUM');

-- 9. Registro de Estudiantes en Cursos
INSERT INTO INSCRIPCION (ID_ESTUDIANTE, NUM_CURSO, FECHA_FIN) VALUES
('1001', 'BIOS001', TO_DATE('2023-12-31', 'YYYY-MM-DD')),
('1002', 'HUM0001', TO_DATE('2023-12-31', 'YYYY-MM-DD'));

CONNECT USER2/password2
-- 10. Actualización de Estudiantes
UPDATE ESTUDIANTE SET APELLIDO = 'Sam' WHERE ID_ESTUDIANTE = '8966';

CONNECT USER1/password1
UPDATE ESTUDIANTE SET NOMBRE = 'Omar', APELLIDO = 'Rios' WHERE ID_ESTUDIANTE = '2907';



CREATE TABLE CLIENTS (
    ID_CLIENTE CHAR(1) PRIMARY KEY,
    NOMBRE VARCHAR2(10),
    CREDITO NUMBER(5,2)
);

INSERT INTO CLIENTS (ID_CLIENTE, NOMBRE, CREDITO) VALUES
('A', 'Juan', 1000),
('B', 'Maria', 2000),
('C', 'Pedro', 3000),
('D', 'Ana', 4000),
('E', 'Luis', 5000);

-- DECLARE 
--     CURSOR UPDATE_CURSOR IS
--         SELECT CREDITO,ID_CLIENTE 
--         FROM CLIENTS
--         WHERE CREDITO > 50
--         FOR UPDATE OF CREDITO;
--         BEGIN
--             FOR X IN UPDATE_CURSOR LOOP
--                 update CLIENTS
--                 set CREDITO = CREDITO * 1.10
--                 WHERE CURRENT OF UPDATE_CURSOR;
--                 dbms.
--             END LOOP;






-- ----Examen--------

SET SERVEROUTPUT ON;

-- Creación de la tabla "Articulos"
CREATE TABLE Articulos (
    Codigo NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100),
    Precio NUMBER,
    Cod_almacen NUMBER
);

INSERT ALL 
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (1, 'Pinza', 79, 1)
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (2, 'Martillo', 122, 1)
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (3, 'Desarmador', 47, 1)
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (4, 'Podadora', 7000, 2)
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (5, 'Buje', 22, 3)
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (6, 'Espatula', 16, 2)
    INTO Articulos (Codigo, Descripcion, Precio, Cod_almacen) VALUES (7, 'Brocha', 30, 1)
SELECT * FROM dual;

-- Creación de la tabla "Almacenes"
CREATE TABLE Almacenes (
    Codigo NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100)
);

INSERT ALL 
    INTO Almacenes (Codigo, Descripcion) VALUES (1, 'Producto terminado')
    INTO Almacenes (Codigo, Descripcion) VALUES (2, 'Produccion en proceso')
    INTO Almacenes (Codigo, Descripcion) VALUES (3, 'Materia prima')
SELECT * FROM dual;

-- Creación de las tablas "mayores" y "menores"
CREATE TABLE mayores (
    Codigo NUMBER,
    Descripcion VARCHAR2(100),
    Precio NUMBER,
    Cod_almacen NUMBER
);

CREATE TABLE menores (
    Codigo NUMBER,
    Descripcion VARCHAR2(100),
    Precio NUMBER,
    Cod_almacen NUMBER
);

SELECT * FROM Articulos;
SELECT * FROM Almacenes;
SELECT * FROM mayores;
SELECT * FROM menores;

-- Creación del procedimiento "Copia"
CREATE OR REPLACE PROCEDURE Copia(p_precio_threshold IN NUMBER) AS
BEGIN
    -- Copiar a la tabla "mayores" si no existe ya
    INSERT INTO mayores (Codigo, Descripcion, Precio, Cod_almacen)
    SELECT Codigo, Descripcion, Precio, Cod_almacen
    FROM Articulos
    WHERE Precio >= p_precio_threshold
    AND NOT EXISTS (
        SELECT 1 FROM mayores m WHERE m.Codigo = Articulos.Codigo
    );

    -- Copiar a la tabla "menores" si no existe ya
    INSERT INTO menores (Codigo, Descripcion, Precio, Cod_almacen)
    SELECT Codigo, Descripcion, Precio, Cod_almacen
    FROM Articulos
    WHERE Precio < p_precio_threshold
    AND NOT EXISTS (
        SELECT 1 FROM menores m WHERE m.Codigo = Articulos.Codigo
    );
END;
/

-- Creación del trigger para "mayores"
CREATE OR REPLACE TRIGGER trg_mayores
AFTER INSERT ON mayores
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Registro adicionado en tabla: Mayores');
END;
/

-- Creación del trigger para "menores"
CREATE OR REPLACE TRIGGER trg_menores
AFTER INSERT ON menores
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Registro adicionado en tabla: Menores');
END;
/

-- Creación de la vista que muestra los datos de "Articulos" con el nombre del almacén
CREATE OR REPLACE VIEW vista_articulos AS
SELECT a.Codigo, a.Descripcion, a.Precio, al.Descripcion AS Almacen
FROM Articulos a
JOIN Almacenes al ON a.Cod_almacen = al.Codigo;

-- Consulta para verificar la creación del procedimiento
SELECT object_type, object_name, created, timestamp, status 
FROM user_objects 
WHERE object_name = 'COPIA';

-- Ejecución del procedimiento "Copia"
BEGIN
    Copia(100);
END;
/

SELECT * FROM mayores;
SELECT * FROM menores;

INSERT INTO mayores (Codigo, Descripcion, Precio, Cod_almacen) VALUES (8, 'Nuevo Articulo Mayor', 150, 1);
INSERT INTO menores (Codigo, Descripcion, Precio, Cod_almacen) VALUES (9, 'Nuevo Articulo Menor', 50, 2);

SELECT * FROM vista_articulos;

BEGIN
    Copia(50);  -- Para copiar artículos con precio >= 50
END;
/
BEGIN
    Copia(200);  -- Para copiar artículos con precio >= 200
END;
/
SELECT * FROM mayores;
SELECT * FROM menores;




-- Limpieza de tablas y objetos creados
DROP TABLE Articulos;
DROP TABLE Almacenes;
DROP TABLE mayores;
DROP TABLE menores;
DROP VIEW vista_articulos;
DROP PROCEDURE Copia;
DROP TRIGGER trg_mayores;
DROP TRIGGER trg_menores;
PURGE RECYCLEBIN;
COMMIT;