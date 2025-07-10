import { Router } from 'express';
import { query } from 'express-validator';
import { validateRequest } from '../middleware/validateRequest';
import { ShopController } from '../controllers/ShopController';

const router = Router();
const shopController = new ShopController();

/**
 * @swagger
 * /api/shops/nearby:
 *   get:
 *     summary: Get nearby shops
 *     tags: [Shops]
 *     parameters:
 *       - in: query
 *         name: lat
 *         type: number
 *         required: true
 *         description: User's latitude
 *       - in: query
 *         name: lng
 *         type: number
 *         required: true
 *         description: User's longitude
 *       - in: query
 *         name: radius
 *         type: number
 *         required: false
 *         description: Search radius in kilometers (default: 10)
 *       - in: query
 *         name: category
 *         type: string
 *         required: false
 *         description: Filter by shop category
 *       - in: query
 *         name: premiumOnly
 *         type: boolean
 *         required: false
 *         description: Only return premium shops
 *     responses:
 *       200:
 *         description: Successfully retrieved nearby shops
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Shop'
 */
router.get('/nearby',
  [
    query('lat').isFloat({ min: -90, max: 90 }).withMessage('Latitude must be between -90 and 90'),
    query('lng').isFloat({ min: -180, max: 180 }).withMessage('Longitude must be between -180 and 180'),
    query('radius').optional().isFloat({ min: 0.1, max: 100 }).withMessage('Radius must be between 0.1 and 100 km'),
    query('category').optional().isString().withMessage('Category must be a string'),
    query('premiumOnly').optional().isBoolean().withMessage('premiumOnly must be a boolean')
  ],
  validateRequest,
  shopController.getNearbyShops
);

/**
 * @swagger
 * /api/shops/{id}:
 *   get:
 *     summary: Get shop details
 *     tags: [Shops]
 *     parameters:
 *       - in: path
 *         name: id
 *         type: string
 *         required: true
 *         description: Shop ID
 *     responses:
 *       200:
 *         description: Successfully retrieved shop details
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Shop'
 *       404:
 *         description: Shop not found
 */
router.get('/:id',
  shopController.getShopById
);

export default router;