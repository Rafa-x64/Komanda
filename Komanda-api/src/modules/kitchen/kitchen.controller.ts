import { Request, Response } from 'express';
import { KitchenService } from './kitchen.service';
import { updateOrderStatusSchema } from './kitchen.validator';
import { broadcastNewOrderToKitchen } from './kitchen.socket';

// Obtiene todas las ordenes activas en cocina
export const getActiveOrders = async (req: Request, res: Response): Promise<void> => {
    try {
        const restaurantId = (req as any).user?.restaurantId || (req as any).user?.restaurante_id;
        if (!restaurantId) {
            res.status(403).json({ status: "error", message: "Restaurante no identificado (Multi-tenant activo)" });
            return;
        }

        const orders = await KitchenService.getKitchenOrders(restaurantId);
        res.status(200).json({ status: "success", data: orders });
    } catch (error: any) {
        res.status(500).json({ status: "error", message: error.message });
    }
};

// Actualiza el estado de una orden y avisa por websockets
export const updateOrderStatus = async (req: Request, res: Response): Promise<void> => {
    try {
        const restaurantId = (req as any).user?.restaurantId || (req as any).user?.restaurante_id;
        if (!restaurantId) {
            res.status(403).json({ status: "error", message: "Restaurante no identificado (Multi-tenant activo)" });
            return;
        }

        const orderId = parseInt(req.params.id as string);
        if (isNaN(orderId)) {
            res.status(400).json({ status: "error", message: "ID de orden inválido" });
            return;
        }

        const validData = updateOrderStatusSchema.parse(req.body);
        
        await KitchenService.updateOrderStatus(orderId, validData.estado, restaurantId);

        // Disparar socket a los clientes de la cocina para que sepan que algo cambio a 'listo' o 'preparando'
        broadcastNewOrderToKitchen({ 
            action: 'actualizar_estado', 
            payload: { id: orderId, estado: validData.estado } 
        });

        res.status(200).json({ status: "success", message: "Estado de orden actualizado a " + validData.estado });
    } catch (error: any) {
        if (error.name === "ZodError") {
            res.status(400).json({ status: "error", message: "Validación fallida", details: error.errors });
            return;
        }
        res.status(400).json({ status: "error", message: error.message });
    }
};