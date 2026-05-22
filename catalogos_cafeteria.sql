-- =====================================================
-- PROYECTO: CAFETERÍA
-- ORACLE DATABASE 26ai
-- Authors: Almaraz García Beatriz, Martínez Ojeda Jonhatan Alexis, Raya Ramírez Angel Adrián
-- Description: Scrip para los inserts iniciales necesarios para hacer los catálogos de los productos.
-- =====================================================

--======================================================
--CATEGORIAS
--======================================================
INSERT INTO CATEGORIA_PRODUCTO (NOMBRE)
VALUES ('CAFE');

INSERT INTO CATEGORIA_PRODUCTO (NOMBRE)
VALUES ('ALIMENTO');

--======================================================
--TAMAÑOS
--======================================================
INSERT INTO TAMANO (NOMBRE, ONZAS, INCREMENTO_PRECIO, FACTOR_MULTIPLICADOR)
VALUES
    ('CHICO', 8, 0, 1),
    ('MEDIANO', 12, 10, 1.3),
    ('GRANDE', 16, 18, 1.5);

--======================================================
--TIPOS DE LECHE
--======================================================
INSERT INTO TIPO_LECHE (NOMBRE, COSTO_EXTRA)
VALUES
    ('ENTERA', 0),
    ('DESLACTOSADA', 5),
    ('SOYA', 10),
    ('ALMENDRA', 8),
    ('AVENA', 8);

--======================================================
--TEMPERATURA
--======================================================
INSERT INTO TEMPERATURA (NOMBRE)
VALUES
    ('CALIENTE'),
    ('FRIO');

--======================================================
--EXTRAS
--======================================================
INSERT INTO EXTRA (NOMBRE, COSTO_EXTRA)
VALUES
    ('SHOT ESPRESSO', 15),
    ('CREMA BATIDA', 5),
    ('AZUCAR', 0),
    ('CANELA', 0),
    ('JARABE VAINILLA', 3);

--======================================================
--INSUMOS
--======================================================
INSERT INTO INSUMO (NOMBRE, CANTIDAD_DISPONIBLE, UNIDAD_MEDIDA, COSTO_UNITARIO, STOCK_MINIMO)
VALUES
    ('CAFE MOLIDO', 2000, 'GRAMOS', 0.25, 500),
    ('LECHE ENTERA', 2500, 'ML', 0.03, 500),
    ('VASO', 250, 'PIEZAS', 1.50, 5), 
    ('CHOCOLATE', 1000, 'GRAMOS', 1.50, 50),
    ('HELADO VAINILLA', 1000, 'ML', 0.70, 250),
    ('HELADO CHOCOLATE', 1000, 'ML', 0.70, 250), --NO INCLUIDO EN LAS RECETAS
    ('AZUCAR', 2000, 'GRAMOS', 0.02, 100),
    ('CANELA', 1000, 'GRAMOS', 0.8, 50),
    ('JARABE VAINILLA', 1000, 'ML', 0.30, 50),
    ('JARABE MENTA', 1000, 'ML', 0.30, 50),
    ('CREMA BATIDA', 1000, 'ML', 0.20, 50),
    ('LECHE DESLACTOSADA', 2500, 'ML', 0.04, 500),
    ('LECHE SOYA', 100, 'ML', 0.05, 10),  --CON ESTE HAREMOS PRUEBAS DE PEDIDOS DE INSUMOS
    ('LECHE ALMENDRA', 2500, 'ML', 0.05, 500),
    ('LECHE AVENA', 2500, 'ML', 0.06, 500);

--======================================================
--PRODUCTOS
--======================================================
INSERT INTO PRODUCTO (ID_CATEGORIA, NOMBRE, PRECIO_BASE, USA_LECHE, CANTIDAD_LECHE_BASE)
VALUES
    (1, 'ESPRESSO', 45, 'N', NULL),
    (1, 'FLAT WHITE', 55, 'S', 180),
    (1, 'AMERICANO', 45, 'N', NULL),
    (1, 'CAPUCCINO', 60, 'S', 200),
    (1, 'LATTE', 60, 'S', 250),
    (1, 'MOKA', 60, 'S', 200),
    (1, 'CHOCOMENTA', 65, 'S', 200),
    (1, 'AFFOGATO', 60, 'N', NULL),
    (1, 'COLD BREW', 50, 'N', NULL),
    (2, 'CROISSANT', 35, 'N', NULL),
    (2, 'PAN FRANCES', 55, 'N', NULL),
    (2, 'PANQUE PLATANO', 45, 'N', NULL),
    (2, 'PANQUE CHOCOLATE', 45, 'N', NULL),
    (2, 'PANQUE NUEZ', 45, 'N', NULL),
    (2, 'CHEESECAKE', 60, 'N', NULL);
--DE IGUAL MANERA, INSERTAR TODOS LOS PRODUCTOS QUE SE NOS OCURRAN

--======================================================
--PRODUCTO_INSUMO (AQUÍ SE DEFINEN LAS RECETAS PARA CADA CAFÉ)
--======================================================
--ESPRESSO
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (1, 1, 18),
    --VASO
    (1, 3, 1);


--FLAT WHITE
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (2, 1, 18),
    --VASO
    (2, 3, 1);
    
--AMERICANO
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (3, 1, 18),
    --VASO
    (3, 3, 1);

--CAPUCCINO
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (4, 1, 18),
    --VASO
    (4, 3, 1);
    
--LATTE
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (5, 1, 18),
    --VASO
    (5, 3, 1);

--MOKA
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (6, 1, 18),
    --VASO
    (6, 3, 1),
    --CHOCOLATE
    (6, 4, 25);

--CHOCOMENTA
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (7, 1, 18),
    --VASO
    (7, 3, 1),
    --CHOCOLATE
    (7, 4, 20),
    --JARABE MENTA
    (7, 10, 15);

--AFOGATTO
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (8, 1, 18),
    --VASO
    (8, 3, 1),
    --HELADO VAINILLA
    (8, 5, 50);

--COLD BREW
INSERT INTO PRODUCTO_INSUMO (ID_PRODUCTO, ID_INSUMO, CANTIDAD_USADA)
VALUES
    --CAFE MOLIDO
    (9, 1, 25),
    --VASO
    (9, 3, 1);