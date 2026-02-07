# KOMANDA  
Sistema Integral de Gestión para Restaurantes (SaaS)

---

# Tabla de Contenidos
1. [Definición del Sistema](#definición-del-sistema)  
2. [Arquitectura Funcional y Módulos](#arquitectura-funcional-y-módulos)  
   - [1. Módulo de Inventario y Logística](#1-módulo-de-inventario-y-logística-el-activo)  
   - [2. Módulo de Ingeniería de Menú](#2-módulo-de-ingeniería-de-menú-costos-y-precios)  
   - [3. Módulo de Operaciones](#3-módulo-de-operaciones-punto-de-venta-y-cocina)  
   - [4. Módulo Contable y Financiero](#4-módulo-contable-y-financiero)  
3. [Roles de Usuario y Permisos (RBAC)](#roles-de-usuario-y-permisos-rbac)  
4. [Validaciones Críticas del Sistema](#validaciones-críticas-del-sistema)  
5. [Notas y Observaciones Generales](#notas-y-observaciones-generales)

---

# Definición del Sistema
**KOMANDA** es un sistema de información web (SaaS) diseñado para la gestión integral de restaurantes. Su objetivo principal es centralizar las operaciones de ventas, compras e inventario, garantizando la trazabilidad financiera en tiempo real.  
Además de gestionar la toma de pedidos, automatiza la contabilidad de costos y genera estados financieros precisos basados en la operación diaria.

---

# Arquitectura Funcional y Módulos
El sistema se estructura en cuatro módulos principales que interactúan entre sí para asegurar la integridad de los datos contables y operativos.

---

# 1. Módulo de Inventario y Logística (El Activo)

## Gestión de Insumos
- Registro detallado de materias primas.
- Diferenciación entre:
  - **Unidad de compra:** Ej. *Saco de 50 kg*  
  - **Unidad de consumo:** Ej. *Gramos*

## Valorización de Inventario
- Cálculo automático del **Costo Promedio Ponderado (CPP)** tras cada compra.
- Determinación del valor monetario real del inventario (**Activo Corriente**).

## Alertas y Restricciones
- Notificación de niveles mínimos y puntos de reorden.
- **Bloqueo de ventas** si el inventario disponible de ingredientes es insuficiente.

> **Nota:** Este módulo es crítico para garantizar la integridad financiera del sistema, ya que alimenta directamente los costos de venta y el balance general.

---

# 2. Módulo de Ingeniería de Menú (Costos y Precios)

## Recetas Estándar (BOM)
- Definición precisa de platos.
- Asociación de ingredientes, cantidades y unidades de consumo.

## Precios Dinámicos
- Sugerencia automática del **Precio de Venta al Público (PVP)** basada en:
  - Costo actual de ingredientes  
  - Margen de utilidad configurado
- Visualización de rentabilidad por plato ante variaciones de costos.

> **Observación:** La estandarización de recetas es esencial para evitar variaciones en costos y garantizar la rentabilidad real del negocio.

---

# 3. Módulo de Operaciones (Punto de Venta y Cocina)

## Toma de Pedidos (Meseros)
- Registro de comandas.
- Validación en tiempo real de disponibilidad de stock.

## Gestión de Cocina (KDS)
- Visualización de pedidos en tiempo real.
- Al marcar una orden como *Lista* o *Entregada*, se ejecuta la baja automática de inventario (**Back-flushing**).

## Caja y Facturación
- Gestión de cobros.
- Múltiples métodos de pago.
- Cierre de caja diario (arqueo).

> **Nota:** El back-flushing garantiza que el inventario se descuente exactamente cuando la cocina confirma la preparación, evitando inconsistencias.

---

# 4. Módulo Contable y Financiero

## Registro de Gastos Operativos
- Control de gastos fijos y variables:
  - Alquiler
  - Servicios
  - Nómina básica

## Estados Financieros Automáticos

### Balance General
- **Activos:**
  - Caja/Bancos
  - Valor del Inventario
- **Pasivos:**
  - Cuentas por pagar a proveedores
- **Patrimonio**

### Estado de Resultados
- Ventas Totales  
- Costos de Venta (Materia Prima)  
- Gastos Operativos  
- **Utilidad Neta**

> **Observación:** Este módulo convierte automáticamente la operación diaria en información contable formal, reduciendo errores humanos y tiempos de cierre.

---

# Roles de Usuario y Permisos (RBAC)

## Administrador / Gerente
- Acceso total.
- Configuración de recetas.
- Aprobación de compras.
- Visualización de costos y reportes contables.
- Ajuste de precios de venta.

## Cajero
- Facturación, cobro y cierre de caja.
- Sin acceso a estructura de costos.

## Mesero
- Toma de pedidos.
- Consulta de disponibilidad de platos.

## Cocina
- Visualización de comandas.
- Gestión de estados de preparación.

> **Nota:** La separación de roles evita fraudes, errores y accesos indebidos a información sensible.

---

# Validaciones Críticas del Sistema

## Integridad de Stock
- No se puede facturar ni comandar un producto si los ingredientes requeridos no están disponibles.

## Costo Histórico vs. Actual
- Registro del costo histórico de insumos para calcular correctamente la utilidad del periodo, independientemente de fluctuaciones futuras.

> **Observación:** Esta validación es clave para cumplir con estándares contables y evitar distorsiones en los estados financieros.

---

# Notas y Observaciones Generales

- El sistema debe garantizar **consistencia transaccional** entre módulos (inventario, ventas, costos y contabilidad).
- La trazabilidad es un requisito central: cada movimiento debe dejar un rastro auditable.
- La arquitectura debe permitir escalabilidad para múltiples sucursales.
- El sistema debe registrar **todas las operaciones en tiempo real** para evitar desbalances.
- La estandarización de recetas y el control de inventario son los pilares para obtener estados financieros confiables.
