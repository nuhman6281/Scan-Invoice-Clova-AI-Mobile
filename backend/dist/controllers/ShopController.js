"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShopController = void 0;
const client_1 = require("@prisma/client");
const logger_1 = require("../utils/logger");
const prisma = new client_1.PrismaClient();
class ShopController {
    async getNearbyShops(req, res) {
        try {
            const lat = parseFloat(req.query.lat);
            const lng = parseFloat(req.query.lng);
            const radius = parseFloat(req.query.radius) || 10;
            const category = req.query.category;
            const premiumOnly = req.query.premiumOnly === 'true';
            logger_1.logger.info('Getting nearby shops', {
                lat,
                lng,
                radius,
                category,
                premiumOnly
            });
            const latDelta = radius / 111.32;
            const lngDelta = radius / (111.32 * Math.cos(lat * Math.PI / 180));
            const shops = await prisma.shop.findMany({
                where: {
                    AND: [
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
                        ...(category ? [{
                                category: {
                                    equals: category,
                                    mode: 'insensitive'
                                }
                            }] : []),
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
            const shopsWithDistance = shops.map(shop => {
                const distance = this.calculateDistance({ latitude: lat, longitude: lng }, { latitude: shop.latitude, longitude: shop.longitude });
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
        }
        catch (error) {
            logger_1.logger.error('Error getting nearby shops', {
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
    async getShopById(req, res) {
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
        }
        catch (error) {
            logger_1.logger.error('Error getting shop by ID', {
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
    calculateDistance(point1, point2) {
        const R = 6371;
        const dLat = this.toRadians(point2.latitude - point1.latitude);
        const dLon = this.toRadians(point2.longitude - point1.longitude);
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(this.toRadians(point1.latitude)) *
                Math.cos(this.toRadians(point2.latitude)) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
    toRadians(degrees) {
        return degrees * (Math.PI / 180);
    }
}
exports.ShopController = ShopController;
//# sourceMappingURL=ShopController.js.map