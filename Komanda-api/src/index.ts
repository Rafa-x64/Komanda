import express from 'express';
import cors from 'cors';
import "reflect-metadata";
import { Conexion } from "./config/database";
import { signupRouter } from "./modules/signup/signup.routes";
import { SignInRoutes } from "./modules/signin/signin.routes";
import { salesRouter } from "./modules/sales/sales.routes";
import { employeesRouter } from "./modules/employees/employees.routes";
import { getKitchenStatus } from './modules/kitchen/kitchen.controller';

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Rutas públicas (sin auth)
app.use("/api/v1/signup", signupRouter);
app.use("/api/v1/signin", SignInRoutes);

// Rutas protegidas (auth middleware aplicado dentro de cada router)
app.use("/api/v1/sales", salesRouter);
app.use("/api/v1/employees", employeesRouter);

app.get('/api/v1/kitchen/status', getKitchenStatus);

app.get('/', (_req, res) => {
  res.json({
    message: 'API de KOMANDA funcionando',
    system: 'EndeavourOS',
    status: 'cooking 🍳'
  });
});

Conexion.initialize()
  .then(() => {
    console.log("Database connected");
    app.listen(PORT, () => {
      console.log(`\n🚀 Server ready at: http://localhost:${PORT}`);
    });
  })
  .catch((error) => {
    console.error("Database connection error:", error);
    process.exit(1);
  });
