import { z } from 'zod'

export const DateRangeSchema = z.object({
    dateFrom: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Formato de fecha inválido (YYYY-MM-DD)').optional(),
    dateTo: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Formato de fecha inválido (YYYY-MM-DD)').optional(),
})

export type DateRangeInput = z.infer<typeof DateRangeSchema>
