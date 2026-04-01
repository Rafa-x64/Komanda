---
trigger: always_on
---

Nunca confíes en lo que te manda el frontend (aunque lo hayas hecho tú). Valida los datos apenas entran a tu API (usa Zod si vas con TS, o Form Requests si vas con PHP/Laravel). Si la data está sucia, rebótala de inmediato. Ahorra recursos y dolores de cabeza.