import { z } from "zod";

const schema = z.object({
    unidad_compra_id: z.number().int().positive().optional().nullable(),
});

console.log(schema.parse({ unidad_compra_id: null }));
console.log(schema.parse({ unidad_compra_id: undefined }));
console.log(schema.parse({ unidad_compra_id: "" }));
