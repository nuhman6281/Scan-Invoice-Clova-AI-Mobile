"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const express_validator_1 = require("express-validator");
const validateRequest_1 = require("../middleware/validateRequest");
const ShopController_1 = require("../controllers/ShopController");
const router = (0, express_1.Router)();
const shopController = new ShopController_1.ShopController();
router.get('/nearby', [
    (0, express_validator_1.query)('lat').isFloat({ min: -90, max: 90 }).withMessage('Latitude must be between -90 and 90'),
    (0, express_validator_1.query)('lng').isFloat({ min: -180, max: 180 }).withMessage('Longitude must be between -180 and 180'),
    (0, express_validator_1.query)('radius').optional().isFloat({ min: 0.1, max: 100 }).withMessage('Radius must be between 0.1 and 100 km'),
    (0, express_validator_1.query)('category').optional().isString().withMessage('Category must be a string'),
    (0, express_validator_1.query)('premiumOnly').optional().isBoolean().withMessage('premiumOnly must be a boolean')
], validateRequest_1.validateRequest, shopController.getNearbyShops);
router.get('/:id', shopController.getShopById);
exports.default = router;
//# sourceMappingURL=shops.js.map