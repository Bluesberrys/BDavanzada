CREATE TABLESPACE GALGO DATAFILE 'D:\Max\Proyectos\BDavanzada/GALGO.DBF' SIZE 10M; 

CREATE USER BLUE IDENTIFIED BY 090322 DEFAULT TABLESPACE GALGO;

GRANT CONNECT, CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, UNLIMITED TABLESPACE TO BLUE;

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

-- <--	INSERT	-->
INSERT INTO cliente VALUES
('CL001','Juan','Hernández','López','Av. Reforma 123, CDMX'),
('CL002','María','García','Pérez','Calle Morelos 45, Puebla'),
('CL003','Luis','Ramírez','Cruz','Av. Juárez 67, Guadalajara'),
('CL004','Ana','Flores','Martínez','Calle Hidalgo 22, Monterrey'),
('CL005','Carlos','Sánchez','Moreno','Blvd. Díaz Ordaz 130, León'),
('CL006','Fernanda','Ortiz','Reyes','Calle Independencia 11, Toluca'),
('CL007','José','Vargas','Ruiz','Calle Juárez 501, Querétaro'),
('CL008','Valeria','Torres','Rojas','Av. Insurgentes 999, CDMX'),
('CL009','Miguel','Navarro','Soto','Calle Allende 34, Mérida'),
('CL010','Lucía','Cortés','Aguilar','Av. Universidad 101, San Luis Potosí');

INSERT INTO centrales VALUES
('CEN01','Central Norte','CDMX','15','5551234567'),
('CEN02','Central Sur','CDMX','12','5557654321'),
('CEN03','Central de Guadalajara','Guadalajara','10','3335678912'),
('CEN04','Central de Monterrey','Monterrey','14','8187654321'),
('CEN05','Central de Puebla','Puebla','11','2223344556'),
('CEN06','Central de León','León','8','4771122334'),
('CEN07','Central de Toluca','Toluca','7','7229988776'),
('CEN08','Central de Querétaro','Querétaro','9','4426655443'),
('CEN09','Central de Mérida','Mérida','6','9993344556'),
('CEN10','Central de SLP','San Luis Potosí','8','4445566778');

INSERT INTO camion VALUES
('NCI000000001','ABC1234','001','Volvo','2020','45','CEN01'),
('NCI000000002','BCD2345','002','Mercedes','2019','40','CEN02'),
('NCI000000003','CDE3456','003','Scania','2021','42','CEN03'),
('NCI000000004','DEF4567','004','MAN','2022','44','CEN04'),
('NCI000000005','EFG5678','005','Volvo','2020','38','CEN05'),
('NCI000000006','FGH6789','006','Mercedes','2018','36','CEN06'),
('NCI000000007','GHI7890','007','Scania','2021','50','CEN07'),
('NCI000000008','HIJ8901','008','MAN','2022','48','CEN08'),
('NCI000000009','IJK9012','009','Volvo','2019','40','CEN09'),
('NCI000000010','JKL0123','010','Mercedes','2020','42','CEN10');

INSERT INTO imprevisto VALUES
('001','Ponchadura de llanta','Una de las llantas delanteras sufrió una ponchadura.','B'),
('002','Falla mecánica','Problema en el motor detectado durante el recorrido.','A'),
('003','Retraso por tráfico','Tráfico pesado en la autopista principal.','C'),
('004','Problema eléctrico','Falla en el sistema de luces interiores.','B'),
('005','Puerta atascada','Puerta trasera no cierra correctamente.','C'),
('006','Avería de aire acondicionado','Sistema de aire no enfría.','B'),
('007','Accidente leve','Colisión menor sin heridos.','A'),
('008','Retraso por clima','Lluvias intensas causaron demora.','C'),
('009','Vidrio roto','Ventana lateral rota por impacto.','B'),
('010','Frenos defectuosos','Sistema de frenos requiere revisión urgente.','A');

INSERT INTO problemas VALUES
('P0001','001','NCI000000001','2025-09-12','CDMX'),
('P0002','002','NCI000000004','2025-09-15','Monterrey'),
('P0003','003','NCI000000003','2025-09-10','Guadalajara'),
('P0004','004','NCI000000006','2025-09-11','León'),
('P0005','005','NCI000000005','2025-09-18','Puebla'),
('P0006','006','NCI000000007','2025-09-13','Toluca'),
('P0007','007','NCI000000009','2025-09-09','Mérida'),
('P0008','008','NCI000000008','2025-09-14','Querétaro'),
('P0009','009','NCI000000010','2025-09-19','San Luis Potosí'),
('P0010','010','NCI000000002','2025-09-20','CDMX');

INSERT INTO chofer VALUES
('HJLJ800101MX1','Jorge','López','Jiménez','12345678901',45,'Av. Central 23, CDMX','jorge.lopez@correo.com','5512345678',10),
('MGCP820202MX2','Marcos','García','Pineda','23456789012',43,'Calle Sol 77, Puebla','marcos.garcia@correo.com','5523456789',8),
('LRRC900303MX3','Luis','Ramírez','Cano','34567890123',38,'Av. Hidalgo 12, Guadalajara','luis.ramirez@correo.com','5534567890',6),
('AFSM850404MX4','Alberto','Flores','Sánchez','45678901234',40,'Calle Sur 45, Monterrey','alberto.flores@correo.com','5545678901',7),
('CMMR870505MX5','Carlos','Moreno','Rojas','56789012345',41,'Blvd. Hidalgo 99, León','carlos.moreno@correo.com','5556789012',9),
('FOTR910606MX6','Fernando','Torres','Ríos','67890123456',34,'Calle Palma 22, Toluca','fernando.torres@correo.com','5567890123',5),
('JVRZ920707MX7','Javier','Vázquez','Ruiz','78901234567',33,'Av. Insurgentes 350, Querétaro','javier.vazquez@correo.com','5578901234',4),
('MNRL930808MX8','Manuel','Navarro','Lara','89012345678',32,'Calle Norte 8, Mérida','manuel.navarro@correo.com','5589012345',4),
('LSAR950909MX9','Laura','Sánchez','Ramos','90123456789',30,'Av. México 45, Puebla','laura.sanchez@correo.com','5590123456',3),
('LAGR960101MX0','Lucía','Aguilar','Rojas','01234567890',29,'Calle Juárez 55, CDMX','lucia.aguilar@correo.com','5501234567',2);

INSERT INTO conduce VALUES
('CON01','HJLJ800101MX1','NCI000000001'),
('CON02','MGCP820202MX2','NCI000000002'),
('CON03','LRRC900303MX3','NCI000000003'),
('CON04','AFSM850404MX4','NCI000000004'),
('CON05','CMMR870505MX5','NCI000000005'),
('CON06','FOTR910606MX6','NCI000000006'),
('CON07','JVRZ920707MX7','NCI000000007'),
('CON08','MNRL930808MX8','NCI000000008'),
('CON09','LSAR950909MX9','NCI000000009'),
('CON10','LAGR960101MX0','NCI000000010');

INSERT INTO ruta VALUES
('R001','CEN01','CEN03'),
('R002','CEN03','CEN04'),
('R003','CEN05','CEN01'),
('R004','CEN02','CEN06'),
('R005','CEN07','CEN08'),
('R006','CEN08','CEN09'),
('R007','CEN04','CEN10'),
('R008','CEN10','CEN05'),
('R009','CEN09','CEN02'),
('R010','CEN06','CEN07');

INSERT INTO tramo VALUES
('T0001','R001','CEN01','CEN02'),
('T0002','R002','CEN03','CEN04'),
('T0003','R003','CEN05','CEN01'),
('T0004','R004','CEN02','CEN06'),
('T0005','R005','CEN07','CEN08'),
('T0006','R006','CEN08','CEN09'),
('T0007','R007','CEN04','CEN10'),
('T0008','R008','CEN10','CEN05'),
('T0009','R009','CEN09','CEN02'),
('T0010','R010','CEN06','CEN07');

INSERT INTO reservacion VALUES
('RS001','R001','CL001','2025-09-20'),
('RS002','R002','CL002','2025-09-21'),
('RS003','R003','CL003','2025-09-22'),
('RS004','R004','CL004','2025-09-23'),
('RS005','R005','CL005','2025-09-24'),
('RS006','R006','CL006','2025-09-25'),
('RS007','R007','CL007','2025-09-26'),
('RS008','R008','CL008','2025-09-27'),
('RS009','R009','CL009','2025-09-28'),
('RS010','R010','CL010','2025-09-29');

INSERT INTO recorrido VALUES
('REC001','CON01','R001','T0001','07:30',20,'07:45'),
('REC002','CON02','R002','T0002','08:00',15,'08:10'),
('REC003','CON03','R003','T0003','09:00',18,'09:20'),
('REC004','CON04','R004','T0004','10:00',25,'10:15'),
('REC005','CON05','R005','T0005','11:30',22,'11:45'),
('REC006','CON06','R006','T0006','12:00',17,'12:20'),
('REC007','CON07','R007','T0007','13:15',19,'13:35'),
('REC008','CON08','R008','T0008','14:00',16,'14:25'),
('REC009','CON09','R009','T0009','15:00',14,'15:10'),
('REC010','CON10','R010','T0010','16:00',21,'16:15');

INSERT INTO boleto VALUES
('01','RS001','REC001',250.00,'S'),
('02','RS001','REC001',250.00,'S'),
('03','RS002','REC002',300.00,'S'),
('04','RS003','REC003',280.00,'N'),
('05','RS004','REC004',320.00,'S'),
('06','RS005','REC005',350.00,'S'),
('07','RS006','REC006',270.00,'N'),
('08','RS007','REC007',310.00,'S'),
('09','RS008','REC008',330.00,'S'),
('10','RS009','REC009',290.00,'S');
