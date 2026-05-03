import { z } from "zod";

// El dashboard solo recibe query params opcionales (no body)
export const dashboardQuerySchema = z.object({
    range: z.enum(["today", "week", "month"]).optional().default("today"),
});

export type DashboardQuery = z.infer<typeof dashboardQuerySchema>;
