import express from 'express';

const app = express();
const PORT = 3000;

// Middleware para JSON (Vital para las comandas del restaurante)
app.use(express.json());

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
