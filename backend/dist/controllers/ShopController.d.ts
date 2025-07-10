import { Request, Response } from 'express';
export declare class ShopController {
    getNearbyShops(req: Request, res: Response): Promise<void>;
    getShopById(req: Request, res: Response): Promise<void>;
    private calculateDistance;
    private toRadians;
}
//# sourceMappingURL=ShopController.d.ts.map