# Reports API

> Endpoints para obtener reportes financieros, operativos y de inventario, incluyendo predicciones de ventas.

**Base URL:** `/api/v1/reports`

---

## 1. Resumen de Dashboard (Overview)

Obtiene el resumen de KPIs similar al panel de administración.

**Endpoint:** `GET /overview`  
**Auth:** Requiere token JWT.  
**Rol permitido:** `admin`

### Respuesta Exitosa (200 OK)

```json
{
  "status": "success",
  "data": {
    "kpis": {
      "ingreso_bruto": 1500.50,
      "costo_operativo": 600.20,
      "tickets_semana": 120
    },
    "rentabilidad": [],
    "chartData": []
  }
}
```

---

## 2. Generación de Reportes

Obtiene datos tabulares para diversos tipos de reportes, filtrados por rango de fechas opcional.

**Endpoint:** `GET /`  
**Auth:** Requiere token JWT.  
**Rol permitido:** `admin`

### Parámetros de Query (Query Params)

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `type` | string | **Sí** | Tipo de reporte: `ventas`, `inventario`, `empleados`, `gastos`, `contabilidad`, `mermas`, `predicciones` |
| `dateFrom` | string | No | Fecha de inicio (formato `YYYY-MM-DD`) |
| `dateTo` | string | No | Fecha de fin (formato `YYYY-MM-DD`) |

### Tipos de Reportes Soportados

- **`ventas`**: Historial de pedidos pagados y cerrados.
- **`inventario`**: Estado actual del inventario, con alertas de nivel crítico.
- **`empleados`**: Ventas generadas y horas (turnos) por empleado.
- **`gastos`**: Registro de gastos operativos.
- **`contabilidad`**: Asientos contables y movimientos en libro diario.
- **`mermas`**: Insumos perdidos, cantidad y costo asociado.
- **`predicciones`**: Pronóstico de ventas a 7 días basado en una media móvil de 30 días.

### Respuesta Exitosa (200 OK) - Ejemplo tipo 'ventas'

```json
{
  "status": "success",
  "data": [
    {
      "fecha": "2026-04-15 14:30:00",
      "ticket": "PED-20260415-0001",
      "base": "$40.00",
      "tax": "$6.40",
      "total": "$46.40"
    }
  ]
}
```

### Respuesta Exitosa (200 OK) - Ejemplo tipo 'predicciones'

```json
{
  "status": "success",
  "data": [
    {
      "fecha_proyectada": "2026-05-04",
      "concepto": "Venta Proyectada (Pronóstico)",
      "monto_estimado": "$150.25",
      "metodo": "Basado en media móvil 30d"
    }
  ]
}
```
