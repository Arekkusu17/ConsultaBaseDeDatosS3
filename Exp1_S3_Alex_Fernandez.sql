-- Caso 1: Listado de Clientes con Rango de Renta
SELECT 
    TO_CHAR(c.numrut_cli, '999G999G999')|| '-' || c.dvrut_cli AS "RUT Cliente",
    INITCAP(c.nombre_cli) || ' ' || INITCAP(c.appaterno_cli) || ' ' || INITCAP(c.apmaterno_cli) AS "Nombre Completo Cliente",
    INITCAP(c.direccion_cli) AS "Direcci�n Cliente",
    TO_CHAR(c.renta_cli, '$999G999G999') AS "Renta Cliente",
    SUBSTR(LPAD(c.celular_cli, 9, '0'), 1, 2) || '-' ||
    SUBSTR(LPAD(c.celular_cli, 9, '0'), 3, 3) || '-' ||
    SUBSTR(LPAD(c.celular_cli, 9, '0'), 6, 4) AS "Celular Cliente",
    CASE
        WHEN c.renta_cli > 500000 THEN 'TRAMO 1'
        WHEN c.renta_cli BETWEEN 400000 AND 500000 THEN 'TRAMO 2'
        WHEN c.renta_cli BETWEEN 200000 AND 399999 THEN 'TRAMO 3'
        ELSE 'TRAMO 4'
    END AS "Tramo Renta Cliente"
FROM cliente c
WHERE (c.renta_cli BETWEEN &RENTA_MINIMA AND &RENTA_MAXIMA)
AND c.celular_cli IS NOT NULL
ORDER BY INITCAP(c.nombre_cli) || ' ' ||
    INITCAP(c.appaterno_cli) || ' ' ||
    INITCAP(c.apmaterno_cli);


-- CASO 2: Sueldo Promedio por Categor�a de Empleado.

SELECT
    e.id_categoria_emp AS "CODIGO_CATEGORIA",
    CASE e.id_categoria_emp
        WHEN 1 THEN 'Gerente'
        WHEN 2 THEN 'Supervisor'
        WHEN 3 THEN 'Ejecutivo de Arriendo'
        WHEN 4 THEN 'Auxiliar'
    END AS "DESCRIPCION_CATEGORIA",
    COUNT(*) AS "CANTIDAD_EMPLEADOS",
    CASE e.id_sucursal
        WHEN 10 THEN 'Sucursal Las Condes'
        WHEN 20 THEN 'Sucursal Santiago Centro'
        WHEN 30 THEN 'Sucursal Providencia'
        WHEN 40 THEN 'Sucursal Vitacura'
    END AS "SUCURSAL",
    TO_CHAR(ROUND(AVG(e.sueldo_emp)), '$999G999G999') AS "SUELDO_PROMEDIO"
FROM empleado e
GROUP BY e.id_categoria_emp, e.id_sucursal
HAVING AVG(e.sueldo_emp) > &SUELDO_PROMEDIO_MINIMO
ORDER BY AVG(e.sueldo_emp) DESC;


-- CASO 3: Arriendo Promedio por Tipo de Propiedad
SELECT
    p.id_tipo_propiedad AS "CODIGO_TIPO",
    CASE p.id_tipo_propiedad
        WHEN 'A' THEN 'CASA'
        WHEN 'B' THEN 'DEPARTAMENTO'
        WHEN 'C' THEN 'LOCAL'
        WHEN 'D' THEN 'PARCELA SIN CASA'
        WHEN 'E' THEN 'PARCELA CON CASA'
    END AS "DESCRIPCION_TIPO",
    COUNT(*) AS "TOTAL_PROPIEDADES",
    TO_CHAR(ROUND(AVG(p.valor_arriendo)), '$999G999G999') AS "PROMEDIO_ARRIENDO",
    TO_CHAR(ROUND(AVG(p.superficie),2), '999D00') AS "PROMEDIO_SUPERFICIE",
    TO_CHAR(ROUND(AVG(p.valor_arriendo / p.superficie)), '$999G999G999') AS "VALOR_ARRIENDO_M2",
    CASE
        WHEN AVG(p.valor_arriendo / p.superficie) < 5000 THEN 'Econ�mico'
        WHEN AVG(p.valor_arriendo / p.superficie) BETWEEN 5000 AND 10000 THEN 'Medio'
        ELSE 'Alto'
    END AS "CLASIFICACI�N"
FROM propiedad p
GROUP BY p.id_tipo_propiedad
HAVING AVG(p.valor_arriendo / p.superficie) > 1000
ORDER BY AVG(p.valor_arriendo / p.superficie) DESC;

