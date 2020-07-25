/*---------------------------------------------------------------------------------------------------*/
/*--------------------------------------------LLENANDO MODELO ER-------------------------------------*/

/*----------------------------INSERTANDO EN TABLA RAZA--------------------------------*/
USE PROYECTO_2;
INSERT INTO RAZA(nombre)
SELECT distinct (CAST(t.RAZA AS CHAR character SET utf8) COLLATE utf8_bin) as NAME FROM temporal t
WHERE t.RAZA is not null;

/*--------------------------INSERTANDO TABLA PAIS------------------------------------*/
INSERT INTO PAIS(nombre)
SELECT distinct (CAST(t.PAIS AS CHAR character SET utf8) COLLATE utf8_bin) as NAME_P FROM temporal t
WHERE t.PAIS is not null;

/*-------------------------------INSERTANDO TABLA REGION-------------------------------*/

INSERT INTO REGION(nombre)
SELECT distinct (CAST(t.REGION AS CHAR character SET utf8) COLLATE utf8_bin) as NAME_R
FROM temporal t
where t.REGION is not null;


/*--------------------------------INSERTANDO TABLA PAIS_REGION---------------------------*/
INSERT INTO PAIS_REGION(id_pais, id_region)
SELECT distinct p.id_pais,r.id_region
from temporal t
INNER JOIN PAIS p
ON  (CAST(p.nombre AS CHAR character SET utf8) COLLATE utf8_bin) =  (CAST(t.PAIS AS CHAR character SET utf8) COLLATE utf8_bin)
INNER JOIN REGION r
ON  (CAST(r.nombre AS CHAR character SET utf8) COLLATE utf8_bin) =  (CAST(t.REGION AS CHAR character SET utf8) COLLATE utf8_bin)
WHERE p.nombre IS NOT NULL AND r.nombre IS NOT NULL;

/*-------------------------------------INSERTANDO TABLA DEPARTAMENTO--------------------------------*/
INSERT INTO DEPARTAMENTO(nombre,id_region)
SELECT distinct t.DEPTO, r.id_region
FROM temporal t
INNER JOIN REGION r
ON  (CAST(r.nombre AS CHAR character SET utf8) COLLATE utf8_bin) =  (CAST(t.REGION AS CHAR character SET utf8) COLLATE utf8_bin)
INNER JOIN PAIS p ON p.nombre = t.PAIS
INNER JOIN PAIS_REGION pr ON pr.id_pais = p.id_pais and pr.id_region = r.id_region
group by pr.id_detalle, p.nombre, pr.id_region, t.DEPTO, r.id_region;

/*---------------------------------------INSERTANDO TABLA MUNICIPIO---------------------------------------*/
INSERT INTO MUNICIPIO(nombre,id_dept)
SELECT distinct t.MUNICIPIO, d.id_dept
FROM temporal t
INNER JOIN DEPARTAMENTO d
ON (CAST(d.nombre AS CHAR character SET utf8) COLLATE utf8_bin) = (CAST(t.DEPTO AS CHAR character SET utf8) COLLATE utf8_bin);

/*-------------------------------------INSERTANDO TABLA PARTIDO------------------------------------------*/
INSERT INTO PARTIDO(nombre,siglas)
SELECT distinct NOMBRE_PARTIDO, PARTIDO
FROM temporal
WHERE NOMBRE_PARTIDO IS NOT NULL AND PARTIDO IS NOT NULL;

/*----------------------------------INSERTANDO TABLA ELECCION ---------------------------------------*/
INSERT INTO ELECCION(nombre,anio,id_pais)
SELECT distinct t.NOMBRE_ELECCION,t.ANIO_ELECCION, p.id_pais
FROM temporal t
LEFT JOIN PAIS p
ON p.nombre= t.PAIS;


/*--------------------------------------INSERTANDO TABLA POBLACION--------------------------------------*/
INSERT INTO POBLACION(sexo, alfabetos,analfabetos,primaria,nivel_medio,universidad,id_eleccion,id_raza,id_municipio,id_partido)
SELECT distinct t.SEXO,t.ALFABETOS,t.ANALFABETOS,t.PRIMARIA,t.NIVEL_MEDIO,t.UNIVERSITARIOS,e.id_eleccion,r.id_raza,m.id_municipio,p.id_partido
FROM temporal t
INNER JOIN RAZA r
ON r.nombre = t.RAZA
INNER JOIN MUNICIPIO m
ON m.nombre = t.MUNICIPIO
INNER JOIN PARTIDO p
ON p.nombre = t.NOMBRE_PARTIDO AND p.siglas = t.PARTIDO
INNER JOIN ELECCION e
ON  e.nombre = t.NOMBRE_ELECCION AND e.anio = t.ANIO_ELECCION AND e.id_pais = 
(SELECT pa.id_pais from PAIS pa where pa.nombre=t.PAIS)
inner join PAIS pai
ON pai.nombre = t.PAIS
inner join DEPARTAMENTO de
ON de.nombre = t.DEPTO AND m.id_dept = de.id_dept;