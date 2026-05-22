-- =====================================================
-- PROYECTO: CAFETERÍA
-- ORACLE DATABASE 26ai
-- Authors: Almaraz García Beatriz, Martínez Ojeda Jonhatan Alexis, Raya Ramírez Angel Adrián
-- Description: Scrip que contiene consultas que pueden ser relevantes para la cafetería.
-- =====================================================

-- =====================================================
-- QUERY: PRODUCTOS MAS VENDIDOS
-- =====================================================
SELECT PR.NOMBRE, SUM(DP.CANTIDAD) TOTAL_VENDIDO
FROM PRODUCTO PR
JOIN DETALLE_PEDIDO DP
ON PR.ID_PRODUCTO = DP.ID_PRODUCTO
GROUP BY PR.NOMBRE
ORDER BY TOTAL_VENDIDO DESC;

-- =====================================================
-- QUERY: CLIENTE QUE MAS HA GASTADO
-- =====================================================
SELECT C.NOMBRE, C.AP_PATERNO, SUM(P.TOTAL) TOTAL_GASTADO
FROM CLIENTE C
JOIN PEDIDO P
ON C.ID_CLIENTE = P.ID_CLIENTE
GROUP BY C.NOMBRE, C.AP_PATERNO
ORDER BY TOTAL_GASTADO DESC;

-- =====================================================
-- QUERY: INGRESOS POR DIA
-- =====================================================
SELECT TRUNC(FECHA_HORA) FECHA, SUM(TOTAL) INGRESOS
FROM PEDIDO
GROUP BY TRUNC(FECHA_HORA)
ORDER BY FECHA;

-- =====================================================
-- QUERY: PRODUCTOS (CAFES) QUE USAN UN INSUMO ESPECÍFICO (CONTIENEN LACTOSAAAA, SI ME DAN GANAS LO AJUSTO PARA QUE EL USUARIO PUEDA INGRESAR EL INSUMO QUE QUIERA)
--ESTE IGUAL YA NO JALA CON LA LECHE PORQUE LE ESTUVE MOVIENDO CARAJO
-- =====================================================
SELECT P.NOMBRE PRODUCTO, I.NOMBRE INSUMO
FROM PRODUCTO P

JOIN PRODUCTO_INSUMO PI
ON P.ID_PRODUCTO = PI.ID_PRODUCTO

JOIN INSUMO I
ON PI.ID_INSUMO = I.ID_INSUMO

WHERE I.NOMBRE = 'LECHE ENTERA';

-- =====================================================
-- QUERY: INVENTARIO RESTANTE ORDENADO
-- =====================================================
SELECT NOMBRE, CANTIDAD_DISPONIBLE, UNIDAD_MEDIDA
FROM INSUMO
ORDER BY CANTIDAD_DISPONIBLE ASC;

-- =====================================================
-- QUERY: EMPLEADO CON MAS VENTAS
-- =====================================================
SELECT E.NOMBRE, E.AP_PATERNO, COUNT(P.ID_PEDIDO) PEDIDOS_REALIZADOS, SUM(P.TOTAL TOTAL_VENDIDO)
FROM EMPLEADO E
JOIN PEDIDO P
ON E.ID_EMPLEADO = P.ID_EMPLEADO
GROUP BY E.NOMBRE, E.AP_PATERNO
ORDER BY TOTAL_VENDIDO DESC;

-- =====================================================
-- QUERY: PRODUCTOS QUE NUNCA SE HAN VENDIDO
-- =====================================================
SELECT P.NOMBRE
FROM PRODUCTO P
LEFT JOIN DETALLE_PEDIDO DP
ON P.ID_PRODUCTO = DP.ID_PRODUCTO
WHERE DP.ID_PRODUCTO IS NULL;

-- =====================================================
-- QUERY: RECETA DE UN CAFÉ     COMO YA LE MOVI UNAS COSAS TENGO Q AJUSTAR ESTA MADRE PARA QUE MUESTRE TAMBIEN LAS CANTIDADES DE LECHE
-- =====================================================
SELECT P.NOMBRE AS PRODUCTO, I.NOMBRE AS INSUMO, PI.CANTIDAD_USADA, I.UNIDAD_MEDIDA
FROM PRODUCTO_INSUMO PI

JOIN PRODUCTO P
ON PI.ID_PRODUCTO = P.ID_PRODUCTO

JOIN INSUMO I
ON PI.ID_INSUMO = I.ID_INSUMO

ORDER BY P.NOMBRE;