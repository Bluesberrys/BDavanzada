CREATE TABLE Costos (
    codigo VARCHAR2(20) PRIMARY KEY,
    cantidad NUMBER,
    pu NUMBER
);

CREATE TABLE Costo_Produccion (
    codigo VARCHAR2(20) PRIMARY KEY,
    costo_produccion NUMBER
);

INSERT ALL
    INTO Costos VALUES ('AIH7045', 3, 287.34)
    INTO Costos VALUES ('AAB6846', 2, 138.90)
    INTO Costos VALUES ('ANN1172', 1, 614.76)
    INTO Costos VALUES ('AAB1519', 18, 23.29)
    INTO Costos VALUES ('ZNM1614', 17, 11.56)
    INTO Costos VALUES ('ZNM1519', 6, 56.34)
    INTO Costos VALUES ('ZNK1618', 5, 19.82)
    INTO Costos VALUES ('ZJI1147', 3, 24.11)
    INTO Costos VALUES ('ZJI1326', 11, 76.00)
    INTO Costos VALUES ('BIG1896', 19, 29.45)
    INTO Costos VALUES ('BIG1914', 14, 17.28)
    INTO Costos VALUES ('BIH1922', 32, 66.40)
    INTO Costos VALUES ('BIH1667', 66, 4.32)
    INTO Costos VALUES ('BIL1765', 71, 3.12)
    INTO Costos VALUES ('BIL1419', 26, 0.56)
    INTO Costos VALUES ('CNN8416', 3, 1.39)
    INTO Costos VALUES ('CNN1118', 7, 0.77)
    INTO Costos VALUES ('CNL1847', 21, 0.56)
    INTO Costos VALUES ('LNM1516', 8, 3.56)
    INTO Costos VALUES ('LNM8745', 12, 19.22)
    INTO Costos VALUES ('LNM6969', 70, 0.43)
    INTO Costos VALUES ('ZNJI4389', 3, 0.98)
    INTO Costos VALUES ('ZNK8710', 6, 214.11)
SELECT * FROM dual;

CREATE OR REPLACE PROCEDURE calcula(p_codigo IN VARCHAR2) IS
    filtro  VARCHAR2(2);
    total   NUMBER;
BEGIN
    SELECT CASE SUBSTR(p_codigo, 1, 1)
             WHEN 'A' THEN 'NM'
             WHEN 'Z' THEN 'NN'
             WHEN 'B' THEN 'NL'
             WHEN 'C' THEN 'NK'
             WHEN 'L' THEN 'IH'
           END
    INTO filtro
    FROM dual;

    SELECT SUM(cantidad * pu)
    INTO total
    FROM Costos
    WHERE SUBSTR(codigo, 2, 2) = filtro;

    DBMS_OUTPUT.PUT_LINE(
        'El costo de produccion del articulo ' || p_codigo ||
        ' es de ' || total || ' pesos.'
    );
END;
/

CREATE OR REPLACE TRIGGER calculo_costo
AFTER INSERT ON Costos
FOR EACH ROW
DECLARE
    filtro VARCHAR2(2);
    total  NUMBER;
BEGIN
    SELECT CASE SUBSTR(:NEW.codigo, 1, 1)
             WHEN 'A' THEN 'NM'
             WHEN 'Z' THEN 'NN'
             WHEN 'B' THEN 'NL'
             WHEN 'C' THEN 'NK'
             WHEN 'L' THEN 'IH'
           END
    INTO filtro
    FROM dual;

    IF filtro IS NULL THEN
        RETURN;
    END IF;

    SELECT SUM(cantidad * pu)
    INTO total
    FROM Costos
    WHERE SUBSTR(codigo, 2, 2) = filtro;

    INSERT INTO Costo_Produccion (codigo, costo_produccion)
    VALUES (:NEW.codigo, total);
END;
/

SET SERVEROUTPUT ON;

EXECUTE calcula('AIH7045');
EXECUTE calcula('ZNM5678');

SELECT * FROM Costo_Produccion;

Select text from user_source where name='CALCULA' and type='PROCEDURE';
Select text from user_source where name='CALCULO_COSTO' and type='TRIGGER';
select OBJECT_NAME, TABLESPACE_NAME,CREATED, TIMESTAMP, OBJECT_ID FROM USER_OBJECTS,USER_TABLES WHERE USER_OBJECTS.OBJECT_NAME=USER_TABLES.TABLE_NAME AND TABLE_NAME='COSTO_PRODUCCION';
