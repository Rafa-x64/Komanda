import express from 'express';
import cors from 'cors';
import "reflect-metadata";
import { Conexion } from "./config/database";
import { signupRouter } from "./modules/signup/signup.routes";
import { SignInRoutes } from "./modules/signin/signin.routes";

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

const app = express();
const PORT = 3000;

app.use(cors());
// Middleware para JSON (Vital para las comandas del restaurante)
app.use(express.json());

// Rutas de módulos
app.use("/api/v1/signup", signupRouter);
app.use("/api/v1/signin", SignInRoutes);

import { getKitchenStatus } from './modules/kitchen/kitchen.controller';

app.get('/api/v1/kitchen/status', getKitchenStatus);

app.get('/', (req, res) => {
  res.json({
    message: 'API de KOMANDA funcionando',
    system: 'EndeavourOS',
    status: 'cooking 🍳'
  });
});

