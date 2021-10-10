--1. Mostrar el contenido de la tabla Person, del esquema Person

SELECT *
FROM Person.Person

--2. Mostrar los nombres y apellido de las personas cuyo apellido sea White

SELECT p.FirstName, p.MiddleName, p.LastName
FROM Person.Person p
WHERE p.LastName = 'White'

--3. Mostrar el Id y apellido de las personas que se los llame como Mr. y su apellido sea White.

SELECT p.BusinessEntityID, p.LastName
FROM Person.Person p
WHERE p.Title = 'Mr.'AND p.LastName = 'White'

--4. ¿Cuales son los tipos de personas existentes en la tabla?

SELECT p.PersonType
FROM Person.Person p
GROUP BY p.PersonType

--5. Mostrar el contenido de la tabla Employee, del esquema HumanResources

SELECT *
FROM HumanResources.Employee e

--6. Hallar el Id y fecha de nacimiento de los empleados que tengan como función Research and Development Manager o que tengan más de 10 VacationHours

SELECT e.BusinessEntityID, e.BirthDate
FROM HumanResources.Employee e
WHERE e.JobTitle = 'Research and Development Manager' OR e.VacationHours > 10

--7. Mostrar los empleados casados que hayan nacido con posterioridad al 01/01/1986

SELECT *
FROM HumanResources.Employee e
WHERE e.MaritalStatus = 'M' AND e.BirthDate > '01-01-1986'

--8. Mostrar el id, nombres, apellido de los empleados ordenados desde el de fecha de nacimiento más antigua

SELECT e.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName, e.BirthDate
FROM HumanResources.Employee e, Person.Person p
WHERE e.BusinessEntityID = p.BusinessEntityID
ORDER BY e.BirthDate ASC

--9. Mostrar los datos de la tabla Product del esquema Production

SELECT *
FROM Production.Product p

--10. Hallar el Id y el nombre de los productos cuyo nombre comience con "Chain"

SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.Name LIKE 'Chain%'

--11. Hallar el Id y el nombre de los productos cuyo nombre contenga "helmet"

SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.Name LIKE '%helmet%'

--12. Mostrar los datos principales de las personas cuyo LastName termine con "es" y contenga en total 5 caracteres

SELECT *
FROM Person.Person p
WHERE p.LastName LIKE '___es'

--13. Usando la tabla SpecialOffer del esquema Sales, mostrar la diferencia entre MinQty y MaxQty, con el id y descripciÃ³n

SELECT s.MaxQty - s.MinQty as 'DifQty', s.SpecialOfferID, s.[Description]
FROM Sales.SpecialOffer s

--14. ¿Cómo el motor resuelve la anterior consulta cuando no tiene asignado valor MinQty o MaxQty?
--Usar la función ISNULL para, cuando no tengan asignado valor, reemplazarlo en el cálculo por 0 (cero).

SELECT ISNULL(s.MaxQty - s.MinQty,0) as 'DifQty', s.SpecialOfferID, s.[Description]
FROM Sales.SpecialOffer s

--15. Para la tabla SalesOrderDetail del esquema Sales:

--a) ¿Cuál es el precio unitario más caro vendido?

SELECT MAX(s.UnitPrice)
FROM Sales.SalesOrderDetail s

--b) ¿Cuál es el número total de items ordenado para cada producto?

SELECT s.ProductID, COUNT(s.OrderQty) as 'Quantity'
FROM Sales.SalesOrderDetail s
GROUP BY s.ProductID

--c) ¿Cuál es la cantidad de líneas de cada orden, solo para aquellas órdenes que tengan más de 50 líneas? Ordenar por id de orden descendente.

SELECT s.SalesOrderID, COUNT(s.LineTotal) as 'Number of Lines'
FROM Sales.SalesOrderDetail s
GROUP BY s.SalesOrderID
HAVING COUNT(s.LineTotal) > 50
ORDER BY s.SalesOrderID DESC

--d) ¿Cuál es la cantidad distinta de productos ordenados?

SELECT COUNT(DISTINCT s.ProductID) as 'QtyProducts'
FROM Sales.SalesOrderDetail s

--16. ¿Cuántos clientes están almacenados en la tabla Customers?

SELECT COUNT(c.CustomerID) as 'QtyCustomer'
FROM Sales.Customer c


--17.A ¿Cuál es la cantidad de clientes por territorio? 

SELECT c.TerritoryID, COUNT(c.CustomerID) as 'QtyCustomer'
FROM Sales.Customer c
GROUP BY c.TerritoryID


--17.B ¿Y cuál es la cantidad de clientes para aquellos territorios que tengan más de 1500 clientes?

SELECT c.TerritoryID, COUNT(c.CustomerID) as 'QtyCustomer'
FROM Sales.Customer c
GROUP BY c.TerritoryID
HAVING COUNT(c.CustomerID) > 1500


--18. Usando la tabla SalesOrderHeader, cuál es la cantidad de órdenes emitidas por año?
--(usar la función Year).

SELECT YEAR(s.OrderDate) AS 'Year', COUNT(s.SalesOrderID) AS 'Number of orders'
FROM Sales.SalesOrderHeader s
GROUP BY YEAR(s.OrderDate)

--19. Para los empleados, contar la cantidad de empleados solteros nacidos por aÃ±o y por
--género, para aquellos años donde hayan nacido mÃ¡s de 10 empleados.

SELECT YEAR(BirthDate) as "Year", Gender, COUNT(BusinessEntityID) as "Number of employees"
FROM HumanResources.Employee
WHERE MaritalStatus = 'S' and YEAR(BirthDate) IN

    (SELECT YEAR(BirthDate)
    FROM HumanResources.Employee
    GROUP BY YEAR(BirthDate)
    HAVING COUNT(BusinessEntityID) > 10)

GROUP BY YEAR(BirthDate), Gender

--20. La tabla Employee no contiene el nombre de los empleados. Ese dato se encuentra en
--la tabla Person. La columna que relaciona ambas tablas es BusinessEntityID

--a) Obtener el nombre y apellido de los empleados que nacieron durante el aÃ±o 1986
--y su género es M.

SELECT p.FirstName, p.MiddleName, p.LastName
FROM HumanResources.Employee e, Person.Person p 
WHERE e.BusinessEntityID = p.BusinessEntityID
AND e.Gender = 'M' AND YEAR(BirthDate) = 1986

--b) ¿Cual es la cantidad de empleados por genero, cuyo nombre comience con la
--letra J? o hayan nacido despues del año 1977?

SELECT e.Gender, COUNT(e.BusinessEntityID) as 'Number of Employees'
FROM HumanResources.Employee e, Person.Person p 
WHERE e.BusinessEntityID = p.BusinessEntityID
AND (p.FirstName LIKE 'J%' OR YEAR(e.BirthDate) > 1977)
GROUP BY e.Gender

--21. La tabla Product contiene los productos y la tabla ProductModel, los modelos.

--a) Encontrar la descripción del producto y la descripción del modelo asociado, para
--aquellos productos que no tengan color indicado y para los cuales el nivel seguro de
--stock (SafetyStockLevel) sea menor estricto a 1000.

SELECT p.Name, m.CatalogDescription
FROM Production.Product p, Production.ProductModel m
WHERE p.ProductModelID = m.ProductModelID
AND p.Color IS NULL
AND p.SafetyStockLevel < 1000

/*b) Obtener todas las ventas de los meses de junio y julio del 2011. Mostrar el
nombre y apellido del cliente, el nro de venta, su fecha y el modelo del producto
vendido*/

SELECT 
    p.FirstName,
    p.MiddleName,
    p.LastName,
    h.SalesOrderNumber, 
    h.OrderDate,
    m.Name as 'Model'
FROM 
    Production.Product pr,
    Production.ProductModel m,
    Person.Person p,
    Sales.Customer c,
    Sales.SalesOrderHeader h,
    Sales.SalesOrderDetail d
WHERE 
    h.CustomerID = c.CustomerID 
    AND c.PersonID = p.BusinessEntityID
    AND pr.ProductModelID = m.ProductModelID
    AND h.SalesOrderID = d.SalesOrderID
    AND pr.ProductID = d.ProductID
    AND YEAR(h.OrderDate) = 2011
    AND MONTH(h.OrderDate) IN (06,07)

/*22. En la tabla SalesPerson se modelan los vendedores. Mostrar el id de todos los
vendedores junto al id de la venta, para aquellas con numero de revisión igual a 9 y que
se hayan vendido en el 2013. Incluir a aquellos vendedores que no hayan efectuados
ventas.*/

SELECT
    sp.BusinessEntityID,
    h.SalesOrderID
FROM 
    Sales.SalesPerson sp 
    LEFT OUTER JOIN 
    Sales.SalesOrderHeader h
    ON sp.BusinessEntityID = h.SalesPersonID
WHERE 
    h.RevisionNumber = 9
    AND YEAR(h.OrderDate) = 2013

/*23. Mostrar la descripción de los productos que nunca hayan sido vendidos.*/

SELECT 
    pr.Name
FROM   
    Production.Product pr 
    LEFT OUTER JOIN 
    Sales.SalesOrderDetail sd
    ON
        pr.ProductID = sd.ProductID
WHERE
    sd.ProductID IS NULL

/*24. Modificar la resolución del punto anterior para agregar el nombre del vendedor, que se
encuentra en la tabla Person.*/

SELECT
    sp.BusinessEntityID,
    h.SalesOrderID,
    p.FirstName,
    p.MiddleName,
    p.LastName
FROM 
    Sales.SalesPerson sp 
    LEFT OUTER JOIN 
    Sales.SalesOrderHeader h
    ON sp.BusinessEntityID = h.SalesPersonID
    JOIN
    Person.Person p 
    ON  sp.BusinessEntityID = p.BusinessEntityID
WHERE 
    h.RevisionNumber = 9
    AND YEAR(h.OrderDate) = 2013


/*25. Calcular para los tipos de contacto, cuántas personas asociadas están registradas.
Ordenar el resultado por cantidad, descendente. (esquema Person)*/

SELECT 
    bec.ContactTypeID,
    COUNT(p.BusinessEntityID) as "Number of Persons"
FROM 
    Person.Person p,
    Person.BusinessEntityContact bec
WHERE
    bec.PersonID = p.BusinessEntityID
GROUP BY
    bec.ContactTypeID
ORDER BY COUNT(p.BusinessEntityID) DESC 

/*26. Calcular el total vendido por territorio, para aquellos que tengan más de 100 ventas a
nivel producto. Considerar precio unitario y cantidad vendida. (esquema Sales)*/

SELECT 
    soh.TerritoryID,
    SUM(sod.UnitPrice * sod.OrderQty) as 'Total Sales'
FROM 
    Sales.SalesOrderDetail sod,
    Sales.SalesOrderHeader soh
WHERE
    sod.SalesOrderID = soh.SalesOrderID
GROUP BY 
    soh.TerritoryID
HAVING
    SUM(sod.OrderQty) > 100

/* 27. Usando subconsultas, obtener Id y nombre de los productos que hayan sido vendidos
durante el año 2013.*/

--Solución sin subconsulta:
    
SELECT 
    DISTINCT sod.ProductID,
    pr.Name
FROM
    Sales.SalesOrderDetail sod,
    Sales.SalesOrderHeader soh,
    Production.Product pr
WHERE
    sod.ProductID = pr.ProductID
    AND sod.SalesOrderID = soh.SalesOrderID
    AND YEAR(soh.OrderDate) = 2013
ORDER BY 
    sod.ProductID ASC

--Solución con subconsulta:
    
SELECT p.ProductID, p.Name 
FROM Production.Product p
WHERE p.ProductID IN (SELECT DISTINCT sod.ProductID
    FROM Sales.SalesOrderHeader soh
        JOIN Sales.SalesOrderDetail sod
            ON soh.SalesOrderID = sod.SalesOrderID
    WHERE YEAR(soh.OrderDate) = 2013)
    
/*28. Usando subconsultas, obtener el nombre de los productos que no hayan sido
vendidos nunca*/

SELECT DISTINCT p.Name 
FROM Production.Product p
WHERE p.ProductID NOT IN (SELECT DISTINCT sod.ProductID
    FROM Sales.SalesOrderHeader soh
        JOIN Sales.SalesOrderDetail sod
            ON soh.SalesOrderID = sod.SalesOrderID)
ORDER BY p.Name ASC  
    
/*29. Obtener los productos vendidos de mayor precio unitario, entre los vendidos en el año
2013.*/

--Solución A:

SELECT p.ProductID, p.Name 
FROM Production.Product p
WHERE p.ProductID IN (SELECT DISTINCT sod.ProductID
    FROM Sales.SalesOrderHeader soh
        INNER JOIN Sales.SalesOrderDetail sod
            ON soh.SalesOrderID = sod.SalesOrderID
    WHERE YEAR(soh.OrderDate) = 2013 
    AND sod.UnitPrice = (SELECT MAX(sod.UnitPrice)
    FROM Sales.SalesOrderDetail sod, Sales.SalesOrderHeader soh
    WHERE sod.SalesOrderID = soh.SalesOrderID 
    AND YEAR(soh.OrderDate) = 2013))
ORDER BY p.ProductID ASC

--Solución B:

SELECT DISTINCT
	sod.UnitPrice,
	p.ProductID ,
	p.Name
FROM 
	Production.Product p ,
	Sales.SalesOrderDetail sod ,
	Sales.SalesOrderHeader soh
WHERE
	p.ProductID = sod.ProductID 
	AND sod.SalesOrderID = soh.SalesOrderID 
	AND YEAR(soh.OrderDate) = 2013
	AND sod.UnitPrice = (SELECT 
							MAX(sod.UnitPrice)
						FROM 
							Sales.SalesOrderDetail sod,
							Sales.SalesOrderHeader soh
						WHERE
							sod.SalesOrderID = soh.SalesOrderID 
							AND YEAR(soh.OrderDate) = 2013)

--30. Mostrar los departamentos que tengan máxima cantidad de empleados.

--Solución A:
							
SELECT
	d.Name , COUNT(edh.BusinessEntityID)
FROM 
	HumanResources.EmployeeDepartmentHistory edh
	JOIN
	HumanResources.Department d
	ON d.DepartmentID = edh.DepartmentID 
WHERE 
	edh.EndDate IS NULL
GROUP BY
	d.Name 
HAVING 
	COUNT(edh.BusinessEntityID) = (SELECT MAX(y.num)
	FROM (SELECT COUNT(edh.BusinessEntityID) as 'num'
	FROM HumanResources.EmployeeDepartmentHistory edh
	JOIN
	HumanResources.Department d 
	ON d.DepartmentID = edh.DepartmentID
	WHERE edh.EndDate IS NULL
	GROUP BY d.DepartmentID) y)
	
--Solución B:
	
SELECT edh. DepartmentID , COUNT (*)
FROM AdventureWorks2019.HumanResources.EmployeeDepartmentHistory edh 
GROUP BY edh.DepartmentID 
HAVING count () >= ALL (SELECT COUNT ()
FROM AdventureWorks2019.HumanResources.EmployeeDepartmentHistory edh 
GROUP BY edh.DepartmentID 
)
	
--31. Hallar los empleados con menor antiguedad dentro de cada departamento
	
--Solución A:
	
	SELECT edh.BusinessEntityID, edh.DepartmentID , edh.StartDate 
FROM 
	HumanResources.EmployeeDepartmentHistory edh
	LEFT OUTER JOIN HumanResources.EmployeeDepartmentHistory edh2
	ON edh.DepartmentID = edh2.DepartmentID AND edh.StartDate < edh2.StartDate 
WHERE 
	edh2.StartDate IS NULL
ORDER BY edh.DepartmentID ASC

--Solución B:

SELECT edh1.DepartmentID, edh1.BusinessEntityID, edh1.StartDate 
FROM HumanResources.EmployeeDepartmentHistory edh1
WHERE edh1.StartDate = (SELECT MAX(edh2.StartDate)
        FROM HumanResources.EmployeeDepartmentHistory edh2
        WHERE edh1.DepartmentID = edh2.DepartmentID)
        
--32. Hallar las provincias que tengan más cantidad de domicilios que los que tiene la
--provincia con Id 58.
        
SELECT 
	a.StateProvinceID,
	COUNT(*) AS 'AddressQty'
FROM 
	Person.Address a 
GROUP BY
	a.StateProvinceID 
HAVING
	COUNT(*) > (SELECT COUNT(*)
	FROM Person.Address a2
	WHERE a.StateProvinceID = 58)
ORDER BY a.StateProvinceID ASC

--33. Encontrar el nombre de los productos que no pertenezcan a la subcategoría “Wheels”,
--usando EXISTS.

SELECT 
	p.ProductSubcategoryID, p.Name 
FROM
	Production.Product p ,
	Production.ProductSubcategory ps 
WHERE 
	p.ProductSubcategoryID = ps.ProductSubcategoryID 
	AND EXISTS (SELECT ps.Name 
	FROM Production.ProductSubcategory
	WHERE ps.Name <> 'Wheels')
ORDER BY
	p.ProductSubcategoryID DESC

--34. Encontrar el nombre de los productos cuyo precio de lista es mayor o igual al máximo
--precio de lista de cualquier subcategoría de producto.

SELECT
	p.ProductSubcategoryID , p.Name , p.ListPrice 	
FROM 
	Production.Product p
WHERE 
	p.ListPrice IN (SELECT MAX(p.ListPrice)
	FROM Production.Product p
	GROUP BY p.ProductSubcategoryID) 
ORDER BY
	p.ProductSubcategoryID ASC
	
/*35. Encontrar los nombres de los empleados que también sean vendedores. Usar
subconsultas anidadas*/
	
SELECT 
	e.JobTitle,
	p.LastName,  
	p.FirstName,
	p.MiddleName
FROM
	HumanResources.Employee e , Person.Person p 
WHERE
	e.BusinessEntityID = p.BusinessEntityID 
	AND e.BusinessEntityID IN (SELECT e.BusinessEntityID 
	FROM HumanResources.Employee e
	WHERE e.JobTitle = 'Sales Representative')
ORDER BY 
	p.LastName ASC
