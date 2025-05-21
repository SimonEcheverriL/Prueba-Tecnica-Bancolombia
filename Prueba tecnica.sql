
/*1.Cuáles son las ventas de cada uno de los productos vendidos por categoría y por cada uno de los vendedores, indique aquí los nombres de estado civil sexo y tipo de identificación de cada vendedor en la consulta.*/

SELECT 
    ct.idCategoria,
    prod.NombreProducto,
    (vd.Nombre1 || ' ' ||  vd.Apellido1) AS Nombre_Vendedor,
    vd.EstadoCivil AS Estado_Civil_Vendedor,
    vd.Sexo,
    vd.TipoDeidentificacion,
    SUM(dv.Total) AS Total_Ventas,
    SUM(dv.Cantidad) AS Total_Unidades_Vendidas
FROM 
    TblDetalleVenta dv
	
INNER JOIN TblVenta v ON dv.idFactura = v.idFactura
INNER JOIN TblProducto prod ON dv.idProducto = prod.idProducto
INNER JOIN TblCategoria ct ON prod.idCategoria = ct.idCategoria
INNER JOIN TblVendedor vd ON v.Vendedor = vd.identificacion

GROUP BY 
    ct.idCategoria,
    prod.NombreProducto,
    Nombre_Vendedor,
    vd.EstadoCivil,
    vd.Sexo,
    vd.TipoDeidentificacion

/*2.Cuáles son los productos que han tenido mayor venta y a qué vendedor pertenece?*/

SELECT 
    prod.Nombre,
    (vd.Nombre1 || ' ' ||vd.Apellido1) AS Nombre_Vendedor,
    SUM(dv.Cantidad) AS Total_Ventas
FROM 
    TblDetalleVenta dv
	
INNER JOIN TblVenta v ON dv.idFactura = v.idFactura
INNER JOIN TblProducto prod ON dv.idProducto = prod.idProducto
INNER JOIN TblVendedor vd ON v.Vendedor = vd.identificacion

GROUP BY 
    prod.Nombre,
    Nombre_Vendedor
ORDER BY 
    Total_Ventas DESC
	
/*3.Construya una consulta general que involucre todas las tablas del Modelo Relacional y permita visualizar totales en ella.*/

 SELECT 
    (vd.Nombre1 || ' ' || vd.Apellido1 )AS Nombre_Vendedor,
    ct.Descripcion AS Categoria,
    prod.Nombre AS Producto,
    SUM(dv.Total) AS TotalVentas,
    SUM(dv.Cantidad) AS TotalUnidades,
    COUNT(v.idFactura) AS VentasRealizadas 
 FROM TblVenta v
 
 INNER JOIN TblDetalleVenta dv ON v.idFactura = dv.idFactura
 INNER JOIN TblVendedor vd ON v.Vendedor = vd.identificacion 
 INNER JOIN TblConceptoDetalle cd ON vd.TipoDeidentificacion=cd.idDetalleConcepto /* sin la logica de negocio , desconozco si es la relacion correcta entre ambas tablas o si falta alguna fk en la imagen que se paso*/
 INNER JOIN TblConcepto c ON cd.idConcepto = c.idConcepto
 INNER JOIN TblProducto prod ON dv.idProducto = prod.idProducto
 INNER JOIN TblCategoria ct ON prod.idCategoria = ct.idCategoria
 
 GROUP BY 
    vd.Nombre1, 
	vd.Apellido1, 
	ct.Descripcion, 
	prod.Nombre;
 
 /*4.¿Cuáles son algunas estrategias que usarías para optimizar el rendimiento de consultas SQL en grandes conjuntos de datos?,*/

 Cuando se trata de grandes conjuntos de datos y optimización del rendimiento en las consultas SQL es clave: 

	Indexación adecuada. 
		La creación de índices en columnas usadas con frecuencia con cláusulas WHERE, JOIN y ORDER BY
		Evitar los índices en columnas con baja selectividad (Por ejemplo: booleanos o columnas con pocos valores únicos),

	Optimización de consultas.
		Evitar el SELECT * → Ya que es mejor seleccionar solo las columnas necesarias
		Utilizar LIMIT, TOP, FETCH si no es necesario traer todos los registros,
		Reemplazar subconsultas innecesarias con JOINs cuando sea posible,
		Priorizar el INNER JOIN cuando no necesitamos nulos (Y es mas eficiente que LEFT JOIN),
		Hacer el uso del WITH para crear tablas temporales que permitan reutilizar subconsultas complejas varias veces 
		
	Particionamiento (Partitioning).
		Dividir tablas grandes en particiones por rangos basados en las necesidades o la logica de negocio(Ejemplo: Fechas)
		Ejemplo: Al particionar una tabla de ventas por año_mes puede acelerar consultas históricas,


	Optimización del esquema.
		Elige tipos de datos adecuados (ej. INT en lugar de VARCHAR para IDs)
		Usa particionamiento vertical: Separa columnas muy accedidas de las menos usada