import { Router } from "express";
import { SettingsController } from "./settings.controller";
import { authMiddleware } from "../../shared/middleware/auth.middleware";

const router = Router();

router.use(authMiddleware);

router.get("/restaurant", SettingsController.getRestaurantInfo);
router.put("/restaurant", SettingsController.updateRestaurantInfo);
router.put("/profile", SettingsController.updateProfile);

export default router;
