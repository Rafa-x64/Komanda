--
-- PostgreSQL database dump
--

\restrict gtPSSm4ScMjCyeFd4aE2aahPi2ZZR1cCYF5tnYJh9ghIQlJ2qhj8Nt37lYKMQ4E

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-03-24 21:06:28 -04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 12 (class 2615 OID 18902)
-- Name: contabilidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabilidad;


ALTER SCHEMA contabilidad OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 18897)
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 18901)
-- Name: finanzas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA finanzas;


ALTER SCHEMA finanzas OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 18898)
-- Name: inventario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventario;


ALTER SCHEMA inventario OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 19778)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 18899)
-- Name: menu; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA menu;


ALTER SCHEMA menu OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 18900)
-- Name: operaciones; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA operaciones;


ALTER SCHEMA operaciones OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 19779)
-- Name: sales; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 19767)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1062 (class 1247 OID 18944)
-- Name: estado_caja; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_caja AS ENUM (
    'abierta',
    'cerrada'
);


ALTER TYPE public.estado_caja OWNER TO postgres;

--
-- TOC entry 1056 (class 1247 OID 18928)
-- Name: estado_cuenta; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_cuenta AS ENUM (
    'abierta',
    'cuenta_pedida',
    'pagada',
    'cerrada'
);


ALTER TYPE public.estado_cuenta OWNER TO postgres;

--
-- TOC entry 1059 (class 1247 OID 18938)
-- Name: estado_factura; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_factura AS ENUM (
    'emitida',
    'anulada'
);


ALTER TYPE public.estado_factura OWNER TO postgres;

--
-- TOC entry 1050 (class 1247 OID 18904)
-- Name: estado_mesa; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_mesa AS ENUM (
    'libre',
    'ocupada',
    'reservada',
    'inactiva'
);


ALTER TYPE public.estado_mesa OWNER TO postgres;

--
-- TOC entry 1080 (class 1247 OID 19004)
-- Name: estado_pago_compra; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pago_compra AS ENUM (
    'pendiente',
    'pagada',
    'parcial'
);


ALTER TYPE public.estado_pago_compra OWNER TO postgres;

--
-- TOC entry 1053 (class 1247 OID 18914)
-- Name: estado_pedido; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pedido AS ENUM (
    'pendiente',
    'enviado',
    'preparando',
    'listo',
    'entregado',
    'anulado'
);


ALTER TYPE public.estado_pedido OWNER TO postgres;

--
-- TOC entry 1077 (class 1247 OID 18992)
-- Name: estado_reserva; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_reserva AS ENUM (
    'pendiente',
    'confirmada',
    'cancelada',
    'completada',
    'no_show'
);


ALTER TYPE public.estado_reserva OWNER TO postgres;

--
-- TOC entry 1179 (class 1247 OID 19882)
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'preparing',
    'ready',
    'delivered',
    'cancelled'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- TOC entry 1185 (class 1247 OID 19973)
-- Name: orders_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.orders_status_enum AS ENUM (
    'pending',
    'preparing',
    'ready',
    'delivered',
    'cancelled'
);


ALTER TYPE public.orders_status_enum OWNER TO postgres;

--
-- TOC entry 1071 (class 1247 OID 18970)
-- Name: referencia_tipo_banco; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.referencia_tipo_banco AS ENUM (
    'venta',
    'egreso',
    'compra',
    'deposito_caja',
    'ajuste'
);


ALTER TYPE public.referencia_tipo_banco OWNER TO postgres;

--
-- TOC entry 1068 (class 1247 OID 18956)
-- Name: referencia_tipo_caja; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.referencia_tipo_caja AS ENUM (
    'venta',
    'egreso',
    'compra',
    'apertura',
    'cierre',
    'ajuste'
);


ALTER TYPE public.referencia_tipo_caja OWNER TO postgres;

--
-- TOC entry 1074 (class 1247 OID 18982)
-- Name: tipo_merma; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_merma AS ENUM (
    'desperdicio',
    'vencimiento',
    'rotura',
    'otro'
);


ALTER TYPE public.tipo_merma OWNER TO postgres;

--
-- TOC entry 1065 (class 1247 OID 18950)
-- Name: tipo_movimiento; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_movimiento AS ENUM (
    'ingreso',
    'egreso'
);


ALTER TYPE public.tipo_movimiento OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 17018)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 327 (class 1259 OID 19470)
-- Name: libro_diario; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.libro_diario (
    id integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    tipo character varying(50) NOT NULL,
    debe numeric(12,2) DEFAULT 0 NOT NULL,
    haber numeric(12,2) DEFAULT 0 NOT NULL,
    referencia_tipo character varying(50),
    referencia_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE contabilidad.libro_diario OWNER TO postgres;

--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE libro_diario; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.libro_diario IS 'Asientos contables para generar Balance General y Estado de Resultados';


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN libro_diario.tipo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.libro_diario.tipo IS 'Ej: venta, costo_venta, gasto_operativo, compra_insumo, merma';


--
-- TOC entry 326 (class 1259 OID 19469)
-- Name: libro_diario_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.libro_diario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.libro_diario_id_seq OWNER TO postgres;

--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 326
-- Name: libro_diario_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.libro_diario_id_seq OWNED BY contabilidad.libro_diario.id;


--
-- TOC entry 279 (class 1259 OID 19041)
-- Name: metodos_pago; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.metodos_pago (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE core.metodos_pago OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 19040)
-- Name: metodos_pago_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.metodos_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.metodos_pago_id_seq OWNER TO postgres;

--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 278
-- Name: metodos_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.metodos_pago_id_seq OWNED BY core.metodos_pago.id;


--
-- TOC entry 275 (class 1259 OID 19012)
-- Name: restaurante; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.restaurante (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion text,
    telefono character varying(20),
    email character varying(100),
    logo_url text,
    moneda character varying(3) DEFAULT 'USD'::character varying NOT NULL,
    zona_horaria character varying(50) DEFAULT 'America/Caracas'::character varying NOT NULL,
    impuesto_porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    propina_porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    patrimonio_inicial numeric(12,2) DEFAULT 0 NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.restaurante OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 19011)
-- Name: restaurante_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.restaurante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.restaurante_id_seq OWNER TO postgres;

--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 274
-- Name: restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.restaurante_id_seq OWNED BY core.restaurante.id;


--
-- TOC entry 281 (class 1259 OID 19053)
-- Name: roles; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.roles OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 19052)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.roles_id_seq OWNER TO postgres;

--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 280
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.roles_id_seq OWNED BY core.roles.id;


--
-- TOC entry 333 (class 1259 OID 19806)
-- Name: tables; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.tables (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    capacidad integer DEFAULT 2,
    status character varying(20) DEFAULT 'available'::character varying
);


ALTER TABLE core.tables OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 19805)
-- Name: tables_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.tables_id_seq OWNER TO postgres;

--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 332
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.tables_id_seq OWNED BY core.tables.id;


--
-- TOC entry 277 (class 1259 OID 19031)
-- Name: unidad_medida; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.unidad_medida (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    abreviatura character varying(5) NOT NULL
);


ALTER TABLE core.unidad_medida OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 19030)
-- Name: unidad_medida_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.unidad_medida_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.unidad_medida_id_seq OWNER TO postgres;

--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 276
-- Name: unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.unidad_medida_id_seq OWNED BY core.unidad_medida.id;


--
-- TOC entry 283 (class 1259 OID 19064)
-- Name: usuarios; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.usuarios (
    id integer NOT NULL,
    restaurante_id integer NOT NULL,
    rol_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.usuarios OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 19063)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 282
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.usuarios_id_seq OWNED BY core.usuarios.id;


--
-- TOC entry 323 (class 1259 OID 19433)
-- Name: banco; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.banco (
    id integer NOT NULL,
    nombre_banco character varying(100) NOT NULL,
    numero_cuenta character varying(50) NOT NULL,
    saldo_actual numeric(12,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finanzas.banco OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 19432)
-- Name: banco_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.banco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.banco_id_seq OWNER TO postgres;

--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 322
-- Name: banco_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.banco_id_seq OWNED BY finanzas.banco.id;


--
-- TOC entry 325 (class 1259 OID 19449)
-- Name: banco_movimientos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.banco_movimientos (
    id integer NOT NULL,
    banco_id integer NOT NULL,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tipo public.tipo_movimiento NOT NULL,
    monto numeric(12,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_tipo public.referencia_tipo_banco NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE finanzas.banco_movimientos OWNER TO postgres;

--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE banco_movimientos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';


--
-- TOC entry 324 (class 1259 OID 19448)
-- Name: banco_movimientos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.banco_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.banco_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 324
-- Name: banco_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.banco_movimientos_id_seq OWNED BY finanzas.banco_movimientos.id;


--
-- TOC entry 319 (class 1259 OID 19394)
-- Name: caja; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.caja (
    id integer NOT NULL,
    fecha_apertura timestamp without time zone NOT NULL,
    fecha_cierre timestamp without time zone,
    monto_inicial numeric(12,2) NOT NULL,
    monto_final numeric(12,2),
    monto_teorico numeric(12,2),
    diferencia numeric(12,2),
    estado public.estado_caja DEFAULT 'abierta'::public.estado_caja,
    usuario_apertura_id integer NOT NULL,
    usuario_cierre_id integer,
    observaciones text,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finanzas.caja OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 19393)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.caja_id_seq OWNER TO postgres;

--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 318
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.caja_id_seq OWNED BY finanzas.caja.id;


--
-- TOC entry 321 (class 1259 OID 19412)
-- Name: caja_movimientos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.caja_movimientos (
    id integer NOT NULL,
    caja_id integer NOT NULL,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tipo public.tipo_movimiento NOT NULL,
    monto numeric(12,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_tipo public.referencia_tipo_caja NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE finanzas.caja_movimientos OWNER TO postgres;

--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE caja_movimientos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';


--
-- TOC entry 320 (class 1259 OID 19411)
-- Name: caja_movimientos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.caja_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.caja_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 320
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.caja_movimientos_id_seq OWNED BY finanzas.caja_movimientos.id;


--
-- TOC entry 317 (class 1259 OID 19376)
-- Name: egresos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.egresos (
    id integer NOT NULL,
    fecha date NOT NULL,
    monto numeric(12,2) NOT NULL,
    categoria_id integer NOT NULL,
    razon character varying(255) NOT NULL,
    descripcion text,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finanzas.egresos OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 19375)
-- Name: egresos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 316
-- Name: egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.egresos_id_seq OWNED BY finanzas.egresos.id;


--
-- TOC entry 285 (class 1259 OID 19088)
-- Name: categoria_egresos; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.categoria_egresos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.categoria_egresos OWNER TO postgres;

--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 285
-- Name: COLUMN categoria_egresos.nombre; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.categoria_egresos.nombre IS 'Ej: proveedores, servicios, nomina, otros';


--
-- TOC entry 284 (class 1259 OID 19087)
-- Name: categoria_egresos_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.categoria_egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.categoria_egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 284
-- Name: categoria_egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.categoria_egresos_id_seq OWNED BY inventario.categoria_egresos.id;


--
-- TOC entry 295 (class 1259 OID 19164)
-- Name: compra_detalle; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.compra_detalle (
    id integer NOT NULL,
    compra_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad_compra numeric(10,3) NOT NULL,
    unidad_compra_id integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    factor_conversion numeric(10,3) NOT NULL,
    cantidad_inventario numeric(10,3) GENERATED ALWAYS AS ((cantidad_compra * factor_conversion)) STORED,
    restaurante_id integer NOT NULL
);


ALTER TABLE inventario.compra_detalle OWNER TO postgres;

--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN compra_detalle.factor_conversion; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.compra_detalle.factor_conversion IS 'Multiplicador para convertir Unidad Compra -> Unidad Inventario (ej. 1 Saco = 50000 gr)';


--
-- TOC entry 294 (class 1259 OID 19163)
-- Name: compra_detalle_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.compra_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.compra_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 294
-- Name: compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.compra_detalle_id_seq OWNED BY inventario.compra_detalle.id;


--
-- TOC entry 293 (class 1259 OID 19148)
-- Name: compras; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.compras (
    id integer NOT NULL,
    fecha date NOT NULL,
    numero_factura_proveedor character varying(50),
    total numeric(12,2) NOT NULL,
    estado_pago public.estado_pago_compra DEFAULT 'pagada'::public.estado_pago_compra,
    saldo_pendiente numeric(12,2) DEFAULT 0,
    descripcion character varying(255),
    proveedor_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.compras OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 19147)
-- Name: compras_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.compras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.compras_id_seq OWNER TO postgres;

--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 292
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.compras_id_seq OWNED BY inventario.compras.id;


--
-- TOC entry 291 (class 1259 OID 19128)
-- Name: ingredientes; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.ingredientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    cantidad_disponible numeric(10,3) DEFAULT 0,
    cantidad_minima numeric(10,3) DEFAULT 0,
    unidad_id integer NOT NULL,
    costo_promedio numeric(10,2) DEFAULT 0,
    merma_teorica_porcentaje numeric(5,2) DEFAULT 0,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.ingredientes OWNER TO postgres;

--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 291
-- Name: TABLE ingredientes; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON TABLE inventario.ingredientes IS 'Inventario de materias primas con costo promedio ponderado';


--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 291
-- Name: COLUMN ingredientes.merma_teorica_porcentaje; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.ingredientes.merma_teorica_porcentaje IS '% de pérdida natural (ej. cáscaras, huesos) para cálculo preciso de costos del ingrediente limpio';


--
-- TOC entry 290 (class 1259 OID 19127)
-- Name: ingredientes_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 290
-- Name: ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.ingredientes_id_seq OWNED BY inventario.ingredientes.id;


--
-- TOC entry 297 (class 1259 OID 19182)
-- Name: mermas; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.mermas (
    id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    tipo public.tipo_merma DEFAULT 'desperdicio'::public.tipo_merma NOT NULL,
    razon text NOT NULL,
    reportado_por integer NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.mermas OWNER TO postgres;

--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE mermas; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON TABLE inventario.mermas IS 'Registro de pérdidas de inventario para conciliar stock teórico vs real';


--
-- TOC entry 296 (class 1259 OID 19181)
-- Name: mermas_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.mermas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.mermas_id_seq OWNER TO postgres;

--
-- TOC entry 4444 (class 0 OID 0)
-- Dependencies: 296
-- Name: mermas_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.mermas_id_seq OWNED BY inventario.mermas.id;


--
-- TOC entry 287 (class 1259 OID 19099)
-- Name: proveedores; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.proveedores (
    id integer NOT NULL,
    identificacion character varying(30) NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(20),
    email character varying(100),
    direccion text,
    restaurante_id integer NOT NULL,
    banco_nombre character varying(50),
    banco_cuenta_numero character varying(30),
    activo boolean DEFAULT true,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.proveedores OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 19098)
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 4445 (class 0 OID 0)
-- Dependencies: 286
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.proveedores_id_seq OWNED BY inventario.proveedores.id;


--
-- TOC entry 289 (class 1259 OID 19117)
-- Name: unidad_compra; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.unidad_compra (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.unidad_compra OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 19116)
-- Name: unidad_compra_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.unidad_compra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.unidad_compra_id_seq OWNER TO postgres;

--
-- TOC entry 4446 (class 0 OID 0)
-- Dependencies: 288
-- Name: unidad_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.unidad_compra_id_seq OWNED BY inventario.unidad_compra.id;


--
-- TOC entry 329 (class 1259 OID 19781)
-- Name: categories; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.categories (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE inventory.categories OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 19780)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE inventory.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventory.categories_id_seq OWNER TO postgres;

--
-- TOC entry 4447 (class 0 OID 0)
-- Dependencies: 328
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.categories_id_seq OWNED BY inventory.categories.id;


--
-- TOC entry 331 (class 1259 OID 19790)
-- Name: products; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.products (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    precio_venta numeric(10,2) NOT NULL,
    categoria_id integer,
    imagen_url character varying(255),
    activo boolean DEFAULT true
);


ALTER TABLE inventory.products OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 19789)
-- Name: products_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE inventory.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventory.products_id_seq OWNER TO postgres;

--
-- TOC entry 4448 (class 0 OID 0)
-- Dependencies: 330
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.products_id_seq OWNED BY inventory.products.id;


--
-- TOC entry 299 (class 1259 OID 19202)
-- Name: categorias; Type: TABLE; Schema: menu; Owner: postgres
--

CREATE TABLE menu.categorias (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    orden integer DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE menu.categorias OWNER TO postgres;

--
-- TOC entry 4449 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE categorias; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON TABLE menu.categorias IS 'Categorías del menú: Entradas, Platos Fuertes, Bebidas, Postres, etc.';


--
-- TOC entry 298 (class 1259 OID 19201)
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: menu; Owner: postgres
--

CREATE SEQUENCE menu.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE menu.categorias_id_seq OWNER TO postgres;

--
-- TOC entry 4450 (class 0 OID 0)
-- Dependencies: 298
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.categorias_id_seq OWNED BY menu.categorias.id;


--
-- TOC entry 303 (class 1259 OID 19239)
-- Name: receta_ingredientes; Type: TABLE; Schema: menu; Owner: postgres
--

CREATE TABLE menu.receta_ingredientes (
    id integer NOT NULL,
    receta_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE menu.receta_ingredientes OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 19238)
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE; Schema: menu; Owner: postgres
--

CREATE SEQUENCE menu.receta_ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE menu.receta_ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4451 (class 0 OID 0)
-- Dependencies: 302
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.receta_ingredientes_id_seq OWNED BY menu.receta_ingredientes.id;


--
-- TOC entry 301 (class 1259 OID 19217)
-- Name: recetas; Type: TABLE; Schema: menu; Owner: postgres
--

CREATE TABLE menu.recetas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    categoria_id integer,
    imagen_url text,
    costo_produccion numeric(10,2) DEFAULT 0,
    precio_sugerido numeric(10,2) DEFAULT 0,
    precio_venta numeric(10,2) DEFAULT 0,
    margen_utilidad numeric(5,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE menu.recetas OWNER TO postgres;

--
-- TOC entry 4452 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE recetas; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON TABLE menu.recetas IS 'Recetas estándar (BOM - Bill of Materials) del menú';


--
-- TOC entry 300 (class 1259 OID 19216)
-- Name: recetas_id_seq; Type: SEQUENCE; Schema: menu; Owner: postgres
--

CREATE SEQUENCE menu.recetas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE menu.recetas_id_seq OWNER TO postgres;

--
-- TOC entry 4453 (class 0 OID 0)
-- Dependencies: 300
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.recetas_id_seq OWNED BY menu.recetas.id;


--
-- TOC entry 315 (class 1259 OID 19349)
-- Name: facturas; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.facturas (
    id integer NOT NULL,
    numero_factura character varying(50) NOT NULL,
    pedido_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer,
    cliente_nombre character varying(100),
    cliente_identificacion character varying(30),
    cliente_direccion text,
    cliente_email character varying(100),
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    descuento numeric(12,2) DEFAULT 0,
    impuestos numeric(10,2) DEFAULT 0,
    propina numeric(10,2) DEFAULT 0,
    total numeric(12,2) NOT NULL,
    estado public.estado_factura DEFAULT 'emitida'::public.estado_factura,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.facturas OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 19348)
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.facturas_id_seq OWNER TO postgres;

--
-- TOC entry 4454 (class 0 OID 0)
-- Dependencies: 314
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.facturas_id_seq OWNED BY operaciones.facturas.id;


--
-- TOC entry 305 (class 1259 OID 19255)
-- Name: mesas; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.mesas (
    id integer NOT NULL,
    numero integer NOT NULL,
    nombre character varying(50),
    capacidad integer NOT NULL,
    estado public.estado_mesa DEFAULT 'libre'::public.estado_mesa,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.mesas OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 19254)
-- Name: mesas_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.mesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.mesas_id_seq OWNER TO postgres;

--
-- TOC entry 4455 (class 0 OID 0)
-- Dependencies: 304
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.mesas_id_seq OWNED BY operaciones.mesas.id;


--
-- TOC entry 307 (class 1259 OID 19271)
-- Name: meseros; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.meseros (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.meseros OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 19270)
-- Name: meseros_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.meseros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.meseros_id_seq OWNER TO postgres;

--
-- TOC entry 4456 (class 0 OID 0)
-- Dependencies: 306
-- Name: meseros_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.meseros_id_seq OWNED BY operaciones.meseros.id;


--
-- TOC entry 313 (class 1259 OID 19331)
-- Name: pedido_detalle; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.pedido_detalle (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    receta_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    notas text,
    restaurante_id integer NOT NULL
);


ALTER TABLE operaciones.pedido_detalle OWNER TO postgres;

--
-- TOC entry 4457 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN pedido_detalle.notas; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.pedido_detalle.notas IS 'Instrucciones para cocina: "Sin piña", "Extra queso", etc.';


--
-- TOC entry 312 (class 1259 OID 19330)
-- Name: pedido_detalle_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.pedido_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.pedido_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4458 (class 0 OID 0)
-- Dependencies: 312
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.pedido_detalle_id_seq OWNED BY operaciones.pedido_detalle.id;


--
-- TOC entry 311 (class 1259 OID 19304)
-- Name: pedidos; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.pedidos (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    mesa_id integer,
    mesero_id integer,
    cliente character varying(100),
    estado public.estado_pedido DEFAULT 'pendiente'::public.estado_pedido,
    estado_cuenta public.estado_cuenta DEFAULT 'abierta'::public.estado_cuenta,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(12,2) DEFAULT 0,
    descuento numeric(12,2) DEFAULT 0,
    impuestos numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.pedidos OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 19303)
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.pedidos_id_seq OWNER TO postgres;

--
-- TOC entry 4459 (class 0 OID 0)
-- Dependencies: 310
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.pedidos_id_seq OWNED BY operaciones.pedidos.id;


--
-- TOC entry 309 (class 1259 OID 19285)
-- Name: reservas; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.reservas (
    id integer NOT NULL,
    mesa_id integer,
    cliente_nombre character varying(100) NOT NULL,
    cliente_telefono character varying(20),
    fecha_reserva timestamp without time zone NOT NULL,
    cantidad_personas integer NOT NULL,
    estado public.estado_reserva DEFAULT 'pendiente'::public.estado_reserva,
    notas text,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.reservas OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 19284)
-- Name: reservas_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.reservas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.reservas_id_seq OWNER TO postgres;

--
-- TOC entry 4460 (class 0 OID 0)
-- Dependencies: 308
-- Name: reservas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.reservas_id_seq OWNED BY operaciones.reservas.id;


--
-- TOC entry 271 (class 1259 OID 16770)
-- Name: banco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banco (
    id integer NOT NULL,
    nombre_banco character varying(100) NOT NULL,
    numero_cuenta character varying(50) NOT NULL,
    saldo_actual numeric(10,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.banco OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 16769)
-- Name: banco_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banco_id_seq OWNER TO postgres;

--
-- TOC entry 4461 (class 0 OID 0)
-- Dependencies: 270
-- Name: banco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banco_id_seq OWNED BY public.banco.id;


--
-- TOC entry 273 (class 1259 OID 16784)
-- Name: banco_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banco_movimientos (
    id integer NOT NULL,
    banco_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    monto numeric(10,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.banco_movimientos OWNER TO postgres;

--
-- TOC entry 4462 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE banco_movimientos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';


--
-- TOC entry 272 (class 1259 OID 16783)
-- Name: banco_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banco_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banco_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4463 (class 0 OID 0)
-- Dependencies: 272
-- Name: banco_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banco_movimientos_id_seq OWNED BY public.banco_movimientos.id;


--
-- TOC entry 267 (class 1259 OID 16733)
-- Name: caja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja (
    id integer NOT NULL,
    fecha_apertura timestamp without time zone NOT NULL,
    fecha_cierre timestamp without time zone,
    monto_inicial numeric(10,2) NOT NULL,
    monto_final numeric(10,2),
    usuario_apertura_id integer NOT NULL,
    usuario_cierre_id integer,
    observaciones text,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.caja OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 16732)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_id_seq OWNER TO postgres;

--
-- TOC entry 4464 (class 0 OID 0)
-- Dependencies: 266
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 269 (class 1259 OID 16750)
-- Name: caja_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja_movimientos (
    id integer NOT NULL,
    caja_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    monto numeric(10,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.caja_movimientos OWNER TO postgres;

--
-- TOC entry 4465 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE caja_movimientos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';


--
-- TOC entry 268 (class 1259 OID 16749)
-- Name: caja_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4466 (class 0 OID 0)
-- Dependencies: 268
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_movimientos_id_seq OWNED BY public.caja_movimientos.id;


--
-- TOC entry 239 (class 1259 OID 16516)
-- Name: categoria_egresos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_egresos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.categoria_egresos OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16515)
-- Name: categoria_egresos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4467 (class 0 OID 0)
-- Dependencies: 238
-- Name: categoria_egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_egresos_id_seq OWNED BY public.categoria_egresos.id;


--
-- TOC entry 249 (class 1259 OID 16585)
-- Name: compra_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra_detalle (
    id integer NOT NULL,
    compra_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    unidad_compra_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.compra_detalle OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16584)
-- Name: compra_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compra_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compra_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4468 (class 0 OID 0)
-- Dependencies: 248
-- Name: compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compra_detalle_id_seq OWNED BY public.compra_detalle.id;


--
-- TOC entry 247 (class 1259 OID 16572)
-- Name: compras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compras (
    id integer NOT NULL,
    fecha date NOT NULL,
    total numeric(10,2) NOT NULL,
    descripcion character varying(255),
    proveedor_id integer,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.compras OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16571)
-- Name: compras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compras_id_seq OWNER TO postgres;

--
-- TOC entry 4469 (class 0 OID 0)
-- Dependencies: 246
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;


--
-- TOC entry 265 (class 1259 OID 16716)
-- Name: egresos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.egresos (
    id integer NOT NULL,
    fecha date NOT NULL,
    monto numeric(10,2) NOT NULL,
    categoria_id integer NOT NULL,
    razon character varying(255) NOT NULL,
    descripcion text,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.egresos OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 16715)
-- Name: egresos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4470 (class 0 OID 0)
-- Dependencies: 264
-- Name: egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.egresos_id_seq OWNED BY public.egresos.id;


--
-- TOC entry 263 (class 1259 OID 16696)
-- Name: facturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facturas (
    id integer NOT NULL,
    numero_factura character varying(50) NOT NULL,
    pedido_id integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    impuestos numeric(10,2) DEFAULT 0,
    total numeric(10,2) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.facturas OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 16695)
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facturas_id_seq OWNER TO postgres;

--
-- TOC entry 4471 (class 0 OID 0)
-- Dependencies: 262
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- TOC entry 245 (class 1259 OID 16556)
-- Name: ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    cantidad_disponible numeric(10,3) DEFAULT 0,
    cantidad_minima numeric(10,3) DEFAULT 0,
    unidad_id integer NOT NULL,
    costo_promedio numeric(10,2) DEFAULT 0,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.ingredientes OWNER TO postgres;

--
-- TOC entry 4472 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE ingredientes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ingredientes IS 'Inventario de materias primas con costo promedio';


--
-- TOC entry 244 (class 1259 OID 16555)
-- Name: ingredientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4473 (class 0 OID 0)
-- Dependencies: 244
-- Name: ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredientes_id_seq OWNED BY public.ingredientes.id;


--
-- TOC entry 255 (class 1259 OID 16636)
-- Name: mesas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mesas (
    id integer NOT NULL,
    numero integer NOT NULL,
    nombre character varying(50),
    capacidad integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.mesas OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 16635)
-- Name: mesas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mesas_id_seq OWNER TO postgres;

--
-- TOC entry 4474 (class 0 OID 0)
-- Dependencies: 254
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mesas_id_seq OWNED BY public.mesas.id;


--
-- TOC entry 257 (class 1259 OID 16650)
-- Name: meseros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meseros (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.meseros OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 16649)
-- Name: meseros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meseros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meseros_id_seq OWNER TO postgres;

--
-- TOC entry 4475 (class 0 OID 0)
-- Dependencies: 256
-- Name: meseros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meseros_id_seq OWNED BY public.meseros.id;


--
-- TOC entry 233 (class 1259 OID 16478)
-- Name: metodos_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metodos_pago (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.metodos_pago OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16477)
-- Name: metodos_pago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metodos_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metodos_pago_id_seq OWNER TO postgres;

--
-- TOC entry 4476 (class 0 OID 0)
-- Dependencies: 232
-- Name: metodos_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metodos_pago_id_seq OWNED BY public.metodos_pago.id;


--
-- TOC entry 336 (class 1259 OID 19958)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 19983)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    restaurant_id uuid,
    user_id uuid,
    table_id uuid,
    status public.orders_status_enum DEFAULT 'pending'::public.orders_status_enum NOT NULL,
    subtotal numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    tax_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    total_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 16680)
-- Name: pedido_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_detalle (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    receta_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.pedido_detalle OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 16679)
-- Name: pedido_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4477 (class 0 OID 0)
-- Dependencies: 260
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_detalle_id_seq OWNED BY public.pedido_detalle.id;


--
-- TOC entry 259 (class 1259 OID 16662)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    mesa_id integer,
    mesero_id integer,
    cliente character varying(100),
    fecha_hora timestamp without time zone NOT NULL,
    total numeric(10,2) DEFAULT 0,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 16661)
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_id_seq OWNER TO postgres;

--
-- TOC entry 4478 (class 0 OID 0)
-- Dependencies: 258
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- TOC entry 241 (class 1259 OID 16526)
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedores (
    id integer NOT NULL,
    identificacion character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(20),
    email character varying(100),
    direccion text,
    restaurante_id integer NOT NULL,
    banco_nombre character varying(50),
    banco_cuenta_numero character varying(30),
    activo boolean DEFAULT true,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.proveedores OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16525)
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 4479 (class 0 OID 0)
-- Dependencies: 240
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;


--
-- TOC entry 253 (class 1259 OID 16620)
-- Name: receta_ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receta_ingredientes (
    id integer NOT NULL,
    receta_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.receta_ingredientes OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 16619)
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receta_ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.receta_ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4480 (class 0 OID 0)
-- Dependencies: 252
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receta_ingredientes_id_seq OWNED BY public.receta_ingredientes.id;


--
-- TOC entry 251 (class 1259 OID 16601)
-- Name: recetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recetas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    costo_produccion numeric(10,2) DEFAULT 0,
    precio_sugerido numeric(10,2) DEFAULT 0,
    precio_venta numeric(10,2) DEFAULT 0,
    margen_utilidad numeric(5,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.recetas OWNER TO postgres;

--
-- TOC entry 4481 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE recetas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.recetas IS 'Recetas estándar (BOM - Bill of Materials)';


--
-- TOC entry 250 (class 1259 OID 16600)
-- Name: recetas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recetas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recetas_id_seq OWNER TO postgres;

--
-- TOC entry 4482 (class 0 OID 0)
-- Dependencies: 250
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recetas_id_seq OWNED BY public.recetas.id;


--
-- TOC entry 229 (class 1259 OID 16456)
-- Name: restaurante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurante (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    patrimonio_inicial numeric(10,2) DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.restaurante OWNER TO postgres;

--
-- TOC entry 4483 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE restaurante; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.restaurante IS 'Tabla base para multi-tenencia';


--
-- TOC entry 228 (class 1259 OID 16455)
-- Name: restaurante_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restaurante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurante_id_seq OWNER TO postgres;

--
-- TOC entry 4484 (class 0 OID 0)
-- Dependencies: 228
-- Name: restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restaurante_id_seq OWNED BY public.restaurante.id;


--
-- TOC entry 235 (class 1259 OID 16488)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16487)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 4485 (class 0 OID 0)
-- Dependencies: 234
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 243 (class 1259 OID 16546)
-- Name: unidad_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_compra (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.unidad_compra OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16545)
-- Name: unidad_compra_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_compra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidad_compra_id_seq OWNER TO postgres;

--
-- TOC entry 4486 (class 0 OID 0)
-- Dependencies: 242
-- Name: unidad_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_compra_id_seq OWNED BY public.unidad_compra.id;


--
-- TOC entry 231 (class 1259 OID 16468)
-- Name: unidad_medida; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_medida (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    abreviatura character varying(5) NOT NULL
);


ALTER TABLE public.unidad_medida OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16467)
-- Name: unidad_medida_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_medida_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidad_medida_id_seq OWNER TO postgres;

--
-- TOC entry 4487 (class 0 OID 0)
-- Dependencies: 230
-- Name: unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_medida_id_seq OWNED BY public.unidad_medida.id;


--
-- TOC entry 237 (class 1259 OID 16498)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    restaurante_id integer NOT NULL,
    rol_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    activo boolean DEFAULT true
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16497)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 4488 (class 0 OID 0)
-- Dependencies: 236
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 335 (class 1259 OID 19860)
-- Name: order_items; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.order_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid,
    product_id integer,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE sales.order_items OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 19834)
-- Name: orders; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.orders (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    restaurant_id integer,
    user_id integer,
    table_id integer,
    status character varying(50) DEFAULT 'pending'::character varying,
    subtotal numeric(10,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    total_amount numeric(10,2) DEFAULT 0 NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE sales.orders OWNER TO postgres;

--
-- TOC entry 3807 (class 2604 OID 20124)
-- Name: libro_diario id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario ALTER COLUMN id SET DEFAULT nextval('contabilidad.libro_diario_id_seq'::regclass);


--
-- TOC entry 3716 (class 2604 OID 20125)
-- Name: metodos_pago id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago ALTER COLUMN id SET DEFAULT nextval('core.metodos_pago_id_seq'::regclass);


--
-- TOC entry 3706 (class 2604 OID 20126)
-- Name: restaurante id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.restaurante ALTER COLUMN id SET DEFAULT nextval('core.restaurante_id_seq'::regclass);


--
-- TOC entry 3719 (class 2604 OID 20127)
-- Name: roles id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.roles ALTER COLUMN id SET DEFAULT nextval('core.roles_id_seq'::regclass);


--
-- TOC entry 3814 (class 2604 OID 20128)
-- Name: tables id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.tables ALTER COLUMN id SET DEFAULT nextval('core.tables_id_seq'::regclass);


--
-- TOC entry 3715 (class 2604 OID 20129)
-- Name: unidad_medida id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.unidad_medida ALTER COLUMN id SET DEFAULT nextval('core.unidad_medida_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 20130)
-- Name: usuarios id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios ALTER COLUMN id SET DEFAULT nextval('core.usuarios_id_seq'::regclass);


--
-- TOC entry 3800 (class 2604 OID 20131)
-- Name: banco id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco ALTER COLUMN id SET DEFAULT nextval('finanzas.banco_id_seq'::regclass);


--
-- TOC entry 3805 (class 2604 OID 20132)
-- Name: banco_movimientos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos ALTER COLUMN id SET DEFAULT nextval('finanzas.banco_movimientos_id_seq'::regclass);


--
-- TOC entry 3795 (class 2604 OID 20133)
-- Name: caja id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja ALTER COLUMN id SET DEFAULT nextval('finanzas.caja_id_seq'::regclass);


--
-- TOC entry 3798 (class 2604 OID 20134)
-- Name: caja_movimientos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('finanzas.caja_movimientos_id_seq'::regclass);


--
-- TOC entry 3793 (class 2604 OID 20135)
-- Name: egresos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos ALTER COLUMN id SET DEFAULT nextval('finanzas.egresos_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 20136)
-- Name: categoria_egresos id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos ALTER COLUMN id SET DEFAULT nextval('inventario.categoria_egresos_id_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 20137)
-- Name: compra_detalle id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle ALTER COLUMN id SET DEFAULT nextval('inventario.compra_detalle_id_seq'::regclass);


--
-- TOC entry 3740 (class 2604 OID 20138)
-- Name: compras id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras ALTER COLUMN id SET DEFAULT nextval('inventario.compras_id_seq'::regclass);


--
-- TOC entry 3733 (class 2604 OID 20139)
-- Name: ingredientes id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes ALTER COLUMN id SET DEFAULT nextval('inventario.ingredientes_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 20140)
-- Name: mermas id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas ALTER COLUMN id SET DEFAULT nextval('inventario.mermas_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 20141)
-- Name: proveedores id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores ALTER COLUMN id SET DEFAULT nextval('inventario.proveedores_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 20142)
-- Name: unidad_compra id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra ALTER COLUMN id SET DEFAULT nextval('inventario.unidad_compra_id_seq'::regclass);


--
-- TOC entry 3811 (class 2604 OID 20143)
-- Name: categories id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.categories ALTER COLUMN id SET DEFAULT nextval('inventory.categories_id_seq'::regclass);


--
-- TOC entry 3812 (class 2604 OID 20144)
-- Name: products id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products ALTER COLUMN id SET DEFAULT nextval('inventory.products_id_seq'::regclass);


--
-- TOC entry 3749 (class 2604 OID 20145)
-- Name: categorias id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias ALTER COLUMN id SET DEFAULT nextval('menu.categorias_id_seq'::regclass);


--
-- TOC entry 3762 (class 2604 OID 20146)
-- Name: receta_ingredientes id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes ALTER COLUMN id SET DEFAULT nextval('menu.receta_ingredientes_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 20147)
-- Name: recetas id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas ALTER COLUMN id SET DEFAULT nextval('menu.recetas_id_seq'::regclass);


--
-- TOC entry 3786 (class 2604 OID 20148)
-- Name: facturas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas ALTER COLUMN id SET DEFAULT nextval('operaciones.facturas_id_seq'::regclass);


--
-- TOC entry 3763 (class 2604 OID 20149)
-- Name: mesas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas ALTER COLUMN id SET DEFAULT nextval('operaciones.mesas_id_seq'::regclass);


--
-- TOC entry 3767 (class 2604 OID 20150)
-- Name: meseros id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros ALTER COLUMN id SET DEFAULT nextval('operaciones.meseros_id_seq'::regclass);


--
-- TOC entry 3785 (class 2604 OID 20151)
-- Name: pedido_detalle id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('operaciones.pedido_detalle_id_seq'::regclass);


--
-- TOC entry 3775 (class 2604 OID 20152)
-- Name: pedidos id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos ALTER COLUMN id SET DEFAULT nextval('operaciones.pedidos_id_seq'::regclass);


--
-- TOC entry 3771 (class 2604 OID 20153)
-- Name: reservas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas ALTER COLUMN id SET DEFAULT nextval('operaciones.reservas_id_seq'::regclass);


--
-- TOC entry 3702 (class 2604 OID 20154)
-- Name: banco id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco ALTER COLUMN id SET DEFAULT nextval('public.banco_id_seq'::regclass);


--
-- TOC entry 3705 (class 2604 OID 20155)
-- Name: banco_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos ALTER COLUMN id SET DEFAULT nextval('public.banco_movimientos_id_seq'::regclass);


--
-- TOC entry 3700 (class 2604 OID 20156)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 3701 (class 2604 OID 20157)
-- Name: caja_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('public.caja_movimientos_id_seq'::regclass);


--
-- TOC entry 3672 (class 2604 OID 20158)
-- Name: categoria_egresos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos ALTER COLUMN id SET DEFAULT nextval('public.categoria_egresos_id_seq'::regclass);


--
-- TOC entry 3683 (class 2604 OID 20159)
-- Name: compra_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle ALTER COLUMN id SET DEFAULT nextval('public.compra_detalle_id_seq'::regclass);


--
-- TOC entry 3682 (class 2604 OID 20160)
-- Name: compras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);


--
-- TOC entry 3699 (class 2604 OID 20161)
-- Name: egresos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos ALTER COLUMN id SET DEFAULT nextval('public.egresos_id_seq'::regclass);


--
-- TOC entry 3697 (class 2604 OID 20162)
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- TOC entry 3678 (class 2604 OID 20163)
-- Name: ingredientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes ALTER COLUMN id SET DEFAULT nextval('public.ingredientes_id_seq'::regclass);


--
-- TOC entry 3691 (class 2604 OID 20164)
-- Name: mesas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas ALTER COLUMN id SET DEFAULT nextval('public.mesas_id_seq'::regclass);


--
-- TOC entry 3692 (class 2604 OID 20165)
-- Name: meseros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros ALTER COLUMN id SET DEFAULT nextval('public.meseros_id_seq'::regclass);


--
-- TOC entry 3668 (class 2604 OID 20166)
-- Name: metodos_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago ALTER COLUMN id SET DEFAULT nextval('public.metodos_pago_id_seq'::regclass);


--
-- TOC entry 3696 (class 2604 OID 20167)
-- Name: pedido_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('public.pedido_detalle_id_seq'::regclass);


--
-- TOC entry 3694 (class 2604 OID 20168)
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- TOC entry 3673 (class 2604 OID 20169)
-- Name: proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);


--
-- TOC entry 3690 (class 2604 OID 20170)
-- Name: receta_ingredientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes ALTER COLUMN id SET DEFAULT nextval('public.receta_ingredientes_id_seq'::regclass);


--
-- TOC entry 3684 (class 2604 OID 20171)
-- Name: recetas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas ALTER COLUMN id SET DEFAULT nextval('public.recetas_id_seq'::regclass);


--
-- TOC entry 3663 (class 2604 OID 20172)
-- Name: restaurante id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurante ALTER COLUMN id SET DEFAULT nextval('public.restaurante_id_seq'::regclass);


--
-- TOC entry 3669 (class 2604 OID 20173)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3677 (class 2604 OID 20174)
-- Name: unidad_compra id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra ALTER COLUMN id SET DEFAULT nextval('public.unidad_compra_id_seq'::regclass);


--
-- TOC entry 3667 (class 2604 OID 20175)
-- Name: unidad_medida id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida ALTER COLUMN id SET DEFAULT nextval('public.unidad_medida_id_seq'::regclass);


--
-- TOC entry 3670 (class 2604 OID 20176)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 4402 (class 0 OID 19470)
-- Dependencies: 327
-- Data for Name: libro_diario; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.libro_diario (id, fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4354 (class 0 OID 19041)
-- Dependencies: 279
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.metodos_pago (id, nombre, activo, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4350 (class 0 OID 19012)
-- Dependencies: 275
-- Data for Name: restaurante; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.restaurante (id, nombre, direccion, telefono, email, logo_url, moneda, zona_horaria, impuesto_porcentaje, propina_porcentaje, patrimonio_inicial, activo, created_at, updated_at) FROM stdin;
1	Example	cabudare	0412 555 1041	example@gmail.com	\N	VES	America/Caracas	10.00	20.00	0.00	t	2026-03-03 10:56:13.498568	2026-03-03 10:56:13.498568
2	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 21:52:48.010658	2026-03-17 21:52:48.010658
3	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 21:59:59.449976	2026-03-17 21:59:59.449976
4	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 22:00:30.926985	2026-03-17 22:00:30.926985
5	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 22:20:35.042632	2026-03-17 22:20:35.042632
6	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 22:35:18.121913	2026-03-17 22:35:18.121913
7	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:33:18.852771	2026-03-18 16:33:18.852771
8	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:33:27.781321	2026-03-18 16:33:27.781321
9	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:33:35.43098	2026-03-18 16:33:35.43098
10	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:35:36.794919	2026-03-18 16:35:36.794919
11	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:48:52.562202	2026-03-18 16:48:52.562202
\.


--
-- TOC entry 4356 (class 0 OID 19053)
-- Dependencies: 281
-- Data for Name: roles; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.roles (id, nombre, restaurante_id, created_at) FROM stdin;
1	admin	1	2026-03-03 10:56:13.498568
2	cajero	1	2026-03-24 20:21:54.161944
3	mesero	1	2026-03-24 20:22:05.04884
4	cocina	1	2026-03-24 20:22:15.689054
\.


--
-- TOC entry 4408 (class 0 OID 19806)
-- Dependencies: 333
-- Data for Name: tables; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.tables (id, nombre, capacidad, status) FROM stdin;
1	Mesa 1 (Ventana)	4	available
2	Mesa 2 (Terraza)	2	available
3	Mesa 3 (VIP)	6	available
4	Mesa 4 (Centro)	4	available
5	Mesa 5 (Esquina)	2	available
6	Mesa 6 (Premium)	8	available
7	Barra 1	1	available
8	Barra 2	1	available
9	Barra 3	1	available
10	Terraza 2	4	available
\.


--
-- TOC entry 4352 (class 0 OID 19031)
-- Dependencies: 277
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.unidad_medida (id, nombre, abreviatura) FROM stdin;
\.


--
-- TOC entry 4358 (class 0 OID 19064)
-- Dependencies: 283
-- Data for Name: usuarios; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.usuarios (id, restaurante_id, rol_id, nombre, email, username, password_hash, activo, created_at, updated_at) FROM stdin;
1	1	1	Rafael Alvarez	alvarezrafaelat@gmail.com	rafa	$2b$10$6JMAAOJhP4KELVmgGzmNPusKbj26cDTk1novu7g3iZIbDczvuy4cy	t	2026-03-03 10:56:13.498568	2026-03-24 20:02:26.070936
3	1	2	ejemplo ejemplo 2	ejemplo2@gmail.com	ejemplo1234	$2b$10$3pnS/YawKWVC/Ve.xJ87iOzqmAQkvBVP7B7MMBK/eM8l/FR84T/y2	t	2026-03-24 20:09:48.932891	2026-03-24 20:23:12.382321
2	1	4	ejemplo ejemplo	ejemplo@gmail.com	ejemplo123	$2b$10$fP3fFvAXpX7QKyH5Y8XhpOTyJisJ9oQy0uqk2rGi.kHok.sfFejUe	t	2026-03-24 20:03:50.680361	2026-03-24 20:28:55.93198
\.


--
-- TOC entry 4398 (class 0 OID 19433)
-- Dependencies: 323
-- Data for Name: banco; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.banco (id, nombre_banco, numero_cuenta, saldo_actual, activo, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4400 (class 0 OID 19449)
-- Dependencies: 325
-- Data for Name: banco_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.banco_movimientos (id, banco_id, fecha_hora, tipo, monto, concepto, referencia_tipo, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4394 (class 0 OID 19394)
-- Dependencies: 319
-- Data for Name: caja; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.caja (id, fecha_apertura, fecha_cierre, monto_inicial, monto_final, monto_teorico, diferencia, estado, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4396 (class 0 OID 19412)
-- Dependencies: 321
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.caja_movimientos (id, caja_id, fecha_hora, tipo, monto, concepto, referencia_tipo, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4392 (class 0 OID 19376)
-- Dependencies: 317
-- Data for Name: egresos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.egresos (id, fecha, monto, categoria_id, razon, descripcion, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4360 (class 0 OID 19088)
-- Dependencies: 285
-- Data for Name: categoria_egresos; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.categoria_egresos (id, nombre, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4370 (class 0 OID 19164)
-- Dependencies: 295
-- Data for Name: compra_detalle; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.compra_detalle (id, compra_id, ingrediente_id, cantidad_compra, unidad_compra_id, precio_unitario, factor_conversion, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4368 (class 0 OID 19148)
-- Dependencies: 293
-- Data for Name: compras; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.compras (id, fecha, numero_factura_proveedor, total, estado_pago, saldo_pendiente, descripcion, proveedor_id, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4366 (class 0 OID 19128)
-- Dependencies: 291
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.ingredientes (id, nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, merma_teorica_porcentaje, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4372 (class 0 OID 19182)
-- Dependencies: 297
-- Data for Name: mermas; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.mermas (id, ingrediente_id, cantidad, tipo, razon, reportado_por, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4362 (class 0 OID 19099)
-- Dependencies: 287
-- Data for Name: proveedores; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.proveedores (id, identificacion, nombre, telefono, email, direccion, restaurante_id, banco_nombre, banco_cuenta_numero, activo, observaciones, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4364 (class 0 OID 19117)
-- Dependencies: 289
-- Data for Name: unidad_compra; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.unidad_compra (id, nombre, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4404 (class 0 OID 19781)
-- Dependencies: 329
-- Data for Name: categories; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

COPY inventory.categories (id, nombre) FROM stdin;
1	Bebidas
2	Platos Fuertes
3	Postres
4	Cafetería
5	Entradas
6	Carnes
7	Ensaladas
\.


--
-- TOC entry 4406 (class 0 OID 19790)
-- Dependencies: 331
-- Data for Name: products; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

COPY inventory.products (id, nombre, precio_venta, categoria_id, imagen_url, activo) FROM stdin;
1	Coca Cola JUMBO	2.50	1	\N	t
2	Agua Mineral	1.00	1	\N	t
3	Jugo de Naranja	2.00	1	\N	t
4	Limonada	1.50	1	\N	t
5	Cerveza Artesanal	3.50	1	\N	t
6	Vino Tinto (Copa)	4.00	1	\N	t
7	Hamburguesa Doble	8.50	2	\N	t
8	Pizza Margarita	12.00	2	\N	t
9	Pasta Alfredo	10.50	2	\N	t
10	Sushi Roll (8 piezas)	14.00	2	\N	t
11	Tacos al Pastor (3)	7.50	2	\N	t
12	Pollo a la Plancha	9.00	2	\N	t
13	Tiramisú	4.50	3	\N	t
14	Pastel de Chocolate	5.00	3	\N	t
15	Helado 2 Sabores	3.50	3	\N	t
16	Flan Napolitano	3.00	3	\N	t
17	Café Americano	1.50	4	\N	t
18	Cappuccino	2.50	4	\N	t
19	Latte	2.50	4	\N	t
20	Espresso	1.00	4	\N	t
21	Té Matcha	3.00	4	\N	t
22	Tequeños (5)	5.50	5	\N	t
23	Papas Fritas	3.50	5	\N	t
24	Aros de Cebolla	4.00	5	\N	t
25	Nachos con Queso	6.00	5	\N	t
26	Filet Mignon	22.00	6	\N	t
27	Ribeye	25.00	6	\N	t
28	Costillas BBQ	18.00	6	\N	t
29	Ensalada César	8.00	7	\N	t
30	Ensalada Caprese	7.50	7	\N	t
31	Ensalada Mixta	6.00	7	\N	t
\.


--
-- TOC entry 4374 (class 0 OID 19202)
-- Dependencies: 299
-- Data for Name: categorias; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.categorias (id, nombre, orden, activo, restaurante_id, created_at, updated_at) FROM stdin;
1	Entradas	1	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
2	Platos Fuertes	2	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
3	Bebidas	3	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
4	Postres	4	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
\.


--
-- TOC entry 4378 (class 0 OID 19239)
-- Dependencies: 303
-- Data for Name: receta_ingredientes; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.receta_ingredientes (id, receta_id, ingrediente_id, cantidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4376 (class 0 OID 19217)
-- Dependencies: 301
-- Data for Name: recetas; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.recetas (id, nombre, descripcion, categoria_id, imagen_url, costo_produccion, precio_sugerido, precio_venta, margen_utilidad, activo, restaurante_id, created_at, updated_at) FROM stdin;
1	Nachos con Guacamole	\N	1	\N	0.00	0.00	6.50	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
2	Hamburguesa Komanda	\N	2	\N	0.00	0.00	9.50	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
3	Limonada Natural	\N	3	\N	0.00	0.00	3.00	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
4	Flan Napolitano	\N	4	\N	0.00	0.00	5.00	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
\.


--
-- TOC entry 4390 (class 0 OID 19349)
-- Dependencies: 315
-- Data for Name: facturas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.facturas (id, numero_factura, pedido_id, metodo_pago_id, usuario_id, cliente_nombre, cliente_identificacion, cliente_direccion, cliente_email, fecha, subtotal, descuento, impuestos, propina, total, estado, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4380 (class 0 OID 19255)
-- Dependencies: 305
-- Data for Name: mesas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.mesas (id, numero, nombre, capacidad, estado, restaurante_id, created_at, updated_at) FROM stdin;
2	2	Mesa 2	4	libre	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
1	1	Mesa 1	4	ocupada	1	2026-03-24 19:31:17.54503	2026-03-24 19:38:02.017175
3	3	Mesa 3	6	ocupada	1	2026-03-24 19:31:17.54503	2026-03-24 19:38:21.838216
\.


--
-- TOC entry 4382 (class 0 OID 19271)
-- Dependencies: 307
-- Data for Name: meseros; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.meseros (id, nombre, activo, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4388 (class 0 OID 19331)
-- Dependencies: 313
-- Data for Name: pedido_detalle; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.pedido_detalle (id, pedido_id, receta_id, cantidad, precio_unitario, subtotal, notas, restaurante_id) FROM stdin;
1	1	4	1	5.00	5.00	\N	1
2	1	2	1	9.50	9.50	\N	1
3	2	4	1	5.00	5.00	\N	1
4	2	2	1	9.50	9.50	\N	1
5	2	3	1	3.00	3.00	\N	1
6	2	1	1	6.50	6.50	\N	1
7	3	4	1	5.00	5.00	\N	1
8	3	2	1	9.50	9.50	\N	1
9	3	3	1	3.00	3.00	\N	1
10	3	1	1	6.50	6.50	\N	1
11	4	4	2	5.00	10.00	\N	1
12	4	3	4	3.00	12.00	\N	1
13	4	1	4	6.50	26.00	\N	1
14	4	2	2	9.50	19.00	\N	1
\.


--
-- TOC entry 4386 (class 0 OID 19304)
-- Dependencies: 311
-- Data for Name: pedidos; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.pedidos (id, codigo, mesa_id, mesero_id, cliente, estado, estado_cuenta, fecha_hora, subtotal, descuento, impuestos, total, restaurante_id, created_at, updated_at) FROM stdin;
1	PED-20260324-0001	1	\N	\N	pendiente	abierta	2026-03-24 19:32:19.598162	14.50	0.00	1.45	15.95	1	2026-03-24 19:32:19.598162	2026-03-24 19:32:19.598162
2	PED-20260324-0002	1	\N	\N	pendiente	abierta	2026-03-24 19:37:56.254636	24.00	0.00	2.40	26.40	1	2026-03-24 19:37:56.254636	2026-03-24 19:37:56.254636
3	PED-20260324-0003	1	\N	\N	pendiente	abierta	2026-03-24 19:38:02.017175	24.00	0.00	2.40	26.40	1	2026-03-24 19:38:02.017175	2026-03-24 19:38:02.017175
4	PED-20260324-0004	3	\N	\N	pendiente	abierta	2026-03-24 19:38:21.838216	67.00	0.00	6.70	73.70	1	2026-03-24 19:38:21.838216	2026-03-24 19:38:21.838216
\.


--
-- TOC entry 4384 (class 0 OID 19285)
-- Dependencies: 309
-- Data for Name: reservas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.reservas (id, mesa_id, cliente_nombre, cliente_telefono, fecha_reserva, cantidad_personas, estado, notas, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4346 (class 0 OID 16770)
-- Dependencies: 271
-- Data for Name: banco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco (id, nombre_banco, numero_cuenta, saldo_actual, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4348 (class 0 OID 16784)
-- Dependencies: 273
-- Data for Name: banco_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco_movimientos (id, banco_id, fecha_hora, monto, concepto, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4342 (class 0 OID 16733)
-- Dependencies: 267
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja (id, fecha_apertura, fecha_cierre, monto_inicial, monto_final, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4344 (class 0 OID 16750)
-- Dependencies: 269
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_movimientos (id, caja_id, fecha_hora, monto, concepto, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4314 (class 0 OID 16516)
-- Dependencies: 239
-- Data for Name: categoria_egresos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_egresos (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4324 (class 0 OID 16585)
-- Dependencies: 249
-- Data for Name: compra_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra_detalle (id, compra_id, ingrediente_id, cantidad, precio_unitario, unidad_compra_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4322 (class 0 OID 16572)
-- Dependencies: 247
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compras (id, fecha, total, descripcion, proveedor_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4340 (class 0 OID 16716)
-- Dependencies: 265
-- Data for Name: egresos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egresos (id, fecha, monto, categoria_id, razon, descripcion, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4338 (class 0 OID 16696)
-- Dependencies: 263
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas (id, numero_factura, pedido_id, fecha, subtotal, impuestos, total, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4320 (class 0 OID 16556)
-- Dependencies: 245
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredientes (id, nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4330 (class 0 OID 16636)
-- Dependencies: 255
-- Data for Name: mesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mesas (id, numero, nombre, capacidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4332 (class 0 OID 16650)
-- Dependencies: 257
-- Data for Name: meseros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meseros (id, nombre, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4308 (class 0 OID 16478)
-- Dependencies: 233
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metodos_pago (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4411 (class 0 OID 19958)
-- Dependencies: 336
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, unit_price, subtotal, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4412 (class 0 OID 19983)
-- Dependencies: 337
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, restaurant_id, user_id, table_id, status, subtotal, tax_amount, total_amount, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4336 (class 0 OID 16680)
-- Dependencies: 261
-- Data for Name: pedido_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_detalle (id, pedido_id, receta_id, cantidad, precio_unitario, subtotal, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4334 (class 0 OID 16662)
-- Dependencies: 259
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, codigo, mesa_id, mesero_id, cliente, fecha_hora, total, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4316 (class 0 OID 16526)
-- Dependencies: 241
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedores (id, identificacion, nombre, telefono, email, direccion, restaurante_id, banco_nombre, banco_cuenta_numero, activo, observaciones, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4328 (class 0 OID 16620)
-- Dependencies: 253
-- Data for Name: receta_ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receta_ingredientes (id, receta_id, ingrediente_id, cantidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4326 (class 0 OID 16601)
-- Dependencies: 251
-- Data for Name: recetas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recetas (id, nombre, descripcion, costo_produccion, precio_sugerido, precio_venta, margen_utilidad, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4304 (class 0 OID 16456)
-- Dependencies: 229
-- Data for Name: restaurante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurante (id, nombre, patrimonio_inicial, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4310 (class 0 OID 16488)
-- Dependencies: 235
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4318 (class 0 OID 16546)
-- Dependencies: 243
-- Data for Name: unidad_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_compra (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4306 (class 0 OID 16468)
-- Dependencies: 231
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_medida (id, nombre, abreviatura) FROM stdin;
\.


--
-- TOC entry 4312 (class 0 OID 16498)
-- Dependencies: 237
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, restaurante_id, rol_id, nombre, email, username, activo) FROM stdin;
\.


--
-- TOC entry 4410 (class 0 OID 19860)
-- Dependencies: 335
-- Data for Name: order_items; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.order_items (id, order_id, product_id, quantity, unit_price, subtotal, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4409 (class 0 OID 19834)
-- Dependencies: 334
-- Data for Name: orders; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.orders (id, restaurant_id, user_id, table_id, status, subtotal, tax_amount, total_amount, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4489 (class 0 OID 0)
-- Dependencies: 326
-- Name: libro_diario_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.libro_diario_id_seq', 1, false);


--
-- TOC entry 4490 (class 0 OID 0)
-- Dependencies: 278
-- Name: metodos_pago_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.metodos_pago_id_seq', 1, false);


--
-- TOC entry 4491 (class 0 OID 0)
-- Dependencies: 274
-- Name: restaurante_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.restaurante_id_seq', 11, true);


--
-- TOC entry 4492 (class 0 OID 0)
-- Dependencies: 280
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.roles_id_seq', 4, true);


--
-- TOC entry 4493 (class 0 OID 0)
-- Dependencies: 332
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.tables_id_seq', 10, true);


--
-- TOC entry 4494 (class 0 OID 0)
-- Dependencies: 276
-- Name: unidad_medida_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.unidad_medida_id_seq', 1, false);


--
-- TOC entry 4495 (class 0 OID 0)
-- Dependencies: 282
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.usuarios_id_seq', 3, true);


--
-- TOC entry 4496 (class 0 OID 0)
-- Dependencies: 322
-- Name: banco_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.banco_id_seq', 1, false);


--
-- TOC entry 4497 (class 0 OID 0)
-- Dependencies: 324
-- Name: banco_movimientos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.banco_movimientos_id_seq', 1, false);


--
-- TOC entry 4498 (class 0 OID 0)
-- Dependencies: 318
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.caja_id_seq', 1, false);


--
-- TOC entry 4499 (class 0 OID 0)
-- Dependencies: 320
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.caja_movimientos_id_seq', 1, false);


--
-- TOC entry 4500 (class 0 OID 0)
-- Dependencies: 316
-- Name: egresos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.egresos_id_seq', 1, false);


--
-- TOC entry 4501 (class 0 OID 0)
-- Dependencies: 284
-- Name: categoria_egresos_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.categoria_egresos_id_seq', 1, false);


--
-- TOC entry 4502 (class 0 OID 0)
-- Dependencies: 294
-- Name: compra_detalle_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.compra_detalle_id_seq', 1, false);


--
-- TOC entry 4503 (class 0 OID 0)
-- Dependencies: 292
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.compras_id_seq', 1, false);


--
-- TOC entry 4504 (class 0 OID 0)
-- Dependencies: 290
-- Name: ingredientes_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.ingredientes_id_seq', 1, false);


--
-- TOC entry 4505 (class 0 OID 0)
-- Dependencies: 296
-- Name: mermas_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.mermas_id_seq', 1, false);


--
-- TOC entry 4506 (class 0 OID 0)
-- Dependencies: 286
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.proveedores_id_seq', 1, false);


--
-- TOC entry 4507 (class 0 OID 0)
-- Dependencies: 288
-- Name: unidad_compra_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.unidad_compra_id_seq', 1, false);


--
-- TOC entry 4508 (class 0 OID 0)
-- Dependencies: 328
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.categories_id_seq', 7, true);


--
-- TOC entry 4509 (class 0 OID 0)
-- Dependencies: 330
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.products_id_seq', 31, true);


--
-- TOC entry 4510 (class 0 OID 0)
-- Dependencies: 298
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.categorias_id_seq', 4, true);


--
-- TOC entry 4511 (class 0 OID 0)
-- Dependencies: 302
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.receta_ingredientes_id_seq', 1, false);


--
-- TOC entry 4512 (class 0 OID 0)
-- Dependencies: 300
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.recetas_id_seq', 4, true);


--
-- TOC entry 4513 (class 0 OID 0)
-- Dependencies: 314
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.facturas_id_seq', 1, false);


--
-- TOC entry 4514 (class 0 OID 0)
-- Dependencies: 304
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.mesas_id_seq', 3, true);


--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 306
-- Name: meseros_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.meseros_id_seq', 1, false);


--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 312
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.pedido_detalle_id_seq', 14, true);


--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 310
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.pedidos_id_seq', 4, true);


--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 308
-- Name: reservas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.reservas_id_seq', 1, false);


--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 270
-- Name: banco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banco_id_seq', 1, false);


--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 272
-- Name: banco_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banco_movimientos_id_seq', 1, false);


--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 266
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_id_seq', 1, false);


--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 268
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_movimientos_id_seq', 1, false);


--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 238
-- Name: categoria_egresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_egresos_id_seq', 1, false);


--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 248
-- Name: compra_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compra_detalle_id_seq', 1, false);


--
-- TOC entry 4525 (class 0 OID 0)
-- Dependencies: 246
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compras_id_seq', 1, false);


--
-- TOC entry 4526 (class 0 OID 0)
-- Dependencies: 264
-- Name: egresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.egresos_id_seq', 1, false);


--
-- TOC entry 4527 (class 0 OID 0)
-- Dependencies: 262
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_id_seq', 1, false);


--
-- TOC entry 4528 (class 0 OID 0)
-- Dependencies: 244
-- Name: ingredientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredientes_id_seq', 1, false);


--
-- TOC entry 4529 (class 0 OID 0)
-- Dependencies: 254
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mesas_id_seq', 1, false);


--
-- TOC entry 4530 (class 0 OID 0)
-- Dependencies: 256
-- Name: meseros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meseros_id_seq', 1, false);


--
-- TOC entry 4531 (class 0 OID 0)
-- Dependencies: 232
-- Name: metodos_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metodos_pago_id_seq', 1, false);


--
-- TOC entry 4532 (class 0 OID 0)
-- Dependencies: 260
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_detalle_id_seq', 1, false);


--
-- TOC entry 4533 (class 0 OID 0)
-- Dependencies: 258
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- TOC entry 4534 (class 0 OID 0)
-- Dependencies: 240
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_id_seq', 1, false);


--
-- TOC entry 4535 (class 0 OID 0)
-- Dependencies: 252
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receta_ingredientes_id_seq', 1, false);


--
-- TOC entry 4536 (class 0 OID 0)
-- Dependencies: 250
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recetas_id_seq', 1, false);


--
-- TOC entry 4537 (class 0 OID 0)
-- Dependencies: 228
-- Name: restaurante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restaurante_id_seq', 1, false);


--
-- TOC entry 4538 (class 0 OID 0)
-- Dependencies: 234
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 4539 (class 0 OID 0)
-- Dependencies: 242
-- Name: unidad_compra_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_compra_id_seq', 1, false);


--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 230
-- Name: unidad_medida_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_medida_id_seq', 1, false);


--
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 236
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, false);


--
-- TOC entry 4029 (class 2606 OID 19485)
-- Name: libro_diario libro_diario_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario
    ADD CONSTRAINT libro_diario_pkey PRIMARY KEY (id);


--
-- TOC entry 3927 (class 2606 OID 19051)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 3923 (class 2606 OID 19029)
-- Name: restaurante restaurante_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.restaurante
    ADD CONSTRAINT restaurante_pkey PRIMARY KEY (id);


--
-- TOC entry 3929 (class 2606 OID 19062)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4035 (class 2606 OID 19815)
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- TOC entry 3925 (class 2606 OID 19039)
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 3931 (class 2606 OID 19081)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 3933 (class 2606 OID 19083)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4021 (class 2606 OID 19465)
-- Name: banco_movimientos banco_movimientos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT banco_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 4018 (class 2606 OID 19446)
-- Name: banco banco_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco
    ADD CONSTRAINT banco_pkey PRIMARY KEY (id);


--
-- TOC entry 4013 (class 2606 OID 19428)
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 4009 (class 2606 OID 19408)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4005 (class 2606 OID 19390)
-- Name: egresos egresos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3935 (class 2606 OID 19097)
-- Name: categoria_egresos categoria_egresos_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos
    ADD CONSTRAINT categoria_egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3952 (class 2606 OID 19178)
-- Name: compra_detalle compra_detalle_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT compra_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3948 (class 2606 OID 19160)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 3946 (class 2606 OID 19143)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3958 (class 2606 OID 19198)
-- Name: mermas mermas_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT mermas_pkey PRIMARY KEY (id);


--
-- TOC entry 3939 (class 2606 OID 19113)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 3941 (class 2606 OID 19126)
-- Name: unidad_compra unidad_compra_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra
    ADD CONSTRAINT unidad_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 4031 (class 2606 OID 19788)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4033 (class 2606 OID 19799)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3960 (class 2606 OID 19214)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- TOC entry 3970 (class 2606 OID 19249)
-- Name: receta_ingredientes receta_ingredientes_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3972 (class 2606 OID 19251)
-- Name: receta_ingredientes receta_ingredientes_receta_id_ingrediente_id_key; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_receta_id_ingrediente_id_key UNIQUE (receta_id, ingrediente_id);


--
-- TOC entry 3966 (class 2606 OID 19234)
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- TOC entry 3998 (class 2606 OID 19371)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 4000 (class 2606 OID 19369)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 3976 (class 2606 OID 19267)
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- TOC entry 3979 (class 2606 OID 19282)
-- Name: meseros meseros_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros
    ADD CONSTRAINT meseros_pkey PRIMARY KEY (id);


--
-- TOC entry 3996 (class 2606 OID 19345)
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3990 (class 2606 OID 19324)
-- Name: pedidos pedidos_codigo_key; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT pedidos_codigo_key UNIQUE (codigo);


--
-- TOC entry 3992 (class 2606 OID 19322)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 3983 (class 2606 OID 19300)
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY (id);


--
-- TOC entry 4041 (class 2606 OID 19971)
-- Name: order_items PK_005269d8574e6fac0493715c308; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_005269d8574e6fac0493715c308" PRIMARY KEY (id);


--
-- TOC entry 4043 (class 2606 OID 20001)
-- Name: orders PK_710e2d4957aa5878dfe94e4ac2f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_710e2d4957aa5878dfe94e4ac2f" PRIMARY KEY (id);


--
-- TOC entry 3919 (class 2606 OID 16799)
-- Name: banco_movimientos banco_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT banco_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3916 (class 2606 OID 16781)
-- Name: banco banco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT banco_pkey PRIMARY KEY (id);


--
-- TOC entry 3912 (class 2606 OID 16765)
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3909 (class 2606 OID 16746)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 3850 (class 2606 OID 16524)
-- Name: categoria_egresos categoria_egresos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos
    ADD CONSTRAINT categoria_egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3869 (class 2606 OID 16597)
-- Name: compra_detalle compra_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT compra_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3864 (class 2606 OID 16581)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 3905 (class 2606 OID 16729)
-- Name: egresos egresos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3899 (class 2606 OID 16712)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 3901 (class 2606 OID 16710)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 3862 (class 2606 OID 16568)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3884 (class 2606 OID 16646)
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- TOC entry 3887 (class 2606 OID 16659)
-- Name: meseros meseros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros
    ADD CONSTRAINT meseros_pkey PRIMARY KEY (id);


--
-- TOC entry 3840 (class 2606 OID 16486)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 3897 (class 2606 OID 16692)
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3891 (class 2606 OID 16675)
-- Name: pedidos pedidos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_codigo_key UNIQUE (codigo);


--
-- TOC entry 3893 (class 2606 OID 16673)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 3854 (class 2606 OID 16542)
-- Name: proveedores proveedores_identificacion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_identificacion_key UNIQUE (identificacion);


--
-- TOC entry 3856 (class 2606 OID 16540)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 3879 (class 2606 OID 16630)
-- Name: receta_ingredientes receta_ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3881 (class 2606 OID 16632)
-- Name: receta_ingredientes receta_ingredientes_receta_id_ingrediente_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_receta_id_ingrediente_id_key UNIQUE (receta_id, ingrediente_id);


--
-- TOC entry 3875 (class 2606 OID 16616)
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- TOC entry 3836 (class 2606 OID 16466)
-- Name: restaurante restaurante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurante
    ADD CONSTRAINT restaurante_pkey PRIMARY KEY (id);


--
-- TOC entry 3842 (class 2606 OID 16496)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3858 (class 2606 OID 16554)
-- Name: unidad_compra unidad_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra
    ADD CONSTRAINT unidad_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 3838 (class 2606 OID 16476)
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 3846 (class 2606 OID 16510)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 3848 (class 2606 OID 16512)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4039 (class 2606 OID 19870)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4037 (class 2606 OID 19849)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4025 (class 1259 OID 19486)
-- Name: idx_libro_fecha; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_fecha ON contabilidad.libro_diario USING btree (fecha);


--
-- TOC entry 4026 (class 1259 OID 19488)
-- Name: idx_libro_referencia; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_referencia ON contabilidad.libro_diario USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 4027 (class 1259 OID 19487)
-- Name: idx_libro_tipo; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_tipo ON contabilidad.libro_diario USING btree (tipo);


--
-- TOC entry 4019 (class 1259 OID 19447)
-- Name: idx_banco_activo; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_activo ON finanzas.banco USING btree (activo);


--
-- TOC entry 4022 (class 1259 OID 19468)
-- Name: idx_banco_mov_banco; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_banco ON finanzas.banco_movimientos USING btree (banco_id);


--
-- TOC entry 4023 (class 1259 OID 19466)
-- Name: idx_banco_mov_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_fecha ON finanzas.banco_movimientos USING btree (fecha_hora);


--
-- TOC entry 4024 (class 1259 OID 19467)
-- Name: idx_banco_mov_referencia; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_referencia ON finanzas.banco_movimientos USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 4010 (class 1259 OID 19409)
-- Name: idx_caja_estado; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_estado ON finanzas.caja USING btree (estado);


--
-- TOC entry 4011 (class 1259 OID 19410)
-- Name: idx_caja_fechas; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_fechas ON finanzas.caja USING btree (fecha_apertura, fecha_cierre);


--
-- TOC entry 4014 (class 1259 OID 19431)
-- Name: idx_caja_mov_caja; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_caja ON finanzas.caja_movimientos USING btree (caja_id);


--
-- TOC entry 4015 (class 1259 OID 19429)
-- Name: idx_caja_mov_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_fecha ON finanzas.caja_movimientos USING btree (fecha_hora);


--
-- TOC entry 4016 (class 1259 OID 19430)
-- Name: idx_caja_mov_referencia; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_referencia ON finanzas.caja_movimientos USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 4006 (class 1259 OID 19392)
-- Name: idx_egresos_categoria; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_egresos_categoria ON finanzas.egresos USING btree (categoria_id);


--
-- TOC entry 4007 (class 1259 OID 19391)
-- Name: idx_egresos_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_egresos_fecha ON finanzas.egresos USING btree (fecha);


--
-- TOC entry 3953 (class 1259 OID 19179)
-- Name: idx_compra_detalle_compra; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compra_detalle_compra ON inventario.compra_detalle USING btree (compra_id);


--
-- TOC entry 3954 (class 1259 OID 19180)
-- Name: idx_compra_detalle_ingrediente; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compra_detalle_ingrediente ON inventario.compra_detalle USING btree (ingrediente_id);


--
-- TOC entry 3949 (class 1259 OID 19161)
-- Name: idx_compras_fecha; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compras_fecha ON inventario.compras USING btree (fecha);


--
-- TOC entry 3950 (class 1259 OID 19162)
-- Name: idx_compras_proveedor; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compras_proveedor ON inventario.compras USING btree (proveedor_id);


--
-- TOC entry 3942 (class 1259 OID 19144)
-- Name: idx_ingredientes_nombre; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_nombre ON inventario.ingredientes USING btree (nombre);


--
-- TOC entry 3943 (class 1259 OID 19146)
-- Name: idx_ingredientes_restaurante; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_restaurante ON inventario.ingredientes USING btree (restaurante_id);


--
-- TOC entry 3944 (class 1259 OID 19145)
-- Name: idx_ingredientes_stock; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_stock ON inventario.ingredientes USING btree (cantidad_disponible, cantidad_minima);


--
-- TOC entry 3955 (class 1259 OID 19200)
-- Name: idx_mermas_fecha; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_mermas_fecha ON inventario.mermas USING btree (created_at);


--
-- TOC entry 3956 (class 1259 OID 19199)
-- Name: idx_mermas_ingrediente; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_mermas_ingrediente ON inventario.mermas USING btree (ingrediente_id);


--
-- TOC entry 3936 (class 1259 OID 19114)
-- Name: idx_proveedores_nombre; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_proveedores_nombre ON inventario.proveedores USING btree (nombre);


--
-- TOC entry 3937 (class 1259 OID 19115)
-- Name: idx_proveedores_restaurante; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_proveedores_restaurante ON inventario.proveedores USING btree (restaurante_id, nombre);


--
-- TOC entry 3961 (class 1259 OID 19215)
-- Name: idx_categorias_restaurante; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_categorias_restaurante ON menu.categorias USING btree (restaurante_id, orden);


--
-- TOC entry 3967 (class 1259 OID 19253)
-- Name: idx_receta_ingredientes_ingrediente; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_ingrediente ON menu.receta_ingredientes USING btree (ingrediente_id);


--
-- TOC entry 3968 (class 1259 OID 19252)
-- Name: idx_receta_ingredientes_receta; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_receta ON menu.receta_ingredientes USING btree (receta_id);


--
-- TOC entry 3962 (class 1259 OID 19236)
-- Name: idx_recetas_activo; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_activo ON menu.recetas USING btree (activo);


--
-- TOC entry 3963 (class 1259 OID 19237)
-- Name: idx_recetas_categoria; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_categoria ON menu.recetas USING btree (categoria_id);


--
-- TOC entry 3964 (class 1259 OID 19235)
-- Name: idx_recetas_nombre; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_nombre ON menu.recetas USING btree (nombre);


--
-- TOC entry 4001 (class 1259 OID 19373)
-- Name: idx_facturas_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON operaciones.facturas USING btree (fecha);


--
-- TOC entry 4002 (class 1259 OID 19374)
-- Name: idx_facturas_fecha_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_fecha_estado ON operaciones.facturas USING btree (fecha, estado);


--
-- TOC entry 4003 (class 1259 OID 19372)
-- Name: idx_facturas_numero; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON operaciones.facturas USING btree (numero_factura);


--
-- TOC entry 3973 (class 1259 OID 19268)
-- Name: idx_mesas_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_mesas_estado ON operaciones.mesas USING btree (estado);


--
-- TOC entry 3974 (class 1259 OID 19269)
-- Name: idx_mesas_numero; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_mesas_numero ON operaciones.mesas USING btree (numero);


--
-- TOC entry 3977 (class 1259 OID 19283)
-- Name: idx_meseros_nombre; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_meseros_nombre ON operaciones.meseros USING btree (nombre);


--
-- TOC entry 3993 (class 1259 OID 19346)
-- Name: idx_pedido_detalle_pedido; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_pedido ON operaciones.pedido_detalle USING btree (pedido_id);


--
-- TOC entry 3994 (class 1259 OID 19347)
-- Name: idx_pedido_detalle_receta; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_receta ON operaciones.pedido_detalle USING btree (receta_id);


--
-- TOC entry 3984 (class 1259 OID 19328)
-- Name: idx_pedidos_codigo; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_codigo ON operaciones.pedidos USING btree (codigo);


--
-- TOC entry 3985 (class 1259 OID 19325)
-- Name: idx_pedidos_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_estado ON operaciones.pedidos USING btree (estado);


--
-- TOC entry 3986 (class 1259 OID 19326)
-- Name: idx_pedidos_estado_cuenta; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_estado_cuenta ON operaciones.pedidos USING btree (estado_cuenta);


--
-- TOC entry 3987 (class 1259 OID 19327)
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha ON operaciones.pedidos USING btree (fecha_hora);


--
-- TOC entry 3988 (class 1259 OID 19329)
-- Name: idx_pedidos_fecha_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha_estado ON operaciones.pedidos USING btree (fecha_hora, estado);


--
-- TOC entry 3980 (class 1259 OID 19302)
-- Name: idx_reservas_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_reservas_estado ON operaciones.reservas USING btree (estado);


--
-- TOC entry 3981 (class 1259 OID 19301)
-- Name: idx_reservas_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_reservas_fecha ON operaciones.reservas USING btree (fecha_reserva);


--
-- TOC entry 3917 (class 1259 OID 16782)
-- Name: idx_banco_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_activo ON public.banco USING btree (activo);


--
-- TOC entry 3920 (class 1259 OID 16802)
-- Name: idx_banco_movimientos_banco; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_movimientos_banco ON public.banco_movimientos USING btree (banco_id);


--
-- TOC entry 3921 (class 1259 OID 16800)
-- Name: idx_banco_movimientos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_movimientos_fecha ON public.banco_movimientos USING btree (fecha_hora);


--
-- TOC entry 3910 (class 1259 OID 16748)
-- Name: idx_caja_fechas; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_fechas ON public.caja USING btree (fecha_apertura, fecha_cierre);


--
-- TOC entry 3913 (class 1259 OID 16768)
-- Name: idx_caja_movimientos_caja; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_movimientos_caja ON public.caja_movimientos USING btree (caja_id);


--
-- TOC entry 3914 (class 1259 OID 16766)
-- Name: idx_caja_movimientos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_movimientos_fecha ON public.caja_movimientos USING btree (fecha_hora);


--
-- TOC entry 3870 (class 1259 OID 16598)
-- Name: idx_compra_detalle_compra; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compra_detalle_compra ON public.compra_detalle USING btree (compra_id);


--
-- TOC entry 3871 (class 1259 OID 16599)
-- Name: idx_compra_detalle_ingrediente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compra_detalle_ingrediente ON public.compra_detalle USING btree (ingrediente_id);


--
-- TOC entry 3865 (class 1259 OID 16582)
-- Name: idx_compras_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_fecha ON public.compras USING btree (fecha);


--
-- TOC entry 3866 (class 1259 OID 17021)
-- Name: idx_compras_fecha_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_fecha_proveedor ON public.compras USING btree (fecha, proveedor_id);


--
-- TOC entry 3867 (class 1259 OID 16583)
-- Name: idx_compras_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_proveedor ON public.compras USING btree (proveedor_id);


--
-- TOC entry 3906 (class 1259 OID 16731)
-- Name: idx_egresos_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_egresos_categoria ON public.egresos USING btree (categoria_id);


--
-- TOC entry 3907 (class 1259 OID 16730)
-- Name: idx_egresos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_egresos_fecha ON public.egresos USING btree (fecha);


--
-- TOC entry 3902 (class 1259 OID 16714)
-- Name: idx_facturas_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON public.facturas USING btree (fecha);


--
-- TOC entry 3903 (class 1259 OID 16713)
-- Name: idx_facturas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON public.facturas USING btree (numero_factura);


--
-- TOC entry 3859 (class 1259 OID 16569)
-- Name: idx_ingredientes_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ingredientes_nombre ON public.ingredientes USING btree (nombre);


--
-- TOC entry 3860 (class 1259 OID 16570)
-- Name: idx_ingredientes_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ingredientes_stock ON public.ingredientes USING btree (cantidad_disponible, cantidad_minima);


--
-- TOC entry 3882 (class 1259 OID 16648)
-- Name: idx_mesas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mesas_numero ON public.mesas USING btree (numero);


--
-- TOC entry 3885 (class 1259 OID 16660)
-- Name: idx_meseros_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_meseros_nombre ON public.meseros USING btree (nombre);


--
-- TOC entry 3894 (class 1259 OID 16693)
-- Name: idx_pedido_detalle_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_pedido ON public.pedido_detalle USING btree (pedido_id);


--
-- TOC entry 3895 (class 1259 OID 16694)
-- Name: idx_pedido_detalle_receta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_receta ON public.pedido_detalle USING btree (receta_id);


--
-- TOC entry 3888 (class 1259 OID 16678)
-- Name: idx_pedidos_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_codigo ON public.pedidos USING btree (codigo);


--
-- TOC entry 3889 (class 1259 OID 16677)
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha ON public.pedidos USING btree (fecha_hora);


--
-- TOC entry 3851 (class 1259 OID 16543)
-- Name: idx_proveedores_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedores_nombre ON public.proveedores USING btree (nombre);


--
-- TOC entry 3852 (class 1259 OID 16544)
-- Name: idx_proveedores_restaurante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedores_restaurante ON public.proveedores USING btree (restaurante_id, nombre);


--
-- TOC entry 3876 (class 1259 OID 16634)
-- Name: idx_receta_ingredientes_ingrediente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_ingrediente ON public.receta_ingredientes USING btree (ingrediente_id);


--
-- TOC entry 3877 (class 1259 OID 16633)
-- Name: idx_receta_ingredientes_receta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_receta ON public.receta_ingredientes USING btree (receta_id);


--
-- TOC entry 3872 (class 1259 OID 16618)
-- Name: idx_recetas_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recetas_activo ON public.recetas USING btree (activo);


--
-- TOC entry 3873 (class 1259 OID 16617)
-- Name: idx_recetas_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recetas_nombre ON public.recetas USING btree (nombre);


--
-- TOC entry 3843 (class 1259 OID 16514)
-- Name: idx_usuarios_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_email ON public.usuarios USING btree (email);


--
-- TOC entry 3844 (class 1259 OID 16513)
-- Name: idx_usuarios_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_username ON public.usuarios USING btree (username);


--
-- TOC entry 4146 (class 2620 OID 19754)
-- Name: restaurante trg_restaurante_updated; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_restaurante_updated BEFORE UPDATE ON core.restaurante FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4147 (class 2620 OID 19755)
-- Name: usuarios trg_usuarios_updated; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_usuarios_updated BEFORE UPDATE ON core.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4155 (class 2620 OID 19763)
-- Name: banco trg_banco_updated; Type: TRIGGER; Schema: finanzas; Owner: postgres
--

CREATE TRIGGER trg_banco_updated BEFORE UPDATE ON finanzas.banco FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4149 (class 2620 OID 19757)
-- Name: ingredientes trg_ingredientes_updated; Type: TRIGGER; Schema: inventario; Owner: postgres
--

CREATE TRIGGER trg_ingredientes_updated BEFORE UPDATE ON inventario.ingredientes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4148 (class 2620 OID 19756)
-- Name: proveedores trg_proveedores_updated; Type: TRIGGER; Schema: inventario; Owner: postgres
--

CREATE TRIGGER trg_proveedores_updated BEFORE UPDATE ON inventario.proveedores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4150 (class 2620 OID 19758)
-- Name: categorias trg_categorias_updated; Type: TRIGGER; Schema: menu; Owner: postgres
--

CREATE TRIGGER trg_categorias_updated BEFORE UPDATE ON menu.categorias FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4151 (class 2620 OID 19759)
-- Name: recetas trg_recetas_updated; Type: TRIGGER; Schema: menu; Owner: postgres
--

CREATE TRIGGER trg_recetas_updated BEFORE UPDATE ON menu.recetas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4152 (class 2620 OID 19760)
-- Name: mesas trg_mesas_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_mesas_updated BEFORE UPDATE ON operaciones.mesas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4153 (class 2620 OID 19761)
-- Name: meseros trg_meseros_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_meseros_updated BEFORE UPDATE ON operaciones.meseros FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4154 (class 2620 OID 19762)
-- Name: pedidos trg_pedidos_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_pedidos_updated BEFORE UPDATE ON operaciones.pedidos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4145 (class 2620 OID 17020)
-- Name: proveedores update_proveedores_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_proveedores_updated_at BEFORE UPDATE ON public.proveedores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4144 (class 2620 OID 17019)
-- Name: restaurante update_restaurante_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_restaurante_updated_at BEFORE UPDATE ON public.restaurante FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4137 (class 2606 OID 19749)
-- Name: libro_diario fk_libro_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario
    ADD CONSTRAINT fk_libro_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4088 (class 2606 OID 20019)
-- Name: usuarios FK_7ba064af415d3da35c33731f743; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT "FK_7ba064af415d3da35c33731f743" FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id);


--
-- TOC entry 4087 (class 2606 OID 19489)
-- Name: metodos_pago fk_metodos_pago_restaurante; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4133 (class 2606 OID 19734)
-- Name: banco_movimientos fk_banco_mov_banco; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id);


--
-- TOC entry 4134 (class 2606 OID 19739)
-- Name: banco_movimientos fk_banco_mov_metodo_pago; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4135 (class 2606 OID 19729)
-- Name: banco_movimientos fk_banco_mov_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4136 (class 2606 OID 19744)
-- Name: banco_movimientos fk_banco_mov_usuario; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4132 (class 2606 OID 19724)
-- Name: banco fk_banco_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4128 (class 2606 OID 19709)
-- Name: caja_movimientos fk_caja_mov_caja; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_caja FOREIGN KEY (caja_id) REFERENCES finanzas.caja(id);


--
-- TOC entry 4129 (class 2606 OID 19714)
-- Name: caja_movimientos fk_caja_mov_metodo_pago; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4130 (class 2606 OID 19704)
-- Name: caja_movimientos fk_caja_mov_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4131 (class 2606 OID 19719)
-- Name: caja_movimientos fk_caja_mov_usuario; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4125 (class 2606 OID 19689)
-- Name: caja fk_caja_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4126 (class 2606 OID 19694)
-- Name: caja fk_caja_usuario_apertura; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4127 (class 2606 OID 19699)
-- Name: caja fk_caja_usuario_cierre; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4123 (class 2606 OID 19684)
-- Name: egresos fk_egresos_categoria; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES inventario.categoria_egresos(id);


--
-- TOC entry 4124 (class 2606 OID 19679)
-- Name: egresos fk_egresos_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4089 (class 2606 OID 19509)
-- Name: categoria_egresos fk_cat_egresos_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos
    ADD CONSTRAINT fk_cat_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4096 (class 2606 OID 19549)
-- Name: compra_detalle fk_compra_det_compra; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_compra FOREIGN KEY (compra_id) REFERENCES inventario.compras(id) ON DELETE CASCADE;


--
-- TOC entry 4097 (class 2606 OID 19554)
-- Name: compra_detalle fk_compra_det_ingrediente; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4098 (class 2606 OID 19544)
-- Name: compra_detalle fk_compra_det_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4099 (class 2606 OID 19559)
-- Name: compra_detalle fk_compra_det_unidad; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_unidad FOREIGN KEY (unidad_compra_id) REFERENCES inventario.unidad_compra(id);


--
-- TOC entry 4094 (class 2606 OID 19539)
-- Name: compras fk_compras_proveedor; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES inventario.proveedores(id);


--
-- TOC entry 4095 (class 2606 OID 19534)
-- Name: compras fk_compras_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4092 (class 2606 OID 19524)
-- Name: ingredientes fk_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4093 (class 2606 OID 19529)
-- Name: ingredientes fk_ingredientes_unidad; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES core.unidad_medida(id);


--
-- TOC entry 4100 (class 2606 OID 19569)
-- Name: mermas fk_mermas_ingrediente; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4101 (class 2606 OID 19564)
-- Name: mermas fk_mermas_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4102 (class 2606 OID 19574)
-- Name: mermas fk_mermas_usuario; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_usuario FOREIGN KEY (reportado_por) REFERENCES core.usuarios(id);


--
-- TOC entry 4090 (class 2606 OID 19514)
-- Name: proveedores fk_proveedores_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4091 (class 2606 OID 19519)
-- Name: unidad_compra fk_unidad_compra_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4138 (class 2606 OID 19800)
-- Name: products products_categoria_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES inventory.categories(id);


--
-- TOC entry 4103 (class 2606 OID 19579)
-- Name: categorias fk_categorias_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias
    ADD CONSTRAINT fk_categorias_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4106 (class 2606 OID 19604)
-- Name: receta_ingredientes fk_receta_ing_ingrediente; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4107 (class 2606 OID 19599)
-- Name: receta_ingredientes fk_receta_ing_receta; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id) ON DELETE CASCADE;


--
-- TOC entry 4108 (class 2606 OID 19594)
-- Name: receta_ingredientes fk_receta_ing_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4104 (class 2606 OID 19589)
-- Name: recetas fk_recetas_categoria; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT fk_recetas_categoria FOREIGN KEY (categoria_id) REFERENCES menu.categorias(id);


--
-- TOC entry 4105 (class 2606 OID 19584)
-- Name: recetas fk_recetas_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4119 (class 2606 OID 19669)
-- Name: facturas fk_facturas_metodo_pago; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4120 (class 2606 OID 19664)
-- Name: facturas fk_facturas_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id);


--
-- TOC entry 4121 (class 2606 OID 19659)
-- Name: facturas fk_facturas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4122 (class 2606 OID 19674)
-- Name: facturas fk_facturas_usuario; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4109 (class 2606 OID 19609)
-- Name: mesas fk_mesas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4110 (class 2606 OID 19614)
-- Name: meseros fk_meseros_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4116 (class 2606 OID 19649)
-- Name: pedido_detalle fk_pedido_det_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4117 (class 2606 OID 19654)
-- Name: pedido_detalle fk_pedido_det_receta; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id);


--
-- TOC entry 4118 (class 2606 OID 19644)
-- Name: pedido_detalle fk_pedido_det_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4113 (class 2606 OID 19634)
-- Name: pedidos fk_pedidos_mesa; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);


--
-- TOC entry 4114 (class 2606 OID 19639)
-- Name: pedidos fk_pedidos_mesero; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES operaciones.meseros(id);


--
-- TOC entry 4115 (class 2606 OID 19629)
-- Name: pedidos fk_pedidos_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4111 (class 2606 OID 19624)
-- Name: reservas fk_reservas_mesa; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT fk_reservas_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);


--
-- TOC entry 4112 (class 2606 OID 19619)
-- Name: reservas fk_reservas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT fk_reservas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4143 (class 2606 OID 20024)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4083 (class 2606 OID 17003)
-- Name: banco_movimientos fk_banco_movimientos_banco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_banco FOREIGN KEY (banco_id) REFERENCES public.banco(id);


--
-- TOC entry 4084 (class 2606 OID 17008)
-- Name: banco_movimientos fk_banco_movimientos_metodo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES public.metodos_pago(id);


--
-- TOC entry 4085 (class 2606 OID 16903)
-- Name: banco_movimientos fk_banco_movimientos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4086 (class 2606 OID 17013)
-- Name: banco_movimientos fk_banco_movimientos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4082 (class 2606 OID 16898)
-- Name: banco fk_banco_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4078 (class 2606 OID 16988)
-- Name: caja_movimientos fk_caja_movimientos_caja; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_caja FOREIGN KEY (caja_id) REFERENCES public.caja(id);


--
-- TOC entry 4079 (class 2606 OID 16993)
-- Name: caja_movimientos fk_caja_movimientos_metodo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES public.metodos_pago(id);


--
-- TOC entry 4080 (class 2606 OID 16893)
-- Name: caja_movimientos fk_caja_movimientos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4081 (class 2606 OID 16998)
-- Name: caja_movimientos fk_caja_movimientos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4075 (class 2606 OID 16888)
-- Name: caja fk_caja_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4076 (class 2606 OID 16978)
-- Name: caja fk_caja_usuario_apertura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4077 (class 2606 OID 16983)
-- Name: caja fk_caja_usuario_cierre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4048 (class 2606 OID 16818)
-- Name: categoria_egresos fk_categoria_egresos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos
    ADD CONSTRAINT fk_categoria_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4055 (class 2606 OID 16923)
-- Name: compra_detalle fk_compra_detalle_compra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_compra FOREIGN KEY (compra_id) REFERENCES public.compras(id) ON DELETE CASCADE;


--
-- TOC entry 4056 (class 2606 OID 16928)
-- Name: compra_detalle fk_compra_detalle_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES public.ingredientes(id);


--
-- TOC entry 4057 (class 2606 OID 16843)
-- Name: compra_detalle fk_compra_detalle_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4058 (class 2606 OID 16933)
-- Name: compra_detalle fk_compra_detalle_unidad_compra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_unidad_compra FOREIGN KEY (unidad_compra_id) REFERENCES public.unidad_compra(id);


--
-- TOC entry 4053 (class 2606 OID 16918)
-- Name: compras fk_compras_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES public.proveedores(id);


--
-- TOC entry 4054 (class 2606 OID 16838)
-- Name: compras fk_compras_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4073 (class 2606 OID 16938)
-- Name: egresos fk_egresos_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES public.categoria_egresos(id);


--
-- TOC entry 4074 (class 2606 OID 16883)
-- Name: egresos fk_egresos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4071 (class 2606 OID 16973)
-- Name: facturas fk_facturas_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id);


--
-- TOC entry 4072 (class 2606 OID 16878)
-- Name: facturas fk_facturas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4051 (class 2606 OID 16833)
-- Name: ingredientes fk_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4052 (class 2606 OID 16913)
-- Name: ingredientes fk_ingredientes_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES public.unidad_medida(id);


--
-- TOC entry 4063 (class 2606 OID 16858)
-- Name: mesas fk_mesas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4064 (class 2606 OID 16863)
-- Name: meseros fk_meseros_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4044 (class 2606 OID 16803)
-- Name: metodos_pago fk_metodos_pago_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4068 (class 2606 OID 16963)
-- Name: pedido_detalle fk_pedido_detalle_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4069 (class 2606 OID 16968)
-- Name: pedido_detalle fk_pedido_detalle_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_receta FOREIGN KEY (receta_id) REFERENCES public.recetas(id);


--
-- TOC entry 4070 (class 2606 OID 16873)
-- Name: pedido_detalle fk_pedido_detalle_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4065 (class 2606 OID 16953)
-- Name: pedidos fk_pedidos_mesa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES public.mesas(id);


--
-- TOC entry 4066 (class 2606 OID 16958)
-- Name: pedidos fk_pedidos_mesero; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES public.meseros(id);


--
-- TOC entry 4067 (class 2606 OID 16868)
-- Name: pedidos fk_pedidos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4049 (class 2606 OID 16823)
-- Name: proveedores fk_proveedores_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4060 (class 2606 OID 16948)
-- Name: receta_ingredientes fk_receta_ingredientes_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES public.ingredientes(id);


--
-- TOC entry 4061 (class 2606 OID 16943)
-- Name: receta_ingredientes fk_receta_ingredientes_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_receta FOREIGN KEY (receta_id) REFERENCES public.recetas(id) ON DELETE CASCADE;


--
-- TOC entry 4062 (class 2606 OID 16853)
-- Name: receta_ingredientes fk_receta_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4059 (class 2606 OID 16848)
-- Name: recetas fk_recetas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4045 (class 2606 OID 16808)
-- Name: roles fk_roles_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT fk_roles_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4050 (class 2606 OID 16828)
-- Name: unidad_compra fk_unidad_compra_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4046 (class 2606 OID 16813)
-- Name: usuarios fk_usuarios_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4047 (class 2606 OID 16908)
-- Name: usuarios fk_usuarios_rol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES public.roles(id);


--
-- TOC entry 4141 (class 2606 OID 19871)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES sales.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4142 (class 2606 OID 19876)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id);


--
-- TOC entry 4139 (class 2606 OID 19850)
-- Name: orders orders_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES core.restaurante(id);


--
-- TOC entry 4140 (class 2606 OID 19855)
-- Name: orders orders_table_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES core.tables(id);


-- Completed on 2026-03-24 21:06:29 -04

--
-- PostgreSQL database dump complete
--

\unrestrict gtPSSm4ScMjCyeFd4aE2aahPi2ZZR1cCYF5tnYJh9ghIQlJ2qhj8Nt37lYKMQ4E

