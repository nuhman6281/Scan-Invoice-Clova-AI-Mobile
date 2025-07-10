import { Router } from 'express';
import { query } from 'express-validator';
import { validateRequest } from '../middleware/validateRequest';
import { ProductController } from '../controllers/ProductController';

const router = Router();
const productController = new ProductController();

/**
 * @swagger
 * /api/products:
 *   get:
 *     summary: Get products with filters
 *     tags: [Products]
 *     parameters:
 *       - in: query
 *         name: category
 *         type: string
 *         required: false
 *         description: Filter by product category
 *       - in: query
 *         name: search
 *         type: string
 *         required: false
 *         description: Search in product names and keywords
 *       - in: query
 *         name: minPrice
 *         type: number
 *         required: false
 *         description: Minimum price filter
 *       - in: query
 *         name: maxPrice
 *         type: number
 *         required: false
 *         description: Maximum price filter
 *       - in: query
 *         name: page
 *         type: integer
 *         required: false
 *         description: Page number (default: 1)
 *       - in: query
 *         name: limit
 *         type: integer
 *         required: false
 *         description: Items per page (default: 20, max: 100)
 *     responses:
 *       200:
 *         description: Successfully retrieved products
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
 *                     $ref: '#/components/schemas/Product'
 *                 pagination:
 *                   $ref: '#/components/schemas/Pagination'
 */
router.get('/',
  [
    query('category').optional().isString().withMessage('Category must be a string'),
    query('search').optional().isString().withMessage('Search must be a string'),
    query('minPrice').optional().isFloat({ min: 0 }).withMessage('Min price must be a positive number'),
    query('maxPrice').optional().isFloat({ min: 0 }).withMessage('Max price must be a positive number'),
    query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
    query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100')
  ],
  validateRequest,
  productController.getProducts
);

export default router;