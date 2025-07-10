"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductController = void 0;
const client_1 = require("@prisma/client");
const logger_1 = require("../utils/logger");
const prisma = new client_1.PrismaClient();
class ProductController {
    async getProducts(req, res) {
        try {
            const { category, search, minPrice, maxPrice, page = '1', limit = '20' } = req.query;
            const pageNum = parseInt(page);
            const limitNum = parseInt(limit);
            const skip = (pageNum - 1) * limitNum;
            const where = {
                isAvailable: true
            };
            if (category) {
                where.category = {
                    equals: category,
                    mode: 'insensitive'
                };
            }
            if (search) {
                where.OR = [
                    {
                        name: {
                            contains: search,
                            mode: 'insensitive'
                        }
                    },
                    {
                        normalizedName: {
                            contains: search,
                            mode: 'insensitive'
                        }
                    },
                    {
                        keywords: {
                            hasSome: [search.toLowerCase()]
                        }
                    }
                ];
            }
            if (minPrice || maxPrice) {
                where.price = {};
                if (minPrice) {
                    where.price.gte = parseFloat(minPrice);
                }
                if (maxPrice) {
                    where.price.lte = parseFloat(maxPrice);
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
        }
        catch (error) {
            logger_1.logger.error('Error getting products', {
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
exports.ProductController = ProductController;
//# sourceMappingURL=ProductController.js.map