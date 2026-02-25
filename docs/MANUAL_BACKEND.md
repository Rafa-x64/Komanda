# 🛠️ Manual de Backend (API)

> "Aquí forjamos la lógica que mueve los engranajes. Si el backend falla, el restaurante cierra."

Este manual describe cómo trabajar en el **Núcleo Híbrido** de KOMANDA: una fusión de **Node.js (TypeScript)** para velocidad y **PHP** para reportes/legacy.

---

## 📌 Tabla de Contenidos

1.  [Arquitectura Híbrida (Hybrid Core)](#1-arquitectura-híbrida-hybrid-core)
2.  [Estructura de Carpetas](#2-estructura-de-carpetas)
3.  [Flujo de Desarrollo: Paso a Paso](#3-flujo-de-desarrollo-paso-a-paso)
4.  [Paso 1: Entidad (domain/\*.entity.ts)](#paso-1-entidad)
5.  [Paso 2: Validador (\*.validator.ts)](#paso-2-validador)
6.  [Paso 3: Servicio (\*.service.ts)](#paso-3-servicio)
7.  [Paso 4: Controlador (\*.controller.ts)](#paso-4-controlador)
8.  [Paso 5: Rutas (\*.routes.ts)](#paso-5-rutas)
9.  [Paso 6: Registro en index.ts](#paso-6-registro-en-indexts)
10. [Conexión a la Base de Datos](#4-conexión-a-la-base-de-datos)
11. [Conexión Frontend → Backend (fetch)](#5-conexión-frontend--backend-fetch)
12. [Endpoint Tipo B: PHP (Reports)](#6-endpoint-tipo-b-php-reports)
13. [Errores Comunes y Soluciones](#7-errores-comunes-y-soluciones)

---

## 1. Arquitectura Híbrida (Hybrid Core)

KOMANDA corre dos servidores en paralelo dentro del mismo contenedor/máquina:

- **Node.js (Puerto 3000):** Maneja WebSockets, la lógica del POS, Kitchen Display System y todo lo que requiere alta concurrencia.
- **PHP (Puerto 8000):** Se usa como un "Script Runner" para generar PDFs, Excel, reportes contables complejos o lógica que es más fácil de mantener en PHP.

### ⚠️ Regla de Oro: CORS

Para que el Frontend (Puerto 5173) pueda hablar con ambos backends, SIEMPRE debes configurar los headers de CORS correctamente.

---

## 2. Estructura de Carpetas

Cada módulo nuevo va en `src/modules/` con esta estructura:

```bash
Komanda-api/src/
├── config/
│   └── database.ts              # Conexión a PostgreSQL (TypeORM DataSource)
├── index.ts                     # Entry Point: Express + CORS + Rutas
├── api/                         # Scripts PHP (endpoints sueltos)
│
└── modules/                     # 📂 Módulos de Node (DDD Lite)
    └── signup/                  # Ejemplo: Módulo de Registro
        ├── domain/              # Entidades TypeORM (representan tablas)
        │   ├── restaurant.entity.ts
        │   ├── user.entity.ts
        │   └── role.entity.ts
        ├── signup.validator.ts  # Validación de entrada (Zod)
        ├── signup.service.ts    # Lógica de negocio (transacciones, bcrypt)
        ├── signup.controller.ts # Recibe petición, valida, delega
        └── signup.routes.ts     # Define rutas Express del módulo
```

### Convención de Nombres

| Tipo de Archivo | Patrón            | Ejemplo                |
| --------------- | ----------------- | ---------------------- |
| Entidad         | `*.entity.ts`     | `restaurant.entity.ts` |
| Validador       | `*.validator.ts`  | `signup.validator.ts`  |
| Servicio        | `*.service.ts`    | `signup.service.ts`    |
| Controlador     | `*.controller.ts` | `signup.controller.ts` |
| Rutas           | `*.routes.ts`     | `signup.routes.ts`     |

---

## 3. Flujo de Desarrollo: Paso a Paso

Cuando necesites crear un nuevo endpoint que interactúe con la base de datos, sigue este orden:

```
Entidad → Validador → Servicio → Controlador → Rutas → index.ts
```

Cada archivo tiene UNA sola responsabilidad. Nunca mezcles lógica de BD en el controlador ni validaciones en el servicio.

---

### Paso 1: Entidad

📁 `src/modules/signup/domain/restaurant.entity.ts`

**¿Qué hace?** Define la forma de una tabla de PostgreSQL como una clase de TypeScript. TypeORM lee estas clases y sabe cómo hablar con tu BD.

**Reglas:**

- El `name` del `@Entity()` debe coincidir **exactamente** con el nombre de tu tabla en PostgreSQL
- Usa `schema: "core"` para indicar el schema de PostgreSQL
- Columnas en **snake_case** y español (como la BD real)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from "typeorm";
import { User } from "./user.entity";

// @Entity le dice a TypeORM: "Esta clase = la tabla core.restaurante"
@Entity({ name: "restaurante", schema: "core" })
export class Restaurant {
  // SERIAL auto-incrementable (como el id de tu SQL)
  @PrimaryGeneratedColumn()
  id!: number;

  // Columna obligatoria (NOT NULL en la BD)
  @Column({ type: "varchar", length: 100 })
  nombre!: string;

  // Columna opcional (nullable: true = puede ser NULL)
  @Column({ type: "text", nullable: true })
  direccion!: string;

  // Columna con valor por defecto
  @Column({ type: "varchar", length: 3, default: "USD" })
  moneda!: string;

  // Columna numérica con precisión (NUMERIC(5,2) en SQL)
  @Column({ type: "decimal", precision: 5, scale: 2, default: 0 })
  impuesto_porcentaje!: number;

  // Timestamp automático
  @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
  created_at!: Date;

  // Relación 1:N → Un restaurante tiene muchos usuarios
  @OneToMany(() => User, (user) => user.restaurant)
  usuarios!: User[];
}
```

> **¿Por qué `!` en cada propiedad?** TypeORM inicializa las propiedades por ti cuando lee de la BD. El `!` le dice a TypeScript: "confía, esto se va a llenar".

---

### Paso 2: Validador

📁 `src/modules/signup/signup.validator.ts`

**¿Qué hace?** Es el portero. Revisa que los datos que manda el frontend estén completos y sean válidos **antes** de tocar la base de datos. Si algo está mal, rebota la petición inmediatamente.

**¿Por qué Zod?** Es la librería de validación más rápida y legible para TypeScript. Escribes el esquema una vez y obtienes tanto la validación como el tipo de TypeScript.

```typescript
import { z } from "zod";

export const signupSchema = z
  .object({
    // Estos nombres DEBEN coincidir con el JSON que manda el frontend
    restaurant: z.object({
      name: z.string().min(2, "Nombre del restaurante muy corto"),
      phone: z.string().optional(), // opcional = puede venir vacío
      address: z.string().optional(),
      email: z.string().email("Correo no válido").optional().or(z.literal("")),
      currency: z.string().default("USD"), // si no viene, usa "USD"
      zone: z.string().default("America/Caracas"),
      tax: z.coerce.string().optional(), // z.coerce: convierte number → string
      tip: z.coerce.string().optional(),
      restaurantLogo: z.string().optional(),
    }),
    admin: z.object({
      name: z.string().min(2, "Nombre muy corto"),
      userName: z.string().min(3, "Username muy corto"),
      email: z.string().email("Correo no válido"),
      password: z.string().min(6, "Contraseña muy corta"),
      confirmPassword: z.string(),
    }),
    // .refine() = validación personalizada que cruza campos
  })
  .refine((data) => data.admin.password === data.admin.confirmPassword, {
    message: "Las contraseñas no coinciden",
    path: ["admin", "confirmPassword"], // dónde mostrar el error
  });

// Esto genera automáticamente el tipo TypeScript del esquema
export type SignupInput = z.infer<typeof signupSchema>;
```

> **Tip:** Usa `z.coerce.string()` cuando un `<input type="number">` del frontend manda un `number` pero tú necesitas un `string` en el backend.

---

### Paso 3: Servicio

📁 `src/modules/signup/signup.service.ts`

**¿Qué hace?** Contiene la **lógica pesada de negocio**. Aquí es donde interactúas con la base de datos, haces cálculos, hasheas contraseñas, etc. El controlador NUNCA debe hacer estas cosas.

**Concepto clave: Transacciones.** Cuando necesitas insertar datos en varias tablas a la vez (ej: restaurante + rol + usuario), usas un `QueryRunner` para crear una **transacción**. Esto garantiza que si algo falla en el paso 3, los pasos 1 y 2 se revierten automáticamente.

```
Transacción = "O se guardan TODOS los datos, o no se guarda NINGUNO"
```

```typescript
import { Conexion } from "../../config/database";
import { Restaurant } from "./domain/restaurant.entity";
import { Role } from "./domain/role.entity";
import { User } from "./domain/user.entity";
import bcrypt from "bcrypt";
import { SignupInput } from "./signup.validator";

export const SignupService = {
  async register(data: SignupInput) {
    // 1. Crear un QueryRunner = una conexión dedicada a esta transacción
    const queryRunner = Conexion.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();
    // A partir de aquí, nada se guarda en la BD hasta hacer COMMIT

    try {
      // 2. Verificar duplicados antes de insertar
      const existingUser = await queryRunner.manager.findOne(User, {
        where: { email: data.admin.email },
      });
      if (existingUser) {
        throw new Error("El correo ya está registrado.");
      }

      // 3. INSERT Restaurante
      // .create() construye el objeto en memoria (NO lo guarda aún)
      // .save() ejecuta el INSERT en la BD
      const restaurant = queryRunner.manager.create(Restaurant, {
        nombre: data.restaurant.name,
        direccion: data.restaurant.address || null,
        telefono: data.restaurant.phone || null,
        email: data.restaurant.email || null,
        moneda: data.restaurant.currency || "USD",
        zona_horaria: data.restaurant.zone || "America/Caracas",
        impuesto_porcentaje: parseFloat(data.restaurant.tax || "0"),
        propina_porcentaje: parseFloat(data.restaurant.tip || "0"),
      } as any);
      await queryRunner.manager.save(restaurant);
      // Después del save(), restaurant.id tiene el ID generado por PostgreSQL

      // 4. INSERT Rol (usando el ID del restaurante recién creado)
      const role = queryRunner.manager.create(Role, {
        nombre: "admin",
        restaurante_id: restaurant.id, // FK al restaurante
      } as any);
      await queryRunner.manager.save(role);

      // 5. Hashear la contraseña (NUNCA guardes passwords en texto plano)
      const salt = await bcrypt.genSalt(10);
      const passwordHash = await bcrypt.hash(data.admin.password, salt);

      // 6. INSERT Usuario (vinculado al restaurante y al rol)
      const user = queryRunner.manager.create(User, {
        restaurante_id: restaurant.id,
        rol_id: role.id,
        nombre: data.admin.name,
        email: data.admin.email,
        username: data.admin.userName,
        password_hash: passwordHash,
      } as any);
      await queryRunner.manager.save(user);

      // 7. COMMIT: Si llegamos aquí sin errores, se guardan los 3 INSERTs
      await queryRunner.commitTransaction();

      return {
        restaurantId: restaurant.id,
        restaurantName: restaurant.nombre,
        adminId: user.id,
        adminEmail: user.email,
        role: role.nombre,
      };
    } catch (error) {
      // ROLLBACK: Si algo falló, se deshacen TODOS los INSERTs
      await queryRunner.rollbackTransaction();
      throw error; // Re-lanzamos para que el controller lo atrape
    } finally {
      // SIEMPRE liberar la conexión (haya o no error)
      await queryRunner.release();
    }
  },
};
```

> **¿Cuándo usar QueryRunner?** Siempre que hagas más de un INSERT/UPDATE que dependa del otro. Si solo necesitas hacer un `findOne()` simple, usa `Conexion.getRepository(Entity)` directamente.

---

### Paso 4: Controlador

📁 `src/modules/signup/signup.controller.ts`

**¿Qué hace?** Es el intermediario entre la petición HTTP y el servicio. Su trabajo es simple:

1. Recibir `req.body`
2. Validar con Zod
3. Delegar al Service
4. Retornar la respuesta JSON

**Regla:** El controlador NO debe tener lógica de negocio. Si ves un `bcrypt.hash()` o un `findOne()` aquí, algo está mal.

```typescript
import { Request, Response } from "express";
import { signupSchema } from "./signup.validator";
import { SignupService } from "./signup.service";

export const SignupController = {
  async register(req: Request, res: Response) {
    try {
      // 1. VALIDAR: safeParse no lanza error, retorna un objeto con .success
      const parseResult = signupSchema.safeParse(req.body);

      if (!parseResult.success) {
        // Zod detectó datos malos → respondemos 400 con los errores
        const errors = parseResult.error.issues.map((e) => e.message);
        return res.status(400).json({
          status: "error",
          message: "Datos inválidos",
          errors, // Array de mensajes como ["Email no válido", "Password muy corta"]
        });
      }

      // 2. DELEGAR: Los datos limpios van al servicio
      const result = await SignupService.register(parseResult.data);

      // 3. RESPONDER: Éxito = 201 Created
      return res.status(201).json({
        status: "success",
        data: result,
      });
    } catch (error: unknown) {
      // Error del servicio (ej: email duplicado, error de BD)
      console.error("❌ Error en signup:", error);
      const message =
        error instanceof Error ? error.message : "Error al registrar";
      return res.status(400).json({
        status: "error",
        message,
      });
    }
  },
};
```

### Formato de Respuestas (JSend)

Todas las respuestas siguen el formato **JSend**:

```json
// Éxito (200, 201)
{ "status": "success", "data": { ... } }

// Error de validación (400)
{ "status": "error", "message": "Datos inválidos", "errors": ["..."] }

// Error de servidor (400, 500)
{ "status": "error", "message": "Descripción del error" }
```

---

### Paso 5: Rutas

📁 `src/modules/signup/signup.routes.ts`

**¿Qué hace?** Liga un método HTTP (`POST`, `GET`, etc.) con una función del controlador. Es solo un mapa.

```typescript
import { Router } from "express";
import { SignupController } from "./signup.controller";

export const signupRouter = Router();

// POST /register → SignupController.register
signupRouter.post("/register", SignupController.register);
```

> La ruta final será `/api/v1/signup/register` porque en `index.ts` montamos este router bajo `/api/v1/signup`.

---

### Paso 6: Registro en index.ts

📁 `src/index.ts`

**¿Qué hace?** Es el punto de entrada de toda la aplicación. Aquí se configura Express, CORS, los middlewares, y se **montan** los routers de cada módulo.

```typescript
import express from "express";
import cors from "cors";
import "reflect-metadata"; // OBLIGATORIO para TypeORM
import { Conexion } from "./config/database";
import { signupRouter } from "./modules/signup/signup.routes";

// Conectar a PostgreSQL al arrancar
Conexion.initialize()
  .then(() => console.log("Database connected"))
  .catch((error) => console.error("Database connection error:", error));

const app = express();
const PORT = 3000;

app.use(cors()); // Permitir peticiones del frontend (puerto 5173)
app.use(express.json()); // Parsear JSON del body

// MONTAR MÓDULOS: Prefijo + Router
app.use("/api/v1/signup", signupRouter); // → /api/v1/signup/register

app.listen(PORT, () => {
  console.log(`\n🚀 Server ready at: http://localhost:${PORT}`);
});
```

> **Al crear un módulo nuevo**, solo necesitas agregar **una línea** aquí: `app.use("/api/v1/tumodulo", tuRouter);`

---

## 4. Conexión a la Base de Datos

📁 `src/config/database.ts`

```typescript
import { DataSource } from "typeorm";
import { Restaurant } from "../modules/signup/domain/restaurant.entity";
import { User } from "../modules/signup/domain/user.entity";
import { Role } from "../modules/signup/domain/role.entity";

export const Conexion = new DataSource({
  type: "postgres",
  host: "localhost",
  port: 5432,
  username: "postgres",
  password: "postgres",
  database: "Komanda",
  synchronize: false, // ⚠️ SIEMPRE false: no queremos que TypeORM cree tablas
  logging: false,
  entities: [Restaurant, User, Role], // Registra cada entidad nueva aquí
});
```

### Reglas Importantes

| Configuración      | Valor   | ¿Por qué?                                                     |
| ------------------ | ------- | ------------------------------------------------------------- |
| `synchronize`      | `false` | Nunca dejar en `true` si ya tienes tablas. Crea duplicados.   |
| `entities`         | Array   | Cada entidad nueva DEBE registrarse aquí.                     |
| `reflect-metadata` | Import  | OBLIGATORIO en `index.ts` para que los decoradores funcionen. |

---

## 5. Conexión Frontend → Backend (fetch)

El flujo completo del frontend al backend:

```
Vue (formData) → fetch() → Express (Controller) → Zod → Service → PostgreSQL
                                                                        ↓
Vue (muestra resultado) ← JSON ← Express (Controller) ← Service ← BD (datos)
```

### Ejemplo Real: SingUp.vue

```typescript
const submitWizard = async () => {
  try {
    // 1. Enviar datos al backend como JSON
    const respuesta = await fetch(
      "http://localhost:3000/api/v1/signup/register",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" }, // ⚠️ OBLIGATORIO
        body: JSON.stringify(formData.value), // Convierte el objeto Vue a JSON
      },
    );

    // 2. Leer la respuesta del backend
    const data = await respuesta.json();

    // 3. Verificar si fue exitoso
    if (!respuesta.ok) {
      // El backend respondió con 400 o 500
      alert(`Error: ${data.message}`);
      console.error("Errores:", data.errors); // Array de errores de Zod
      return;
    }

    // 4. Éxito → redirigir
    alert("¡Registrado con éxito!");
    window.location.href = "/login";
  } catch (error) {
    // Error de red (el servidor está apagado, no hay internet, etc.)
    alert("No se pudo conectar con el servidor");
  }
};
```

### Checklist para cada fetch

- [ ] URL correcta: `http://localhost:3000/api/v1/{modulo}/{ruta}`
- [ ] Método correcto: `POST` para crear, `GET` para leer
- [ ] Header `Content-Type: application/json` (si mandas body)
- [ ] `JSON.stringify()` del body
- [ ] Verificar `respuesta.ok` antes de usar los datos

---

## 6. Endpoint Tipo B: PHP (Reports/Calculations)

Usa esto para "Dirty Jobs": Scripts rápidos, cálculos matemáticos pesados, generación de archivos.

### Paso 1: Crea el Script

Archivo: `src/api/reporte_diario.php`

```php
<?php
// 1. Headers OBLIGATORIOS (CORS + JSON)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 2. Tu Lógica (Conexión a BD, Cálculos, etc)
$data = [
    "date" => date("Y-m-d"),
    "total_sales" => 1500.50,
    "generated_by" => "PHP Core"
];

// 3. Respuesta JSend
echo json_encode([
    "status" => "success",
    "data" => $data
]);
```

No necesitas registrar rutas. PHP sirve el archivo tal cual.
URL: `http://localhost:8000/api/reporte_diario.php`

---

## 7. Errores Comunes y Soluciones

| Error                                   | Causa                                                      | Solución                                                                      |
| --------------------------------------- | ---------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `expected string, received number`      | Un `<input type="number">` manda number, Zod espera string | Usa `z.coerce.string()` en el validador                                       |
| `relation "X" does not exist`           | La entidad apunta a una tabla que no existe en la BD       | Verifica que `@Entity({ name, schema })` coincida con tu SQL                  |
| `synchronize: true` creó tablas raras   | TypeORM intenta crear tablas automáticamente               | Pon `synchronize: false` en database.ts                                       |
| CORS error en el frontend               | El backend no permite peticiones del frontend              | Agrega `app.use(cors())` en index.ts                                          |
| `Cannot find module 'reflect-metadata'` | Falta la dependencia para decoradores                      | `pnpm add reflect-metadata` y agregar `import "reflect-metadata"` en index.ts |
| `EntityMetadataNotFoundError`           | La entidad no está registrada                              | Agrégala al array `entities` en database.ts                                   |
| 400 sin `errors` array                  | El error viene del Service, no de Zod                      | Revisa `console.error` en la terminal del backend                             |
| El "Siguiente" del form llama a la API  | Vue fallthrough: el `submit` nativo se propaga             | Agrega `'submit'` a `defineEmits` del componente hijo                         |

---

> **Receta rápida para un módulo nuevo:**
>
> 1. Crea `src/modules/tumodulo/domain/tumodelo.entity.ts`
> 2. Registra la entidad en `database.ts`
> 3. Crea `tumodulo.validator.ts` con el esquema Zod
> 4. Crea `tumodulo.service.ts` con la lógica
> 5. Crea `tumodulo.controller.ts` que valida y delega
> 6. Crea `tumodulo.routes.ts` con las rutas
> 7. Monta en `index.ts`: `app.use("/api/v1/tumodulo", tuRouter)`
> 8. Reinicia el backend: `pnpm dev`
