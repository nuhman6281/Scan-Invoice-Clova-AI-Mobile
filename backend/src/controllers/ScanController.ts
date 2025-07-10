import { Request, Response } from 'express';
import { ScanService } from '../services/ScanService';
import { logger } from '../utils/logger';

export class ScanController {
  private scanService: ScanService;

  constructor() {
    this.scanService = new ScanService();
  }

  /**
   * Scan an invoice and find product alternatives
   */
  async scanInvoice(req: Request, res: Response): Promise<void> {
    try {
      if (!req.file) {
        res.status(400).json({
          success: false,
          error: {
            message: 'No image file provided'
          }
        });
        return;
      }

      const { latitude, longitude } = req.body;
      const radius = parseFloat(req.query.radius as string) || 10;
      const premiumOnly = req.query.premiumOnly === 'true';

      logger.info('Starting invoice scan', {
        imagePath: req.file.path,
        latitude,
        longitude,
        radius,
        premiumOnly
      });

      const result = await this.scanService.processInvoice({
        imagePath: req.file.path,
        userLocation: { latitude: parseFloat(latitude), longitude: parseFloat(longitude) },
        radius,
        premiumOnly
      });

      res.status(200).json({
        success: true,
        data: result
      });

    } catch (error) {
      logger.error('Error scanning invoice', { error: error instanceof Error ? error.message : error });
      
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to process invoice',
          ...(process.env.NODE_ENV !== 'production' && { details: error instanceof Error ? error.message : 'Unknown error' })
        }
      });
    }
  }

  /**
   * Get scan history
   */
  async getScanHistory(req: Request, res: Response): Promise<void> {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const history = await this.scanService.getScanHistory(page, limit);

      res.status(200).json({
        success: true,
        data: history.scans,
        pagination: {
          page,
          limit,
          total: history.total,
          totalPages: Math.ceil(history.total / limit)
        }
      });

    } catch (error) {
      logger.error('Error getting scan history', { error: error instanceof Error ? error.message : error });
      
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to retrieve scan history'
        }
      });
    }
  }
}