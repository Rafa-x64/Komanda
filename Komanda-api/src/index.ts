import express from 'express';
import cors from 'cors';
import "reflect-metadata";
import { Conexion } from "./config/database";
import { signupRouter } from "./modules/signup/signup.routes";
import { SignInRoutes } from "./modules/signin/signin.routes";
import { posRouter } from "./modules/pos/pos.routes";
import { employeesRouter } from "./modules/employees/employees.routes";
import { menuRouter } from "./modules/menu/menu.routes";
import { kitchenRouter } from "./modules/kitchen/kitchen.routes";
import { setupKitchenSocket } from "./modules/kitchen/kitchen.socket";
import { WebSocketServer } from "ws";

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Rutas públicas (sin auth)
app.use("/api/v1/signup", signupRouter);
app.use("/api/v1/signin", SignInRoutes);

// Rutas protegidas (auth middleware aplicado dentro de cada router)
app.use("/api/v1/pos", posRouter);
app.use("/api/v1/employees", employeesRouter);
app.use("/api/v1/menu", menuRouter);
app.use("/api/v1/kitchen", kitchenRouter);

app.get('/', (_req, res) => {
  res.json({
    message: 'API de KOMANDA funcionando',
    system: 'EndeavourOS',
    status: 'cooking 🍳'
  });
});

Conexion.initialize()
  .then(() => {
    console.log("Database connected to:", Conexion.options.database);
    const server = app.listen(PORT, () => {
      console.log(`\n🚀 Server ready at: http://localhost:${PORT}`);
    });
    const wss = new WebSocketServer({ server });
    setupKitchenSocket(wss);
  })
  .catch((error) => {
    console.error("Database connection error:", error.message || "Unknown error");
    process.exit(1);
  });
