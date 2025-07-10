"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductMatchingService = void 0;
const client_1 = require("@prisma/client");
const logger_1 = require("../utils/logger");
const prisma = new client_1.PrismaClient();
class ProductMatchingService {
    async findAlternatives(scannedItems, userLocation, radius = 10, premiumOnly = false) {
        try {
            logger_1.logger.info('Finding product alternatives', {
                itemsCount: scannedItems.length,
                radius,
                premiumOnly
            });
            const alternatives = [];
            for (const item of scannedItems) {
                const itemAlternatives = await this.findAlternativesForItem(item, userLocation, radius, premiumOnly);
                alternatives.push(...itemAlternatives);
            }
            alternatives.sort((a, b) => b.savingsPercentage - a.savingsPercentage);
            logger_1.logger.info('Found alternatives', {
                alternativesCount: alternatives.length
            });
            return alternatives.slice(0, 50);
        }
        catch (error) {
            logger_1.logger.error('Error finding alternatives', {
                error: error instanceof Error ? error.message : error
            });
            return [];
        }
    }
    async findAlternativesForItem(item, userLocation, radius, premiumOnly) {
        const alternatives = [];
        try {
            const latDelta = radius / 111.32;
            const lngDelta = radius / (111.32 * Math.cos(userLocation.latitude * Math.PI / 180));
            const similarProducts = await prisma.product.findMany({
                where: {
                    AND: [
                        {
                            OR: [
                                {
                                    normalizedName: {
                                        contains: item.normalizedName,
                                        mode: 'insensitive'
                                    }
                                },
                                {
                                    keywords: {
                                        hasSome: this.extractKeywords(item.name)
                                    }
                                },
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
                                lt: item.price
                            }
                        },
                        {
                            shop: {
                                AND: [
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
                take: 20
            });
            for (const product of similarProducts) {
                const savings = item.price - product.price;
                const savingsPercentage = (savings / item.price) * 100;
                const distance = this.calculateDistance(userLocation, { latitude: product.shop.latitude, longitude: product.shop.longitude });
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
        }
        catch (error) {
            logger_1.logger.error('Error finding alternatives for item', {
                item: item.name,
                error: error instanceof Error ? error.message : error
            });
        }
        return alternatives;
    }
    extractKeywords(name) {
        const stopWords = ['the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by'];
        return name
            .toLowerCase()
            .split(/\s+/)
            .filter(word => word.length > 2 &&
            !stopWords.includes(word) &&
            !/^\d+$/.test(word))
            .slice(0, 5);
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
exports.ProductMatchingService = ProductMatchingService;
//# sourceMappingURL=ProductMatchingService.js.map