--1. Mostrar el contenido de la tabla Person, del esquema Person

SELECT *
FROM Person.Person

--2. Mostrar los nombres y apelllido de las personas cuyo apellido sea “White”.

SELECT p.FirstName, p.MiddleName, p.LastName
FROM Person.Person p
WHERE p.LastName = 'White'

--3. Mostrar el Id y apellido de las personas que se los llame como “Mr.” y su apellido sea “White”.

SELECT p.BusinessEntityID, p.LastName
FROM Person.Person p
WHERE p.Title = 'Mr.'AND p.LastName = 'White'

--4. ¿Cuáles son los tipos de personas existentes en la tabla?

SELECT p.PersonType
FROM Person.Person p
GROUP BY p.PersonType

--5. Mostrar el contenido de la tabla Employee, del esquema HumanResources

SELECT *
FROM HumanResources.Employee e

--6. Hallar el Id y fecha de nacimiento de los empleados que tengan como función “Research and Development Manager” o que tengan más de 10 “VacationHours”

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

--10. Hallar el Id y el nombre de los productos cuyo nombre comience con “Chain”

SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.Name LIKE 'Chain%'

--11. Hallar el Id y el nombre de los productos cuyo nombre contenga “helmet”

SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.Name LIKE '%helmet%'

--12. Mostrar los datos principales de las personas cuyo LastName termine con “es” y contenga en total 5 caracteres

SELECT *
FROM Person.Person p
WHERE p.LastName LIKE '___es'

--13. Usando la tabla SpecialOffer del esquema Sales, mostrar la diferencia entre MinQty y MaxQty, con el id y descripción

SELECT s.MaxQty - s.MinQty as 'DifQty', s.SpecialOfferID, s.[Description]
FROM Sales.SpecialOffer s

--14. ¿Cómo el motor resuelve la anterior consulta cuando no tiene asignado valor MinQty ó MaxQty?
Usar la función ISNULL para, cuando no tengan asignado valor, reemplazarlo - en el cálculo – por 0 (cero).

SELECT ISNULL(s.MaxQty,0) - ISNULL(s.MinQty,0) as 'DifQty', s.SpecialOfferID, s.[Description]
FROM Sales.SpecialOffer s

--15. Para la tabla SalesOrderDetail del esquema Sales:

--a) ¿Cuál es el precio unitario más caro vendido?

SELECT MAX(s.UnitPrice)
FROM Sales.SalesOrderDetail s

--b) ¿Cuál es el número total de items ordenado para cada producto?

SELECT s.ProductID, COUNT(s.OrderQty) as 'Quantity'
FROM Sales.SalesOrderDetail s
GROUP BY s.ProductID

--c) ¿Cuál es la cantidad de líneas de cada orden, sólo para aquellas órdenes que tengan más de 50 líneas? Ordenar por id de orden descendente.

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

--19. Para los empleados, contar la cantidad de empleados solteros nacidos por año y por
--género, para aquellos años donde hayan nacido más de 10 empleados.

SELECT YEAR(e.BirthDate) as 'Year', e.Gender, COUNT(e.BusinessEntityID) as 'Number of employees'
FROM HumanResources.Employee e
WHERE e.MaritalStatus = 'S'
GROUP BY YEAR(e.BirthDate), e.Gender
HAVING 10 < ANY (SELECT COUNT(e.BusinessEntityID)
FROM HumanResources.Employee e
GROUP BY YEAR(e.BirthDate))