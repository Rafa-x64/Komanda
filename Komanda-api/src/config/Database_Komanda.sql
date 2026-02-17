-- ======================================================
-- SISTEMA DE GESTIÓN DE RESTAURANTES (SAAS)
-- Base de datos completa para PostgreSQL
-- Versión CORREGIDA - Con todas las columnas restaurante_id
-- ======================================================

-- Eliminar tablas si existen (en orden inverso)
DROP TABLE IF EXISTS banco_movimientos CASCADE;
DROP TABLE IF EXISTS banco CASCADE;
DROP TABLE IF EXISTS caja_movimientos CASCADE;
DROP TABLE IF EXISTS caja CASCADE;
DROP TABLE IF EXISTS facturas CASCADE;
DROP TABLE IF EXISTS pedido_detalle CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS meseros CASCADE;
DROP TABLE IF EXISTS mesas CASCADE;
DROP TABLE IF EXISTS receta_ingredientes CASCADE;
DROP TABLE IF EXISTS recetas CASCADE;
DROP TABLE IF EXISTS compra_detalle CASCADE;
DROP TABLE IF EXISTS compras CASCADE;
DROP TABLE IF EXISTS proveedores CASCADE;
DROP TABLE IF EXISTS unidad_compra CASCADE;
DROP TABLE IF EXISTS egresos CASCADE;
DROP TABLE IF EXISTS categoria_egresos CASCADE;
DROP TABLE IF EXISTS ingredientes CASCADE;
DROP TABLE IF EXISTS unidad_medida CASCADE;
DROP TABLE IF EXISTS metodos_pago CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS restaurante CASCADE;

-- Eliminar tipos ENUM si existen
DROP TYPE IF EXISTS estado_mesa CASCADE;
DROP TYPE IF EXISTS estado_pedido CASCADE;
DROP TYPE IF EXISTS estado_factura CASCADE;
DROP TYPE IF EXISTS estado_caja CASCADE;
DROP TYPE IF EXISTS tipo_movimiento CASCADE;
DROP TYPE IF EXISTS referencia_tipo_caja CASCADE;
DROP TYPE IF EXISTS referencia_tipo_banco CASCADE;

-- ======================================================
-- CREACIÓN DE TIPOS ENUM
-- ======================================================

CREATE TYPE estado_mesa AS ENUM ('libre', 'ocupada', 'reservada', 'inactiva');
CREATE TYPE estado_pedido AS ENUM ('pendiente', 'preparando', 'listo', 'pagado', 'cancelado');
CREATE TYPE estado_factura AS ENUM ('emitida', 'anulada');
CREATE TYPE estado_caja AS ENUM ('abierta', 'cerrada');
CREATE TYPE tipo_movimiento AS ENUM ('ingreso', 'egreso');
CREATE TYPE referencia_tipo_caja AS ENUM ('venta', 'egreso', 'compra', 'apertura', 'cierre', 'ajuste');
CREATE TYPE referencia_tipo_banco AS ENUM ('venta', 'egreso', 'compra', 'deposito_caja', 'ajuste');

-- ======================================================
-- TABLAS BASE
-- ======================================================

-- Tabla restaurante (multi-tenencia)
CREATE TABLE restaurante (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    patrimonio_inicial DECIMAL(10, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Unidades de medida
CREATE TABLE unidad_medida (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    abreviatura VARCHAR(5) NOT NULL
);

-- Métodos de pago
CREATE TABLE metodos_pago (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    restaurante_id INTEGER NOT NULL
);

-- Roles de usuario
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL, -- 'admin', 'cajero', 'cocinero', 'mesero'
    restaurante_id INTEGER NOT NULL
);

-- Usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    restaurante_id INTEGER NOT NULL,
    rol_id INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    activo BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_usuarios_email ON usuarios(email);

-- ======================================================
-- MÓDULO DE INVENTARIO Y COMPRAS
-- ======================================================

-- Categorías de egresos
CREATE TABLE categoria_egresos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL, -- 'proveedores', 'servicios', 'nomina', 'otros'
    restaurante_id INTEGER NOT NULL
);

-- Proveedores
CREATE TABLE proveedores (
    id SERIAL PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion TEXT,
    restaurante_id INTEGER NOT NULL,
    banco_nombre VARCHAR(50),
    banco_cuenta_numero VARCHAR(30),
    activo BOOLEAN DEFAULT TRUE,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_proveedores_nombre ON proveedores(nombre);
CREATE INDEX idx_proveedores_restaurante ON proveedores(restaurante_id, nombre);

-- Unidad de compra (sacos, cajas, etc)
CREATE TABLE unidad_compra (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    restaurante_id INTEGER NOT NULL
);

-- Ingredientes (inventario)
CREATE TABLE ingredientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad_disponible DECIMAL(10,3) DEFAULT 0,
    cantidad_minima DECIMAL(10,3) DEFAULT 0,
    unidad_id INTEGER NOT NULL,
    costo_promedio DECIMAL(10,2) DEFAULT 0,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_ingredientes_nombre ON ingredientes(nombre);
CREATE INDEX idx_ingredientes_stock ON ingredientes(cantidad_disponible, cantidad_minima);

-- Compras
CREATE TABLE compras (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255),
    proveedor_id INTEGER,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_compras_fecha ON compras(fecha);
CREATE INDEX idx_compras_proveedor ON compras(proveedor_id);

-- Detalle de compras
CREATE TABLE compra_detalle (
    id SERIAL PRIMARY KEY,
    compra_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    unidad_compra_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_compra_detalle_compra ON compra_detalle(compra_id);
CREATE INDEX idx_compra_detalle_ingrediente ON compra_detalle(ingrediente_id);

-- ======================================================
-- MÓDULO DE RECETAS Y MENÚ
-- ======================================================

-- Recetas
CREATE TABLE recetas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    costo_produccion DECIMAL(10,2) DEFAULT 0,
    precio_sugerido DECIMAL(10,2) DEFAULT 0,
    precio_venta DECIMAL(10,2) DEFAULT 0,
    margen_utilidad DECIMAL(5,2) DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_recetas_nombre ON recetas(nombre);
CREATE INDEX idx_recetas_activo ON recetas(activo);

-- Ingredientes de recetas
CREATE TABLE receta_ingredientes (
    id SERIAL PRIMARY KEY,
    receta_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    restaurante_id INTEGER NOT NULL,
    UNIQUE(receta_id, ingrediente_id)
);

CREATE INDEX idx_receta_ingredientes_receta ON receta_ingredientes(receta_id);
CREATE INDEX idx_receta_ingredientes_ingrediente ON receta_ingredientes(ingrediente_id);

-- ======================================================
-- MÓDULO DE OPERACIONES (MESAS, MESEROS, PEDIDOS)
-- ======================================================

-- Mesas
CREATE TABLE mesas (
    id SERIAL PRIMARY KEY,
    numero INTEGER NOT NULL,
    nombre VARCHAR(50),
    capacidad INTEGER NOT NULL,
    estado estado_mesa DEFAULT 'libre',
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_mesas_estado ON mesas(estado);
CREATE INDEX idx_mesas_numero ON mesas(numero);

-- Meseros
CREATE TABLE meseros (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_meseros_nombre ON meseros(nombre);

-- Pedidos
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    mesa_id INTEGER,
    mesero_id INTEGER,
    cliente VARCHAR(100),
    estado estado_pedido DEFAULT 'pendiente',
    fecha_hora TIMESTAMP NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_pedidos_estado ON pedidos(estado);
CREATE INDEX idx_pedidos_fecha ON pedidos(fecha_hora);
CREATE INDEX idx_pedidos_codigo ON pedidos(codigo);

-- Detalle de pedidos
CREATE TABLE pedido_detalle (
    id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    receta_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_pedido_detalle_pedido ON pedido_detalle(pedido_id);
CREATE INDEX idx_pedido_detalle_receta ON pedido_detalle(receta_id);

-- Facturas
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    pedido_id INTEGER NOT NULL,
    fecha TIMESTAMP NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    impuestos DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado estado_factura DEFAULT 'emitida',
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_facturas_numero ON facturas(numero_factura);
CREATE INDEX idx_facturas_fecha ON facturas(fecha);

-- ======================================================
-- MÓDULO DE EGRESOS
-- ======================================================

-- Egresos (gastos)
CREATE TABLE egresos (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    categoria_id INTEGER NOT NULL,
    razon VARCHAR(255) NOT NULL,
    descripcion TEXT,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_egresos_fecha ON egresos(fecha);
CREATE INDEX idx_egresos_categoria ON egresos(categoria_id);

-- ======================================================
-- MÓDULO DE CAJA Y BANCO (CORREGIDO)
-- ======================================================

-- Caja (sesiones de caja)
CREATE TABLE caja (
    id SERIAL PRIMARY KEY,
    fecha_apertura TIMESTAMP NOT NULL,
    fecha_cierre TIMESTAMP,
    monto_inicial DECIMAL(10,2) NOT NULL,
    monto_final DECIMAL(10,2),
    estado estado_caja DEFAULT 'abierta',
    usuario_apertura_id INTEGER NOT NULL,
    usuario_cierre_id INTEGER,
    observaciones TEXT,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_caja_estado ON caja(estado);
CREATE INDEX idx_caja_fechas ON caja(fecha_apertura, fecha_cierre);

-- Movimientos de caja (CON RESTAURANTE_ID)
CREATE TABLE caja_movimientos (
    id SERIAL PRIMARY KEY,
    caja_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    tipo tipo_movimiento NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    referencia_tipo referencia_tipo_caja NOT NULL,
    referencia_id INTEGER NOT NULL,
    metodo_pago_id INTEGER,
    usuario_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_caja_movimientos_fecha ON caja_movimientos(fecha_hora);
CREATE INDEX idx_caja_movimientos_referencia ON caja_movimientos(referencia_tipo, referencia_id);
CREATE INDEX idx_caja_movimientos_caja ON caja_movimientos(caja_id);

-- Banco (cuentas bancarias)
CREATE TABLE banco (
    id SERIAL PRIMARY KEY,
    nombre_banco VARCHAR(100) NOT NULL,
    numero_cuenta VARCHAR(50) NOT NULL,
    saldo_actual DECIMAL(10,2) DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_banco_activo ON banco(activo);

-- Movimientos de banco (CON RESTAURANTE_ID)
CREATE TABLE banco_movimientos (
    id SERIAL PRIMARY KEY,
    banco_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    tipo tipo_movimiento NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    referencia_tipo referencia_tipo_banco NOT NULL,
    referencia_id INTEGER NOT NULL,
    metodo_pago_id INTEGER,
    usuario_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_banco_movimientos_fecha ON banco_movimientos(fecha_hora);
CREATE INDEX idx_banco_movimientos_referencia ON banco_movimientos(referencia_tipo, referencia_id);
CREATE INDEX idx_banco_movimientos_banco ON banco_movimientos(banco_id);

-- ======================================================
-- RELACIONES (CLAVES FORÁNEAS)
-- ======================================================

-- Relaciones multi-tenant
ALTER TABLE metodos_pago ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE roles ADD CONSTRAINT fk_roles_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE usuarios ADD CONSTRAINT fk_usuarios_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE categoria_egresos ADD CONSTRAINT fk_categoria_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE proveedores ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE unidad_compra ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE ingredientes ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE compras ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE compra_detalle ADD CONSTRAINT fk_compra_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE recetas ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE receta_ingredientes ADD CONSTRAINT fk_receta_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE mesas ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE meseros ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE pedido_detalle ADD CONSTRAINT fk_pedido_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE facturas ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE egresos ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE caja ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE caja_movimientos ADD CONSTRAINT fk_caja_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE banco ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;
ALTER TABLE banco_movimientos ADD CONSTRAINT fk_banco_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES restaurante(id) ON DELETE CASCADE;

-- Relaciones específicas
ALTER TABLE usuarios ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES roles(id);

ALTER TABLE ingredientes ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES unidad_medida(id);

ALTER TABLE compras ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedores(id);

ALTER TABLE compra_detalle ADD CONSTRAINT fk_compra_detalle_compra FOREIGN KEY (compra_id) REFERENCES compras(id) ON DELETE CASCADE;
ALTER TABLE compra_detalle ADD CONSTRAINT fk_compra_detalle_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id);
ALTER TABLE compra_detalle ADD CONSTRAINT fk_compra_detalle_unidad_compra FOREIGN KEY (unidad_compra_id) REFERENCES unidad_compra(id);

ALTER TABLE egresos ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES categoria_egresos(id);

ALTER TABLE receta_ingredientes ADD CONSTRAINT fk_receta_ingredientes_receta FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE;
ALTER TABLE receta_ingredientes ADD CONSTRAINT fk_receta_ingredientes_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id);

ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES mesas(id);
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES meseros(id);

ALTER TABLE pedido_detalle ADD CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE;
ALTER TABLE pedido_detalle ADD CONSTRAINT fk_pedido_detalle_receta FOREIGN KEY (receta_id) REFERENCES recetas(id);

ALTER TABLE facturas ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(id);

ALTER TABLE caja ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES usuarios(id);
ALTER TABLE caja ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES usuarios(id);

ALTER TABLE caja_movimientos ADD CONSTRAINT fk_caja_movimientos_caja FOREIGN KEY (caja_id) REFERENCES caja(id);
ALTER TABLE caja_movimientos ADD CONSTRAINT fk_caja_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id);
ALTER TABLE caja_movimientos ADD CONSTRAINT fk_caja_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE banco_movimientos ADD CONSTRAINT fk_banco_movimientos_banco FOREIGN KEY (banco_id) REFERENCES banco(id);
ALTER TABLE banco_movimientos ADD CONSTRAINT fk_banco_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id);
ALTER TABLE banco_movimientos ADD CONSTRAINT fk_banco_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

-- ======================================================
-- TRIGGER PARA ACTUALIZAR updated_at AUTOMÁTICAMENTE
-- ======================================================

-- Función para actualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para tablas con updated_at
CREATE TRIGGER update_restaurante_updated_at BEFORE UPDATE ON restaurante FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_proveedores_updated_at BEFORE UPDATE ON proveedores FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ======================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- ======================================================

CREATE INDEX idx_compras_fecha_proveedor ON compras(fecha, proveedor_id);
CREATE INDEX idx_pedidos_fecha_estado ON pedidos(fecha_hora, estado);
CREATE INDEX idx_facturas_fecha_estado ON facturas(fecha, estado);

-- ======================================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- ======================================================

COMMENT ON TABLE restaurante IS 'Tabla base para multi-tenencia';
COMMENT ON TABLE ingredientes IS 'Inventario de materias primas con costo promedio';
COMMENT ON TABLE recetas IS 'Recetas estándar (BOM - Bill of Materials)';
COMMENT ON TABLE caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';
COMMENT ON TABLE banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';

-- ======================================================
-- FIN DEL SCRIPT
-- ======================================================