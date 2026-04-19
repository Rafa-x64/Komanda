const jwt = require('jsonwebtoken');
const token = jwt.sign({ userId: 1, restaurantId: 1, role: 'admin' }, 'komanda_secret_key_2026', { expiresIn: '1h' });

async function test() {
  try {
    const res = await fetch('http://localhost:3000/api/v1/inventory', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    const inv = await res.json();
    console.log("Inventario Response:", inv);
  } catch (e) { console.error(e); }
}
test();
