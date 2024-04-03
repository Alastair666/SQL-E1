-- Validando Creación de Base de Datos (En caso de no existir)
DROP DATABASE IF EXISTS ansi_db;
CREATE DATABASE IF NOT EXISTS ansi_db;
USE ansi_db;

/** Creación de las Tablas **/
-- CÓDIGO POSTAL
CREATE TABLE codigo_postal (
id_codigo_postal INT NOT NULL AUTO_INCREMENT,
cp VARCHAR(7) NOT NULL,
c_estado VARCHAR(10) NOT NULL,
c_municipio VARCHAR(10) NOT NULL,
id_pais INT NOT NULL,
PRIMARY KEY (id_codigo_postal),
KEY (cp)
);
-- DOMICILIO
CREATE TABLE domicilio (
id_domicilio INT NOT NULL AUTO_INCREMENT,
cp VARCHAR(7) NOT NULL,
colonia VARCHAR(150) NOT NULL,
calle VARCHAR(150) NOT NULL,
no_ext VARCHAR(7) NOT NULL,
no_int VARCHAR(7) NOT NULL,
PRIMARY KEY (id_domicilio),
FOREIGN KEY (cp) REFERENCES codigo_postal(cp)
);
-- BENEFICIARIO
CREATE TABLE beneficiarios (
id_beneficiario INT NOT NULL AUTO_INCREMENT,
id_domicilio INT NOT NULL,
ap_paterno VARCHAR(50) NOT NULL,
ap_materno VARCHAR(50) NOT NULL,
nombre VARCHAR(100) NOT NULL,
fecha_nac DATE NOT NULL,
id_genero TINYINT NOT NULL,
id_tipo_seguro TINYINT NOT NULL,
no_afiliacion VARCHAR(10) NOT NULL,
clave_mem VARCHAR(25) NOT NULL,
fecha_ingreso DATE NOT NULL,
PRIMARY KEY (id_beneficiario),
FOREIGN KEY (id_domicilio) REFERENCES domicilio(id_domicilio)
);
CREATE UNIQUE INDEX idx_clave_mem ON beneficiarios(clave_mem);
-- TUTORES
CREATE TABLE tutores (
id_tutor INT NOT NULL AUTO_INCREMENT,
id_beneficiario INT NOT NULL,
id_domicilio INT NOT NULL,
id_prioridad INT NOT NULL,
ap_paterno VARCHAR(50) NOT NULL,
ap_materno VARCHAR(50) NOT NULL,
nombre VARCHAR(100) NOT NULL,
id_parentesco TINYINT NOT NULL,
no_tel_1 VARCHAR(20) NOT NULL,
no_tel_2 VARCHAR(20) NOT NULL,
PRIMARY KEY (id_tutor),
FOREIGN KEY (id_beneficiario) REFERENCES beneficiarios(id_beneficiario),
FOREIGN KEY (id_domicilio) REFERENCES domicilio(id_domicilio)
);
-- DISTRITO
CREATE TABLE distrito (
id_distrito INT NOT NULL AUTO_INCREMENT,
id_estatus TINYINT NOT NULL,
descripcion VARCHAR(20) NOT NULL,
abreviatura VARCHAR(10) NOT NULL,
fecha_fundacion DATE NOT NULL,
PRIMARY KEY (id_distrito)
);
-- GRUPO
CREATE TABLE grupo (
id_grupo INT NOT NULL AUTO_INCREMENT,
id_distrito INT NOT NULL,
id_estatus TINYINT NOT NULL,
nombre VARCHAR(100) NOT NULL,
numero INT NOT NULL,
id_domicilio INT NOT NULL,
fecha_fundacion DATE NOT NULL,
PRIMARY KEY (id_grupo),
FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito),
FOREIGN KEY (id_domicilio) REFERENCES domicilio(id_domicilio)
);
-- SECCION
CREATE TABLE seccion (
id_seccion INT NOT NULL AUTO_INCREMENT,
edad_inicial INT NOT NULL,
edad_final INT NOT NULL,
nombre VARCHAR(50) NOT NULL,
id_seccion_anterior INT NOT NULL,
PRIMARY KEY (id_seccion)
);
-- ADELANTOS
CREATE TABLE adelantos (
id_adelantos INT NOT NULL AUTO_INCREMENT,
id_seccion INT NOT NULL,
descripcion VARCHAR(50) NOT NULL,
id_adelanto_anterior INT NOT NULL,
adelanto_terminal BIT NOT NULL,
PRIMARY KEY (id_adelantos),
FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);
-- RETOS
CREATE TABLE retos (
id_reto INT NOT NULL AUTO_INCREMENT,
id_adelantos INT NOT NULL,
id_categoria INT NOT NULL,
id_reto_anterior INT NOT NULL,
descripcion VARCHAR(500) NOT NULL,
predeterminado BIT NOT NULL,
PRIMARY KEY (id_reto),
FOREIGN KEY (id_adelantos) REFERENCES adelantos(id_adelantos)
);
-- REGISTRO
CREATE TABLE registro (
id_registro INT NOT NULL AUTO_INCREMENT,
id_beneficiario INT NOT NULL,
id_distrito INT NOT NULL,
id_grupo INT NOT NULL,
id_estatus TINYINT NOT NULL,
id_seccion INT NOT NULL,
año INT NOT NULL,
fecha_inicio DATE NOT NULL,
fecha_termino DATE NOT NULL,
PRIMARY KEY (id_registro),
FOREIGN KEY (id_beneficiario) REFERENCES beneficiarios(id_beneficiario),
FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito),
FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo),
FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);
-- ADELANTO PROGRESIVO
CREATE TABLE adelanto_progresivo (
id_adelanto_progresivo INT,
id_registro INT,
id_adelantos INT,
id_estatus TINYINT,
fecha_propuesta DATE,
fecha_real DATE,
observaciones VARCHAR(200),
PRIMARY KEY (id_adelanto_progresivo),
FOREIGN KEY (id_registro) REFERENCES registro(id_registro),
FOREIGN KEY (id_adelantos) REFERENCES adelantos(id_adelantos)
);
-- ADELANTO PROGRESIVO DETALLE
CREATE TABLE adelanto_progresivo_detalle (
id_detalles_adelanto INT,
id_adelanto_progresivo INT,
id_reto INT,
completado BIT,
fecha_realizado DATE,
detalles VARCHAR(200),
PRIMARY KEY (id_detalles_adelanto),
FOREIGN KEY (id_adelanto_progresivo) REFERENCES adelanto_progresivo(id_adelanto_progresivo),
FOREIGN KEY (id_reto) REFERENCES retos(id_reto)
);
-- TABLAS
CREATE TABLE tablas (
id_tabla INT,
nombre_tabla VARCHAR(50),
id_tipo TINYINT,
alias_tabla VARCHAR(50),
descripcion VARCHAR(500),
campo_llave VARCHAR(20),
PRIMARY KEY (id_tabla)
);
-- BITACORA TIPO
CREATE TABLE bitacora_tipo (
id_bitacora_tipo INT,
id_tabla INT,
descripcion VARCHAR(200),
id_clasificacion TINYINT,
PRIMARY KEY (id_bitacora_tipo),
FOREIGN KEY (id_tabla) REFERENCES tablas(id_tabla)
);
-- CATALOGO TIPO
CREATE TABLE catalogo_tipo (
id_catalogo_tipo INT,
id_tabla INT,
descripcion VARCHAR(50),
id_tipo_superior INT,
PRIMARY KEY (id_catalogo_tipo),
FOREIGN KEY (id_tabla) REFERENCES tablas(id_tabla)
);
-- CATALOGO
CREATE TABLE catalogo (
id_catalogo INT,
id_catalogo_tipo INT,
id_catalogo_superior INT,
id_valor INT,
descripcion VARCHAR(50),
valor_alternativo VARCHAR(50),
PRIMARY KEY (id_catalogo),
FOREIGN KEY (id_catalogo_tipo) REFERENCES catalogo_tipo(id_catalogo_tipo)
);
-- USUARIO
CREATE TABLE usuario (
id_usuario INT,
nombre VARCHAR(100),
email VARCHAR(100),
no_telefono VARCHAR(15),
clave_acceso VARCHAR(100),
sesiones_disponibles INT,
fecha_registro DATE,
duracion_sesion INT,
PRIMARY KEY (id_usuario)
);
-- SESIÓN USUARIO
CREATE TABLE sesion_usuario (
id_sesion INT,
id_usuario INT,
id_estatus_sesion TINYINT,
id_tipo_dispositivo TINYINT,
fecha_inicio DATETIME,
duracion_min INT,
nombre_disp VARCHAR(50),
PRIMARY KEY (id_sesion),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
-- BITACORA
CREATE TABLE bitacora (
id_bitacora BIGINT,
id_bitacora_tipo INT,
id_tabla INT,
id_registro INT,
fecha_bitacora DATE,
detalles VARCHAR(150),
id_sesion INT,
PRIMARY KEY (id_bitacora),
FOREIGN KEY (id_bitacora_tipo) REFERENCES bitacora_tipo(id_bitacora_tipo),
FOREIGN KEY (id_tabla) REFERENCES tablas(id_tabla)
);
-- PERFIL
CREATE TABLE perfil (
id_perfil INT,
nombre VARCHAR(50),
detalles VARCHAR(150),
administrador BIT,
PRIMARY KEY (id_perfil)
);
-- PERFIL USUARIO
CREATE TABLE perfil_usuario (
id_perfil_usuario INT,
id_usuario INT,
id_perfil INT,
perfil_activo BIT,
PRIMARY KEY (id_perfil_usuario),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);
-- PERFIL ACCIONES
CREATE TABLE perfil_acciones (
id_perfil_acciones INT,
id_perfil INT,
id_accion INT,
permitir BIT,
PRIMARY KEY (id_perfil_acciones),
FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);