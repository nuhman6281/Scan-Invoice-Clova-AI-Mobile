import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { logger } from '../utils/logger';

const prisma = new PrismaClient();

export class ShopController {
  /**
   * Get nearby shops based on location
   */
  async getNearbyShops(req: Request, res: Response): Promise<void> {
    try {
      const lat = parseFloat(req.query.lat as string);
      const lng = parseFloat(req.query.lng as string);
      const radius = parseFloat(req.query.radius as string) || 10;
      const category = req.query.category as string;
      const premiumOnly = req.query.premiumOnly === 'true';

      logger.info('Getting nearby shops', {
        lat,
        lng,
        radius,
        category,
        premiumOnly
      });

      // Calculate bounding box for spatial query
      const latDelta = radius / 111.32; // Rough conversion from km to degrees
      const lngDelta = radius / (111.32 * Math.cos(lat * Math.PI / 180));

      const shops = await prisma.shop.findMany({
        where: {
          AND: [
            // Spatial query
            {
              latitude: {
                gte: lat - latDelta,
                lte: lat + latDelta
              }
            },
            {
              longitude: {
                gte: lng - lngDelta,
                lte: lng + lngDelta
              }
            },
            // Category filter
            ...(category ? [{
              category: {
                equals: category,
                mode: 'insensitive'
              }
            }] : []),
            // Premium filter
            ...(premiumOnly ? [{
              isPremium: true
            }] : [])
          ]
        },
        orderBy: [
          { isPremium: 'desc' },
          { rating: 'desc' }
        ],
        take: 50
      });

      // Calculate distances and sort
      const shopsWithDistance = shops.map(shop => {
        const distance = this.calculateDistance(
          { latitude: lat, longitude: lng },
          { latitude: shop.latitude, longitude: shop.longitude }
        );
        return {
          ...shop,
          distance
        };
      }).filter(shop => shop.distance <= radius)
        .sort((a, b) => a.distance - b.distance);

      res.status(200).json({
        success: true,
        data: shopsWithDistance
      });

    } catch (error) {
      logger.error('Error getting nearby shops', {
        error: error instanceof Error ? error.message : error
      });
      
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to retrieve nearby shops'
        }
      });
    }
  }

  /**
   * Get shop by ID
   */
  async getShopById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;

      const shop = await prisma.shop.findUnique({
        where: { id },
        include: {
          products: {
            where: { isAvailable: true },
            orderBy: { price: 'asc' },
            take: 20
          }
        }
      });

      if (!shop) {
        res.status(404).json({
          success: false,
          error: {
            message: 'Shop not found'
          }
        });
        return;
      }

      res.status(200).json({
        success: true,
        data: shop
      });

    } catch (error) {
      logger.error('Error getting shop by ID', {
        error: error instanceof Error ? error.message : error,
        shopId: req.params.id
      });
      
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to retrieve shop details'
        }
      });
    }
  }

  /**
   * Calculate distance between two points using Haversine formula
   */
  private calculateDistance(
    point1: { latitude: number; longitude: number },
    point2: { latitude: number; longitude: number }
  ): number {
    const R = 6371; // Earth's radius in kilometers
    const dLat = this.toRadians(point2.latitude - point1.latitude);
    const dLon = this.toRadians(point2.longitude - point1.longitude);
    
    const a = 
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRadians(point1.latitude)) * 
      Math.cos(this.toRadians(point2.latitude)) * 
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  /**
   * Convert degrees to radians
   */
  private toRadians(degrees: number): number {
    return degrees * (Math.PI / 180);
  }
}