import { Conexion } from "./config/database";
import { KitchenService } from "./modules/kitchen/kitchen.service";

Conexion.initialize().then(async () => {
    try {
        const orders = await KitchenService.getKitchenOrders(1);
        console.log("KITCHEN ORDERS FOR RESTAURANT 1:", JSON.stringify(orders, null, 2));
    } catch (e) {
        console.error(e);
    }
    process.exit(0);
});
