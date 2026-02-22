import { Router } from "express";
import { SignupController } from "./signup.controller";

export const signupRouter = Router();

signupRouter.post("/register", SignupController.register);
