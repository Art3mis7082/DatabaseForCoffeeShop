-- =====================================================
-- PROYECTO: CAFETERÍA
-- ORACLE DATABASE 26ai
-- Authors: Almaraz García Beatriz, Martínez Ojeda Jonhatan Alexis, Raya Ramírez Angel Adrián
-- Description: Script que contiene un pequeño dataset de prueba, 
-- =====================================================

-- =====================================================
-- EMPLEADOS
-- =====================================================

INSERT INTO EMPLEADO (
    NOMBRE, 
    AP_PATERNO, 
    AP_MATERNO, 
    FECHA_CONTRATACION, 
    RFC, 
    CORREO,
    TELEFONO
    )
VALUES 
    (
    'ELI', 
    'BRITO', 
    'MARTINEZ',
    TO_DATE('2024-01-15','YYYY-MM-DD'),
    'BRME010101ABC',
    'eli@cafeteria.com',
    '5512345678'
    ),
    (
    'BETTY', 
    'ALMARAZ', 
    'GARCIA',
    TO_DATE('2024-03-10','YYYY-MM-DD'),
    'ALGB020202XYZ',
    'betty@cafeteria.com',
    '5598765432'
    );

-- =====================================================
-- CLIENTES
-- =====================================================

INSERT INTO CLIENTE (
    NOMBRE,
    AP_PATERNO, 
    AP_MATERNO,
    CORREO,
    TELEFONO
    )
VALUES
    (
    'JONHATAN', 
    'MARTINEZ', 
    'OJEDA', 
    'jonny@gmail.com', 
    '5511111111'),
    (
    'ANGEL', 
    'RAYA', 
    'RAMIREZ', 
    'aneglous@gmail.com', 
    '5522222222'),
    (
    'SOFIA', 
    'RAMOS', 
    'DIAZ',
    'sofia@gmail.com',
    '5533333333');
