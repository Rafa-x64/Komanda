import { Conexion } from "./config/database";

Conexion.initialize().then(async () => {
    const pedidos = await Conexion.query("SELECT * FROM operaciones.pedidos ORDER BY id DESC LIMIT 5");
    console.log("PEDIDOS:", pedidos);
    
    // Test if any tables are missing or foreign key fails
    process.exit(0);
}).catch(console.error);
