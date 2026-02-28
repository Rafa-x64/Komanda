-- ======================================================
-- KOMANDA - SISTEMA DE GESTIÓN DE RESTAURANTES (SAAS)
-- Base de datos para PostgreSQL
-- Versión 2.1 - Robustez mejorada (Reservas, Descuentos, Conversiones)
-- ======================================================

-- ======================================================
-- LIMPIEZA TOTAL (orden inverso de dependencias)
-- ======================================================

DROP SCHEMA IF EXISTS contabilidad CASCADE;
DROP SCHEMA IF EXISTS finanzas CASCADE;
DROP SCHEMA IF EXISTS operaciones CASCADE;
DROP SCHEMA IF EXISTS menu CASCADE;
DROP SCHEMA IF EXISTS inventario CASCADE;
DROP SCHEMA IF EXISTS core CASCADE;

-- Eliminar tipos ENUM globales si existen
DROP TYPE IF EXISTS estado_mesa CASCADE;
DROP TYPE IF EXISTS estado_pedido CASCADE;
DROP TYPE IF EXISTS estado_cuenta CASCADE;
DROP TYPE IF EXISTS estado_factura CASCADE;
DROP TYPE IF EXISTS estado_caja CASCADE;
DROP TYPE IF EXISTS tipo_movimiento CASCADE;
DROP TYPE IF EXISTS referencia_tipo_caja CASCADE;
DROP TYPE IF EXISTS referencia_tipo_banco CASCADE;
DROP TYPE IF EXISTS tipo_merma CASCADE;
DROP TYPE IF EXISTS estado_reserva CASCADE;
DROP TYPE IF EXISTS estado_pago_compra CASCADE;

-- ======================================================
-- CREACIÓN DE ESQUEMAS
-- ======================================================

CREATE SCHEMA core;           -- Restaurante, usuarios, roles, configuración
CREATE SCHEMA inventario;     -- Ingredientes, proveedores, compras, mermas
CREATE SCHEMA menu;           -- Recetas, categorías, ingredientes de receta
CREATE SCHEMA operaciones;    -- Mesas, meseros, pedidos, facturas, reservas
CREATE SCHEMA finanzas;       -- Caja, banco, egresos
CREATE SCHEMA contabilidad;   -- Libro diario (asientos contables)

-- ======================================================
-- CREACIÓN DE TIPOS ENUM
-- ======================================================

CREATE TYPE estado_mesa AS ENUM ('libre', 'ocupada', 'reservada', 'inactiva');
CREATE TYPE estado_pedido AS ENUM ('pendiente', 'enviado', 'preparando', 'listo', 'entregado', 'anulado');
CREATE TYPE estado_cuenta AS ENUM ('abierta', 'cuenta_pedida', 'pagada', 'cerrada');
CREATE TYPE estado_factura AS ENUM ('emitida', 'anulada');
CREATE TYPE estado_caja AS ENUM ('abierta', 'cerrada');
CREATE TYPE tipo_movimiento AS ENUM ('ingreso', 'egreso');
CREATE TYPE referencia_tipo_caja AS ENUM ('venta', 'egreso', 'compra', 'apertura', 'cierre', 'ajuste');
CREATE TYPE referencia_tipo_banco AS ENUM ('venta', 'egreso', 'compra', 'deposito_caja', 'ajuste');
CREATE TYPE tipo_merma AS ENUM ('desperdicio', 'vencimiento', 'rotura', 'otro');
CREATE TYPE estado_reserva AS ENUM ('pendiente', 'confirmada', 'cancelada', 'completada', 'no_show');
CREATE TYPE estado_pago_compra AS ENUM ('pendiente', 'pagada', 'parcial');

-- ======================================================
-- FUNCIÓN GLOBAL: auto-update de updated_at
-- ======================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ======================================================
-- ESQUEMA: core
-- ======================================================

-- Restaurante (tenant principal)
CREATE TABLE core.restaurante (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    logo_url TEXT,
    moneda VARCHAR(3) DEFAULT 'USD',
    zona_horaria VARCHAR(50) DEFAULT 'America/Caracas',
    impuesto_porcentaje DECIMAL(5,2) DEFAULT 0,
    propina_porcentaje DECIMAL(5,2) DEFAULT 0,
    patrimonio_inicial DECIMAL(12,2) DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Unidades de medida (global, no multi-tenant)
CREATE TABLE core.unidad_medida (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    abreviatura VARCHAR(5) NOT NULL
);

-- Métodos de pago
CREATE TABLE core.metodos_pago (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Roles de usuario
CREATE TABLE core.roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN core.roles.nombre IS 'Valores esperados: admin, cajero, cocinero, mesero';

-- Usuarios
CREATE TABLE core.usuarios (
    id SERIAL PRIMARY KEY,
    restaurante_id INTEGER NOT NULL,
    rol_id INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_usuarios_username ON core.usuarios(username);
CREATE INDEX idx_usuarios_email ON core.usuarios(email);
CREATE INDEX idx_usuarios_restaurante ON core.usuarios(restaurante_id);

-- ======================================================
-- ESQUEMA: inventario
-- ======================================================

-- Categorías de egresos
CREATE TABLE inventario.categoria_egresos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN inventario.categoria_egresos.nombre IS 'Ej: proveedores, servicios, nomina, otros';

-- Proveedores
CREATE TABLE inventario.proveedores (
    id SERIAL PRIMARY KEY,
    identificacion VARCHAR(30) NOT NULL,
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

CREATE INDEX idx_proveedores_nombre ON inventario.proveedores(nombre);
CREATE INDEX idx_proveedores_restaurante ON inventario.proveedores(restaurante_id, nombre);

-- Unidad de compra (sacos, cajas, etc.)
CREATE TABLE inventario.unidad_compra (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ingredientes (inventario de materias primas)
CREATE TABLE inventario.ingredientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad_disponible DECIMAL(10,3) DEFAULT 0,
    cantidad_minima DECIMAL(10,3) DEFAULT 0,
    unidad_id INTEGER NOT NULL, -- Unidad de consumo (ej. gramos, mililitros)
    costo_promedio DECIMAL(10,2) DEFAULT 0,
    merma_teorica_porcentaje DECIMAL(5,2) DEFAULT 0, -- % de pérdida esperada al procesar
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ingredientes_nombre ON inventario.ingredientes(nombre);
CREATE INDEX idx_ingredientes_stock ON inventario.ingredientes(cantidad_disponible, cantidad_minima);
CREATE INDEX idx_ingredientes_restaurante ON inventario.ingredientes(restaurante_id);

COMMENT ON COLUMN inventario.ingredientes.merma_teorica_porcentaje IS '% de pérdida natural (ej. cáscaras, huesos) para cálculo preciso de costos del ingrediente limpio';

-- Compras
CREATE TABLE inventario.compras (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    numero_factura_proveedor VARCHAR(50),
    total DECIMAL(12,2) NOT NULL,
    estado_pago estado_pago_compra DEFAULT 'pagada',
    saldo_pendiente DECIMAL(12,2) DEFAULT 0,
    descripcion VARCHAR(255),
    proveedor_id INTEGER,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_compras_fecha ON inventario.compras(fecha);
CREATE INDEX idx_compras_proveedor ON inventario.compras(proveedor_id);

-- Detalle de compras
CREATE TABLE inventario.compra_detalle (
    id SERIAL PRIMARY KEY,
    compra_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    cantidad_compra DECIMAL(10,3) NOT NULL, -- Cantidad en unidad de compra (ej. 2 [Sacos])
    unidad_compra_id INTEGER NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    factor_conversion DECIMAL(10,3) NOT NULL, -- Cuántas unidades de consumo hay en 1 unidad de compra? (ej. 50000 [gr])
    cantidad_inventario DECIMAL(10,3) GENERATED ALWAYS AS (cantidad_compra * factor_conversion) STORED, -- Se suma al stock (100000 gr)
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_compra_detalle_compra ON inventario.compra_detalle(compra_id);
CREATE INDEX idx_compra_detalle_ingrediente ON inventario.compra_detalle(ingrediente_id);

COMMENT ON COLUMN inventario.compra_detalle.factor_conversion IS 'Multiplicador para convertir Unidad Compra -> Unidad Inventario (ej. 1 Saco = 50000 gr)';

-- Mermas (desperdicios / pérdidas de inventario)
CREATE TABLE inventario.mermas (
    id SERIAL PRIMARY KEY,
    ingrediente_id INTEGER NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    tipo tipo_merma NOT NULL DEFAULT 'desperdicio',
    razon TEXT NOT NULL,
    reportado_por INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_mermas_ingrediente ON inventario.mermas(ingrediente_id);
CREATE INDEX idx_mermas_fecha ON inventario.mermas(created_at);

COMMENT ON TABLE inventario.mermas IS 'Registro de pérdidas de inventario para conciliar stock teórico vs real';

-- ======================================================
-- ESQUEMA: menu
-- ======================================================

-- Categorías de menú
CREATE TABLE menu.categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    orden INTEGER DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_categorias_restaurante ON menu.categorias(restaurante_id, orden);

COMMENT ON TABLE menu.categorias IS 'Categorías del menú: Entradas, Platos Fuertes, Bebidas, Postres, etc.';

-- Recetas (productos del menú)
CREATE TABLE menu.recetas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria_id INTEGER,
    imagen_url TEXT,
    costo_produccion DECIMAL(10,2) DEFAULT 0,
    precio_sugerido DECIMAL(10,2) DEFAULT 0,
    precio_venta DECIMAL(10,2) DEFAULT 0,
    margen_utilidad DECIMAL(5,2) DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_recetas_nombre ON menu.recetas(nombre);
CREATE INDEX idx_recetas_activo ON menu.recetas(activo);
CREATE INDEX idx_recetas_categoria ON menu.recetas(categoria_id);

-- Ingredientes de recetas (BOM)
CREATE TABLE menu.receta_ingredientes (
    id SERIAL PRIMARY KEY,
    receta_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL, -- Cantidad en Unidad de Inventario (ej. gramos)
    restaurante_id INTEGER NOT NULL,
    UNIQUE(receta_id, ingrediente_id)
);

CREATE INDEX idx_receta_ingredientes_receta ON menu.receta_ingredientes(receta_id);
CREATE INDEX idx_receta_ingredientes_ingrediente ON menu.receta_ingredientes(ingrediente_id);

-- ======================================================
-- ESQUEMA: operaciones
-- ======================================================

-- Mesas
CREATE TABLE operaciones.mesas (
    id SERIAL PRIMARY KEY,
    numero INTEGER NOT NULL,
    nombre VARCHAR(50),
    capacidad INTEGER NOT NULL,
    estado estado_mesa DEFAULT 'libre',
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_mesas_estado ON operaciones.mesas(estado);
CREATE INDEX idx_mesas_numero ON operaciones.mesas(numero);

-- Meseros
CREATE TABLE operaciones.meseros (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_meseros_nombre ON operaciones.meseros(nombre);

-- Reservas (NUEVO)
CREATE TABLE operaciones.reservas (
    id SERIAL PRIMARY KEY,
    mesa_id INTEGER, -- Puede ser NULL si aún no se asigna mesa
    cliente_nombre VARCHAR(100) NOT NULL,
    cliente_telefono VARCHAR(20),
    fecha_reserva TIMESTAMP NOT NULL,
    cantidad_personas INTEGER NOT NULL,
    estado estado_reserva DEFAULT 'pendiente',
    notas TEXT,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reservas_fecha ON operaciones.reservas(fecha_reserva);
CREATE INDEX idx_reservas_estado ON operaciones.reservas(estado);

-- Pedidos
CREATE TABLE operaciones.pedidos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    mesa_id INTEGER,
    mesero_id INTEGER,
    cliente VARCHAR(100),
    estado estado_pedido DEFAULT 'pendiente',
    estado_cuenta estado_cuenta DEFAULT 'abierta',
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(12,2) DEFAULT 0,
    descuento DECIMAL(12,2) DEFAULT 0,
    impuestos DECIMAL(12,2) DEFAULT 0,
    total DECIMAL(12,2) DEFAULT 0,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pedidos_estado ON operaciones.pedidos(estado);
CREATE INDEX idx_pedidos_estado_cuenta ON operaciones.pedidos(estado_cuenta);
CREATE INDEX idx_pedidos_fecha ON operaciones.pedidos(fecha_hora);
CREATE INDEX idx_pedidos_codigo ON operaciones.pedidos(codigo);
CREATE INDEX idx_pedidos_fecha_estado ON operaciones.pedidos(fecha_hora, estado);

-- Detalle de pedidos
CREATE TABLE operaciones.pedido_detalle (
    id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    receta_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    notas TEXT,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_pedido_detalle_pedido ON operaciones.pedido_detalle(pedido_id);
CREATE INDEX idx_pedido_detalle_receta ON operaciones.pedido_detalle(receta_id);

COMMENT ON COLUMN operaciones.pedido_detalle.notas IS 'Instrucciones para cocina: "Sin piña", "Extra queso", etc.';

-- Facturas
CREATE TABLE operaciones.facturas (
    id SERIAL PRIMARY KEY,
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    pedido_id INTEGER NOT NULL,
    metodo_pago_id INTEGER,
    usuario_id INTEGER,
    cliente_nombre VARCHAR(100),
    cliente_identificacion VARCHAR(30),
    cliente_direccion TEXT,
    cliente_email VARCHAR(100),
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(12,2) DEFAULT 0,
    impuestos DECIMAL(10,2) DEFAULT 0,
    propina DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    estado estado_factura DEFAULT 'emitida',
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_facturas_numero ON operaciones.facturas(numero_factura);
CREATE INDEX idx_facturas_fecha ON operaciones.facturas(fecha);
CREATE INDEX idx_facturas_fecha_estado ON operaciones.facturas(fecha, estado);

-- ======================================================
-- ESQUEMA: finanzas
-- ======================================================

-- Egresos (gastos operativos)
CREATE TABLE finanzas.egresos (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    categoria_id INTEGER NOT NULL,
    razon VARCHAR(255) NOT NULL,
    descripcion TEXT,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_egresos_fecha ON finanzas.egresos(fecha);
CREATE INDEX idx_egresos_categoria ON finanzas.egresos(categoria_id);

-- Caja (sesiones de caja)
CREATE TABLE finanzas.caja (
    id SERIAL PRIMARY KEY,
    fecha_apertura TIMESTAMP NOT NULL,
    fecha_cierre TIMESTAMP,
    monto_inicial DECIMAL(12,2) NOT NULL,
    monto_final DECIMAL(12,2),
    monto_teorico DECIMAL(12,2), -- Cálcullado por el sistema
    diferencia DECIMAL(12,2),    -- Final - Teorico
    estado estado_caja DEFAULT 'abierta',
    usuario_apertura_id INTEGER NOT NULL,
    usuario_cierre_id INTEGER,
    observaciones TEXT,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_caja_estado ON finanzas.caja(estado);
CREATE INDEX idx_caja_fechas ON finanzas.caja(fecha_apertura, fecha_cierre);

-- Movimientos de caja
CREATE TABLE finanzas.caja_movimientos (
    id SERIAL PRIMARY KEY,
    caja_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo tipo_movimiento NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    referencia_tipo referencia_tipo_caja NOT NULL,
    referencia_id INTEGER NOT NULL,
    metodo_pago_id INTEGER,
    usuario_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_caja_mov_fecha ON finanzas.caja_movimientos(fecha_hora);
CREATE INDEX idx_caja_mov_referencia ON finanzas.caja_movimientos(referencia_tipo, referencia_id);
CREATE INDEX idx_caja_mov_caja ON finanzas.caja_movimientos(caja_id);

-- Banco (cuentas bancarias)
CREATE TABLE finanzas.banco (
    id SERIAL PRIMARY KEY,
    nombre_banco VARCHAR(100) NOT NULL,
    numero_cuenta VARCHAR(50) NOT NULL,
    saldo_actual DECIMAL(12,2) DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_banco_activo ON finanzas.banco(activo);

-- Movimientos de banco
CREATE TABLE finanzas.banco_movimientos (
    id SERIAL PRIMARY KEY,
    banco_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo tipo_movimiento NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    referencia_tipo referencia_tipo_banco NOT NULL,
    referencia_id INTEGER NOT NULL,
    metodo_pago_id INTEGER,
    usuario_id INTEGER NOT NULL,
    restaurante_id INTEGER NOT NULL
);

CREATE INDEX idx_banco_mov_fecha ON finanzas.banco_movimientos(fecha_hora);
CREATE INDEX idx_banco_mov_referencia ON finanzas.banco_movimientos(referencia_tipo, referencia_id);
CREATE INDEX idx_banco_mov_banco ON finanzas.banco_movimientos(banco_id);

-- ======================================================
-- ESQUEMA: contabilidad
-- ======================================================

-- Libro diario (asientos contables simplificados)
CREATE TABLE contabilidad.libro_diario (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    debe DECIMAL(12,2) NOT NULL DEFAULT 0,
    haber DECIMAL(12,2) NOT NULL DEFAULT 0,
    referencia_tipo VARCHAR(50),
    referencia_id INTEGER,
    restaurante_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_libro_fecha ON contabilidad.libro_diario(fecha);
CREATE INDEX idx_libro_tipo ON contabilidad.libro_diario(tipo);
CREATE INDEX idx_libro_referencia ON contabilidad.libro_diario(referencia_tipo, referencia_id);

COMMENT ON TABLE contabilidad.libro_diario IS 'Asientos contables para generar Balance General y Estado de Resultados';
COMMENT ON COLUMN contabilidad.libro_diario.tipo IS 'Ej: venta, costo_venta, gasto_operativo, compra_insumo, merma';

-- ======================================================
-- RELACIONES (CLAVES FORÁNEAS)
-- ======================================================

-- === core ===
ALTER TABLE core.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE core.roles
    ADD CONSTRAINT fk_roles_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE core.usuarios
    ADD CONSTRAINT fk_usuarios_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES core.roles(id);

-- === inventario ===
ALTER TABLE inventario.categoria_egresos
    ADD CONSTRAINT fk_cat_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE inventario.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE inventario.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES core.unidad_medida(id);

ALTER TABLE inventario.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES inventario.proveedores(id);

ALTER TABLE inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_compra_det_compra FOREIGN KEY (compra_id) REFERENCES inventario.compras(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_compra_det_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id),
    ADD CONSTRAINT fk_compra_det_unidad FOREIGN KEY (unidad_compra_id) REFERENCES inventario.unidad_compra(id);

ALTER TABLE inventario.mermas
    ADD CONSTRAINT fk_mermas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_mermas_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id),
    ADD CONSTRAINT fk_mermas_usuario FOREIGN KEY (reportado_por) REFERENCES core.usuarios(id);

-- === menu ===
ALTER TABLE menu.categorias
    ADD CONSTRAINT fk_categorias_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE menu.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_recetas_categoria FOREIGN KEY (categoria_id) REFERENCES menu.categorias(id);

ALTER TABLE menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_receta_ing_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_receta_ing_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);

-- === operaciones ===
ALTER TABLE operaciones.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE operaciones.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE operaciones.reservas
    ADD CONSTRAINT fk_reservas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reservas_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);

ALTER TABLE operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id),
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES operaciones.meseros(id);

ALTER TABLE operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_pedido_det_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_pedido_det_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id);

ALTER TABLE operaciones.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id),
    ADD CONSTRAINT fk_facturas_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id),
    ADD CONSTRAINT fk_facturas_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);

-- === finanzas ===
ALTER TABLE finanzas.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES inventario.categoria_egresos(id);

ALTER TABLE finanzas.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES core.usuarios(id),
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES core.usuarios(id);

ALTER TABLE finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_caja_mov_caja FOREIGN KEY (caja_id) REFERENCES finanzas.caja(id),
    ADD CONSTRAINT fk_caja_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id),
    ADD CONSTRAINT fk_caja_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);

ALTER TABLE finanzas.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

ALTER TABLE finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_banco_mov_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id),
    ADD CONSTRAINT fk_banco_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id),
    ADD CONSTRAINT fk_banco_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);

-- === contabilidad ===
ALTER TABLE contabilidad.libro_diario
    ADD CONSTRAINT fk_libro_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;

-- ======================================================
-- TRIGGERS: auto-update de updated_at
-- ======================================================

CREATE TRIGGER trg_restaurante_updated BEFORE UPDATE ON core.restaurante FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_usuarios_updated BEFORE UPDATE ON core.usuarios FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_proveedores_updated BEFORE UPDATE ON inventario.proveedores FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_ingredientes_updated BEFORE UPDATE ON inventario.ingredientes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_categorias_updated BEFORE UPDATE ON menu.categorias FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_recetas_updated BEFORE UPDATE ON menu.recetas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_mesas_updated BEFORE UPDATE ON operaciones.mesas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_meseros_updated BEFORE UPDATE ON operaciones.meseros FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_pedidos_updated BEFORE UPDATE ON operaciones.pedidos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_banco_updated BEFORE UPDATE ON finanzas.banco FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ======================================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- ======================================================

COMMENT ON TABLE core.restaurante IS 'Tabla base para multi-tenencia SaaS';
COMMENT ON TABLE inventario.ingredientes IS 'Inventario de materias primas con costo promedio ponderado';
COMMENT ON TABLE menu.recetas IS 'Recetas estándar (BOM - Bill of Materials) del menú';
COMMENT ON TABLE finanzas.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';
COMMENT ON TABLE finanzas.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';

-- ======================================================
-- FIN DEL SCRIPT
-- ======================================================