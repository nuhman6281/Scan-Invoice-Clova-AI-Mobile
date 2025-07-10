import { Router } from 'express';
import multer from 'multer';
import { body, query } from 'express-validator';
import { validateRequest } from '../middleware/validateRequest';
import { ScanController } from '../controllers/ScanController';

const router = Router();

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, process.env.UPLOAD_DIR || './uploads');
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + '.jpg');
  }
});

const upload = multer({
  storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed'));
    }
  }
});

const scanController = new ScanController();

/**
 * @swagger
 * /api/scan/invoice:
 *   post:
 *     summary: Scan an invoice and find product alternatives
 *     tags: [Scan]
 *     consumes:
 *       - multipart/form-data
 *     parameters:
 *       - in: formData
 *         name: image
 *         type: file
 *         required: true
 *         description: Invoice image to scan
 *       - in: formData
 *         name: latitude
 *         type: number
 *         required: true
 *         description: User's latitude
 *       - in: formData
 *         name: longitude
 *         type: number
 *         required: true
 *         description: User's longitude
 *       - in: formData
 *         name: radius
 *         type: number
 *         required: false
 *         description: Search radius in kilometers (default: 10)
 *       - in: formData
 *         name: premiumOnly
 *         type: boolean
 *         required: false
 *         description: Only search premium shops (default: false)
 *     responses:
 *       200:
 *         description: Successfully scanned invoice and found alternatives
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
 *                     scanId:
 *                       type: string
 *                     scannedItems:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/ScannedItem'
 *                     alternatives:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/Alternative'
 *                     summary:
 *                       $ref: '#/components/schemas/ScanSummary'
 *       400:
 *         description: Invalid request parameters
 *       500:
 *         description: Internal server error
 */
router.post('/invoice',
  upload.single('image'),
  [
    body('latitude').isFloat({ min: -90, max: 90 }).withMessage('Latitude must be between -90 and 90'),
    body('longitude').isFloat({ min: -180, max: 180 }).withMessage('Longitude must be between -180 and 180'),
    query('radius').optional().isFloat({ min: 0.1, max: 100 }).withMessage('Radius must be between 0.1 and 100 km'),
    query('premiumOnly').optional().isBoolean().withMessage('premiumOnly must be a boolean')
  ],
  validateRequest,
  scanController.scanInvoice
);

/**
 * @swagger
 * /api/scan/history:
 *   get:
 *     summary: Get scan history
 *     tags: [Scan]
 *     parameters:
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
 *         description: Successfully retrieved scan history
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
 *                     $ref: '#/components/schemas/ScanHistory'
 *                 pagination:
 *                   $ref: '#/components/schemas/Pagination'
 */
router.get('/history',
  [
    query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
    query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100')
  ],
  validateRequest,
  scanController.getScanHistory
);

export default router;