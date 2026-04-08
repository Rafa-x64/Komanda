--
-- PostgreSQL database dump
--

\restrict WUAK399PlKghsnngOnAtz92gQCKgYycfoEsreHVHkya4aeirIQKy0EEvD3YoqsA

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-07 20:21:11 -04

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
-- TOC entry 7 (class 2615 OID 16389)
-- Name: contabilidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabilidad;


ALTER SCHEMA contabilidad OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 16390)
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 16391)
-- Name: finanzas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA finanzas;


ALTER SCHEMA finanzas OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 16392)
-- Name: inventario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventario;


ALTER SCHEMA inventario OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 16393)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 16394)
-- Name: menu; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA menu;


ALTER SCHEMA menu OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 16395)
-- Name: operaciones; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA operaciones;


ALTER SCHEMA operaciones OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 16396)
-- Name: sales; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 16397)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4532 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1208 (class 1247 OID 18032)
-- Name: categoria_gasto_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.categoria_gasto_enum AS ENUM (
    'agua',
    'gas',
    'electricidad',
    'internet',
    'alquiler'
);


ALTER TYPE public.categoria_gasto_enum OWNER TO postgres;

--
-- TOC entry 4533 (class 0 OID 0)
-- Dependencies: 1208
-- Name: TYPE categoria_gasto_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.categoria_gasto_enum IS 'Gastos operativos fijos según enunciado académico: agua, gas, electricidad, internet, alquiler';


--
-- TOC entry 995 (class 1247 OID 16409)
-- Name: estado_caja; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_caja AS ENUM (
    'abierta',
    'cerrada'
);


ALTER TYPE public.estado_caja OWNER TO postgres;

--
-- TOC entry 998 (class 1247 OID 16414)
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
-- TOC entry 1001 (class 1247 OID 16424)
-- Name: estado_factura; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_factura AS ENUM (
    'emitida',
    'anulada'
);


ALTER TYPE public.estado_factura OWNER TO postgres;

--
-- TOC entry 1004 (class 1247 OID 16430)
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
-- TOC entry 1007 (class 1247 OID 16440)
-- Name: estado_pago_compra; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pago_compra AS ENUM (
    'pendiente',
    'pagada',
    'parcial'
);


ALTER TYPE public.estado_pago_compra OWNER TO postgres;

--
-- TOC entry 1010 (class 1247 OID 16448)
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
-- TOC entry 1013 (class 1247 OID 16462)
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
-- TOC entry 1205 (class 1247 OID 18022)
-- Name: metodo_pago_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.metodo_pago_enum AS ENUM (
    'efectivo',
    'pago_movil',
    'tarjeta',
    'divisa'
);


ALTER TYPE public.metodo_pago_enum OWNER TO postgres;

--
-- TOC entry 4534 (class 0 OID 0)
-- Dependencies: 1205
-- Name: TYPE metodo_pago_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.metodo_pago_enum IS 'Métodos de pago aceptados: efectivo (Bs), pago_movil (transferencia), tarjeta (débito/crédito), divisa (USD/EUR físico)';


--
-- TOC entry 1016 (class 1247 OID 16474)
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
-- TOC entry 1019 (class 1247 OID 16486)
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
-- TOC entry 1022 (class 1247 OID 16498)
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
-- TOC entry 1025 (class 1247 OID 16510)
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
-- TOC entry 1211 (class 1247 OID 18044)
-- Name: tipo_cuenta_contable_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_cuenta_contable_enum AS ENUM (
    'activo',
    'pasivo',
    'patrimonio',
    'ingreso',
    'costo',
    'gasto'
);


ALTER TYPE public.tipo_cuenta_contable_enum OWNER TO postgres;

--
-- TOC entry 1028 (class 1247 OID 16524)
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
-- TOC entry 1031 (class 1247 OID 16534)
-- Name: tipo_movimiento; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_movimiento AS ENUM (
    'ingreso',
    'egreso'
);


ALTER TYPE public.tipo_movimiento OWNER TO postgres;

--
-- TOC entry 362 (class 1255 OID 16539)
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
-- TOC entry 347 (class 1259 OID 18159)
-- Name: asiento_lineas; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.asiento_lineas (
    id integer NOT NULL,
    asiento_id integer NOT NULL,
    cuenta_id integer NOT NULL,
    tipo_movimiento character varying(5) NOT NULL,
    monto numeric(12,2) NOT NULL,
    descripcion character varying(255),
    restaurante_id integer NOT NULL,
    CONSTRAINT asiento_lineas_monto_check CHECK ((monto > (0)::numeric)),
    CONSTRAINT asiento_lineas_tipo_movimiento_check CHECK (((tipo_movimiento)::text = ANY ((ARRAY['debe'::character varying, 'haber'::character varying])::text[])))
);


ALTER TABLE contabilidad.asiento_lineas OWNER TO postgres;

--
-- TOC entry 4535 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE asiento_lineas; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.asiento_lineas IS 'Líneas de cada asiento contable. Cada asiento tiene N líneas (min. 2: un Debe y un Haber).
La suma de todas las líneas tipo "debe" debe ser igual a la suma de las "haber" en el mismo asiento.
Ejemplo para una Venta:
  DEBE:  Caja/Banco            500.00
  HABER: Ingresos por Ventas   500.00
  DEBE:  Costo de Ventas       180.00
  HABER: Inventario            180.00';


--
-- TOC entry 4536 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN asiento_lineas.tipo_movimiento; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.asiento_lineas.tipo_movimiento IS 'debe = cargo a la cuenta | haber = abono a la cuenta (partida doble)';


--
-- TOC entry 346 (class 1259 OID 18158)
-- Name: asiento_lineas_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.asiento_lineas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.asiento_lineas_id_seq OWNER TO postgres;

--
-- TOC entry 4537 (class 0 OID 0)
-- Dependencies: 346
-- Name: asiento_lineas_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.asiento_lineas_id_seq OWNED BY contabilidad.asiento_lineas.id;


--
-- TOC entry 345 (class 1259 OID 18136)
-- Name: asientos; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.asientos (
    id integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    origen_tipo character varying(50),
    origen_id integer,
    total_debe numeric(12,2) DEFAULT 0 NOT NULL,
    total_haber numeric(12,2) DEFAULT 0 NOT NULL,
    restaurante_id integer NOT NULL,
    creado_por integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE contabilidad.asientos OWNER TO postgres;

--
-- TOC entry 4538 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE asientos; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.asientos IS 'Cabecera del asiento contable. Cada evento del sistema (venta, compra, gasto) genera
un asiento automáticamente. INVARIANTE: total_debe = total_haber (principio de partida doble).';


--
-- TOC entry 4539 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN asientos.origen_tipo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.asientos.origen_tipo IS 'venta: pedido pagado | compra: entrada de mercancía | gasto_operativo: agua/luz/etc | costo_venta: back-flushing';


--
-- TOC entry 344 (class 1259 OID 18135)
-- Name: asientos_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.asientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.asientos_id_seq OWNER TO postgres;

--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 344
-- Name: asientos_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.asientos_id_seq OWNED BY contabilidad.asientos.id;


--
-- TOC entry 228 (class 1259 OID 16540)
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
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE libro_diario; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.libro_diario IS 'Asientos contables para generar Balance General y Estado de Resultados';


--
-- TOC entry 4542 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN libro_diario.tipo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.libro_diario.tipo IS 'Ej: venta, costo_venta, gasto_operativo, compra_insumo, merma';


--
-- TOC entry 229 (class 1259 OID 16553)
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
-- TOC entry 4543 (class 0 OID 0)
-- Dependencies: 229
-- Name: libro_diario_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.libro_diario_id_seq OWNED BY contabilidad.libro_diario.id;


--
-- TOC entry 343 (class 1259 OID 18109)
-- Name: plan_cuentas; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.plan_cuentas (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    tipo public.tipo_cuenta_contable_enum NOT NULL,
    padre_id integer,
    es_auxiliar boolean DEFAULT true,
    restaurante_id integer,
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE contabilidad.plan_cuentas OWNER TO postgres;

--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE plan_cuentas; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.plan_cuentas IS 'Plan de Cuentas Contable. Estructura jerárquica (padre_id) que permite generar
Balance General y Estado de Resultados agrupando por tipo de cuenta.
Las cuentas globales (restaurante_id IS NULL) aplican a todos los restaurantes.';


--
-- TOC entry 4545 (class 0 OID 0)
-- Dependencies: 343
-- Name: COLUMN plan_cuentas.codigo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.plan_cuentas.codigo IS 'Código contable estándar. Ej: 1=Activo, 2=Pasivo, 3=Patrimonio, 4=Ingreso, 5=Costo, 6=Gasto';


--
-- TOC entry 342 (class 1259 OID 18108)
-- Name: plan_cuentas_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.plan_cuentas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.plan_cuentas_id_seq OWNER TO postgres;

--
-- TOC entry 4546 (class 0 OID 0)
-- Dependencies: 342
-- Name: plan_cuentas_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.plan_cuentas_id_seq OWNED BY contabilidad.plan_cuentas.id;


--
-- TOC entry 232 (class 1259 OID 16563)
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
-- TOC entry 348 (class 1259 OID 18190)
-- Name: v_balance_general; Type: VIEW; Schema: contabilidad; Owner: postgres
--

CREATE VIEW contabilidad.v_balance_general AS
 SELECT r.id AS restaurante_id,
    r.nombre AS restaurante,
    pc.tipo,
    pc.codigo,
    pc.nombre AS cuenta,
    COALESCE(sum(
        CASE al.tipo_movimiento
            WHEN 'debe'::text THEN
            CASE
                WHEN ((pc.tipo)::text = ANY (ARRAY['activo'::text, 'costo'::text, 'gasto'::text])) THEN al.monto
                ELSE (- al.monto)
            END
            WHEN 'haber'::text THEN
            CASE
                WHEN ((pc.tipo)::text = ANY (ARRAY['activo'::text, 'costo'::text, 'gasto'::text])) THEN (- al.monto)
                ELSE al.monto
            END
            ELSE NULL::numeric
        END), (0)::numeric) AS saldo
   FROM (((contabilidad.plan_cuentas pc
     CROSS JOIN core.restaurante r)
     LEFT JOIN contabilidad.asiento_lineas al ON (((al.cuenta_id = pc.id) AND (al.restaurante_id = r.id))))
     LEFT JOIN contabilidad.asientos a ON (((a.id = al.asiento_id) AND (a.restaurante_id = r.id))))
  WHERE (pc.es_auxiliar = true)
  GROUP BY r.id, r.nombre, pc.tipo, pc.codigo, pc.nombre
  ORDER BY pc.codigo;


ALTER VIEW contabilidad.v_balance_general OWNER TO postgres;

--
-- TOC entry 4547 (class 0 OID 0)
-- Dependencies: 348
-- Name: VIEW v_balance_general; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON VIEW contabilidad.v_balance_general IS 'Vista del Balance General y Estado de Resultados. Filtrar por restaurante_id y rango de fechas
usando JOIN con contabilidad.asientos.';


--
-- TOC entry 349 (class 1259 OID 18195)
-- Name: v_estado_resultados; Type: VIEW; Schema: contabilidad; Owner: postgres
--

CREATE VIEW contabilidad.v_estado_resultados AS
 SELECT al.restaurante_id,
    a.fecha,
    pc.tipo,
    pc.nombre AS cuenta,
    sum(
        CASE al.tipo_movimiento
            WHEN 'debe'::text THEN
            CASE
                WHEN ((pc.tipo)::text = ANY (ARRAY['costo'::text, 'gasto'::text])) THEN al.monto
                ELSE (- al.monto)
            END
            WHEN 'haber'::text THEN
            CASE
                WHEN ((pc.tipo)::text = 'ingreso'::text) THEN al.monto
                ELSE (- al.monto)
            END
            ELSE NULL::numeric
        END) AS monto
   FROM ((contabilidad.asiento_lineas al
     JOIN contabilidad.asientos a ON ((a.id = al.asiento_id)))
     JOIN contabilidad.plan_cuentas pc ON ((pc.id = al.cuenta_id)))
  WHERE ((pc.tipo)::text = ANY (ARRAY['ingreso'::text, 'costo'::text, 'gasto'::text]))
  GROUP BY al.restaurante_id, a.fecha, pc.tipo, pc.nombre
  ORDER BY a.fecha, (pc.tipo)::text;


ALTER VIEW contabilidad.v_estado_resultados OWNER TO postgres;

--
-- TOC entry 4548 (class 0 OID 0)
-- Dependencies: 349
-- Name: VIEW v_estado_resultados; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON VIEW contabilidad.v_estado_resultados IS 'Estado de Resultados por fecha. Para obtener el total de un período:
SELECT tipo, cuenta, SUM(monto) FROM contabilidad.v_estado_resultados
WHERE restaurante_id = X AND fecha BETWEEN inicio AND fin
GROUP BY tipo, cuenta;';


--
-- TOC entry 230 (class 1259 OID 16554)
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
-- TOC entry 231 (class 1259 OID 16562)
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
-- TOC entry 4549 (class 0 OID 0)
-- Dependencies: 231
-- Name: metodos_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.metodos_pago_id_seq OWNED BY core.metodos_pago.id;


--
-- TOC entry 233 (class 1259 OID 16586)
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
-- TOC entry 4550 (class 0 OID 0)
-- Dependencies: 233
-- Name: restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.restaurante_id_seq OWNED BY core.restaurante.id;


--
-- TOC entry 234 (class 1259 OID 16587)
-- Name: roles; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.roles OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16594)
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
-- TOC entry 4551 (class 0 OID 0)
-- Dependencies: 235
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.roles_id_seq OWNED BY core.roles.id;


--
-- TOC entry 236 (class 1259 OID 16595)
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
-- TOC entry 237 (class 1259 OID 16602)
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
-- TOC entry 4552 (class 0 OID 0)
-- Dependencies: 237
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.tables_id_seq OWNED BY core.tables.id;


--
-- TOC entry 238 (class 1259 OID 16603)
-- Name: unidad_medida; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.unidad_medida (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    abreviatura character varying(5) NOT NULL
);


ALTER TABLE core.unidad_medida OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16609)
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
-- TOC entry 4553 (class 0 OID 0)
-- Dependencies: 239
-- Name: unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.unidad_medida_id_seq OWNED BY core.unidad_medida.id;


--
-- TOC entry 240 (class 1259 OID 16610)
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
-- TOC entry 241 (class 1259 OID 16628)
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
-- TOC entry 4554 (class 0 OID 0)
-- Dependencies: 241
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.usuarios_id_seq OWNED BY core.usuarios.id;


--
-- TOC entry 242 (class 1259 OID 16629)
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
-- TOC entry 243 (class 1259 OID 16640)
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
-- TOC entry 4555 (class 0 OID 0)
-- Dependencies: 243
-- Name: banco_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.banco_id_seq OWNED BY finanzas.banco.id;


--
-- TOC entry 244 (class 1259 OID 16641)
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
-- TOC entry 4556 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE banco_movimientos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';


--
-- TOC entry 245 (class 1259 OID 16655)
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
-- TOC entry 4557 (class 0 OID 0)
-- Dependencies: 245
-- Name: banco_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.banco_movimientos_id_seq OWNED BY finanzas.banco_movimientos.id;


--
-- TOC entry 246 (class 1259 OID 16656)
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
-- TOC entry 247 (class 1259 OID 16668)
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
-- TOC entry 4558 (class 0 OID 0)
-- Dependencies: 247
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.caja_id_seq OWNED BY finanzas.caja.id;


--
-- TOC entry 248 (class 1259 OID 16669)
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
-- TOC entry 4559 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE caja_movimientos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';


--
-- TOC entry 249 (class 1259 OID 16683)
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
-- TOC entry 4560 (class 0 OID 0)
-- Dependencies: 249
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.caja_movimientos_id_seq OWNED BY finanzas.caja_movimientos.id;


--
-- TOC entry 250 (class 1259 OID 16684)
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
-- TOC entry 251 (class 1259 OID 16696)
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
-- TOC entry 4561 (class 0 OID 0)
-- Dependencies: 251
-- Name: egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.egresos_id_seq OWNED BY finanzas.egresos.id;


--
-- TOC entry 341 (class 1259 OID 18085)
-- Name: gastos_operativos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.gastos_operativos (
    id integer NOT NULL,
    categoria public.categoria_gasto_enum NOT NULL,
    descripcion character varying(255),
    monto numeric(12,2) NOT NULL,
    fecha date NOT NULL,
    metodo_pago public.metodo_pago_enum DEFAULT 'efectivo'::public.metodo_pago_enum NOT NULL,
    referencia character varying(100),
    periodo_mes integer,
    periodo_anio integer,
    usuario_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT gastos_operativos_monto_check CHECK ((monto > (0)::numeric)),
    CONSTRAINT gastos_operativos_periodo_mes_check CHECK (((periodo_mes >= 1) AND (periodo_mes <= 12)))
);


ALTER TABLE finanzas.gastos_operativos OWNER TO postgres;

--
-- TOC entry 4562 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE gastos_operativos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.gastos_operativos IS 'Gastos operativos fijos del restaurante. Según el enunciado académico solo se registran:
agua, gas, electricidad, internet y alquiler. Cada registro genera un asiento contable automático
en contabilidad.asientos (Debe: Gasto / Haber: Caja o Banco).';


--
-- TOC entry 4563 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN gastos_operativos.categoria; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON COLUMN finanzas.gastos_operativos.categoria IS 'Una de las 5 categorías del enunciado: agua, gas, electricidad, internet, alquiler.';


--
-- TOC entry 4564 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN gastos_operativos.periodo_mes; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON COLUMN finanzas.gastos_operativos.periodo_mes IS 'Mes al que corresponde el gasto (puede diferir de la fecha de pago). Usado en Estado de Resultados.';


--
-- TOC entry 340 (class 1259 OID 18084)
-- Name: gastos_operativos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.gastos_operativos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.gastos_operativos_id_seq OWNER TO postgres;

--
-- TOC entry 4565 (class 0 OID 0)
-- Dependencies: 340
-- Name: gastos_operativos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.gastos_operativos_id_seq OWNED BY finanzas.gastos_operativos.id;


--
-- TOC entry 252 (class 1259 OID 16697)
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
-- TOC entry 4566 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN categoria_egresos.nombre; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.categoria_egresos.nombre IS 'Ej: proveedores, servicios, nomina, otros';


--
-- TOC entry 253 (class 1259 OID 16704)
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
-- TOC entry 4567 (class 0 OID 0)
-- Dependencies: 253
-- Name: categoria_egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.categoria_egresos_id_seq OWNED BY inventario.categoria_egresos.id;


--
-- TOC entry 254 (class 1259 OID 16705)
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
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN compra_detalle.factor_conversion; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.compra_detalle.factor_conversion IS 'Multiplicador para convertir Unidad Compra -> Unidad Inventario (ej. 1 Saco = 50000 gr)';


--
-- TOC entry 255 (class 1259 OID 16717)
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
-- TOC entry 4569 (class 0 OID 0)
-- Dependencies: 255
-- Name: compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.compra_detalle_id_seq OWNED BY inventario.compra_detalle.id;


--
-- TOC entry 256 (class 1259 OID 16718)
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
-- TOC entry 257 (class 1259 OID 16728)
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
-- TOC entry 4570 (class 0 OID 0)
-- Dependencies: 257
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.compras_id_seq OWNED BY inventario.compras.id;


--
-- TOC entry 258 (class 1259 OID 16729)
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
-- TOC entry 4571 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE ingredientes; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON TABLE inventario.ingredientes IS 'Inventario de materias primas con costo promedio ponderado';


--
-- TOC entry 4572 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN ingredientes.merma_teorica_porcentaje; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.ingredientes.merma_teorica_porcentaje IS '% de pérdida natural (ej. cáscaras, huesos) para cálculo preciso de costos del ingrediente limpio';


--
-- TOC entry 259 (class 1259 OID 16742)
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
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 259
-- Name: ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.ingredientes_id_seq OWNED BY inventario.ingredientes.id;


--
-- TOC entry 260 (class 1259 OID 16743)
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
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE mermas; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON TABLE inventario.mermas IS 'Registro de pérdidas de inventario para conciliar stock teórico vs real';


--
-- TOC entry 261 (class 1259 OID 16757)
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
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 261
-- Name: mermas_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.mermas_id_seq OWNED BY inventario.mermas.id;


--
-- TOC entry 262 (class 1259 OID 16758)
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
-- TOC entry 263 (class 1259 OID 16770)
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
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 263
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.proveedores_id_seq OWNED BY inventario.proveedores.id;


--
-- TOC entry 264 (class 1259 OID 16771)
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
-- TOC entry 265 (class 1259 OID 16778)
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
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 265
-- Name: unidad_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.unidad_compra_id_seq OWNED BY inventario.unidad_compra.id;


--
-- TOC entry 266 (class 1259 OID 16779)
-- Name: categories; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.categories (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE inventory.categories OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 16784)
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
-- TOC entry 4578 (class 0 OID 0)
-- Dependencies: 267
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.categories_id_seq OWNED BY inventory.categories.id;


--
-- TOC entry 268 (class 1259 OID 16785)
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
-- TOC entry 269 (class 1259 OID 16792)
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
-- TOC entry 4579 (class 0 OID 0)
-- Dependencies: 269
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.products_id_seq OWNED BY inventory.products.id;


--
-- TOC entry 270 (class 1259 OID 16793)
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
-- TOC entry 4580 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE categorias; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON TABLE menu.categorias IS 'Categorías del menú: Entradas, Platos Fuertes, Bebidas, Postres, etc.';


--
-- TOC entry 271 (class 1259 OID 16803)
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
-- TOC entry 4581 (class 0 OID 0)
-- Dependencies: 271
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.categorias_id_seq OWNED BY menu.categorias.id;


--
-- TOC entry 272 (class 1259 OID 16804)
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
-- TOC entry 273 (class 1259 OID 16812)
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
-- TOC entry 4582 (class 0 OID 0)
-- Dependencies: 273
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.receta_ingredientes_id_seq OWNED BY menu.receta_ingredientes.id;


--
-- TOC entry 274 (class 1259 OID 16813)
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
-- TOC entry 4583 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE recetas; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON TABLE menu.recetas IS 'Recetas estándar (BOM - Bill of Materials) del menú';


--
-- TOC entry 275 (class 1259 OID 16828)
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
-- TOC entry 4584 (class 0 OID 0)
-- Dependencies: 275
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.recetas_id_seq OWNED BY menu.recetas.id;


--
-- TOC entry 351 (class 1259 OID 18204)
-- Name: v_rentabilidad_platos; Type: VIEW; Schema: menu; Owner: postgres
--

CREATE VIEW menu.v_rentabilidad_platos AS
 SELECT restaurante_id,
    id AS receta_id,
    nombre AS plato,
    costo_produccion,
    precio_sugerido,
    precio_venta,
        CASE
            WHEN (precio_venta > (0)::numeric) THEN round((((precio_venta - costo_produccion) / precio_venta) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS margen_real_porcentaje,
        CASE
            WHEN (precio_venta > (0)::numeric) THEN (precio_venta - costo_produccion)
            ELSE (0)::numeric
        END AS utilidad_por_plato
   FROM menu.recetas r
  WHERE (activo = true);


ALTER VIEW menu.v_rentabilidad_platos OWNER TO postgres;

--
-- TOC entry 4585 (class 0 OID 0)
-- Dependencies: 351
-- Name: VIEW v_rentabilidad_platos; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON VIEW menu.v_rentabilidad_platos IS 'Reporte de rentabilidad por plato. Compara costo_produccion (CPP de ingredientes * cantidades)
vs precio_venta. El campo costo_produccion debe actualizarse cuando cambia el CPP de un ingrediente.';


--
-- TOC entry 276 (class 1259 OID 16829)
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
-- TOC entry 277 (class 1259 OID 16847)
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
-- TOC entry 4586 (class 0 OID 0)
-- Dependencies: 277
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.facturas_id_seq OWNED BY operaciones.facturas.id;


--
-- TOC entry 278 (class 1259 OID 16848)
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
-- TOC entry 279 (class 1259 OID 16858)
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
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 279
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.mesas_id_seq OWNED BY operaciones.mesas.id;


--
-- TOC entry 280 (class 1259 OID 16859)
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
-- TOC entry 281 (class 1259 OID 16868)
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
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 281
-- Name: meseros_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.meseros_id_seq OWNED BY operaciones.meseros.id;


--
-- TOC entry 282 (class 1259 OID 16869)
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
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN pedido_detalle.notas; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.pedido_detalle.notas IS 'Instrucciones para cocina: "Sin piña", "Extra queso", etc.';


--
-- TOC entry 283 (class 1259 OID 16881)
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
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 283
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.pedido_detalle_id_seq OWNED BY operaciones.pedido_detalle.id;


--
-- TOC entry 284 (class 1259 OID 16882)
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
-- TOC entry 285 (class 1259 OID 16898)
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
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 285
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.pedidos_id_seq OWNED BY operaciones.pedidos.id;


--
-- TOC entry 286 (class 1259 OID 16899)
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
-- TOC entry 287 (class 1259 OID 16912)
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
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 287
-- Name: reservas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.reservas_id_seq OWNED BY operaciones.reservas.id;


--
-- TOC entry 339 (class 1259 OID 18058)
-- Name: transacciones_pago; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.transacciones_pago (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    metodo public.metodo_pago_enum NOT NULL,
    monto numeric(12,2) NOT NULL,
    referencia character varying(100),
    tasa_cambio numeric(12,4) DEFAULT 1,
    usuario_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transacciones_pago_monto_check CHECK ((monto > (0)::numeric))
);


ALTER TABLE operaciones.transacciones_pago OWNER TO postgres;

--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE transacciones_pago; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON TABLE operaciones.transacciones_pago IS 'Registro de método(s) de pago por pedido. Un pedido puede tener múltiples filas (pago mixto).
Permite arqueo por método: SUM(monto) WHERE metodo = ''efectivo'' AND caja_id = X';


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN transacciones_pago.referencia; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.transacciones_pago.referencia IS 'Número de confirmación (pago móvil), últimos 4 dígitos (tarjeta) o identificador libre.';


--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN transacciones_pago.tasa_cambio; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.transacciones_pago.tasa_cambio IS 'Aplica cuando metodo=divisa. Registra la tasa Bs/USD vigente al momento de la transacción para reportes contables correctos.';


--
-- TOC entry 338 (class 1259 OID 18057)
-- Name: transacciones_pago_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.transacciones_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.transacciones_pago_id_seq OWNER TO postgres;

--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 338
-- Name: transacciones_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.transacciones_pago_id_seq OWNED BY operaciones.transacciones_pago.id;


--
-- TOC entry 350 (class 1259 OID 18200)
-- Name: v_arqueo_caja; Type: VIEW; Schema: operaciones; Owner: postgres
--

CREATE VIEW operaciones.v_arqueo_caja AS
 SELECT restaurante_id,
    date(created_at) AS fecha,
    metodo AS metodo_pago,
    count(id) AS num_transacciones,
    sum(monto) AS total_recaudado
   FROM operaciones.transacciones_pago tp
  GROUP BY restaurante_id, (date(created_at)), metodo
  ORDER BY restaurante_id, (date(created_at)), metodo;


ALTER VIEW operaciones.v_arqueo_caja OWNER TO postgres;

--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 350
-- Name: VIEW v_arqueo_caja; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON VIEW operaciones.v_arqueo_caja IS 'Resumen del arqueo de caja por día y método de pago.
Filtra por restaurante_id y fecha para el cierre diario.
Muestra cuánto se recaudó en efectivo, pago_movil, tarjeta y divisa por separado.';


--
-- TOC entry 288 (class 1259 OID 16913)
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
-- TOC entry 289 (class 1259 OID 16922)
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
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 289
-- Name: banco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banco_id_seq OWNED BY public.banco.id;


--
-- TOC entry 290 (class 1259 OID 16923)
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
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE banco_movimientos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';


--
-- TOC entry 291 (class 1259 OID 16934)
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
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 291
-- Name: banco_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banco_movimientos_id_seq OWNED BY public.banco_movimientos.id;


--
-- TOC entry 292 (class 1259 OID 16935)
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
-- TOC entry 293 (class 1259 OID 16945)
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
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 293
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 294 (class 1259 OID 16946)
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
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE caja_movimientos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';


--
-- TOC entry 295 (class 1259 OID 16957)
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
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 295
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_movimientos_id_seq OWNED BY public.caja_movimientos.id;


--
-- TOC entry 296 (class 1259 OID 16958)
-- Name: categoria_egresos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_egresos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.categoria_egresos OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 16964)
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
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 297
-- Name: categoria_egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_egresos_id_seq OWNED BY public.categoria_egresos.id;


--
-- TOC entry 298 (class 1259 OID 16965)
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
-- TOC entry 299 (class 1259 OID 16975)
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
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 299
-- Name: compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compra_detalle_id_seq OWNED BY public.compra_detalle.id;


--
-- TOC entry 300 (class 1259 OID 16976)
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
-- TOC entry 301 (class 1259 OID 16983)
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
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 301
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;


--
-- TOC entry 302 (class 1259 OID 16984)
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
-- TOC entry 303 (class 1259 OID 16995)
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
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 303
-- Name: egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.egresos_id_seq OWNED BY public.egresos.id;


--
-- TOC entry 304 (class 1259 OID 16996)
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
-- TOC entry 305 (class 1259 OID 17007)
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
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 305
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- TOC entry 306 (class 1259 OID 17008)
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
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE ingredientes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ingredientes IS 'Inventario de materias primas con costo promedio';


--
-- TOC entry 307 (class 1259 OID 17018)
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
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 307
-- Name: ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredientes_id_seq OWNED BY public.ingredientes.id;


--
-- TOC entry 308 (class 1259 OID 17019)
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
-- TOC entry 309 (class 1259 OID 17026)
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
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 309
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mesas_id_seq OWNED BY public.mesas.id;


--
-- TOC entry 310 (class 1259 OID 17027)
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
-- TOC entry 311 (class 1259 OID 17034)
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
-- TOC entry 4612 (class 0 OID 0)
-- Dependencies: 311
-- Name: meseros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meseros_id_seq OWNED BY public.meseros.id;


--
-- TOC entry 312 (class 1259 OID 17035)
-- Name: metodos_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metodos_pago (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.metodos_pago OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 17041)
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
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 313
-- Name: metodos_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metodos_pago_id_seq OWNED BY public.metodos_pago.id;


--
-- TOC entry 314 (class 1259 OID 17042)
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
-- TOC entry 315 (class 1259 OID 17054)
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
-- TOC entry 316 (class 1259 OID 17071)
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
-- TOC entry 317 (class 1259 OID 17081)
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
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 317
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_detalle_id_seq OWNED BY public.pedido_detalle.id;


--
-- TOC entry 318 (class 1259 OID 17082)
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
-- TOC entry 319 (class 1259 OID 17090)
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
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 319
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- TOC entry 320 (class 1259 OID 17091)
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
-- TOC entry 321 (class 1259 OID 17103)
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
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 321
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;


--
-- TOC entry 322 (class 1259 OID 17104)
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
-- TOC entry 323 (class 1259 OID 17112)
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
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 323
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receta_ingredientes_id_seq OWNED BY public.receta_ingredientes.id;


--
-- TOC entry 324 (class 1259 OID 17113)
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
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE recetas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.recetas IS 'Recetas estándar (BOM - Bill of Materials)';


--
-- TOC entry 325 (class 1259 OID 17126)
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
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 325
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recetas_id_seq OWNED BY public.recetas.id;


--
-- TOC entry 326 (class 1259 OID 17127)
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
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE restaurante; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.restaurante IS 'Tabla base para multi-tenencia';


--
-- TOC entry 327 (class 1259 OID 17135)
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
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 327
-- Name: restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restaurante_id_seq OWNED BY public.restaurante.id;


--
-- TOC entry 328 (class 1259 OID 17136)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 17142)
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
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 329
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 330 (class 1259 OID 17143)
-- Name: unidad_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_compra (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.unidad_compra OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 17149)
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
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 331
-- Name: unidad_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_compra_id_seq OWNED BY public.unidad_compra.id;


--
-- TOC entry 332 (class 1259 OID 17150)
-- Name: unidad_medida; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_medida (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    abreviatura character varying(5) NOT NULL
);


ALTER TABLE public.unidad_medida OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 17156)
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
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 333
-- Name: unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_medida_id_seq OWNED BY public.unidad_medida.id;


--
-- TOC entry 334 (class 1259 OID 17157)
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
-- TOC entry 335 (class 1259 OID 17167)
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
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 335
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 336 (class 1259 OID 17168)
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
-- TOC entry 337 (class 1259 OID 17177)
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
-- TOC entry 3899 (class 2604 OID 18162)
-- Name: asiento_lineas id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas ALTER COLUMN id SET DEFAULT nextval('contabilidad.asiento_lineas_id_seq'::regclass);


--
-- TOC entry 3895 (class 2604 OID 18139)
-- Name: asientos id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos ALTER COLUMN id SET DEFAULT nextval('contabilidad.asientos_id_seq'::regclass);


--
-- TOC entry 3713 (class 2604 OID 17968)
-- Name: libro_diario id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario ALTER COLUMN id SET DEFAULT nextval('contabilidad.libro_diario_id_seq'::regclass);


--
-- TOC entry 3891 (class 2604 OID 18112)
-- Name: plan_cuentas id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas ALTER COLUMN id SET DEFAULT nextval('contabilidad.plan_cuentas_id_seq'::regclass);


--
-- TOC entry 3717 (class 2604 OID 17969)
-- Name: metodos_pago id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago ALTER COLUMN id SET DEFAULT nextval('core.metodos_pago_id_seq'::regclass);


--
-- TOC entry 3720 (class 2604 OID 17970)
-- Name: restaurante id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.restaurante ALTER COLUMN id SET DEFAULT nextval('core.restaurante_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 17971)
-- Name: roles id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.roles ALTER COLUMN id SET DEFAULT nextval('core.roles_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 17972)
-- Name: tables id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.tables ALTER COLUMN id SET DEFAULT nextval('core.tables_id_seq'::regclass);


--
-- TOC entry 3734 (class 2604 OID 17973)
-- Name: unidad_medida id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.unidad_medida ALTER COLUMN id SET DEFAULT nextval('core.unidad_medida_id_seq'::regclass);


--
-- TOC entry 3735 (class 2604 OID 17974)
-- Name: usuarios id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios ALTER COLUMN id SET DEFAULT nextval('core.usuarios_id_seq'::regclass);


--
-- TOC entry 3739 (class 2604 OID 17975)
-- Name: banco id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco ALTER COLUMN id SET DEFAULT nextval('finanzas.banco_id_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 17976)
-- Name: banco_movimientos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos ALTER COLUMN id SET DEFAULT nextval('finanzas.banco_movimientos_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 17977)
-- Name: caja id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja ALTER COLUMN id SET DEFAULT nextval('finanzas.caja_id_seq'::regclass);


--
-- TOC entry 3749 (class 2604 OID 17978)
-- Name: caja_movimientos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('finanzas.caja_movimientos_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 17979)
-- Name: egresos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos ALTER COLUMN id SET DEFAULT nextval('finanzas.egresos_id_seq'::regclass);


--
-- TOC entry 3888 (class 2604 OID 18088)
-- Name: gastos_operativos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.gastos_operativos ALTER COLUMN id SET DEFAULT nextval('finanzas.gastos_operativos_id_seq'::regclass);


--
-- TOC entry 3753 (class 2604 OID 17980)
-- Name: categoria_egresos id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos ALTER COLUMN id SET DEFAULT nextval('inventario.categoria_egresos_id_seq'::regclass);


--
-- TOC entry 3755 (class 2604 OID 17981)
-- Name: compra_detalle id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle ALTER COLUMN id SET DEFAULT nextval('inventario.compra_detalle_id_seq'::regclass);


--
-- TOC entry 3757 (class 2604 OID 17982)
-- Name: compras id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras ALTER COLUMN id SET DEFAULT nextval('inventario.compras_id_seq'::regclass);


--
-- TOC entry 3761 (class 2604 OID 17983)
-- Name: ingredientes id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes ALTER COLUMN id SET DEFAULT nextval('inventario.ingredientes_id_seq'::regclass);


--
-- TOC entry 3768 (class 2604 OID 17984)
-- Name: mermas id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas ALTER COLUMN id SET DEFAULT nextval('inventario.mermas_id_seq'::regclass);


--
-- TOC entry 3771 (class 2604 OID 17985)
-- Name: proveedores id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores ALTER COLUMN id SET DEFAULT nextval('inventario.proveedores_id_seq'::regclass);


--
-- TOC entry 3775 (class 2604 OID 17986)
-- Name: unidad_compra id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra ALTER COLUMN id SET DEFAULT nextval('inventario.unidad_compra_id_seq'::regclass);


--
-- TOC entry 3777 (class 2604 OID 17987)
-- Name: categories id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.categories ALTER COLUMN id SET DEFAULT nextval('inventory.categories_id_seq'::regclass);


--
-- TOC entry 3778 (class 2604 OID 17988)
-- Name: products id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products ALTER COLUMN id SET DEFAULT nextval('inventory.products_id_seq'::regclass);


--
-- TOC entry 3780 (class 2604 OID 17989)
-- Name: categorias id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias ALTER COLUMN id SET DEFAULT nextval('menu.categorias_id_seq'::regclass);


--
-- TOC entry 3785 (class 2604 OID 17990)
-- Name: receta_ingredientes id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes ALTER COLUMN id SET DEFAULT nextval('menu.receta_ingredientes_id_seq'::regclass);


--
-- TOC entry 3786 (class 2604 OID 17991)
-- Name: recetas id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas ALTER COLUMN id SET DEFAULT nextval('menu.recetas_id_seq'::regclass);


--
-- TOC entry 3794 (class 2604 OID 17992)
-- Name: facturas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas ALTER COLUMN id SET DEFAULT nextval('operaciones.facturas_id_seq'::regclass);


--
-- TOC entry 3801 (class 2604 OID 17993)
-- Name: mesas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas ALTER COLUMN id SET DEFAULT nextval('operaciones.mesas_id_seq'::regclass);


--
-- TOC entry 3805 (class 2604 OID 17994)
-- Name: meseros id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros ALTER COLUMN id SET DEFAULT nextval('operaciones.meseros_id_seq'::regclass);


--
-- TOC entry 3809 (class 2604 OID 17995)
-- Name: pedido_detalle id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('operaciones.pedido_detalle_id_seq'::regclass);


--
-- TOC entry 3810 (class 2604 OID 17996)
-- Name: pedidos id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos ALTER COLUMN id SET DEFAULT nextval('operaciones.pedidos_id_seq'::regclass);


--
-- TOC entry 3820 (class 2604 OID 17997)
-- Name: reservas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas ALTER COLUMN id SET DEFAULT nextval('operaciones.reservas_id_seq'::regclass);


--
-- TOC entry 3885 (class 2604 OID 18061)
-- Name: transacciones_pago id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago ALTER COLUMN id SET DEFAULT nextval('operaciones.transacciones_pago_id_seq'::regclass);


--
-- TOC entry 3824 (class 2604 OID 17998)
-- Name: banco id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco ALTER COLUMN id SET DEFAULT nextval('public.banco_id_seq'::regclass);


--
-- TOC entry 3827 (class 2604 OID 17999)
-- Name: banco_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos ALTER COLUMN id SET DEFAULT nextval('public.banco_movimientos_id_seq'::regclass);


--
-- TOC entry 3828 (class 2604 OID 18000)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 3829 (class 2604 OID 18001)
-- Name: caja_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('public.caja_movimientos_id_seq'::regclass);


--
-- TOC entry 3830 (class 2604 OID 18002)
-- Name: categoria_egresos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos ALTER COLUMN id SET DEFAULT nextval('public.categoria_egresos_id_seq'::regclass);


--
-- TOC entry 3831 (class 2604 OID 18003)
-- Name: compra_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle ALTER COLUMN id SET DEFAULT nextval('public.compra_detalle_id_seq'::regclass);


--
-- TOC entry 3832 (class 2604 OID 18004)
-- Name: compras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);


--
-- TOC entry 3833 (class 2604 OID 18005)
-- Name: egresos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos ALTER COLUMN id SET DEFAULT nextval('public.egresos_id_seq'::regclass);


--
-- TOC entry 3834 (class 2604 OID 18006)
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- TOC entry 3836 (class 2604 OID 18007)
-- Name: ingredientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes ALTER COLUMN id SET DEFAULT nextval('public.ingredientes_id_seq'::regclass);


--
-- TOC entry 3840 (class 2604 OID 18008)
-- Name: mesas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas ALTER COLUMN id SET DEFAULT nextval('public.mesas_id_seq'::regclass);


--
-- TOC entry 3841 (class 2604 OID 18009)
-- Name: meseros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros ALTER COLUMN id SET DEFAULT nextval('public.meseros_id_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 18010)
-- Name: metodos_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago ALTER COLUMN id SET DEFAULT nextval('public.metodos_pago_id_seq'::regclass);


--
-- TOC entry 3853 (class 2604 OID 18011)
-- Name: pedido_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('public.pedido_detalle_id_seq'::regclass);


--
-- TOC entry 3854 (class 2604 OID 18012)
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- TOC entry 3856 (class 2604 OID 18013)
-- Name: proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);


--
-- TOC entry 3860 (class 2604 OID 18014)
-- Name: receta_ingredientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes ALTER COLUMN id SET DEFAULT nextval('public.receta_ingredientes_id_seq'::regclass);


--
-- TOC entry 3861 (class 2604 OID 18015)
-- Name: recetas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas ALTER COLUMN id SET DEFAULT nextval('public.recetas_id_seq'::regclass);


--
-- TOC entry 3867 (class 2604 OID 18016)
-- Name: restaurante id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurante ALTER COLUMN id SET DEFAULT nextval('public.restaurante_id_seq'::regclass);


--
-- TOC entry 3871 (class 2604 OID 18017)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3872 (class 2604 OID 18018)
-- Name: unidad_compra id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra ALTER COLUMN id SET DEFAULT nextval('public.unidad_compra_id_seq'::regclass);


--
-- TOC entry 3873 (class 2604 OID 18019)
-- Name: unidad_medida id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida ALTER COLUMN id SET DEFAULT nextval('public.unidad_medida_id_seq'::regclass);


--
-- TOC entry 3874 (class 2604 OID 18020)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 4526 (class 0 OID 18159)
-- Dependencies: 347
-- Data for Name: asiento_lineas; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.asiento_lineas (id, asiento_id, cuenta_id, tipo_movimiento, monto, descripcion, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4524 (class 0 OID 18136)
-- Dependencies: 345
-- Data for Name: asientos; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.asientos (id, fecha, descripcion, origen_tipo, origen_id, total_debe, total_haber, restaurante_id, creado_por, created_at) FROM stdin;
\.


--
-- TOC entry 4407 (class 0 OID 16540)
-- Dependencies: 228
-- Data for Name: libro_diario; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.libro_diario (id, fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id, created_at) FROM stdin;
1	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	7.15	0.00	venta	13	1	2026-04-04 00:02:27.408462
2	2026-04-04	Ingresos por Ventas	venta	0.00	7.15	venta	13	1	2026-04-04 00:02:27.408462
3	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	13	1	2026-04-04 00:02:27.408462
4	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	13	1	2026-04-04 00:02:27.408462
5	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	14	1	2026-04-04 00:12:52.31896
6	2026-04-04	Ingresos por Ventas	venta	0.00	10.45	venta	14	1	2026-04-04 00:12:52.31896
7	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	14	1	2026-04-04 00:12:52.31896
8	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	14	1	2026-04-04 00:12:52.31896
9	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	15	1	2026-04-04 00:16:00.581704
10	2026-04-04	Ingresos por Ventas	venta	0.00	10.45	venta	15	1	2026-04-04 00:16:00.581704
11	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	15	1	2026-04-04 00:16:00.581704
12	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	15	1	2026-04-04 00:16:00.581704
13	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	5.50	0.00	venta	16	1	2026-04-04 00:19:26.132213
14	2026-04-04	Ingresos por Ventas	venta	0.00	5.50	venta	16	1	2026-04-04 00:19:26.132213
15	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	16	1	2026-04-04 00:19:26.132213
16	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	16	1	2026-04-04 00:19:26.132213
17	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	5.50	0.00	venta	17	1	2026-04-04 00:31:51.480405
18	2026-04-04	Ingresos por Ventas	venta	0.00	5.50	venta	17	1	2026-04-04 00:31:51.480405
19	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	17	1	2026-04-04 00:31:51.480405
20	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	17	1	2026-04-04 00:31:51.480405
21	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	28.60	0.00	venta	18	1	2026-04-04 00:33:29.339811
22	2026-04-04	Ingresos por Ventas	venta	0.00	28.60	venta	18	1	2026-04-04 00:33:29.339811
23	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	18	1	2026-04-04 00:33:29.339811
24	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	18	1	2026-04-04 00:33:29.339811
25	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	9.90	0.00	venta	19	1	2026-04-04 00:33:51.007441
26	2026-04-04	Ingresos por Ventas	venta	0.00	9.90	venta	19	1	2026-04-04 00:33:51.007441
27	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	19	1	2026-04-04 00:33:51.007441
28	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	19	1	2026-04-04 00:33:51.007441
\.


--
-- TOC entry 4522 (class 0 OID 18109)
-- Dependencies: 343
-- Data for Name: plan_cuentas; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.plan_cuentas (id, codigo, nombre, tipo, padre_id, es_auxiliar, restaurante_id, activo, created_at) FROM stdin;
1	1	ACTIVOS	activo	\N	f	\N	t	2026-03-31 21:43:41.142979
6	2	PASIVOS	pasivo	\N	f	\N	t	2026-03-31 21:43:41.142979
9	3	PATRIMONIO	patrimonio	\N	f	\N	t	2026-03-31 21:43:41.142979
13	4	INGRESOS	ingreso	\N	f	\N	t	2026-03-31 21:43:41.142979
15	5	COSTOS DE VENTA	costo	\N	f	\N	t	2026-03-31 21:43:41.142979
17	6	GASTOS OPERATIVOS	gasto	\N	f	\N	t	2026-03-31 21:43:41.142979
2	1.1	Activos Corrientes	activo	1	f	\N	t	2026-03-31 21:43:41.142979
3	1.1.01	Caja	activo	2	t	\N	t	2026-03-31 21:43:41.142979
4	1.1.02	Banco	activo	2	t	\N	t	2026-03-31 21:43:41.142979
5	1.1.03	Inventario de Insumos	activo	2	t	\N	t	2026-03-31 21:43:41.142979
7	2.1	Pasivos Corrientes	pasivo	6	f	\N	t	2026-03-31 21:43:41.142979
8	2.1.01	Cuentas por Pagar a Proveedores	pasivo	7	t	\N	t	2026-03-31 21:43:41.142979
10	3.1.01	Capital Social	patrimonio	9	t	\N	t	2026-03-31 21:43:41.142979
11	3.1.02	Utilidades Acumuladas	patrimonio	9	t	\N	t	2026-03-31 21:43:41.142979
12	3.1.03	Utilidad / Pérdida del Ejercicio	patrimonio	9	t	\N	t	2026-03-31 21:43:41.142979
14	4.1.01	Ingresos por Ventas	ingreso	13	t	\N	t	2026-03-31 21:43:41.142979
16	5.1.01	Costo de Ventas (Ingredientes)	costo	15	t	\N	t	2026-03-31 21:43:41.142979
18	6.1.01	Gasto Agua	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
19	6.1.02	Gasto Gas	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
20	6.1.03	Gasto Electricidad	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
21	6.1.04	Gasto Internet	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
22	6.1.05	Gasto Alquiler	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
\.


--
-- TOC entry 4409 (class 0 OID 16554)
-- Dependencies: 230
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.metodos_pago (id, nombre, activo, restaurante_id, created_at) FROM stdin;
1	Efectivo	t	1	2026-04-01 14:48:28.891424
2	Pago Movil	t	1	2026-04-01 14:48:39.610028
3	Tarjeta Debito/Credito	t	1	2026-04-01 14:48:42.919442
4	Divisa (USD/EUR)	t	1	2026-04-01 14:48:45.589603
\.


--
-- TOC entry 4411 (class 0 OID 16563)
-- Dependencies: 232
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
-- TOC entry 4413 (class 0 OID 16587)
-- Dependencies: 234
-- Data for Name: roles; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.roles (id, nombre, created_at) FROM stdin;
1	admin	2026-03-03 10:56:13.498568
2	cajero	2026-03-24 20:21:54.161944
3	mesero	2026-03-24 20:22:05.04884
4	cocina	2026-03-24 20:22:15.689054
5	super_admin	2026-03-31 21:43:41.176333
\.


--
-- TOC entry 4415 (class 0 OID 16595)
-- Dependencies: 236
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
-- TOC entry 4417 (class 0 OID 16603)
-- Dependencies: 238
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.unidad_medida (id, nombre, abreviatura) FROM stdin;
1	Gramos	g
2	Litros	L
3	Kilogramos	kg
4	Unidades	und
5	Mililitros	ml
\.


--
-- TOC entry 4419 (class 0 OID 16610)
-- Dependencies: 240
-- Data for Name: usuarios; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.usuarios (id, restaurante_id, rol_id, nombre, email, username, password_hash, activo, created_at, updated_at) FROM stdin;
1	1	1	Rafael Alvarez	alvarezrafaelat@gmail.com	rafa	$2b$10$6JMAAOJhP4KELVmgGzmNPusKbj26cDTk1novu7g3iZIbDczvuy4cy	t	2026-03-03 10:56:13.498568	2026-03-24 20:02:26.070936
3	1	2	ejemplo ejemplo 2	ejemplo2@gmail.com	ejemplo1234	$2b$10$3pnS/YawKWVC/Ve.xJ87iOzqmAQkvBVP7B7MMBK/eM8l/FR84T/y2	t	2026-03-24 20:09:48.932891	2026-03-24 20:23:12.382321
2	1	4	ejemplo ejemplo	ejemplo@gmail.com	ejemplo123	$2b$10$fP3fFvAXpX7QKyH5Y8XhpOTyJisJ9oQy0uqk2rGi.kHok.sfFejUe	t	2026-03-24 20:03:50.680361	2026-03-24 20:28:55.93198
\.


--
-- TOC entry 4421 (class 0 OID 16629)
-- Dependencies: 242
-- Data for Name: banco; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.banco (id, nombre_banco, numero_cuenta, saldo_actual, activo, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4423 (class 0 OID 16641)
-- Dependencies: 244
-- Data for Name: banco_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.banco_movimientos (id, banco_id, fecha_hora, tipo, monto, concepto, referencia_tipo, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4425 (class 0 OID 16656)
-- Dependencies: 246
-- Data for Name: caja; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.caja (id, fecha_apertura, fecha_cierre, monto_inicial, monto_final, monto_teorico, diferencia, estado, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4427 (class 0 OID 16669)
-- Dependencies: 248
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.caja_movimientos (id, caja_id, fecha_hora, tipo, monto, concepto, referencia_tipo, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4429 (class 0 OID 16684)
-- Dependencies: 250
-- Data for Name: egresos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.egresos (id, fecha, monto, categoria_id, razon, descripcion, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4520 (class 0 OID 18085)
-- Dependencies: 341
-- Data for Name: gastos_operativos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.gastos_operativos (id, categoria, descripcion, monto, fecha, metodo_pago, referencia, periodo_mes, periodo_anio, usuario_id, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4431 (class 0 OID 16697)
-- Dependencies: 252
-- Data for Name: categoria_egresos; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.categoria_egresos (id, nombre, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4433 (class 0 OID 16705)
-- Dependencies: 254
-- Data for Name: compra_detalle; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.compra_detalle (id, compra_id, ingrediente_id, cantidad_compra, unidad_compra_id, precio_unitario, factor_conversion, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4435 (class 0 OID 16718)
-- Dependencies: 256
-- Data for Name: compras; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.compras (id, fecha, numero_factura_proveedor, total, estado_pago, saldo_pendiente, descripcion, proveedor_id, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4437 (class 0 OID 16729)
-- Dependencies: 258
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.ingredientes (id, nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, merma_teorica_porcentaje, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4439 (class 0 OID 16743)
-- Dependencies: 260
-- Data for Name: mermas; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.mermas (id, ingrediente_id, cantidad, tipo, razon, reportado_por, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4441 (class 0 OID 16758)
-- Dependencies: 262
-- Data for Name: proveedores; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.proveedores (id, identificacion, nombre, telefono, email, direccion, restaurante_id, banco_nombre, banco_cuenta_numero, activo, observaciones, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4443 (class 0 OID 16771)
-- Dependencies: 264
-- Data for Name: unidad_compra; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.unidad_compra (id, nombre, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4445 (class 0 OID 16779)
-- Dependencies: 266
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
-- TOC entry 4447 (class 0 OID 16785)
-- Dependencies: 268
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
-- TOC entry 4449 (class 0 OID 16793)
-- Dependencies: 270
-- Data for Name: categorias; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.categorias (id, nombre, orden, activo, restaurante_id, created_at, updated_at) FROM stdin;
1	Entradas	1	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
2	Platos Fuertes	2	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
3	Bebidas	3	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
4	Postres	4	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
\.


--
-- TOC entry 4451 (class 0 OID 16804)
-- Dependencies: 272
-- Data for Name: receta_ingredientes; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.receta_ingredientes (id, receta_id, ingrediente_id, cantidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4453 (class 0 OID 16813)
-- Dependencies: 274
-- Data for Name: recetas; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.recetas (id, nombre, descripcion, categoria_id, imagen_url, costo_produccion, precio_sugerido, precio_venta, margen_utilidad, activo, restaurante_id, created_at, updated_at) FROM stdin;
1	Nachos con Guacamole	\N	1	\N	0.00	0.00	6.50	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
2	Hamburguesa Komanda	\N	2	\N	0.00	0.00	9.50	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
3	Limonada Natural	\N	3	\N	0.00	0.00	3.00	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
4	Flan Napolitano	\N	4	\N	0.00	0.00	5.00	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
\.


--
-- TOC entry 4455 (class 0 OID 16829)
-- Dependencies: 276
-- Data for Name: facturas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.facturas (id, numero_factura, pedido_id, metodo_pago_id, usuario_id, cliente_nombre, cliente_identificacion, cliente_direccion, cliente_email, fecha, subtotal, descuento, impuestos, propina, total, estado, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4457 (class 0 OID 16848)
-- Dependencies: 278
-- Data for Name: mesas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.mesas (id, numero, nombre, capacidad, estado, restaurante_id, created_at, updated_at) FROM stdin;
2	2	Mesa 2	4	libre	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
1	1	Mesa 1	4	libre	1	2026-03-24 19:31:17.54503	2026-04-04 00:31:51.480405
3	3	Mesa 3	6	libre	1	2026-03-24 19:31:17.54503	2026-04-04 00:33:51.007441
\.


--
-- TOC entry 4459 (class 0 OID 16859)
-- Dependencies: 280
-- Data for Name: meseros; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.meseros (id, nombre, activo, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4461 (class 0 OID 16869)
-- Dependencies: 282
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
15	5	4	3	5.00	15.00	\N	1
16	5	2	2	9.50	19.00	\N	1
17	5	3	4	3.00	12.00	\N	1
18	5	1	4	6.50	26.00	\N	1
22	13	1	1	6.50	6.50	\N	1
23	14	2	1	9.50	9.50	\N	1
24	15	2	1	9.50	9.50	\N	1
25	16	4	1	5.00	5.00	Socket Test	1
26	17	4	1	5.00	5.00	Real-Time Validation	1
27	18	1	4	6.50	26.00	\N	1
28	19	3	3	3.00	9.00	\N	1
\.


--
-- TOC entry 4463 (class 0 OID 16882)
-- Dependencies: 284
-- Data for Name: pedidos; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.pedidos (id, codigo, mesa_id, mesero_id, cliente, estado, estado_cuenta, fecha_hora, subtotal, descuento, impuestos, total, restaurante_id, created_at, updated_at) FROM stdin;
1	PED-20260324-0001	1	\N	\N	pendiente	abierta	2026-03-24 19:32:19.598162	14.50	0.00	1.45	15.95	1	2026-03-24 19:32:19.598162	2026-03-24 19:32:19.598162
2	PED-20260324-0002	1	\N	\N	pendiente	abierta	2026-03-24 19:37:56.254636	24.00	0.00	2.40	26.40	1	2026-03-24 19:37:56.254636	2026-03-24 19:37:56.254636
3	PED-20260324-0003	1	\N	\N	pendiente	abierta	2026-03-24 19:38:02.017175	24.00	0.00	2.40	26.40	1	2026-03-24 19:38:02.017175	2026-03-24 19:38:02.017175
4	PED-20260324-0004	3	\N	\N	pendiente	abierta	2026-03-24 19:38:21.838216	67.00	0.00	6.70	73.70	1	2026-03-24 19:38:21.838216	2026-03-24 19:38:21.838216
5	PED-20260331-0001	1	\N	\N	pendiente	abierta	2026-03-31 16:13:25.688786	72.00	0.00	7.20	79.20	1	2026-03-31 16:13:25.688786	2026-03-31 16:13:25.688786
13	PED-20260404-0001	\N	\N	\N	pendiente	pagada	2026-04-04 00:02:27.408462	6.50	0.00	0.65	7.15	1	2026-04-04 00:02:27.408462	2026-04-04 00:02:27.408462
14	PED-20260404-0002	\N	\N	\N	pendiente	pagada	2026-04-04 00:12:52.31896	9.50	0.00	0.95	10.45	1	2026-04-04 00:12:52.31896	2026-04-04 00:12:52.31896
15	PED-20260404-0003	\N	\N	\N	pendiente	pagada	2026-04-04 00:16:00.581704	9.50	0.00	0.95	10.45	1	2026-04-04 00:16:00.581704	2026-04-04 00:16:00.581704
16	PED-20260404-0004	1	\N	\N	pendiente	pagada	2026-04-04 00:19:26.132213	5.00	0.00	0.50	5.50	1	2026-04-04 00:19:26.132213	2026-04-04 00:19:26.132213
17	PED-20260404-0005	1	\N	\N	pendiente	pagada	2026-04-04 00:31:51.480405	5.00	0.00	0.50	5.50	1	2026-04-04 00:31:51.480405	2026-04-04 00:31:51.480405
18	PED-20260404-0006	\N	\N	\N	pendiente	pagada	2026-04-04 00:33:29.339811	26.00	0.00	2.60	28.60	1	2026-04-04 00:33:29.339811	2026-04-04 00:33:29.339811
19	PED-20260404-0007	3	\N	\N	pendiente	pagada	2026-04-04 00:33:51.007441	9.00	0.00	0.90	9.90	1	2026-04-04 00:33:51.007441	2026-04-04 00:33:51.007441
\.


--
-- TOC entry 4465 (class 0 OID 16899)
-- Dependencies: 286
-- Data for Name: reservas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.reservas (id, mesa_id, cliente_nombre, cliente_telefono, fecha_reserva, cantidad_personas, estado, notas, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4518 (class 0 OID 18058)
-- Dependencies: 339
-- Data for Name: transacciones_pago; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.transacciones_pago (id, pedido_id, metodo, monto, referencia, tasa_cambio, usuario_id, restaurante_id, created_at) FROM stdin;
1	13	efectivo	100.00	\N	1.0000	\N	1	2026-04-04 00:02:27.408462
2	14	divisa	10.64	\N	1.0000	\N	1	2026-04-04 00:12:52.31896
3	15	divisa	10.64	\N	1.0000	\N	1	2026-04-04 00:16:00.581704
4	16	efectivo	100.00	\N	1.0000	\N	1	2026-04-04 00:19:26.132213
5	17	efectivo	100.00	\N	1.0000	\N	1	2026-04-04 00:31:51.480405
6	18	efectivo	29.12	\N	1.0000	\N	1	2026-04-04 00:33:29.339811
7	19	divisa	10.08	\N	1.0000	\N	1	2026-04-04 00:33:51.007441
\.


--
-- TOC entry 4467 (class 0 OID 16913)
-- Dependencies: 288
-- Data for Name: banco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco (id, nombre_banco, numero_cuenta, saldo_actual, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4469 (class 0 OID 16923)
-- Dependencies: 290
-- Data for Name: banco_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco_movimientos (id, banco_id, fecha_hora, monto, concepto, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4471 (class 0 OID 16935)
-- Dependencies: 292
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja (id, fecha_apertura, fecha_cierre, monto_inicial, monto_final, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4473 (class 0 OID 16946)
-- Dependencies: 294
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_movimientos (id, caja_id, fecha_hora, monto, concepto, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4475 (class 0 OID 16958)
-- Dependencies: 296
-- Data for Name: categoria_egresos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_egresos (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4477 (class 0 OID 16965)
-- Dependencies: 298
-- Data for Name: compra_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra_detalle (id, compra_id, ingrediente_id, cantidad, precio_unitario, unidad_compra_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4479 (class 0 OID 16976)
-- Dependencies: 300
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compras (id, fecha, total, descripcion, proveedor_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4481 (class 0 OID 16984)
-- Dependencies: 302
-- Data for Name: egresos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egresos (id, fecha, monto, categoria_id, razon, descripcion, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4483 (class 0 OID 16996)
-- Dependencies: 304
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas (id, numero_factura, pedido_id, fecha, subtotal, impuestos, total, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4485 (class 0 OID 17008)
-- Dependencies: 306
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredientes (id, nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4487 (class 0 OID 17019)
-- Dependencies: 308
-- Data for Name: mesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mesas (id, numero, nombre, capacidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4489 (class 0 OID 17027)
-- Dependencies: 310
-- Data for Name: meseros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meseros (id, nombre, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4491 (class 0 OID 17035)
-- Dependencies: 312
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metodos_pago (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4493 (class 0 OID 17042)
-- Dependencies: 314
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, unit_price, subtotal, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4494 (class 0 OID 17054)
-- Dependencies: 315
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, restaurant_id, user_id, table_id, status, subtotal, tax_amount, total_amount, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4495 (class 0 OID 17071)
-- Dependencies: 316
-- Data for Name: pedido_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_detalle (id, pedido_id, receta_id, cantidad, precio_unitario, subtotal, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4497 (class 0 OID 17082)
-- Dependencies: 318
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, codigo, mesa_id, mesero_id, cliente, fecha_hora, total, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4499 (class 0 OID 17091)
-- Dependencies: 320
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedores (id, identificacion, nombre, telefono, email, direccion, restaurante_id, banco_nombre, banco_cuenta_numero, activo, observaciones, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4501 (class 0 OID 17104)
-- Dependencies: 322
-- Data for Name: receta_ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receta_ingredientes (id, receta_id, ingrediente_id, cantidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4503 (class 0 OID 17113)
-- Dependencies: 324
-- Data for Name: recetas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recetas (id, nombre, descripcion, costo_produccion, precio_sugerido, precio_venta, margen_utilidad, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4505 (class 0 OID 17127)
-- Dependencies: 326
-- Data for Name: restaurante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurante (id, nombre, patrimonio_inicial, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4507 (class 0 OID 17136)
-- Dependencies: 328
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4509 (class 0 OID 17143)
-- Dependencies: 330
-- Data for Name: unidad_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_compra (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4511 (class 0 OID 17150)
-- Dependencies: 332
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_medida (id, nombre, abreviatura) FROM stdin;
\.


--
-- TOC entry 4513 (class 0 OID 17157)
-- Dependencies: 334
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, restaurante_id, rol_id, nombre, email, username, activo) FROM stdin;
\.


--
-- TOC entry 4515 (class 0 OID 17168)
-- Dependencies: 336
-- Data for Name: order_items; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.order_items (id, order_id, product_id, quantity, unit_price, subtotal, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4516 (class 0 OID 17177)
-- Dependencies: 337
-- Data for Name: orders; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.orders (id, restaurant_id, user_id, table_id, status, subtotal, tax_amount, total_amount, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 346
-- Name: asiento_lineas_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.asiento_lineas_id_seq', 1, false);


--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 344
-- Name: asientos_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.asientos_id_seq', 1, false);


--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 229
-- Name: libro_diario_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.libro_diario_id_seq', 28, true);


--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 342
-- Name: plan_cuentas_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.plan_cuentas_id_seq', 22, true);


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 231
-- Name: metodos_pago_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.metodos_pago_id_seq', 4, true);


--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 233
-- Name: restaurante_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.restaurante_id_seq', 11, true);


--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 235
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.roles_id_seq', 5, true);


--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 237
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.tables_id_seq', 10, true);


--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 239
-- Name: unidad_medida_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.unidad_medida_id_seq', 5, true);


--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 241
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.usuarios_id_seq', 3, true);


--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 243
-- Name: banco_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.banco_id_seq', 1, false);


--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 245
-- Name: banco_movimientos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.banco_movimientos_id_seq', 1, false);


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 247
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.caja_id_seq', 1, false);


--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 249
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.caja_movimientos_id_seq', 1, false);


--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 251
-- Name: egresos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.egresos_id_seq', 1, false);


--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 340
-- Name: gastos_operativos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.gastos_operativos_id_seq', 1, false);


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 253
-- Name: categoria_egresos_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.categoria_egresos_id_seq', 1, false);


--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 255
-- Name: compra_detalle_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.compra_detalle_id_seq', 1, false);


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 257
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.compras_id_seq', 1, false);


--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 259
-- Name: ingredientes_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.ingredientes_id_seq', 1, false);


--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 261
-- Name: mermas_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.mermas_id_seq', 1, false);


--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 263
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.proveedores_id_seq', 1, false);


--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 265
-- Name: unidad_compra_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.unidad_compra_id_seq', 1, false);


--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 267
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.categories_id_seq', 7, true);


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 269
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.products_id_seq', 31, true);


--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 271
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.categorias_id_seq', 4, true);


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 273
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.receta_ingredientes_id_seq', 1, false);


--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 275
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.recetas_id_seq', 4, true);


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 277
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.facturas_id_seq', 1, false);


--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 279
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.mesas_id_seq', 3, true);


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 281
-- Name: meseros_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.meseros_id_seq', 1, false);


--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 283
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.pedido_detalle_id_seq', 28, true);


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 285
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.pedidos_id_seq', 19, true);


--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 287
-- Name: reservas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.reservas_id_seq', 1, false);


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 338
-- Name: transacciones_pago_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.transacciones_pago_id_seq', 7, true);


--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 289
-- Name: banco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banco_id_seq', 1, false);


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 291
-- Name: banco_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banco_movimientos_id_seq', 1, false);


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 293
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_id_seq', 1, false);


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 295
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_movimientos_id_seq', 1, false);


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 297
-- Name: categoria_egresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_egresos_id_seq', 1, false);


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 299
-- Name: compra_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compra_detalle_id_seq', 1, false);


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 301
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compras_id_seq', 1, false);


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 303
-- Name: egresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.egresos_id_seq', 1, false);


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 305
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_id_seq', 1, false);


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 307
-- Name: ingredientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredientes_id_seq', 1, false);


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 309
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mesas_id_seq', 1, false);


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 311
-- Name: meseros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meseros_id_seq', 1, false);


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 313
-- Name: metodos_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metodos_pago_id_seq', 1, false);


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 317
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_detalle_id_seq', 1, false);


--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 319
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 321
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_id_seq', 1, false);


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 323
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receta_ingredientes_id_seq', 1, false);


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 325
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recetas_id_seq', 1, false);


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 327
-- Name: restaurante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restaurante_id_seq', 1, false);


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 329
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 331
-- Name: unidad_compra_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_compra_id_seq', 1, false);


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 333
-- Name: unidad_medida_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_medida_id_seq', 1, false);


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 335
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, false);


--
-- TOC entry 4132 (class 2606 OID 18172)
-- Name: asiento_lineas asiento_lineas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT asiento_lineas_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 18150)
-- Name: asientos asientos_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos
    ADD CONSTRAINT asientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3909 (class 2606 OID 17245)
-- Name: libro_diario libro_diario_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario
    ADD CONSTRAINT libro_diario_pkey PRIMARY KEY (id);


--
-- TOC entry 4124 (class 2606 OID 18123)
-- Name: plan_cuentas plan_cuentas_codigo_restaurante_unique; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_codigo_restaurante_unique UNIQUE (codigo, restaurante_id);


--
-- TOC entry 4126 (class 2606 OID 18121)
-- Name: plan_cuentas plan_cuentas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_pkey PRIMARY KEY (id);


--
-- TOC entry 3911 (class 2606 OID 17247)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 3913 (class 2606 OID 17249)
-- Name: restaurante restaurante_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.restaurante
    ADD CONSTRAINT restaurante_pkey PRIMARY KEY (id);


--
-- TOC entry 3915 (class 2606 OID 17251)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3917 (class 2606 OID 17253)
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- TOC entry 3919 (class 2606 OID 17255)
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 3921 (class 2606 OID 17257)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 3923 (class 2606 OID 17259)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 3928 (class 2606 OID 17261)
-- Name: banco_movimientos banco_movimientos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT banco_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3925 (class 2606 OID 17263)
-- Name: banco banco_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco
    ADD CONSTRAINT banco_pkey PRIMARY KEY (id);


--
-- TOC entry 3937 (class 2606 OID 17265)
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3933 (class 2606 OID 17267)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 3942 (class 2606 OID 17269)
-- Name: egresos egresos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 4119 (class 2606 OID 18100)
-- Name: gastos_operativos gastos_operativos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.gastos_operativos
    ADD CONSTRAINT gastos_operativos_pkey PRIMARY KEY (id);


--
-- TOC entry 3946 (class 2606 OID 17271)
-- Name: categoria_egresos categoria_egresos_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos
    ADD CONSTRAINT categoria_egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3948 (class 2606 OID 17273)
-- Name: compra_detalle compra_detalle_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT compra_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3952 (class 2606 OID 17275)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 3959 (class 2606 OID 17277)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3963 (class 2606 OID 17279)
-- Name: mermas mermas_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT mermas_pkey PRIMARY KEY (id);


--
-- TOC entry 3967 (class 2606 OID 17281)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 3969 (class 2606 OID 17283)
-- Name: unidad_compra unidad_compra_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra
    ADD CONSTRAINT unidad_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 3971 (class 2606 OID 17285)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3973 (class 2606 OID 17287)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3975 (class 2606 OID 17289)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- TOC entry 3980 (class 2606 OID 17291)
-- Name: receta_ingredientes receta_ingredientes_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3982 (class 2606 OID 17293)
-- Name: receta_ingredientes receta_ingredientes_receta_id_ingrediente_id_key; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_receta_id_ingrediente_id_key UNIQUE (receta_id, ingrediente_id);


--
-- TOC entry 3987 (class 2606 OID 17295)
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- TOC entry 3989 (class 2606 OID 17297)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 3991 (class 2606 OID 17299)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 3998 (class 2606 OID 17301)
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- TOC entry 4001 (class 2606 OID 17303)
-- Name: meseros meseros_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros
    ADD CONSTRAINT meseros_pkey PRIMARY KEY (id);


--
-- TOC entry 4005 (class 2606 OID 17305)
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4012 (class 2606 OID 17307)
-- Name: pedidos pedidos_codigo_key; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT pedidos_codigo_key UNIQUE (codigo);


--
-- TOC entry 4014 (class 2606 OID 17309)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4018 (class 2606 OID 17311)
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY (id);


--
-- TOC entry 4117 (class 2606 OID 18071)
-- Name: transacciones_pago transacciones_pago_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago
    ADD CONSTRAINT transacciones_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4067 (class 2606 OID 17313)
-- Name: order_items PK_005269d8574e6fac0493715c308; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_005269d8574e6fac0493715c308" PRIMARY KEY (id);


--
-- TOC entry 4069 (class 2606 OID 17315)
-- Name: orders PK_710e2d4957aa5878dfe94e4ac2f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_710e2d4957aa5878dfe94e4ac2f" PRIMARY KEY (id);


--
-- TOC entry 4023 (class 2606 OID 17317)
-- Name: banco_movimientos banco_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT banco_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 4020 (class 2606 OID 17319)
-- Name: banco banco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT banco_pkey PRIMARY KEY (id);


--
-- TOC entry 4030 (class 2606 OID 17321)
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 4027 (class 2606 OID 17323)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4034 (class 2606 OID 17325)
-- Name: categoria_egresos categoria_egresos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos
    ADD CONSTRAINT categoria_egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 4036 (class 2606 OID 17327)
-- Name: compra_detalle compra_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT compra_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4040 (class 2606 OID 17329)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 4045 (class 2606 OID 17331)
-- Name: egresos egresos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 4049 (class 2606 OID 17333)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 4051 (class 2606 OID 17335)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 4057 (class 2606 OID 17337)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4060 (class 2606 OID 17339)
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- TOC entry 4063 (class 2606 OID 17341)
-- Name: meseros meseros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros
    ADD CONSTRAINT meseros_pkey PRIMARY KEY (id);


--
-- TOC entry 4065 (class 2606 OID 17343)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4073 (class 2606 OID 17345)
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4077 (class 2606 OID 17347)
-- Name: pedidos pedidos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_codigo_key UNIQUE (codigo);


--
-- TOC entry 4079 (class 2606 OID 17349)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4083 (class 2606 OID 17351)
-- Name: proveedores proveedores_identificacion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_identificacion_key UNIQUE (identificacion);


--
-- TOC entry 4085 (class 2606 OID 17353)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 4089 (class 2606 OID 17355)
-- Name: receta_ingredientes receta_ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4091 (class 2606 OID 17357)
-- Name: receta_ingredientes receta_ingredientes_receta_id_ingrediente_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_receta_id_ingrediente_id_key UNIQUE (receta_id, ingrediente_id);


--
-- TOC entry 4095 (class 2606 OID 17359)
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- TOC entry 4097 (class 2606 OID 17361)
-- Name: restaurante restaurante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurante
    ADD CONSTRAINT restaurante_pkey PRIMARY KEY (id);


--
-- TOC entry 4099 (class 2606 OID 17363)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4101 (class 2606 OID 17365)
-- Name: unidad_compra unidad_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra
    ADD CONSTRAINT unidad_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 4103 (class 2606 OID 17367)
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 4107 (class 2606 OID 17369)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4109 (class 2606 OID 17371)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4111 (class 2606 OID 17373)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 17375)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 1259 OID 18188)
-- Name: idx_asiento_lineas_asiento; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asiento_lineas_asiento ON contabilidad.asiento_lineas USING btree (asiento_id);


--
-- TOC entry 4134 (class 1259 OID 18189)
-- Name: idx_asiento_lineas_cuenta; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asiento_lineas_cuenta ON contabilidad.asiento_lineas USING btree (cuenta_id, restaurante_id);


--
-- TOC entry 4129 (class 1259 OID 18156)
-- Name: idx_asientos_fecha; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asientos_fecha ON contabilidad.asientos USING btree (fecha, restaurante_id);


--
-- TOC entry 4130 (class 1259 OID 18157)
-- Name: idx_asientos_origen; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asientos_origen ON contabilidad.asientos USING btree (origen_tipo, origen_id);


--
-- TOC entry 3905 (class 1259 OID 17376)
-- Name: idx_libro_fecha; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_fecha ON contabilidad.libro_diario USING btree (fecha);


--
-- TOC entry 3906 (class 1259 OID 17377)
-- Name: idx_libro_referencia; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_referencia ON contabilidad.libro_diario USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 3907 (class 1259 OID 17378)
-- Name: idx_libro_tipo; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_tipo ON contabilidad.libro_diario USING btree (tipo);


--
-- TOC entry 4122 (class 1259 OID 18134)
-- Name: idx_plan_cuentas_tipo; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_plan_cuentas_tipo ON contabilidad.plan_cuentas USING btree (tipo);


--
-- TOC entry 3926 (class 1259 OID 17379)
-- Name: idx_banco_activo; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_activo ON finanzas.banco USING btree (activo);


--
-- TOC entry 3929 (class 1259 OID 17380)
-- Name: idx_banco_mov_banco; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_banco ON finanzas.banco_movimientos USING btree (banco_id);


--
-- TOC entry 3930 (class 1259 OID 17381)
-- Name: idx_banco_mov_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_fecha ON finanzas.banco_movimientos USING btree (fecha_hora);


--
-- TOC entry 3931 (class 1259 OID 17382)
-- Name: idx_banco_mov_referencia; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_referencia ON finanzas.banco_movimientos USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 3934 (class 1259 OID 17383)
-- Name: idx_caja_estado; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_estado ON finanzas.caja USING btree (estado);


--
-- TOC entry 3935 (class 1259 OID 17384)
-- Name: idx_caja_fechas; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_fechas ON finanzas.caja USING btree (fecha_apertura, fecha_cierre);


--
-- TOC entry 3938 (class 1259 OID 17385)
-- Name: idx_caja_mov_caja; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_caja ON finanzas.caja_movimientos USING btree (caja_id);


--
-- TOC entry 3939 (class 1259 OID 17386)
-- Name: idx_caja_mov_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_fecha ON finanzas.caja_movimientos USING btree (fecha_hora);


--
-- TOC entry 3940 (class 1259 OID 17387)
-- Name: idx_caja_mov_referencia; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_referencia ON finanzas.caja_movimientos USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 3943 (class 1259 OID 17388)
-- Name: idx_egresos_categoria; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_egresos_categoria ON finanzas.egresos USING btree (categoria_id);


--
-- TOC entry 3944 (class 1259 OID 17389)
-- Name: idx_egresos_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_egresos_fecha ON finanzas.egresos USING btree (fecha);


--
-- TOC entry 4120 (class 1259 OID 18107)
-- Name: idx_gastos_categoria; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_gastos_categoria ON finanzas.gastos_operativos USING btree (categoria, restaurante_id);


--
-- TOC entry 4121 (class 1259 OID 18106)
-- Name: idx_gastos_restaurante_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_gastos_restaurante_fecha ON finanzas.gastos_operativos USING btree (restaurante_id, fecha);


--
-- TOC entry 3949 (class 1259 OID 17390)
-- Name: idx_compra_detalle_compra; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compra_detalle_compra ON inventario.compra_detalle USING btree (compra_id);


--
-- TOC entry 3950 (class 1259 OID 17391)
-- Name: idx_compra_detalle_ingrediente; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compra_detalle_ingrediente ON inventario.compra_detalle USING btree (ingrediente_id);


--
-- TOC entry 3953 (class 1259 OID 17392)
-- Name: idx_compras_fecha; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compras_fecha ON inventario.compras USING btree (fecha);


--
-- TOC entry 3954 (class 1259 OID 17393)
-- Name: idx_compras_proveedor; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compras_proveedor ON inventario.compras USING btree (proveedor_id);


--
-- TOC entry 3955 (class 1259 OID 17394)
-- Name: idx_ingredientes_nombre; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_nombre ON inventario.ingredientes USING btree (nombre);


--
-- TOC entry 3956 (class 1259 OID 17395)
-- Name: idx_ingredientes_restaurante; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_restaurante ON inventario.ingredientes USING btree (restaurante_id);


--
-- TOC entry 3957 (class 1259 OID 17396)
-- Name: idx_ingredientes_stock; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_stock ON inventario.ingredientes USING btree (cantidad_disponible, cantidad_minima);


--
-- TOC entry 3960 (class 1259 OID 17397)
-- Name: idx_mermas_fecha; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_mermas_fecha ON inventario.mermas USING btree (created_at);


--
-- TOC entry 3961 (class 1259 OID 17398)
-- Name: idx_mermas_ingrediente; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_mermas_ingrediente ON inventario.mermas USING btree (ingrediente_id);


--
-- TOC entry 3964 (class 1259 OID 17399)
-- Name: idx_proveedores_nombre; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_proveedores_nombre ON inventario.proveedores USING btree (nombre);


--
-- TOC entry 3965 (class 1259 OID 17400)
-- Name: idx_proveedores_restaurante; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_proveedores_restaurante ON inventario.proveedores USING btree (restaurante_id, nombre);


--
-- TOC entry 3976 (class 1259 OID 17401)
-- Name: idx_categorias_restaurante; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_categorias_restaurante ON menu.categorias USING btree (restaurante_id, orden);


--
-- TOC entry 3977 (class 1259 OID 17402)
-- Name: idx_receta_ingredientes_ingrediente; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_ingrediente ON menu.receta_ingredientes USING btree (ingrediente_id);


--
-- TOC entry 3978 (class 1259 OID 17403)
-- Name: idx_receta_ingredientes_receta; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_receta ON menu.receta_ingredientes USING btree (receta_id);


--
-- TOC entry 3983 (class 1259 OID 17404)
-- Name: idx_recetas_activo; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_activo ON menu.recetas USING btree (activo);


--
-- TOC entry 3984 (class 1259 OID 17405)
-- Name: idx_recetas_categoria; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_categoria ON menu.recetas USING btree (categoria_id);


--
-- TOC entry 3985 (class 1259 OID 17406)
-- Name: idx_recetas_nombre; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_nombre ON menu.recetas USING btree (nombre);


--
-- TOC entry 3992 (class 1259 OID 17407)
-- Name: idx_facturas_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON operaciones.facturas USING btree (fecha);


--
-- TOC entry 3993 (class 1259 OID 17408)
-- Name: idx_facturas_fecha_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_fecha_estado ON operaciones.facturas USING btree (fecha, estado);


--
-- TOC entry 3994 (class 1259 OID 17409)
-- Name: idx_facturas_numero; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON operaciones.facturas USING btree (numero_factura);


--
-- TOC entry 3995 (class 1259 OID 17410)
-- Name: idx_mesas_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_mesas_estado ON operaciones.mesas USING btree (estado);


--
-- TOC entry 3996 (class 1259 OID 17411)
-- Name: idx_mesas_numero; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_mesas_numero ON operaciones.mesas USING btree (numero);


--
-- TOC entry 3999 (class 1259 OID 17412)
-- Name: idx_meseros_nombre; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_meseros_nombre ON operaciones.meseros USING btree (nombre);


--
-- TOC entry 4002 (class 1259 OID 17413)
-- Name: idx_pedido_detalle_pedido; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_pedido ON operaciones.pedido_detalle USING btree (pedido_id);


--
-- TOC entry 4003 (class 1259 OID 17414)
-- Name: idx_pedido_detalle_receta; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_receta ON operaciones.pedido_detalle USING btree (receta_id);


--
-- TOC entry 4006 (class 1259 OID 17415)
-- Name: idx_pedidos_codigo; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_codigo ON operaciones.pedidos USING btree (codigo);


--
-- TOC entry 4007 (class 1259 OID 17416)
-- Name: idx_pedidos_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_estado ON operaciones.pedidos USING btree (estado);


--
-- TOC entry 4008 (class 1259 OID 17417)
-- Name: idx_pedidos_estado_cuenta; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_estado_cuenta ON operaciones.pedidos USING btree (estado_cuenta);


--
-- TOC entry 4009 (class 1259 OID 17418)
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha ON operaciones.pedidos USING btree (fecha_hora);


--
-- TOC entry 4010 (class 1259 OID 17419)
-- Name: idx_pedidos_fecha_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha_estado ON operaciones.pedidos USING btree (fecha_hora, estado);


--
-- TOC entry 4015 (class 1259 OID 17420)
-- Name: idx_reservas_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_reservas_estado ON operaciones.reservas USING btree (estado);


--
-- TOC entry 4016 (class 1259 OID 17421)
-- Name: idx_reservas_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_reservas_fecha ON operaciones.reservas USING btree (fecha_reserva);


--
-- TOC entry 4114 (class 1259 OID 18083)
-- Name: idx_trans_pago_metodo; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_trans_pago_metodo ON operaciones.transacciones_pago USING btree (metodo, restaurante_id);


--
-- TOC entry 4115 (class 1259 OID 18082)
-- Name: idx_trans_pago_pedido; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_trans_pago_pedido ON operaciones.transacciones_pago USING btree (pedido_id);


--
-- TOC entry 4021 (class 1259 OID 17422)
-- Name: idx_banco_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_activo ON public.banco USING btree (activo);


--
-- TOC entry 4024 (class 1259 OID 17423)
-- Name: idx_banco_movimientos_banco; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_movimientos_banco ON public.banco_movimientos USING btree (banco_id);


--
-- TOC entry 4025 (class 1259 OID 17424)
-- Name: idx_banco_movimientos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_movimientos_fecha ON public.banco_movimientos USING btree (fecha_hora);


--
-- TOC entry 4028 (class 1259 OID 17425)
-- Name: idx_caja_fechas; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_fechas ON public.caja USING btree (fecha_apertura, fecha_cierre);


--
-- TOC entry 4031 (class 1259 OID 17426)
-- Name: idx_caja_movimientos_caja; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_movimientos_caja ON public.caja_movimientos USING btree (caja_id);


--
-- TOC entry 4032 (class 1259 OID 17427)
-- Name: idx_caja_movimientos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_movimientos_fecha ON public.caja_movimientos USING btree (fecha_hora);


--
-- TOC entry 4037 (class 1259 OID 17428)
-- Name: idx_compra_detalle_compra; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compra_detalle_compra ON public.compra_detalle USING btree (compra_id);


--
-- TOC entry 4038 (class 1259 OID 17429)
-- Name: idx_compra_detalle_ingrediente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compra_detalle_ingrediente ON public.compra_detalle USING btree (ingrediente_id);


--
-- TOC entry 4041 (class 1259 OID 17430)
-- Name: idx_compras_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_fecha ON public.compras USING btree (fecha);


--
-- TOC entry 4042 (class 1259 OID 17431)
-- Name: idx_compras_fecha_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_fecha_proveedor ON public.compras USING btree (fecha, proveedor_id);


--
-- TOC entry 4043 (class 1259 OID 17432)
-- Name: idx_compras_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_proveedor ON public.compras USING btree (proveedor_id);


--
-- TOC entry 4046 (class 1259 OID 17433)
-- Name: idx_egresos_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_egresos_categoria ON public.egresos USING btree (categoria_id);


--
-- TOC entry 4047 (class 1259 OID 17434)
-- Name: idx_egresos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_egresos_fecha ON public.egresos USING btree (fecha);


--
-- TOC entry 4052 (class 1259 OID 17435)
-- Name: idx_facturas_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON public.facturas USING btree (fecha);


--
-- TOC entry 4053 (class 1259 OID 17436)
-- Name: idx_facturas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON public.facturas USING btree (numero_factura);


--
-- TOC entry 4054 (class 1259 OID 17437)
-- Name: idx_ingredientes_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ingredientes_nombre ON public.ingredientes USING btree (nombre);


--
-- TOC entry 4055 (class 1259 OID 17438)
-- Name: idx_ingredientes_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ingredientes_stock ON public.ingredientes USING btree (cantidad_disponible, cantidad_minima);


--
-- TOC entry 4058 (class 1259 OID 17439)
-- Name: idx_mesas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mesas_numero ON public.mesas USING btree (numero);


--
-- TOC entry 4061 (class 1259 OID 17440)
-- Name: idx_meseros_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_meseros_nombre ON public.meseros USING btree (nombre);


--
-- TOC entry 4070 (class 1259 OID 17441)
-- Name: idx_pedido_detalle_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_pedido ON public.pedido_detalle USING btree (pedido_id);


--
-- TOC entry 4071 (class 1259 OID 17442)
-- Name: idx_pedido_detalle_receta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_receta ON public.pedido_detalle USING btree (receta_id);


--
-- TOC entry 4074 (class 1259 OID 17443)
-- Name: idx_pedidos_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_codigo ON public.pedidos USING btree (codigo);


--
-- TOC entry 4075 (class 1259 OID 17444)
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha ON public.pedidos USING btree (fecha_hora);


--
-- TOC entry 4080 (class 1259 OID 17445)
-- Name: idx_proveedores_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedores_nombre ON public.proveedores USING btree (nombre);


--
-- TOC entry 4081 (class 1259 OID 17446)
-- Name: idx_proveedores_restaurante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedores_restaurante ON public.proveedores USING btree (restaurante_id, nombre);


--
-- TOC entry 4086 (class 1259 OID 17447)
-- Name: idx_receta_ingredientes_ingrediente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_ingrediente ON public.receta_ingredientes USING btree (ingrediente_id);


--
-- TOC entry 4087 (class 1259 OID 17448)
-- Name: idx_receta_ingredientes_receta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_receta ON public.receta_ingredientes USING btree (receta_id);


--
-- TOC entry 4092 (class 1259 OID 17449)
-- Name: idx_recetas_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recetas_activo ON public.recetas USING btree (activo);


--
-- TOC entry 4093 (class 1259 OID 17450)
-- Name: idx_recetas_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recetas_nombre ON public.recetas USING btree (nombre);


--
-- TOC entry 4104 (class 1259 OID 17451)
-- Name: idx_usuarios_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_email ON public.usuarios USING btree (email);


--
-- TOC entry 4105 (class 1259 OID 17452)
-- Name: idx_usuarios_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_username ON public.usuarios USING btree (username);


--
-- TOC entry 4244 (class 2620 OID 17453)
-- Name: restaurante trg_restaurante_updated; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_restaurante_updated BEFORE UPDATE ON core.restaurante FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4245 (class 2620 OID 17454)
-- Name: usuarios trg_usuarios_updated; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_usuarios_updated BEFORE UPDATE ON core.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4246 (class 2620 OID 17455)
-- Name: banco trg_banco_updated; Type: TRIGGER; Schema: finanzas; Owner: postgres
--

CREATE TRIGGER trg_banco_updated BEFORE UPDATE ON finanzas.banco FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4247 (class 2620 OID 17456)
-- Name: ingredientes trg_ingredientes_updated; Type: TRIGGER; Schema: inventario; Owner: postgres
--

CREATE TRIGGER trg_ingredientes_updated BEFORE UPDATE ON inventario.ingredientes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4248 (class 2620 OID 17457)
-- Name: proveedores trg_proveedores_updated; Type: TRIGGER; Schema: inventario; Owner: postgres
--

CREATE TRIGGER trg_proveedores_updated BEFORE UPDATE ON inventario.proveedores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4249 (class 2620 OID 17458)
-- Name: categorias trg_categorias_updated; Type: TRIGGER; Schema: menu; Owner: postgres
--

CREATE TRIGGER trg_categorias_updated BEFORE UPDATE ON menu.categorias FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4250 (class 2620 OID 17459)
-- Name: recetas trg_recetas_updated; Type: TRIGGER; Schema: menu; Owner: postgres
--

CREATE TRIGGER trg_recetas_updated BEFORE UPDATE ON menu.recetas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4251 (class 2620 OID 17460)
-- Name: mesas trg_mesas_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_mesas_updated BEFORE UPDATE ON operaciones.mesas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4252 (class 2620 OID 17461)
-- Name: meseros trg_meseros_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_meseros_updated BEFORE UPDATE ON operaciones.meseros FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4253 (class 2620 OID 17462)
-- Name: pedidos trg_pedidos_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_pedidos_updated BEFORE UPDATE ON operaciones.pedidos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4254 (class 2620 OID 17463)
-- Name: proveedores update_proveedores_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_proveedores_updated_at BEFORE UPDATE ON public.proveedores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4255 (class 2620 OID 17464)
-- Name: restaurante update_restaurante_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_restaurante_updated_at BEFORE UPDATE ON public.restaurante FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4241 (class 2606 OID 18173)
-- Name: asiento_lineas fk_asiento_lineas_asiento; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT fk_asiento_lineas_asiento FOREIGN KEY (asiento_id) REFERENCES contabilidad.asientos(id) ON DELETE CASCADE;


--
-- TOC entry 4242 (class 2606 OID 18178)
-- Name: asiento_lineas fk_asiento_lineas_cuenta; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT fk_asiento_lineas_cuenta FOREIGN KEY (cuenta_id) REFERENCES contabilidad.plan_cuentas(id);


--
-- TOC entry 4243 (class 2606 OID 18183)
-- Name: asiento_lineas fk_asiento_lineas_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT fk_asiento_lineas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4240 (class 2606 OID 18151)
-- Name: asientos fk_asientos_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos
    ADD CONSTRAINT fk_asientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4135 (class 2606 OID 17465)
-- Name: libro_diario fk_libro_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario
    ADD CONSTRAINT fk_libro_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4238 (class 2606 OID 18124)
-- Name: plan_cuentas fk_plan_cuentas_padre; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuentas_padre FOREIGN KEY (padre_id) REFERENCES contabilidad.plan_cuentas(id);


--
-- TOC entry 4239 (class 2606 OID 18129)
-- Name: plan_cuentas fk_plan_cuentas_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuentas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4137 (class 2606 OID 17470)
-- Name: usuarios FK_7ba064af415d3da35c33731f743; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT "FK_7ba064af415d3da35c33731f743" FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id);


--
-- TOC entry 4136 (class 2606 OID 17475)
-- Name: metodos_pago fk_metodos_pago_restaurante; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4139 (class 2606 OID 17480)
-- Name: banco_movimientos fk_banco_mov_banco; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id);


--
-- TOC entry 4140 (class 2606 OID 17485)
-- Name: banco_movimientos fk_banco_mov_metodo_pago; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4141 (class 2606 OID 17490)
-- Name: banco_movimientos fk_banco_mov_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4142 (class 2606 OID 17495)
-- Name: banco_movimientos fk_banco_mov_usuario; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4138 (class 2606 OID 17500)
-- Name: banco fk_banco_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4146 (class 2606 OID 17505)
-- Name: caja_movimientos fk_caja_mov_caja; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_caja FOREIGN KEY (caja_id) REFERENCES finanzas.caja(id);


--
-- TOC entry 4147 (class 2606 OID 17510)
-- Name: caja_movimientos fk_caja_mov_metodo_pago; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4148 (class 2606 OID 17515)
-- Name: caja_movimientos fk_caja_mov_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4149 (class 2606 OID 17520)
-- Name: caja_movimientos fk_caja_mov_usuario; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4143 (class 2606 OID 17525)
-- Name: caja fk_caja_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4144 (class 2606 OID 17530)
-- Name: caja fk_caja_usuario_apertura; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4145 (class 2606 OID 17535)
-- Name: caja fk_caja_usuario_cierre; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4150 (class 2606 OID 17540)
-- Name: egresos fk_egresos_categoria; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES inventario.categoria_egresos(id);


--
-- TOC entry 4151 (class 2606 OID 17545)
-- Name: egresos fk_egresos_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4237 (class 2606 OID 18101)
-- Name: gastos_operativos fk_gastos_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.gastos_operativos
    ADD CONSTRAINT fk_gastos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4152 (class 2606 OID 17550)
-- Name: categoria_egresos fk_cat_egresos_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos
    ADD CONSTRAINT fk_cat_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4153 (class 2606 OID 17555)
-- Name: compra_detalle fk_compra_det_compra; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_compra FOREIGN KEY (compra_id) REFERENCES inventario.compras(id) ON DELETE CASCADE;


--
-- TOC entry 4154 (class 2606 OID 17560)
-- Name: compra_detalle fk_compra_det_ingrediente; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4155 (class 2606 OID 17565)
-- Name: compra_detalle fk_compra_det_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4156 (class 2606 OID 17570)
-- Name: compra_detalle fk_compra_det_unidad; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_unidad FOREIGN KEY (unidad_compra_id) REFERENCES inventario.unidad_compra(id);


--
-- TOC entry 4157 (class 2606 OID 17575)
-- Name: compras fk_compras_proveedor; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES inventario.proveedores(id);


--
-- TOC entry 4158 (class 2606 OID 17580)
-- Name: compras fk_compras_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4159 (class 2606 OID 17585)
-- Name: ingredientes fk_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4160 (class 2606 OID 17590)
-- Name: ingredientes fk_ingredientes_unidad; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES core.unidad_medida(id);


--
-- TOC entry 4161 (class 2606 OID 17595)
-- Name: mermas fk_mermas_ingrediente; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4162 (class 2606 OID 17600)
-- Name: mermas fk_mermas_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4163 (class 2606 OID 17605)
-- Name: mermas fk_mermas_usuario; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_usuario FOREIGN KEY (reportado_por) REFERENCES core.usuarios(id);


--
-- TOC entry 4164 (class 2606 OID 17610)
-- Name: proveedores fk_proveedores_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4165 (class 2606 OID 17615)
-- Name: unidad_compra fk_unidad_compra_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4166 (class 2606 OID 17620)
-- Name: products products_categoria_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES inventory.categories(id);


--
-- TOC entry 4167 (class 2606 OID 17625)
-- Name: categorias fk_categorias_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias
    ADD CONSTRAINT fk_categorias_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4168 (class 2606 OID 17630)
-- Name: receta_ingredientes fk_receta_ing_ingrediente; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4169 (class 2606 OID 17635)
-- Name: receta_ingredientes fk_receta_ing_receta; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id) ON DELETE CASCADE;


--
-- TOC entry 4170 (class 2606 OID 17640)
-- Name: receta_ingredientes fk_receta_ing_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4171 (class 2606 OID 17645)
-- Name: recetas fk_recetas_categoria; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT fk_recetas_categoria FOREIGN KEY (categoria_id) REFERENCES menu.categorias(id);


--
-- TOC entry 4172 (class 2606 OID 17650)
-- Name: recetas fk_recetas_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4173 (class 2606 OID 17655)
-- Name: facturas fk_facturas_metodo_pago; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4174 (class 2606 OID 17660)
-- Name: facturas fk_facturas_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id);


--
-- TOC entry 4175 (class 2606 OID 17665)
-- Name: facturas fk_facturas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4176 (class 2606 OID 17670)
-- Name: facturas fk_facturas_usuario; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4177 (class 2606 OID 17675)
-- Name: mesas fk_mesas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4178 (class 2606 OID 17680)
-- Name: meseros fk_meseros_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4179 (class 2606 OID 17685)
-- Name: pedido_detalle fk_pedido_det_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4180 (class 2606 OID 17690)
-- Name: pedido_detalle fk_pedido_det_receta; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id);


--
-- TOC entry 4181 (class 2606 OID 17695)
-- Name: pedido_detalle fk_pedido_det_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4182 (class 2606 OID 17700)
-- Name: pedidos fk_pedidos_mesa; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);


--
-- TOC entry 4183 (class 2606 OID 17705)
-- Name: pedidos fk_pedidos_mesero; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES operaciones.meseros(id);


--
-- TOC entry 4184 (class 2606 OID 17710)
-- Name: pedidos fk_pedidos_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4185 (class 2606 OID 17715)
-- Name: reservas fk_reservas_mesa; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT fk_reservas_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);


--
-- TOC entry 4186 (class 2606 OID 17720)
-- Name: reservas fk_reservas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT fk_reservas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4235 (class 2606 OID 18072)
-- Name: transacciones_pago fk_trans_pago_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago
    ADD CONSTRAINT fk_trans_pago_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4236 (class 2606 OID 18077)
-- Name: transacciones_pago fk_trans_pago_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago
    ADD CONSTRAINT fk_trans_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4215 (class 2606 OID 17725)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4188 (class 2606 OID 17730)
-- Name: banco_movimientos fk_banco_movimientos_banco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_banco FOREIGN KEY (banco_id) REFERENCES public.banco(id);


--
-- TOC entry 4189 (class 2606 OID 17735)
-- Name: banco_movimientos fk_banco_movimientos_metodo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES public.metodos_pago(id);


--
-- TOC entry 4190 (class 2606 OID 17740)
-- Name: banco_movimientos fk_banco_movimientos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4191 (class 2606 OID 17745)
-- Name: banco_movimientos fk_banco_movimientos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4187 (class 2606 OID 17750)
-- Name: banco fk_banco_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4195 (class 2606 OID 17755)
-- Name: caja_movimientos fk_caja_movimientos_caja; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_caja FOREIGN KEY (caja_id) REFERENCES public.caja(id);


--
-- TOC entry 4196 (class 2606 OID 17760)
-- Name: caja_movimientos fk_caja_movimientos_metodo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES public.metodos_pago(id);


--
-- TOC entry 4197 (class 2606 OID 17765)
-- Name: caja_movimientos fk_caja_movimientos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4198 (class 2606 OID 17770)
-- Name: caja_movimientos fk_caja_movimientos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4192 (class 2606 OID 17775)
-- Name: caja fk_caja_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4193 (class 2606 OID 17780)
-- Name: caja fk_caja_usuario_apertura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4194 (class 2606 OID 17785)
-- Name: caja fk_caja_usuario_cierre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4199 (class 2606 OID 17790)
-- Name: categoria_egresos fk_categoria_egresos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos
    ADD CONSTRAINT fk_categoria_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4200 (class 2606 OID 17795)
-- Name: compra_detalle fk_compra_detalle_compra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_compra FOREIGN KEY (compra_id) REFERENCES public.compras(id) ON DELETE CASCADE;


--
-- TOC entry 4201 (class 2606 OID 17800)
-- Name: compra_detalle fk_compra_detalle_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES public.ingredientes(id);


--
-- TOC entry 4202 (class 2606 OID 17805)
-- Name: compra_detalle fk_compra_detalle_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4203 (class 2606 OID 17810)
-- Name: compra_detalle fk_compra_detalle_unidad_compra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_unidad_compra FOREIGN KEY (unidad_compra_id) REFERENCES public.unidad_compra(id);


--
-- TOC entry 4204 (class 2606 OID 17815)
-- Name: compras fk_compras_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES public.proveedores(id);


--
-- TOC entry 4205 (class 2606 OID 17820)
-- Name: compras fk_compras_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4206 (class 2606 OID 17825)
-- Name: egresos fk_egresos_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES public.categoria_egresos(id);


--
-- TOC entry 4207 (class 2606 OID 17830)
-- Name: egresos fk_egresos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4208 (class 2606 OID 17835)
-- Name: facturas fk_facturas_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id);


--
-- TOC entry 4209 (class 2606 OID 17840)
-- Name: facturas fk_facturas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4210 (class 2606 OID 17845)
-- Name: ingredientes fk_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4211 (class 2606 OID 17850)
-- Name: ingredientes fk_ingredientes_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES public.unidad_medida(id);


--
-- TOC entry 4212 (class 2606 OID 17855)
-- Name: mesas fk_mesas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4213 (class 2606 OID 17860)
-- Name: meseros fk_meseros_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4214 (class 2606 OID 17865)
-- Name: metodos_pago fk_metodos_pago_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4216 (class 2606 OID 17870)
-- Name: pedido_detalle fk_pedido_detalle_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4217 (class 2606 OID 17875)
-- Name: pedido_detalle fk_pedido_detalle_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_receta FOREIGN KEY (receta_id) REFERENCES public.recetas(id);


--
-- TOC entry 4218 (class 2606 OID 17880)
-- Name: pedido_detalle fk_pedido_detalle_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4219 (class 2606 OID 17885)
-- Name: pedidos fk_pedidos_mesa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES public.mesas(id);


--
-- TOC entry 4220 (class 2606 OID 17890)
-- Name: pedidos fk_pedidos_mesero; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES public.meseros(id);


--
-- TOC entry 4221 (class 2606 OID 17895)
-- Name: pedidos fk_pedidos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4222 (class 2606 OID 17900)
-- Name: proveedores fk_proveedores_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4223 (class 2606 OID 17905)
-- Name: receta_ingredientes fk_receta_ingredientes_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES public.ingredientes(id);


--
-- TOC entry 4224 (class 2606 OID 17910)
-- Name: receta_ingredientes fk_receta_ingredientes_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_receta FOREIGN KEY (receta_id) REFERENCES public.recetas(id) ON DELETE CASCADE;


--
-- TOC entry 4225 (class 2606 OID 17915)
-- Name: receta_ingredientes fk_receta_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4226 (class 2606 OID 17920)
-- Name: recetas fk_recetas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4227 (class 2606 OID 17925)
-- Name: roles fk_roles_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT fk_roles_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4228 (class 2606 OID 17930)
-- Name: unidad_compra fk_unidad_compra_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4229 (class 2606 OID 17935)
-- Name: usuarios fk_usuarios_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4230 (class 2606 OID 17940)
-- Name: usuarios fk_usuarios_rol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES public.roles(id);


--
-- TOC entry 4231 (class 2606 OID 17945)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES sales.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4232 (class 2606 OID 17950)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id);


--
-- TOC entry 4233 (class 2606 OID 17955)
-- Name: orders orders_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES core.restaurante(id);


--
-- TOC entry 4234 (class 2606 OID 17960)
-- Name: orders orders_table_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES core.tables(id);


-- Completed on 2026-04-07 20:21:11 -04

--
-- PostgreSQL database dump complete
--

\unrestrict WUAK399PlKghsnngOnAtz92gQCKgYycfoEsreHVHkya4aeirIQKy0EEvD3YoqsA

