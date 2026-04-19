import { z } from "zod";

export const createProveedorSchema = z.object({
    identificacion: z.string().min(1, "Identificación requerida").max(30),
    nombre: z.string().min(2, "Nombre requerido").max(100),
    telefono: z.string().max(20).optional().nullable(),
    email: z.string().email("Correo no válido").max(100).optional().nullable().or(z.literal("").transform(() => null)),
    direccion: z.string().optional().nullable(),
    banco_nombre: z.string().max(50).optional().nullable(),
    banco_cuenta_numero: z.string().max(30).optional().nullable(),
    observaciones: z.string().optional().nullable(),
});

export const updateProveedorSchema = createProveedorSchema.partial().extend({
    activo: z.boolean().optional()
});

export const createCompraSchema = z.object({
    fecha: z.string(), // YYYY-MM-DD
    numero_factura_proveedor: z.string().max(50).optional().nullable(),
    proveedor_id: z.number().int().positive().optional().nullable(),
    descripcion: z.string().max(255).optional().nullable(),
    estado_pago: z.enum(["pagada", "pendiente", "abonada"]).default("pagada"),
    items: z.array(z.object({
        ingrediente_id: z.number().int().positive().optional().nullable(),
        ingrediente_nombre: z.string().max(100).optional().nullable(),
        cantidad_compra: z.number().positive(),
        unidad_compra_id: z.number().int().positive().default(1),
        precio_unitario: z.number().nonnegative(),
        factor_conversion: z.number().positive().default(1),
    })).min(1, "Debe incluir al menos un ítem en la compra"),
});

export const createGastoSchema = z.object({
    categoria: z.enum(["agua", "gas", "electricidad", "internet", "alquiler", "otros"], {
        errorMap: () => ({ message: "Categoría de gasto no válida." })
    }),
    monto: z.number().positive("El monto debe ser mayor a 0"),
    fecha: z.string(), // YYYY-MM-DD
    metodo_pago: z.enum(["efectivo", "pago_movil", "tarjeta", "divisa"], {
        errorMap: () => ({ message: "Método de pago no válido" })
    }),
    referencia: z.string().max(100).optional().nullable(),
    descripcion: z.string().max(255).optional().nullable(),
});

export type CreateProveedorInput = z.infer<typeof createProveedorSchema>;
export type UpdateProveedorInput = z.infer<typeof updateProveedorSchema>;
export type CreateCompraInput = z.infer<typeof createCompraSchema>;
export type CreateGastoInput = z.infer<typeof createGastoSchema>;
