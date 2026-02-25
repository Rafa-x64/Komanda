# Guía de Contribución - KOMANDA

> [!NOTE]
> Hablenme muchachos. Para que el desarrollo de este SaaS sea fluido y no nos volvamos locos con los conflictos de Git, seguiremos estas reglas.

## 1. Manejo de Ramas (Git Flow Minimalista)

- **`master`**: Código estable y listo para producción. Nadie pushea aquí directo.
- **`feature/*`**: Para cada tarea, crea una rama desde `master` con el nombre: `feature/nombre-de-la-tarea`.

---

## 2. Estándar de Commits (Conventional Commits)

Usamos mensajes que hasta un robot entendería. El formato es: `tipo(modulo): descripción en minúsculas`.

### Tipos Permitidos:

| Tipo          | Descripción                                                | Ejemplo                                        |
| :------------ | :--------------------------------------------------------- | :--------------------------------------------- |
| ✨ `feat`     | Una nueva funcionalidad                                    | `feat(kitchen): agregar vista de pedidos`      |
| 🐛 `fix`      | Corrección de un error                                     | `fix(pos): arreglar cálculo de IVA`            |
| 📚 `docs`     | Cambios en la documentación                                | `docs(readme): actualizar guía de instalación` |
| ♻️ `refactor` | Cambio en el código (sin añadir función ni arreglar error) | `refactor(auth): simplificar validación JWT`   |
| 🔧 `chore`    | Tareas de mantenimiento o actualización                    | `chore(deps): update pnpm`                     |

> [!IMPORTANT]
> **Regla importante:** Un commit = Una sola cosa. No mezcles arreglar un botón con cambiar la base de datos.

---

## 🛠 3. Flujo de Trabajo (Para los que no usan Git)

Si te toca una tarea, sigue estos pasos en tu terminal:

1. **Actualiza tu local:**
   ```bash
   git checkout master && git pull origin master
   ```
2. **Crea tu rama:**
   ```bash
   git checkout -b feat/mi-tarea
   ```
3. **Programa y añade:**
   ```bash
   git add .
   ```
4. **Haz el commit:**
   ```bash
   git commit -m "feat(modulo): descripcion"
   ```
5. **Sube tus cambios:**
   ```bash
   git push origin feat/mi-tarea
   ```
6. **Pull Request:** Abre el PR en GitHub hacia la rama `master` para que alguien lo revise.

---

## 🚫 4. Lo que NUNCA debes hacer

> [!CAUTION]
>
> - **NO subir `node_modules/`:** Asegúrate de que tu `.gitignore` esté activo.
> - **NO pushear con conflictos:** Si GitHub dice que hay conflictos, resuélvelos en tu PC antes de subir.
> - **NO usar mensajes genéricos:** Commits como `"cambios"`, `"fix"`, `"listo"` están completamente prohibidos.
