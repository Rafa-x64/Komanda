# KOMANDA  
Sistema Web Contable SaaS para la Gestión Integral de Restaurantes

---

# Tabla de Contenidos
1. [Definición del Sistema](#definición-del-sistema)  
2. [Arquitectura Funcional y Módulos](#arquitectura-funcional-y-módulos)  
   - [1. Almacén y Compras](#1-almacén-y-compras)  
   - [2. Menú y Recetas](#2-menú-y-recetas)  
   - [3. Punto de Venta](#3-punto-de-venta)  
   - [4. Contabilidad](#4-contabilidad)  
   - [5. Gastos Operativos](#5-gastos-operativos)  
3. [Contexto SaaS Multi-Restaurante](#contexto-saas-multi-restaurante)  
4. [Roles de Usuario y Permisos (RBAC)](#roles-de-usuario-y-permisos-rbac)  
5. [Validaciones Críticas del Sistema](#validaciones-críticas-del-sistema)  
6. [Notas y Observaciones Generales](#notas-y-observaciones-generales)

---

# Definición del Sistema

**KOMANDA** es un sistema de información web de tipo **SaaS (Software as a Service)** diseñado para la gestión integral de restaurantes. Al ser SaaS, una misma instalación puede administrar **múltiples restaurantes**, siendo cada uno un tenant independiente con sus propios datos, usuarios y reportes.

Su objetivo principal es centralizar operaciones de ventas, compras e inventario, garantizando la trazabilidad financiera en tiempo real. El sistema automatiza la contabilidad de costos y genera estados financieros precisos basados en la operación diaria de cada restaurante.

> **Requerimiento académico:** Este sistema debe cumplir con los requerimientos del enunciado del proyecto del curso de Costos y Ventas para Restaurantes (Rafael Álvarez), implementando contabilidad de costos completa, control de inventario por recetas y punto de venta unificado.

---

# Arquitectura Funcional y Módulos

El sistema se estructura en **cinco módulos principales** que interactúan entre sí para asegurar la integridad operativa y contable. Se eliminaron módulos redundantes y se consolidaron funciones relacionadas para una experiencia de usuario más limpia.

---

# 1. Almacén y Compras

> Combina la gestión de materias primas y el control de compras en un único lugar, que es donde naturalmente ocurren ambas operaciones.

## Gestión de Ingredientes (Materias Primas)

- Registro de ingredientes con nombre, unidad de medida (gramos, litros, kilogramos, unidades) y stock mínimo.
- Diferenciación entre:
  - **Unidad de compra:** Ej. *Saco de 50 kg*  
  - **Unidad de consumo:** Ej. *Gramos* (con factor de conversión automático)
- Registro de proveedores.

## Control de Compras

- Registro de entradas de mercancía (aumento de stock).
- Cálculo automático del **Costo Promedio Ponderado (CPP)** tras cada compra nueva.
- Asociación de compras a proveedores para registro de cuentas por pagar.
- Valorización del inventario en tiempo real (**Activo Corriente** del Balance General).

## Alertas de Stock

- Notificación de **Stock Crítico** cuando un ingrediente cae por debajo del mínimo configurado.
- **Bloqueo de ventas** si el stock de ingredientes de una receta es insuficiente.

> **Nota:** Este módulo alimenta directamente los costos de venta y el balance general. Es el pilar financiero del sistema.

---

# 2. Menú y Recetas

> Estandarización de platos (Bill of Materials) y definición de precios dinámicos basados en costo real.

## Recetas Estándar (BOM - Bill of Materials)

- Definición de platos del menú.
- Asociación de ingredientes con cantidades exactas y unidades de consumo.
- Ejemplo: *"Arroz con Salchicha"* consume 200g de arroz, 50g de salchicha y 10g de cebollín.
- Campo de imagen del plato para visualización en POS/KDS.

## Precios Dinámicos

- **Sugerencia automática del Precio de Venta (PVP):** Se calcula sumando el costo actual de todos los ingredientes de la receta + el margen de utilidad configurado (ej. 30%).
- **Ajuste manual:** El administrador puede sobrescribir el precio sugerido desde el mercado.
- Visualización de la rentabilidad por plato en tiempo real.

## Descuento Automático de Inventario

- Al procesar una venta en el Punto de Venta, el sistema resta automáticamente del stock las cantidades proporcionales de cada ingrediente según la receta (**Back-flushing**).

> **Observación:** La estandarización de recetas es esencial para calcular correctamente el Costo de Ventas en el Estado de Resultados.

---

# 3. Punto de Venta

> El módulo de ventas y caja es **un único lugar**. Aquí se registra la venta, se selecciona el método de pago y se cierra la transacción. No hay módulos separados de "ventas" y "caja".

## Toma de Pedidos

- Selección de platos del menú disponibles.
- Validación en tiempo real: si un plato no tiene stock suficiente de ingredientes, se deshabilita.
- Posibilidad de enviar comanda a cocina (KDS).

## Cobro y Registro de Transacciones

El pago puede realizarse con **uno o más métodos** en la misma venta:

| Método de Pago       | Descripción                                   |
| :------------------- | :-------------------------------------------- |
| **Efectivo**         | Bolívares o divisa (USD, EUR, etc.)           |
| **Pago Móvil**       | Transferencia vía Pago Móvil Venezolano       |
| **Tarjeta**          | Débito o crédito (punto de venta físico)      |
| **Divisa en Efectivo** | Dólares / Euros en físico                  |

> **Regla clave:** Cada venta registra **qué método(s) se usaron y por qué monto**. Un arqueo puede realizarse por método de pago. Aunque todo va en el mismo lugar, se especifica con qué transacción se pagó cada venta.

## Facturación

- Generación de comprobante/ticket de venta.
- Registro del monto por cada método de pago utilizado.

## Cierre de Caja (Arqueo)

- Cierre diario con resumen de ventas por método de pago.
- Registro del fondo inicial de caja.
- Diferencias (sobrantes/faltantes) documentadas.

> **Nota:** El back-flushing de inventario ocurre cuando la cocina confirma la entrega del plato, garantizando que el stock se descuente en el momento correcto.

---

# 4. Contabilidad

> Módulo contable **completo y automatizado**. Cada operación del sistema genera su asiento contable correspondiente, sin intervención manual.

## Libro Diario (Asientos Automáticos)

El sistema genera asientos contables automáticos para cada evento:

- **Compra de ingredientes:** Debe → Inventario / Haber → Cuentas por Pagar (o Caja si fue de contado).
- **Venta:** Debe → Caja o Banco / Haber → Ingresos por Ventas.
- **Costo de Venta:** Debe → Costo de Ventas / Haber → Inventario (por el valor de los ingredientes consumidos al CPP).
- **Pago de gasto operativo:** Debe → Gasto (Agua, Luz, etc.) / Haber → Caja o Banco.

## Balance General

| Sección        | Cuentas Incluidas                                  |
| :------------- | :------------------------------------------------- |
| **Activos**    | Caja/Bancos, Inventario (valorizado al CPP)        |
| **Pasivos**    | Cuentas por pagar a proveedores de insumos         |
| **Patrimonio** | Capital social + Utilidades acumuladas del período |

## Estado de Resultados

| Línea                   | Detalle                                                    |
| :---------------------- | :--------------------------------------------------------- |
| **Ingresos**            | Total de ventas del período                                |
| **(-) Costo de Ventas** | Valor de ingredientes consumidos (calculado al CPP)        |
| **= Utilidad Bruta**    |                                                            |
| **(-) Gastos**          | Agua, Gas, Electricidad, Internet, Alquiler                |
| **= Utilidad Neta**     | Resultado final del ejercicio                              |

## Reporte de Rentabilidad por Plato

- Comparativa entre el costo de producción (suma CPP de ingredientes) y el precio de venta final.
- Margen de utilidad real vs. margen configurado.

> **Observación:** Este módulo convierte automáticamente la operación diaria en información contable formal, eliminando errores humanos y reduciendo los tiempos de cierre contable.

---

# 5. Gastos Operativos

> Módulo exclusivo para el registro de los gastos fijos del restaurante que afectan directamente al Estado de Resultados.

## Gastos Registrables

Solo se registran los siguientes conceptos (según el enunciado):

- Agua
- Gas
- Electricidad
- Internet
- Alquiler

## Registro

- Fecha del gasto, monto, descripción y método de pago (caja o banco).
- Generación automática del asiento contable correspondiente.
- Acumulación mensual/periódica para el Estado de Resultados.

---

# Contexto SaaS Multi-Restaurante

**KOMANDA** está concebido como una plataforma SaaS. Esto implica:

- **Multi-tenant:** Cada restaurante es un tenant aislado. Sus datos de inventario, recetas, ventas y reportes son completamente independientes.
- **Administración Centralizada:** Un super-administrador puede gestionar todos los restaurantes desde un panel principal.
- **Roles por Restaurante:** Los permisos RBAC aplican por restaurante; un usuario puede ser Cajero en el Restaurante A y Admin en el Restaurante B.
- **Escalabilidad:** La arquitectura modular permite agregar nuevos restaurantes sin afectar los existentes.

---

# Roles de Usuario y Permisos (RBAC)

| Rol                  | Accesos                                                                          |
| :------------------- | :------------------------------------------------------------------------------- |
| **Super Admin**      | Gestión de todos los restaurantes (solo en contexto SaaS).                       |
| **Admin / Gerente**  | Todo: recetas, costos, compras, reportes contables, gastos, ajuste de precios.   |
| **Vendedor / Cajero**| Solo Punto de Venta: facturación de platos y consulta de disponibilidad de stock. |
| **Cocina**           | Visualización de comandas y cambio de estado de preparación (KDS).               |

> **Nota:** La separación de roles evita fraudes, errores y accesos indebidos a información sensible.

---

# Validaciones Críticas del Sistema

## Stock Insuficiente
- No se puede procesar una venta de un plato si los ingredientes requeridos no están disponibles en cantidad suficiente.

## Alerta de Stock Crítico
- El sistema notifica cuando un ingrediente cae por debajo del nivel mínimo configurado.

## Integridad Transaccional (ACID)
- Si el descuento de inventario falla, la venta no se registra. Todo o nada.

## Costo Histórico
- El costo usado al registrar el Costo de Ventas es el CPP **vigente en el momento de la venta**, no el precio actual del ingrediente.

---

# Notas y Observaciones Generales

- El sistema garantiza **consistencia transaccional** entre módulos.
- Cada movimiento deja un **rastro auditable** (trazabilidad completa).
- La arquitectura permite escalabilidad horizontal para múltiples restaurantes (SaaS).
- La estandarización de recetas y el control de inventario son los pilares para obtener estados financieros confiables.
- Se deben registrar **todas las operaciones en tiempo real** para evitar desbalances contables.
