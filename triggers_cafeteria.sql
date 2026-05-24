-- =====================================================
-- PROYECTO: CAFETERÍA
-- ORACLE DATABASE 26ai
-- Authors: Almaraz García Beatriz, Martínez Ojeda Jonhatan Alexis, Raya Ramírez Angel Adrián
-- Description: Script que contiene triggers necesarios para el correcto funcionamiento del sistema.
-- =====================================================

-- =====================================================
-- TRIGGER: ACTUALIZAR SUBTOTAL AUTOMATICAMENTE
-- =====================================================
CREATE OR REPLACE TRIGGER TGR_SUBTOTAL_DETALLE
BEFORE INSERT OR UPDATE ON DETALLE_PEDIDO
FOR EACH ROW
BEGIN
    :NEW.SUBTOTAL := :NEW.CANTIDAD * :NEW.PRECIO_UNITARIO;
END;
/

-- =====================================================
-- TRIGGER: ACTUALIZAR TOTAL DEL PEDIDO (ESTE YA NO SE USA. IMPORTANTE NO CREARLO) 
-- =====================================================
/*CREATE OR REPLACE TRIGGER TGR_TOTAL_PEDIDO
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_PEDIDO
FOR EACH ROW
BEGIN
    IF INSERTING OR UPDATING THEN
        UPDATE PEDIDO
        SET TOTAL = (
            SELECT NVL(SUM(SUBTOTAL),0)
            FROM DETALLE_PEDIDO
            WHERE ID_PEDIDO = :NEW.ID_PEDIDO
        )
        WHERE ID_PEDIDO = :NEW.ID_PEDIDO;
    END IF;
    
    IF DELETING THEN
        UPDATE PEDIDO
        SET TOTAL = (
            SELECT NVL(SUM(SUBTOTAL),0)
            FROM DETALLE_PEDIDO
            WHERE ID_PEDIDO = :OLD.ID_PEDIDO
        )
        WHERE ID_PEDIDO = :OLD.ID_PEDIDO;
    END IF;
END;
/
*/

-- =====================================================
-- TRIGGER: DESCONTAR INSUMOS AUTOMATICAMENTE
-- =====================================================
CREATE OR REPLACE TRIGGER TGR_DESC_INSUMOS
AFTER INSERT ON DETALLE_PEDIDO
FOR EACH ROW
DECLARE V_FACTOR NUMBER(3,2);
--PARA LA LECHE
V_USA_LECHE CHAR(1);
V_CANTIDAD_LECHE NUMBER(10,2);
V_ID_INSUMO_LECHE NUMBER;
BEGIN
    SELECT FACTOR_MULTIPLICADOR
    INTO V_FACTOR
    FROM TAMANO
    WHERE ID_TAMANO = :NEW.ID_TAMANO;
    
    FOR REC IN (
        SELECT ID_INSUMO, CANTIDAD_USADA
        FROM PRODUCTO_INSUMO
        WHERE ID_PRODUCTO = :NEW.ID_PRODUCTO
    )
    LOOP
        UPDATE INSUMO
        SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE - (REC.CANTIDAD_USADA * V_FACTOR * :NEW.CANTIDAD)
        WHERE ID_INSUMO = REC.ID_INSUMO;
    END LOOP;
    
    SELECT USA_LECHE, CANTIDAD_LECHE_BASE
    INTO V_USA_LECHE, V_CANTIDAD_LECHE
    FROM PRODUCTO
    WHERE ID_PRODUCTO = :NEW.ID_PRODUCTO;
    IF V_USA_LECHE = 'S' THEN
        SELECT ID_INSUMO
        INTO V_ID_INSUMO_LECHE
        FROM TIPO_LECHE
        WHERE ID_LECHE = :NEW.ID_LECHE;
        
        UPDATE INSUMO
        SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE - (V_CANTIDAD_LECHE * V_FACTOR * :NEW.CANTIDAD)
        WHERE ID_INSUMO = V_ID_INSUMO_LECHE;
    END IF;
END;
/

-- =====================================================
-- TRIGGER: GENERAR SOLICITUD AUTOMATICA DE STOCK
-- =====================================================
CREATE OR REPLACE TRIGGER TGR_REABASTECIMIENTO
AFTER UPDATE ON INSUMO
FOR EACH ROW
BEGIN
    IF :NEW.CANTIDAD_DISPONIBLE <= :NEW.STOCK_MINIMO THEN
        IF :NEW.ID_INSUMO IN (3, 4, 5) THEN
            INSERT INTO SOLICITUD_INSUMO 
            (
                ID_INSUMO,
                CANTIDAD_SOLICITADA,
                ESTADO
            )
            VALUES 
            (
                :NEW.ID_INSUMO,
                150,
                'PENDIENTE'
            );
        ELSE
            INSERT INTO SOLICITUD_INSUMO 
            (
                ID_INSUMO,
                CANTIDAD_SOLICITADA,
                ESTADO
            )
            VALUES 
            (
                :NEW.ID_INSUMO,
                1000,
                'PENDIENTE'
            );
        END IF;
    END IF;
END;
/

-- =====================================================
-- VISTA: PRODUCTOS MAS VENDIDOS
-- =====================================================
CREATE OR REPLACE VIEW VW_PRODUCTOS_MAS_VENDIDOS AS
SELECT P.NOMBRE PRODUCTO, SUM(DP.CANTIDAD) "TOTAL VENDIDO"
FROM PRODUCTO P
JOIN DETALLE_PEDIDO DP
ON P.ID_PRODUCTO = DP.ID_PRODUCTO
GROUP BY P.NOMBRE;

-- =====================================================
-- VISTA: HISTORIAL DE COMPRAS
-- =====================================================
CREATE OR REPLACE VIEW VW_HISTORIAL_COMPRAS AS
SELECT 
    C.NOMBRE || ' ' || C.AP_PATERNO CLIENTE,
    P.FECHA_HORA,
    PR.NOMBRE PRODUCTO,
    DP.CANTIDAD,
    DP.SUBTOTAL
FROM PEDIDO P

JOIN CLIENTE C
ON P.ID_CLIENTE = C.ID_CLIENTE

JOIN DETALLE_PEDIDO DP
ON P.ID_PEDIDO = DP.ID_PEDIDO

JOIN PRODUCTO PR
ON DP.ID_PRODUCTO = PR.ID_PRODUCTO;

-- =====================================================
-- VISTA: INVENTARIO BAJO DE INSUMOS
-- =====================================================
CREATE OR REPLACE VIEW VW_INSUMOS_BAJOS AS
SELECT NOMBRE, CANTIDAD_DISPONIBLE, STOCK_MINIMO
FROM INSUMO
WHERE CANTIDAD_DISPONIBLE <= (STOCK_MINIMO + 50);

-- =====================================================
-- VISTA: HORARIOS DE MAYOR AFLUENCIA
-- =====================================================
CREATE OR REPLACE VIEW VW_HORAS_MAS_AFLUENCIA AS
SELECT TO_CHAR(FECHA_HORA, 'HH24') HORA, COUNT(*) TOTAL_PEDIDOS
FROM PEDIDO
GROUP BY TO_CHAR(FECHA_HORA, 'HH24')
ORDER BY TOTAL_PEDIDOS DESC;



