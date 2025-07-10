import { PrismaClient } from '@prisma/client';
import { ScannedItem, Alternative } from './ScanService';
import { logger } from '../utils/logger';

const prisma = new PrismaClient();

export class ProductMatchingService {
  /**
   * Find product alternatives for scanned items
   */
  async findAlternatives(
    scannedItems: ScannedItem[],
    userLocation: { latitude: number; longitude: number },
    radius: number = 10,
    premiumOnly: boolean = false
  ): Promise<Alternative[]> {
    try {
      logger.info('Finding product alternatives', {
        itemsCount: scannedItems.length,
        radius,
        premiumOnly
      });

      const alternatives: Alternative[] = [];

      for (const item of scannedItems) {
        const itemAlternatives = await this.findAlternativesForItem(
          item,
          userLocation,
          radius,
          premiumOnly
        );
        alternatives.push(...itemAlternatives);
      }

      // Sort by savings percentage (highest first)
      alternatives.sort((a, b) => b.savingsPercentage - a.savingsPercentage);

      logger.info('Found alternatives', {
        alternativesCount: alternatives.length
      });

      return alternatives.slice(0, 50); // Limit results

    } catch (error) {
      logger.error('Error finding alternatives', {
        error: error instanceof Error ? error.message : error
      });
      return [];
    }
  }

  /**
   * Find alternatives for a specific item
   */
  private async findAlternativesForItem(
    item: ScannedItem,
    userLocation: { latitude: number; longitude: number },
    radius: number,
    premiumOnly: boolean
  ): Promise<Alternative[]> {
    const alternatives: Alternative[] = [];

    try {
      // Calculate bounding box for spatial query
      const latDelta = radius / 111.32; // Rough conversion from km to degrees
      const lngDelta = radius / (111.32 * Math.cos(userLocation.latitude * Math.PI / 180));

      // Find similar products using multiple strategies
      const similarProducts = await prisma.product.findMany({
        where: {
          AND: [
            {
              OR: [
                // Exact name match
                {
                  normalizedName: {
                    contains: item.normalizedName,
                    mode: 'insensitive'
                  }
                },
                // Keyword matching
                {
                  keywords: {
                    hasSome: this.extractKeywords(item.name)
                  }
                },
                // Category matching
                ...(item.category ? [{
                  category: {
                    equals: item.category,
                    mode: 'insensitive'
                  }
                }] : [])
              ]
            },
            {
              isAvailable: true
            },
            {
              price: {
                lt: item.price // Only cheaper alternatives
              }
            },
            {
              shop: {
                AND: [
                  // Spatial query
                  {
                    latitude: {
                      gte: userLocation.latitude - latDelta,
                      lte: userLocation.latitude + latDelta
                    }
                  },
                  {
                    longitude: {
                      gte: userLocation.longitude - lngDelta,
                      lte: userLocation.longitude + lngDelta
                    }
                  },
                  // Premium filter
                  ...(premiumOnly ? [{
                    isPremium: true
                  }] : [])
                ]
              }
            }
          ]
        },
        include: {
          shop: true
        },
        orderBy: [
          { price: 'asc' },
          { shop: { isPremium: 'desc' } }
        ],
        take: 20 // Limit per item
      });

      // Calculate alternatives with savings and distance
      for (const product of similarProducts) {
        const savings = item.price - product.price;
        const savingsPercentage = (savings / item.price) * 100;
        const distance = this.calculateDistance(
          userLocation,
          { latitude: product.shop.latitude, longitude: product.shop.longitude }
        );

        // Only include if within radius and has meaningful savings
        if (distance <= radius && savingsPercentage >= 5) {
          alternatives.push({
            originalItem: item.name,
            shop: {
              id: product.shop.id,
              name: product.shop.name,
              address: product.shop.address || undefined,
              latitude: product.shop.latitude,
              longitude: product.shop.longitude,
              rating: product.shop.rating || undefined,
              isPremium: product.shop.isPremium,
              category: product.shop.category || undefined,
              imageUrl: product.shop.imageUrl || undefined
            },
            product: {
              id: product.id,
              name: product.name,
              price: product.price,
              category: product.category || undefined,
              brand: product.brand || undefined,
              imageUrl: product.imageUrl || undefined
            },
            savings,
            savingsPercentage,
            distance
          });
        }
      }

    } catch (error) {
      logger.error('Error finding alternatives for item', {
        item: item.name,
        error: error instanceof Error ? error.message : error
      });
    }

    return alternatives;
  }

  /**
   * Extract keywords from product name
   */
  private extractKeywords(name: string): string[] {
    const stopWords = ['the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by'];
    
    return name
      .toLowerCase()
      .split(/\s+/)
      .filter(word => 
        word.length > 2 && 
        !stopWords.includes(word) &&
        !/^\d+$/.test(word) // Exclude pure numbers
      )
      .slice(0, 5); // Limit to 5 keywords
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