import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { logger } from '../utils/logger';

const prisma = new PrismaClient();

export class AnalyticsController {
  /**
   * Get scan analytics and statistics
   */
  async getStats(req: Request, res: Response): Promise<void> {
    try {
      // Get total scans
      const totalScans = await prisma.scanHistory.count();

      // Get total and average savings
      const savingsStats = await prisma.scanHistory.aggregate({
        _sum: {
          potentialSavings: true
        },
        _avg: {
          potentialSavings: true
        }
      });

      // Get most scanned categories (from scan results)
      const scanResults = await prisma.scanHistory.findMany({
        select: {
          scanResult: true
        },
        orderBy: {
          createdAt: 'desc'
        },
        take: 1000 // Limit for performance
      });

      // Extract categories from scan results
      const categoryCounts: { [key: string]: number } = {};
      scanResults.forEach(scan => {
        if (scan.scanResult && typeof scan.scanResult === 'object') {
          const result = scan.scanResult as any;
          if (result.scannedItems && Array.isArray(result.scannedItems)) {
            result.scannedItems.forEach((item: any) => {
              if (item.category) {
                categoryCounts[item.category] = (categoryCounts[item.category] || 0) + 1;
              }
            });
          }
        }
      });

      // Sort categories by count
      const mostScannedCategories = Object.entries(categoryCounts)
        .map(([category, count]) => ({ category, count }))
        .sort((a, b) => b.count - a.count)
        .slice(0, 10);

      res.status(200).json({
        success: true,
        data: {
          totalScans,
          totalSavings: savingsStats._sum.potentialSavings || 0,
          averageSavings: savingsStats._avg.potentialSavings || 0,
          mostScannedCategories
        }
      });

    } catch (error) {
      logger.error('Error getting analytics stats', {
        error: error instanceof Error ? error.message : error
      });
      
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to retrieve analytics'
        }
      });
    }
  }
}