import { Request, Response } from 'express';

export const getKitchenStatus = (req: Request, res: Response) => { 
    res.status(200).json({
        status: "success",
        data: {
            is_open: true,
            active_chefs: 4,
            message: "¡A fuego máximo!"
        }
    });
};