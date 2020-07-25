

/*---------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------CONSULTAS---------------------------------------------------*/

/*-------------------------------------------CONSULTA NO.1------------------------------------------------------*/
USE PROYECTO_2;
SELECT ele.nombre, ele.anio, p.nombre,pa.nombre, max((select sum(pob.alfabetos)+sum(pob.analfabetos) from POBLACION pob
where pob.id_partido = pa.id_partido)) / (select sum(pob.alfabetos)+sum(pob.analfabetos) from POBLACION pob
INNER JOIN ELECCION ele
ON ele.id_eleccion = pob.id_eleccion
where ele.id_pais = p.id_pais) *100 as suma
FROM PARTIDO pa
INNER JOIN POBLACION po
ON pa.id_partido = po.id_partido
INNER JOIN ELECCION ele
ON ele.id_eleccion = po.id_eleccion
INNER JOIN PAIS p
on p.id_pais = ele.id_pais
group by p.nombre;



/*------------------------------------CONSULTA NO.4--------------------------------------------*/
SELECT r.nombre,pa.nombre, sum(po.alfabetos+po.analfabetos) as total_votos
FROM POBLACION po 
INNER JOIN ELECCION ele
ON ele.id_eleccion = po.id_eleccion
INNER JOIN PAIS pa
ON pa.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
ON pa.id_pais = pr.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN MUNICIPIO muni
ON muni.id_municipio = po.id_municipio
inner join RAZA ra
ON ra.id_raza = po.id_raza and ra.nombre='INDIGENAS' 
INNER JOIN DEPARTAMENTO de
on de.id_dept = muni.id_dept and de.id_region = r.id_region
group by pr.id_detalle
having total_votos >
(select sum(po2.alfabetos+po2.analfabetos) FROM POBLACION po2
INNER JOIN ELECCION ele2 ON ele2.id_eleccion = po2.id_eleccion
INNER JOIN PAIS pa2 ON pa2.id_pais = ele2.id_pais
INNER JOIN PAIS_REGION pr2 ON pa2.id_pais = pr2.id_pais
INNER JOIN REGION r2 ON r2.id_region = pr2.id_region
INNER JOIN MUNICIPIO muni2 ON muni2.id_municipio = po2.id_municipio
inner join RAZA ra2 ON ra2.id_raza = po2.id_raza and ra2.nombre='LADINOS' 
INNER JOIN DEPARTAMENTO de2 on de2.id_dept = muni2.id_dept and de2.id_region = r2.id_region
WHERE pr.id_detalle = pr2.id_detalle
group by pr2.id_detalle) and total_votos >
(select sum(po3.alfabetos+po3.analfabetos) FROM POBLACION po3
INNER JOIN ELECCION ele3 ON ele3.id_eleccion = po3.id_eleccion
INNER JOIN PAIS pa3 ON pa3.id_pais = ele3.id_pais
INNER JOIN PAIS_REGION pr3 ON pa3.id_pais = pr3.id_pais
INNER JOIN REGION r3 ON r3.id_region = pr3.id_region
INNER JOIN MUNICIPIO muni3 ON muni3.id_municipio = po3.id_municipio
inner join RAZA ra3 ON ra3.id_raza = po3.id_raza and ra3.nombre='GARIFUNAS' 
INNER JOIN DEPARTAMENTO de3 on de3.id_dept = muni3.id_dept and de3.id_region = r3.id_region
WHERE pr.id_detalle = pr3.id_detalle
group by pr3.id_detalle); 


/*--------------------------------------------CONSULTA NO.5------------------------------------------------*/
select p.nombre as pais, d.nombre as departamento,muni.nombre as municipio, pa.nombre as partido, 
sum(po.universidad) as votos
from PAIS_REGION pr
INNER JOIN PAIS p ON p.id_pais = pr.id_pais
INNER JOIN REGION r ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d ON d.id_region = r.id_region
INNER JOIN MUNICIPIO muni ON muni.id_dept = d.id_dept
INNER JOIN POBLACION po ON po.id_municipio = muni.id_municipio 
INNER JOIN ELECCION ele ON ele.id_eleccion = po.id_eleccion and ele.id_pais = p.id_pais
INNER JOIN PARTIDO pa ON pa.id_partido = po.id_partido
INNER JOIN RAZA ra on ra.id_raza = po.id_raza
GROUP BY p.nombre, d.nombre,muni.nombre,pa.nombre
having votos > sum(po.primaria)*0.25 and votos < sum(po.nivel_medio)*0.30
order by votos desc;




/*---------------------------------------------CONSULTA NO.6-----------------------------------------*/
SELECT d.nombre, (sum(po.universidad)/sum(po.alfabetos+po.analfabetos))*100 as porcentaje_mujeres
from POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept and po.sexo='mujeres'
INNER JOIN RAZA ra
ON ra.id_raza = po.id_raza
INNER JOIN PARTIDO par
ON par.id_partido = po.id_partido
group by d.nombre
having sum(po.universidad)> 
(select sum(po2.universidad) as porcentaje
from POBLACION po2
INNER JOIN ELECCION ele2
on ele2.id_eleccion = po2.id_eleccion
INNER JOIN MUNICIPIO muni2
on muni2.id_municipio = po2.id_municipio
INNER JOIN PAIS p2
ON p2.id_pais = ele2.id_pais
INNER JOIN PAIS_REGION pr2
on pr2.id_pais = p2.id_pais
INNER JOIN REGION r2
ON r2.id_region = pr2.id_region
INNER JOIN DEPARTAMENTO d2
ON d2.id_region = r2.id_region AND muni2.id_dept = d2.id_dept and po2.sexo='hombres'
INNER JOIN RAZA ra2
ON ra2.id_raza = po2.id_raza
INNER JOIN PARTIDO par2
ON par2.id_partido = po2.id_partido
where d.nombre=d2.nombre
);

/*------------------------------------------CONSULTA NO.7---------------------------------------*/
SELECT p.nombre as pais, r.nombre as region,(sum(po.alfabetos+po.analfabetos)/tota_dept(p.id_pais,r.id_region)) as votos
from POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept
INNER JOIN RAZA ra
ON ra.id_raza = po.id_raza
group by p.nombre,r.nombre,p.id_pais, pr.id_region;


/*-----------------------------------------CONSULTA NO.9-------------------------------------*/
SELECT p.nombre, sum(po.primaria) as PRIMARIA, sum(po.nivel_medio) as NIVEL_MEDIO, sum(po.universidad) as UNIVERSIDAD
from POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept
group by p.nombre;


/*--------------------------------consulta no.10----------------------------*/
select p.nombre as pais, ra.nombre as raza,(sum(po.alfabetos+po.analfabetos)/ (select sum(po2.alfabetos+po2.analfabetos) 
from POBLACION po2
INNER JOIN ELECCION ele2 on ele2.id_eleccion = po2.id_eleccion
INNER JOIN MUNICIPIO muni2 on muni2.id_municipio = po2.id_municipio
INNER JOIN PAIS p2 ON p2.id_pais = ele2.id_pais
INNER JOIN PAIS_REGION pr2 on pr2.id_pais = p2.id_pais
INNER JOIN REGION r2 ON r2.id_region = pr2.id_region
INNER JOIN DEPARTAMENTO d2 ON d2.id_region = r2.id_region AND muni2.id_dept = d2.id_dept
INNER JOIN RAZA ra2 on ra2.id_raza = po2.id_raza
where p.nombre = p2.nombre
group by p.nombre)) *100 as porcentaje
from POBLACION po
INNER JOIN ELECCION ele on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr on pr.id_pais = p.id_pais
INNER JOIN REGION r ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d ON d.id_region = r.id_region AND muni.id_dept = d.id_dept
INNER JOIN RAZA ra on ra.id_raza = po.id_raza
group by p.nombre,ra.nombre;



/*-------------------------------------------CONSULTA NO.12-----------------------*/
SELECT ele.anio, sum(po.alfabetos) as total_votos, (sum(po.alfabetos)/(select TOTAL_AÑOS(ele.anio)))*100 as porcentaje
from POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept
INNER JOIN RAZA ra
ON ra.id_raza = po.id_raza
where po.sexo = 'mujeres' and ra.nombre= 'INDIGENAS' 
group by ele.anio;

/*------------------------------------------CONSULTA NO.13----------------------------------*/
select p.nombre, (sum(po.analfabetos)/sum(po.alfabetos+po.analfabetos)*100) as porcentaje
from POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept
group by p.nombre
order by porcentaje desc
limit 1;


/*------------------------------------CONSULTA NO.14----------------------------------*/
SELECT d.nombre,sum(po.alfabetos+po.analfabetos) as votos
FROM POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept and  p.nombre = 'GUATEMALA'
group by d.nombre
having votos >(select sum(po.alfabetos+po.analfabetos) as total
FROM POBLACION po
INNER JOIN ELECCION ele
on ele.id_eleccion = po.id_eleccion
INNER JOIN MUNICIPIO muni
on muni.id_municipio = po.id_municipio
INNER JOIN PAIS p
ON p.id_pais = ele.id_pais
INNER JOIN PAIS_REGION pr
on pr.id_pais = p.id_pais
INNER JOIN REGION r
ON r.id_region = pr.id_region
INNER JOIN DEPARTAMENTO d
ON d.id_region = r.id_region AND muni.id_dept = d.id_dept and  d.nombre = 'Guatemala');