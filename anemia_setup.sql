USE AnemiaSanMartin;

-- Eliminación de tablas si es que existen

DROP TABLE IF EXISTS RegistroAtencion;
DROP TABLE IF EXISTS Establecimiento;
DROP TABLE IF EXISTS Diagnostico;
DROP TABLE IF EXISTS Grado;
DROP TABLE IF EXISTS TipoDiagnostico;
DROP TABLE IF EXISTS Ubicacion;



-- Creación de tablas

CREATE TABLE Ubicacion (
	idUbicacion INT IDENTITY PRIMARY KEY,
	departamento NVARCHAR(50),
	provincia NVARCHAR(50),
	distrito NVARCHAR(50)
);



CREATE TABLE Establecimiento (
	idEstablecimiento INT IDENTITY PRIMARY KEY,
	idUbicación INT FOREIGN KEY REFERENCES Ubicacion(idUbicacion),
	codigoUnico INT,
	nombreEstablecimiento NVARCHAR(50),
	red NVARCHAR(50),
	microRed NVARCHAR(50),
	latitud FLOAT,
	longitud FLOAT,
);



CREATE TABLE TipoDiagnostico(
	idTipoDiagnostico INT IDENTITY PRIMARY KEY,
	valor CHAR(1),
)



CREATE TABLE Grado(
	idGrado INT IDENTITY PRIMARY KEY,
	gradoSeveridad CHAR(3),
)


CREATE TABLE Diagnostico (
	idDiagnostico INT IDENTITY PRIMARY KEY,
	nombre NVARCHAR(100),
);



CREATE TABLE RegistroAtencion (
    pkRegistro INT PRIMARY KEY,
    fechaRegistro DATE,
    fechaAtencion DATE,
	genero CHAR(1),
	edad INT,
	tipoEdad CHAR(1),
	etnia NVARCHAR(50),
    cantidad INT,
    financiador VARCHAR(255),
    fechaCorte DATE,
	idDiagnostico INT FOREIGN KEY REFERENCES Diagnostico(idDiagnostico),
    idGrado INT FOREIGN KEY REFERENCES Grado(idGrado),
	idTipoDiagnostico INT FOREIGN KEY REFERENCES TipoDiagnostico(idTipoDiagnostico),
	idEstablecimiento INT FOREIGN KEY REFERENCES Establecimiento(idEstablecimiento),
);

-- Inserción de datos en las tablas

INSERT INTO Ubicacion (departamento, provincia, distrito)
SELECT DISTINCT 
    DEPARTAMENTO,
    PROVINCIA,
    DISTRITO
FROM dbo.Anemia;



INSERT INTO Diagnostico (nombre)
SELECT DISTINCT
	DIAGNOSTICO
FROM dbo.Anemia;



INSERT INTO TipoDiagnostico (valor)
SELECT DISTINCT
	TIPO_DIAGNOSTICO
FROM dbo.Anemia
WHERE TIPO_DIAGNOSTICO IS NOT NULL;



INSERT INTO Grado (gradoSeveridad)
SELECT DISTINCT
	GRADO_SEVERIDAD
FROM dbo.Anemia
WHERE GRADO_SEVERIDAD IS NOT NULL;



INSERT INTO Establecimiento (
	idUbicación,
	nombreEstablecimiento,
	codigoUnico,
	red,
	microRed,
	latitud,
	longitud
)
SELECT DISTINCT
	u.idUbicacion,
	NOMBRE_ESTABLECIMIENTO,
	CODIGO_UNICO,
	RED,
	MICRORED,
	LATITUD,
	LONGITUD
FROM dbo.Anemia a
JOIN Ubicacion u
	ON a.DEPARTAMENTO = u.departamento
	AND a.PROVINCIA = u.provincia
	AND a.DISTRITO = u.distrito;



INSERT INTO RegistroAtencion(
	pkRegistro,
    fechaRegistro,
    fechaAtencion,
	genero,
	edad,
	tipoEdad,
	etnia,
    cantidad,
    financiador,
    fechaCorte,
	idDiagnostico,
    idGrado,
	idTipoDiagnostico,
	idEstablecimiento
)
SELECT DISTINCT 
	PK_REGISTRO,
    FECHA_REGISTRO,
    F_ATENCION,
	GENERO,
	EDAD_REGISTRO,
	TIPO_EDAD,
	ETNIA,
    CANTIDAD,
    DESCRIPCION_FINANCIADOR,
    FECHA_CORTE,
	d.idDiagnostico,
    g.idGrado,
	td.idTipoDiagnostico,
	e.idEstablecimiento
FROM dbo.Anemia a
JOIN Diagnostico d
	ON a.DIAGNOSTICO = d.nombre
JOIN Grado g
	ON a.GRADO_SEVERIDAD = g.gradoSeveridad
JOIN TipoDiagnostico td
	ON a.TIPO_DIAGNOSTICO = td.valor
JOIN Ubicacion u
	ON a.DEPARTAMENTO = u.departamento
	AND a.PROVINCIA = u.provincia
	AND a.DISTRITO = u.distrito
JOIN Establecimiento e
	ON e.nombreEstablecimiento = a.NOMBRE_ESTABLECIMIENTO
	AND e.codigoUnico = a.CODIGO_UNICO
	AND e.idUbicación = u.idUbicacion;

