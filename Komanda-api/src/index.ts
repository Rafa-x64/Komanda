import express from 'express';
import cors from 'cors';

const app = express();
const PORT = 3000;

app.use(cors());k
// Middleware para JSON (Vital para las comandas del restaurante)
app.use(express.json());

import { getKitchenStatus } from './modules/kitchen/kitchen.controller';

app.get('/api/v1/kitchen/status', getKitchenStatus);

app.get('/', (req, res) => {
  res.json({
    message: 'API de KOMANDA funcionando',
    system: 'EndeavourOS',
    status: 'cooking 🍳'
  });
});

app.listen(PORT, () => {
  console.log(`\n🚀 Server ready at: http://localhost:${PORT}`);
});
