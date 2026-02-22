import { Router } from "express";
import { SignInController } from "./signin.controller";

export const SignInRoutes = Router();

SignInRoutes.post("/login", SignInController.login);