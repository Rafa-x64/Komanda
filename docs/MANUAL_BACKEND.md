# 🛠️ Manual de Backend (API)

> "Aquí forjamos la lógica que mueve los engranajes. Si el backend falla, el restaurante cierra."

## 1. Estructura de un Módulo Nuevo

Para crear un nuevo módulo (ej. `promotions`), crea la carpeta en `modules/` siguiendo esta estructura sagrada:

```bash
/src/modules/promotions/
├── promotions.controller.ts  # Recibe HTTP, valida DTOs, llama servicios
├── promotions.service.ts     # Orquesta la lógica de negocio
├── promotions.model.ts       # Definición de tabla (Entity)
└── dtos/                     # Data Transfer Objects (Input Validation)
    ├── create-promotion.dto.ts
    └── update-promotion.dto.ts
```

## 2. Creando un Endpoint (Paso a Paso)

### A. Define el DTO (Input)

Primero, define qué datos esperas recibir. Usa `zod` o `class-validator`.

```typescript
// dtos/create-promotion.dto.ts
export class CreatePromotionDto {
  name: string;
  discountPercentage: number;
  startDate: Date;
}
```

### B. Crea el Servicio (Lógica)

Aquí va la magia. Validaciones de negocio y llamadas a DB.

```typescript
// promotions.service.ts
export class PromotionsService {
  async create(data: CreatePromotionDto) {
    if (data.discountPercentage > 100) {
      throw new Error("No regales el restaurante, crack.");
    }
    return await PromotionModel.save(data);
  }
}
```

### C. Crea el Controlador (HTTP)

Conecta la ruta con el servicio.

```typescript
// promotions.controller.ts
export const createPromotion = async (req: Request, res: Response) => {
  try {
    const result = await promotionsService.create(req.body);
    res.status(201).json({ status: "success", data: result });
  } catch (error) {
    res.status(400).json({ status: "fail", message: error.message });
  }
};
```

### D. Registra la Ruta

Ve a `modules/index.ts` (o tu router principal) y añade la ruta.

```typescript
router.post("/promotions", createPromotion);
```

## 3. Base de Datos & Migraciones

Usamos **PostgreSQL**. Si cambias un modelo, **DEBES** crear una migración.

```bash
# Crear migración
pnpm typeorm migration:create -n AddPromotionsTable

# Correr migraciones
pnpm typeorm migration:run
```

## 4. Testing

No subas código sin probar. Al menos un test unitario para el servicio.

```typescript
// promotions.service.test.ts
test("should throw error if discount > 100", async () => {
  await expect(service.create({ discountPercentage: 101 })).rejects.toThrow();
});
```

---

> **Tip:** Usa `pnpm dev:api` para levantar solo el backend y ver los logs limpios.
