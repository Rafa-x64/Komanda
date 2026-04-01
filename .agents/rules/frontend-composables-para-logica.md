---
trigger: always_on
---

Olvídate de los Mixins, eso es el pasado. Aprovecha la Composition API de Vue. Si tienes lógica que se repite (ej: lógica para conectar con el WebSocket de la cocina), extráela a un useSocketCocina.ts. Es modular, limpio y super fácil de testear.