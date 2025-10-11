-- <--	TABLESPACE Y USUARIO	-->
CREATE TABLESPACE GALGO DATAFILE 'D:\Max\Proyectos\BDavanzada/GALGO.DBF' SIZE 10M; 

CREATE USER BLUE IDENTIFIED BY 090322 DEFAULT TABLESPACE GALGO;

GRANT CONNECT, CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, UNLIMITED TABLESPACE TO BLUE;

-- <--	CREACION DE TABLAS	-->

CREATE TABLE cliente(
	id_cliente varchar(10) PRIMARY KEY NOT NULL,
	nombre_cliente varchar(30) NOT NULL,
	ap_paterno_cliente varchar(20) NOT NULL,
	ap_materno_cliente varchar(20) NOT NULL,
	domicilio varchar(50) NOT NULL
);

CREATE TABLE centrales(
	id_central varchar(10) PRIMARY KEY NOT NULL,
	nombre_central varchar(50) NOT NULL,
	ubicacion varchar(50) NOT NULL,
	num_camiones varchar(3) NOT NULL,
	telefono_central varchar(10) NOT NULL
);

CREATE TABLE camion(
	nci varchar(13) PRIMARY KEY NOT NULL,
	num_placa varchar(10) NOT NULL,
	num_camion varchar(5) NOT NULL,
	marca varchar(20) NOT NULL,
	modelo varchar(15) NOT NULL,
	num_asientos varchar(2) NOT NULL,
	central varchar(10) NOT NULL,
	FOREIGN KEY(central) REFERENCES centrales(id_central)
);

CREATE TABLE imprevisto(
	num_imprevisto varchar(3) PRIMARY KEY NOT NULL,
	nombre_imprevisto varchar(50) NOT NULL,
	descripcion_imprevisto varchar(100) NOT NULL,
	nivel_gravedad char NOT NULL
);

CREATE TABLE problemas(
	folio_problema varchar(5) PRIMARY KEY NOT NULL,
	num_imprevisto varchar(3) NOT NULL,
	camion varchar(13) NOT NULL,
	fecha date NOT NULL,
	ubicacion varchar(50) NOT NULL
);

CREATE TABLE chofer(
	rfc varchar(13) PRIMARY KEY NOT NULL,
	nombre_chofer varchar(20) NOT NULL,
	ap_paterno_chofer varchar(20) NOT NULL,
	ap_materno_chofer varchar(20) NOT NULL,
	nss varchar(11) NOT NULL,
	edad number(2) NOT NULL,
	domicilio_chofer varchar(50) NOT NULL,
	email_chofer varchar(50) NOT NULL,
	telefono_chofer varchar(10) NOT NULL,
	anios_antiguedad number(2) NOT NULL
);

CREATE TABLE conduce(
	id_conduce varchar(5) PRIMARY KEY NOT NULL,
	chofer varchar(13) NOT NULL,
	camion varchar(13) NOT NULL,
	FOREIGN KEY(chofer) REFERENCES chofer(rfc),
	FOREIGN KEY(camion) REFERENCES camion(nci)
);

CREATE TABLE ruta(
	id_ruta varchar(5) PRIMARY KEY NOT NULL,
	origen varchar(10) NOT NULL,
	destino varchar(10) NOT NULL,
	FOREIGN KEY(origen) REFERENCES centrales(id_central),
	FOREIGN KEY(destino) REFERENCES centrales(id_central)
);

CREATE TABLE tramo(
	id_tramo varchar(10) PRIMARY KEY NOT NULL,
	ruta varchar(5) NOT NULL,
	tramo_origen varchar(10) NOT NULL,
	tramo_destino varchar(10) NOT NULL,
	FOREIGN KEY(ruta) REFERENCES ruta(id_ruta),
	FOREIGN KEY(tramo_origen) REFERENCES centrales(id_central),
	FOREIGN KEY(tramo_destino) REFERENCES centrales(id_central)
);

CREATE TABLE reservacion(
	folio_reserva varchar(10) PRIMARY KEY NOT NULL,
	ruta varchar(10) NOT NULL,
	cliente varchar(10) NOT NULL,
	fecha date NOT NULL,
	FOREIGN KEY(ruta) REFERENCES ruta(id_ruta),
	FOREIGN KEY(cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE recorrido(
	folio_recorrido varchar(50) PRIMARY KEY NOT NULL,
	conduce varchar(5) NOT NULL,
	ruta varchar(5) NOT NULL,
	tramo varchar(10) NOT NULL,
	horario_salida varchar(5) NOT NULL,
	asientos_disponibles number(2) NOT NULL,
	hora_salida_final varchar(5) NOT NULL,
	FOREIGN KEY(conduce) REFERENCES conduce(id_conduce),
	FOREIGN KEY(ruta) REFERENCES ruta(id_ruta),
	FOREIGN KEY(tramo) REFERENCES tramo(id_tramo)
);

CREATE TABLE boleto(
	num_asiento varchar(2) NOT NULL,
	id_reserva varchar(10) NOT NULL,
	folio_recorrido varchar(50) NOT NULL,
	precio decimal(6,2) NOT NULL,
	pagado char NOT NULL,
	FOREIGN KEY(id_reserva) REFERENCES reservacion(folio_reserva),
	FOREIGN KEY(folio_recorrido) REFERENCES recorrido(folio_recorrido)
);

SELECT * FROM CAT;

-- <--	INSERTAR DATOS	-->

INSERT ALL
  INTO cliente VALUES('CL001','Carlos','Ramírez','Lopez','Av. Juárez 123, CDMX')
  INTO cliente VALUES('CL002','María','Hernández','Gómez','Calle Reforma 456, Puebla')
  INTO cliente VALUES('CL003','Luis','Martínez','Sánchez','Av. Morelos 789, Guadalajara')
  INTO cliente VALUES('CL004','Ana','García','Torres','Calle Hidalgo 321, Monterrey')
  INTO cliente VALUES('CL005','Jorge','Pérez','Ramírez','Av. Insurgentes 654, Toluca')
  INTO cliente VALUES('CL006','Sofía','Castro','Flores','Calle Juárez 222, Querétaro')
  INTO cliente VALUES('CL007','Ricardo','Mendoza','Luna','Av. Reforma 888, Mérida')
  INTO cliente VALUES('CL008','Fernanda','Ruiz','Morales','Calle Hidalgo 999, León')
  INTO cliente VALUES('CL009','Miguel','Vega','Salazar','Av. Morelos 555, Cancún')
  INTO cliente VALUES('CL010','Laura','Navarro','Cruz','Calle Central 777, Oaxaca')
SELECT * FROM dual;

INSERT ALL
  INTO centrales VALUES('CEN01','Central Norte','CDMX',50,'5551234567')
  INTO centrales VALUES('CEN02','Central Sur','CDMX',35,'5559876543')
  INTO centrales VALUES('CEN03','Central de Puebla','Puebla',40,'2223456789')
  INTO centrales VALUES('CEN04','Central Guadalajara','Guadalajara',45,'3335678901')
  INTO centrales VALUES('CEN05','Central Monterrey','Monterrey',42,'8184567890')
  INTO centrales VALUES('CEN06','Central Toluca','Toluca',30,'7223456789')
  INTO centrales VALUES('CEN07','Central Mérida','Mérida',28,'9994567890')
  INTO centrales VALUES('CEN08','Central Querétaro','Querétaro',33,'4422345678')
  INTO centrales VALUES('CEN09','Central León','León',29,'4775678901')
  INTO centrales VALUES('CEN10','Central Oaxaca','Oaxaca',31,'9513456789')
SELECT * FROM dual;

INSERT ALL
  INTO camion VALUES('NCI000000001','ABC1234','001','Volvo','2020','45','CEN01')
  INTO camion VALUES('NCI000000002','BCD2345','002','Mercedes','2019','40','CEN02')
  INTO camion VALUES('NCI000000003','CDE3456','003','Scania','2021','42','CEN03')
  INTO camion VALUES('NCI000000004','DEF4567','004','Volvo','2018','38','CEN04')
  INTO camion VALUES('NCI000000005','EFG5678','005','MAN','2022','44','CEN05')
  INTO camion VALUES('NCI000000006','FGH6789','006','Mercedes','2020','39','CEN06')
  INTO camion VALUES('NCI000000007','GHI7890','007','Scania','2021','41','CEN07')
  INTO camion VALUES('NCI000000008','HIJ8901','008','Volvo','2019','43','CEN08')
  INTO camion VALUES('NCI000000009','IJK9012','009','MAN','2022','40','CEN09')
  INTO camion VALUES('NCI000000010','JKL0123','010','Mercedes','2020','42','CEN10')
SELECT * FROM dual;

INSERT ALL
  INTO imprevisto VALUES('001','Falla mecánica','El motor presentó una falla durante el recorrido','A')
  INTO imprevisto VALUES('002','Pinchadura','Una llanta se ponchó en carretera','B')
  INTO imprevisto VALUES('003','Retraso','El camión salió con 30 minutos de retraso','C')
  INTO imprevisto VALUES('004','Clima adverso','Lluvia intensa en la autopista','B')
  INTO imprevisto VALUES('005','Accidente menor','Choque leve sin lesionados','A')
  INTO imprevisto VALUES('006','Problema eléctrico','Falla en sistema de luces','B')
  INTO imprevisto VALUES('007','Cambio de ruta','Ruta modificada por bloqueo','C')
  INTO imprevisto VALUES('008','Pasajero enfermo','Se atendió emergencia médica','B')
  INTO imprevisto VALUES('009','Frenos defectuosos','Se detectó problema en el sistema de frenos','A')
  INTO imprevisto VALUES('010','Demora en carga','Retraso por exceso de equipaje','C')
SELECT * FROM dual;

INSERT ALL
  INTO chofer VALUES('CHOFR001AAA','Juan','Pérez','López','12345678901',35,'Av. Hidalgo 123, CDMX','juan.perez@mail.com','5551112222',5)
  INTO chofer VALUES('CHOFR002BBB','María','Gómez','Hernández','12345678902',29,'Calle Reforma 456, Puebla','maria.gomez@mail.com','2223334444',3)
  INTO chofer VALUES('CHOFR003CCC','Luis','Ramírez','Torres','12345678903',40,'Av. Juárez 789, GDL','luis.ramirez@mail.com','3335556666',8)
  INTO chofer VALUES('CHOFR004DDD','Ana','Sánchez','Ruiz','12345678904',32,'Calle Morelos 111, Monterrey','ana.sanchez@mail.com','8187778888',6)
  INTO chofer VALUES('CHOFR005EEE','Pedro','Flores','Castillo','12345678905',45,'Av. Universidad 222, Toluca','pedro.flores@mail.com','7229990000',10)
  INTO chofer VALUES('CHOFR006FFF','Lucía','Mendoza','Ríos','12345678906',28,'Calle Central 333, Querétaro','lucia.mendoza@mail.com','4421234567',2)
  INTO chofer VALUES('CHOFR007GGG','Carlos','Morales','Cruz','12345678907',38,'Av. Reforma 444, Mérida','carlos.morales@mail.com','9993456789',7)
  INTO chofer VALUES('CHOFR008HHH','Fernanda','Vega','Pérez','12345678908',31,'Calle Hidalgo 555, León','fernanda.vega@mail.com','4775678901',4)
  INTO chofer VALUES('CHOFR009III','Miguel','Ruiz','Navarro','12345678909',37,'Av. Morelos 666, Cancún','miguel.ruiz@mail.com','9983456789',6)
  INTO chofer VALUES('CHOFR010JJJ','Laura','Cruz','Salazar','12345678910',33,'Calle Insurgentes 777, Oaxaca','laura.cruz@mail.com','9513456789',5)
SELECT * FROM dual;

INSERT ALL
  INTO conduce VALUES('CON01','CHOFR001AAA','NCI000000001')
  INTO conduce VALUES('CON02','CHOFR002BBB','NCI000000002')
  INTO conduce VALUES('CON03','CHOFR003CCC','NCI000000003')
  INTO conduce VALUES('CON04','CHOFR004DDD','NCI000000004')
  INTO conduce VALUES('CON05','CHOFR005EEE','NCI000000005')
  INTO conduce VALUES('CON06','CHOFR006FFF','NCI000000006')
  INTO conduce VALUES('CON07','CHOFR007GGG','NCI000000007')
  INTO conduce VALUES('CON08','CHOFR008HHH','NCI000000008')
  INTO conduce VALUES('CON09','CHOFR009III','NCI000000009')
  INTO conduce VALUES('CON10','CHOFR010JJJ','NCI000000010')
SELECT * FROM dual;

INSERT ALL
  INTO ruta VALUES('R001','CEN01','CEN02')
  INTO ruta VALUES('R002','CEN02','CEN03')
  INTO ruta VALUES('R003','CEN03','CEN04')
  INTO ruta VALUES('R004','CEN04','CEN05')
  INTO ruta VALUES('R005','CEN05','CEN06')
  INTO ruta VALUES('R006','CEN06','CEN07')
  INTO ruta VALUES('R007','CEN07','CEN08')
  INTO ruta VALUES('R008','CEN08','CEN09')
  INTO ruta VALUES('R009','CEN09','CEN10')
  INTO ruta VALUES('R010','CEN10','CEN01')
SELECT * FROM dual;

INSERT ALL
  INTO tramo VALUES('T0001','R001','CEN01','CEN02')
  INTO tramo VALUES('T0002','R002','CEN02','CEN03')
  INTO tramo VALUES('T0003','R003','CEN03','CEN04')
  INTO tramo VALUES('T0004','R004','CEN04','CEN05')
  INTO tramo VALUES('T0005','R005','CEN05','CEN06')
  INTO tramo VALUES('T0006','R006','CEN06','CEN07')
  INTO tramo VALUES('T0007','R007','CEN07','CEN08')
  INTO tramo VALUES('T0008','R008','CEN08','CEN09')
  INTO tramo VALUES('T0009','R009','CEN09','CEN10')
  INTO tramo VALUES('T0010','R010','CEN10','CEN01')
SELECT * FROM dual;

INSERT ALL
  INTO reservacion VALUES('RS001','R001','CL001',TO_DATE('2025-09-20','YYYY-MM-DD'))
  INTO reservacion VALUES('RS002','R002','CL002',TO_DATE('2025-09-21','YYYY-MM-DD'))
  INTO reservacion VALUES('RS003','R003','CL003',TO_DATE('2025-09-22','YYYY-MM-DD'))
  INTO reservacion VALUES('RS004','R004','CL004',TO_DATE('2025-09-23','YYYY-MM-DD'))
  INTO reservacion VALUES('RS005','R005','CL005',TO_DATE('2025-09-24','YYYY-MM-DD'))
  INTO reservacion VALUES('RS006','R006','CL006',TO_DATE('2025-09-25','YYYY-MM-DD'))
  INTO reservacion VALUES('RS007','R007','CL007',TO_DATE('2025-09-26','YYYY-MM-DD'))
  INTO reservacion VALUES('RS008','R008','CL008',TO_DATE('2025-09-27','YYYY-MM-DD'))
  INTO reservacion VALUES('RS009','R009','CL009',TO_DATE('2025-09-28','YYYY-MM-DD'))
  INTO reservacion VALUES('RS010','R010','CL010',TO_DATE('2025-09-29','YYYY-MM-DD'))
SELECT * FROM dual;

INSERT ALL
  INTO recorrido VALUES('REC001','CON01','R001','T0001','08:00',40,'12:00')
  INTO recorrido VALUES('REC002','CON02','R002','T0002','09:00',38,'13:00')
  INTO recorrido VALUES('REC003','CON03','R003','T0003','10:00',42,'14:00')
  INTO recorrido VALUES('REC004','CON04','R004','T0004','11:00',39,'15:00')
  INTO recorrido VALUES('REC005','CON05','R005','T0005','07:30',37,'11:30')
  INTO recorrido VALUES('REC006','CON06','R006','T0006','12:00',35,'16:00')
  INTO recorrido VALUES('REC007','CON07','R007','T0007','06:00',45,'10:00')
  INTO recorrido VALUES('REC008','CON08','R008','T0008','13:00',41,'17:00')
  INTO recorrido VALUES('REC009','CON09','R009','T0009','14:00',38,'18:00')
  INTO recorrido VALUES('REC010','CON10','R010','T0010','15:00',40,'19:00')
SELECT * FROM dual;

INSERT ALL
  INTO boleto VALUES('01','RS001','REC001',550.00,'S')
  INTO boleto VALUES('02','RS002','REC002',650.00,'S')
  INTO boleto VALUES('03','RS003','REC003',700.00,'S')
  INTO boleto VALUES('04','RS004','REC004',620.00,'N')
  INTO boleto VALUES('05','RS005','REC005',580.00,'S')
  INTO boleto VALUES('06','RS006','REC006',610.00,'S')
  INTO boleto VALUES('07','RS007','REC007',730.00,'S')
  INTO boleto VALUES('08','RS008','REC008',690.00,'N')
  INTO boleto VALUES('09','RS009','REC009',720.00,'S')
  INTO boleto VALUES('10','RS010','REC010',640.00,'S')
SELECT * FROM dual;

-- <--	CONSULTAS	-->

SELECT * FROM BOLETO;