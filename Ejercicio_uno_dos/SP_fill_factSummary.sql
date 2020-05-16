ALTER PROCEDURE example.FILL_FACT_SUMMARY
AS 

--- borramos la data de la tabla como validacion de que no me duplique informacion 
delete from example.fact_summary

--- obtenemos el año que servira de filtro
DECLARE @anio INT = ( select [value] from example.settings where [key]='anio' );


--- query
with Custome_Supplier_level as (

    select 
        c.CustomerID,
        c.CustomerName, 
        s.SupplierID,
        s.SupplierName, 
        MONTH(o.OrderDate) as mes,
        year(o.OrderDate) as year,
        sum(od.Quantity * p.Price) as total
    from
    example.orderdetails as od 
    inner join example.Orders as o 
    on od.OrderID = o.OrderID
    INNER JOIN example.Products as p 
    on p.ProductoID = od.ProductID
    inner join example.Suppliers as s 
    on s.SupplierID = p.SupplierID
    inner JOIN example.Customers as c 
    on c.CustomerID = o.CustomerId
    where year(o.OrderDate) = @anio
    GROUP BY 
        c.CustomerID,
        c.CustomerName, 
        s.SupplierName, 
        s.SupplierID,
        MONTH(o.OrderDate),
        year(o.OrderDate)
        
), Supplier_level as (

    select     
        p.SupplierID,       
        MONTH(o.OrderDate) as mes,
        year(o.OrderDate) as year,
        avg(od.Quantity * p.Price) as promedio
    from
    example.orderdetails as od 
    inner join example.Orders as o 
    on od.OrderID = o.OrderID
    INNER JOIN example.Products as p 
    on p.ProductoID = od.ProductID
    where year(o.OrderDate) = @anio
    GROUP BY
        p.SupplierID,       
        MONTH(o.OrderDate),
        year(o.OrderDate)

), customer_level as (

    select 
        o.CustomerID,                
        MONTH(o.OrderDate) as mes,
        year(o.OrderDate) as year,
        sum(od.Quantity * p.Price) as total
    from
    example.orderdetails as od 
    inner join example.Orders as o 
    on od.OrderID = o.OrderID
    INNER JOIN example.Products as p 
    on p.ProductoID = od.ProductID
    where year(o.OrderDate) = @anio
    GROUP BY 
        o.CustomerID,        
        MONTH(o.OrderDate),
        year(o.OrderDate)

)

insert into example.fact_summary
select  csl.*,
        CASE
            when csl.total > sl.promedio then 1
            else 0
        END as SuperoPromedio,
        csl.total / cl.total as PorcentajeVentaMensual
from Custome_Supplier_level csl 

inner join Supplier_level sl 
on csl.SupplierID = sl.SupplierID 
and csl.mes = sl.mes
and csl.[year] = sl.[year]

INNER join customer_level cl 
on csl.CustomerID = cl.CustomerID 
and csl.mes = cl.mes
and csl.[year] = cl.[year]


SELECT 1 AS Successed