import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { logger } from '../utils/logger';

const prisma = new PrismaClient();

export class ProductController {
  /**
   * Get products with filters
   */
  async getProducts(req: Request, res: Response): Promise<void> {
    try {
      const {
        category,
        search,
        minPrice,
        maxPrice,
        page = '1',
        limit = '20'
      } = req.query;

      const pageNum = parseInt(page as string);
      const limitNum = parseInt(limit as string);
      const skip = (pageNum - 1) * limitNum;

      // Build where clause
      const where: any = {
        isAvailable: true
      };

      if (category) {
        where.category = {
          equals: category as string,
          mode: 'insensitive'
        };
      }

      if (search) {
        where.OR = [
          {
            name: {
              contains: search as string,
              mode: 'insensitive'
            }
          },
          {
            normalizedName: {
              contains: search as string,
              mode: 'insensitive'
            }
          },
          {
            keywords: {
              hasSome: [(search as string).toLowerCase()]
            }
          }
        ];
      }

      if (minPrice || maxPrice) {
        where.price = {};
        if (minPrice) {
          where.price.gte = parseFloat(minPrice as string);
        }
        if (maxPrice) {
          where.price.lte = parseFloat(maxPrice as string);
        }
      }

      const [products, total] = await Promise.all([
        prisma.product.findMany({
          where,
          include: {
            shop: {
              select: {
                id: true,
                name: true,
                address: true,
                latitude: true,
                longitude: true,
                rating: true,
                isPremium: true,
                category: true
              }
            }
          },
          orderBy: { price: 'asc' },
          skip,
          take: limitNum
        }),
        prisma.product.count({ where })
      ]);

      res.status(200).json({
        success: true,
        data: products,
        pagination: {
          page: pageNum,
          limit: limitNum,
          total,
          totalPages: Math.ceil(total / limitNum)
        }
      });

    } catch (error) {
      logger.error('Error getting products', {
        error: error instanceof Error ? error.message : error
      });
      
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to retrieve products'
        }
      });
    }
  }
}