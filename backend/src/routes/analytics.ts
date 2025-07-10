import { Router } from 'express';
import { AnalyticsController } from '../controllers/AnalyticsController';

const router = Router();
const analyticsController = new AnalyticsController();

/**
 * @swagger
 * /api/analytics/stats:
 *   get:
 *     summary: Get scan analytics and statistics
 *     tags: [Analytics]
 *     responses:
 *       200:
 *         description: Successfully retrieved analytics
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     totalScans:
 *                       type: integer
 *                     totalSavings:
 *                       type: number
 *                     averageSavings:
 *                       type: number
 *                     mostScannedCategories:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           category:
 *                             type: string
 *                           count:
 *                             type: integer
 */
router.get('/stats',
  analyticsController.getStats
);

export default router;