-- =====================================================
-- PROYECTO: CAFETERÍA
-- ORACLE DATABASE 26ai
-- Authors: Almaraz García Beatriz, Martínez Ojeda Jonhatan Alexis, Raya Ramírez Angel Adrián
-- Description: Scrip que contiene procedimientos almacenados necesarios para el correcto funcionamiento del sistema.
-- =====================================================

-- =====================================================
-- PROCEDURE: REGISTRAR UN PEDIDO COMPLETO
-- =====================================================
CREATE OR REPLACE PROCEDURE REGISTRAR_PEDIDO (
    P_ID_CLIENTE IN NUMBER,
    P_ID_EMPLEADO IN NUMBER,
    P_ID_PRODUCTO IN NUMBER,
    P_ID_TAMANO IN NUMBER,
    P_ID_LECHE IN NUMBER,
    P_ID_TEMPERATURA IN NUMBER,
    P_CANTIDAD IN NUMBER,
    P_EXTRAS IN VARCHAR2
)
IS
    V_ID_PEDIDO NUMBER;
    V_ID_DETALLLE NUMBER;
    V_PRECIO_BASE NUMBER(8,2);
    V_PRECIO_EXTRAS NUMBER(8,2) := 0;
    V_PRECIO_TOTAL NUMBER(8,2);
    V_EXTRA_ID NUMBER;
    V_INCREMENTO_TAMANO NUMBER(8,2) := 0;
    V_COSTO_LECHE NUMBER(3,2) := 0;
BEGIN
    --OBTENER EL PRECIO BASE
    SELECT PRECIO_BASE
    INTO V_PRECIO_BASE
    FROM PRODUCTO
    WHERE ID_PRODUCTO = P_ID_PRODUCTO;
    
    --OBTENER EL AUMENTO DE TAMAÑO
    SELECT INCREMENTO_PRECIO
    INTO V_INCREMENTO_TAMANO
    FROM TAMANO
    WHERE ID_TAMANO = P_ID_TAMANO;
    
    --OBTENER COSTO DE LECHE
    SELECT COSTO_EXTRA
    INTO V_COSTO_LECHE
    FROM TIPO_LECHE
    WHERE ID_LECHE = P_ID_LECHE;
    
    --CALCULAR PRECIO DE LOS EXTRAS
    IF P_EXTRAS IS NOT NULL THEN
        FOR REC IN (
            SELECT TO_NUMBER(REGEXP_SUBSTR(P_EXTRAS, '[^,]+', 1, LEVEL)) ID_EXTRA
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_EXTRAS, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        LOOP
            SELECT COSTO_EXTRA
            INTO V_PRECIO_TOTAL
            FROM EXTRA
            WHERE ID_EXTRA = REC.ID_EXTRA;
            
            V_PRECIO_EXTRAS := V_PRECIO_EXTRAS + V_PRECIO_TOTAL;
        END LOOP;
    END IF;
    
    --PRECIO FINAL
    V_PRECIO_TOTAL := V_PRECIO_BASE + V_INCREMENTO_TAMANO + V_COSTO_LECHE + V_PRECIO_EXTRAS;
    
    --CREAR PEDIDO
    INSERT INTO PEDIDO (ID_CLIENTE, ID_EMPLEADO)
    VALUES (P_ID_CLIENTE, P_ID_EMPLEADO)
    RETURNING ID_PEDIDO
    INTO V_ID_PEDIDO;
    
    --INSERTAR DETALLE
    INSERT INTO DETALLE_PEDIDO (
        ID_PEDIDO,
        ID_PRODUCTO,
        ID_TAMANO,
        ID_LECHE,
        ID_TEMPERATURA,
        CANTIDAD,
        PRECIO_UNITARIO,
        SUBTOTAL
    )
    VALUES (
        V_ID_PEDIDO,
        P_ID_PRODUCTO,
        P_ID_TAMANO,
        P_ID_LECHE,
        P_ID_TEMPERATURA,
        P_CANTIDAD,
        V_PRECIO_TOTAL,
        0
    )
    RETURNING ID_DETALLE
    INTO V_ID_DETALLE;
    
    --INSERTAR EXTRAS
    IF P_EXTRAS IS NOT NULL THEN
        FOR REC IN (
            SELECT TO_NUMBER(REGEXP_SUBSTR(P_EXTRAS, '[^,]+', 1, LEVEL)) AS ID_EXTRA
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_EXTRAS, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        LOOP
            INSERT INTO DETALLE_EXTRA (ID_DETALLE, ID_EXTRA)
            VALUES (V_ID_DETALLE, REC.ID_EXTRA);
        END LOOP;
    END IF;
    
    COMMIT;
END;
/
--NOTA: El procedimiento no descuenta los insumos de los extras. Podría hacerlo pero ya me duele la cabeza. :d          

--PARA EJECUTARLO (ejemplo)
BEGIN REGISTRAR_PEDIDO(
        1, -- CLIENTE
        1, -- EMPLEADO
        1, -- PRODUCTO
        2, -- TAMAÑO
        1, -- LECHE
        1, -- TEMPERATURA
        2  -- CANTIDAD
        '1,2' -- EXTRAS
    );

END;
/

-- =====================================================
-- PROCEDURE: YA NO SE ME OCURRIO OTRO
-- =====================================================