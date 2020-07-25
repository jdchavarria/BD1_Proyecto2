
/*-------------------------------------------------CONTADORES-------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------*/

/*--------------------------------------------------VOTACION--------------------------------------------------------*/
SELECT 'VOTACION' AS TABLA, COUNT(*) AS TOTAL FROM POBLACION;

/*--------------------------------------------------PARTIDO---------------------------------------------------------*/
SELECT 'PARTIDO' AS TABLA, COUNT(*) AS TOTAL FROM PARTIDO;

/*-------------------------------------------------MUNICIPIO--------------------------------------------------------*/
SELECT 'MUNICIPIO' AS TABLA, COUNT(*) AS TOTAL FROM MUNICIPIO;

/*-----------------------------------------------DEPARTAMENTO--------------------------------------------------*/
SELECT 'DEPARTAMENTO' AS TABLA, COUNT(*) AS TOTAL FROM DEPARTAMENTO;

/*-------------------------------------------------REGION-----------------------------------------------------------*/
SELECT 'REGION' AS TABLA, COUNT(*) AS TOTAL FROM REGION;

/*-------------------------------------------------PAIS--------------------------------------------------------------*/
SELECT 'PAIS' AS TABLA, COUNT(*) AS TOTAL FROM PAIS;

/*-------------------------------------------------ELECCION---------------------------------------------------------*/
SELECT 'ELECCION' AS TABLA, COUNT(*) AS TOTAL FROM ELECCION;
select ele.anio as cantidad  from ELECCION ele
group by ele.anio;

/*--------------------------------------------CANTIDAD DE VOTOS------------------------------------------------------*/
SELECT SUM(po.alfabetos+analfabetos) as cantidad_votos
from POBLACION po;
