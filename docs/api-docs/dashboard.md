# Dashboard API

> Endpoints para obtener KPIs, metricas y resúmenes de datos para los diferentes roles.

**Base URL:** `/api/v1/dashboard`

---

## 1. Estadísticas del Administrador

Obtiene los KPIs principales, rentabilidad de los platos y datos para la gráfica de ingresos de los últimos 7 días.

**Endpoint:** `GET /admin/stats`  
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
    "rentabilidad": [
      {
        "name": "Hamburguesa Doble",
        "emoji": "🍽️",
        "price": 10.5,
        "cost": 4.2,
        "units": 45,
        "margin": 6.3,
        "marginPct": 60,
        "totalGain": 283.5
      }
    ],
    "chartData": [
      {
        "date": "15/04",
        "revenue": 300,
        "cost": 100
      }
    ]
  }
}
```

---

## 2. Órdenes de Cocina

Obtiene un resumen de las órdenes activas para la vista principal de la cocina.

**Endpoint:** `GET /kitchen/orders`  
**Auth:** Requiere token JWT.  
**Roles permitidos:** `admin`, `cocina`

---

## 3. Mesas del Mesero

Obtiene el estado de las mesas asignadas al mesero autenticado.

**Endpoint:** `GET /waiter/tables`  
**Auth:** Requiere token JWT.  
**Roles permitidos:** `admin`, `mesero`

---

## 4. Estadísticas del Mesero

Obtiene las estadísticas de desempeño del mesero (propinas, total vendido, etc).

**Endpoint:** `GET /waiter/stats`  
**Auth:** Requiere token JWT.  
**Roles permitidos:** `admin`, `mesero`
