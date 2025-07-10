"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnalyticsController = void 0;
const client_1 = require("@prisma/client");
const logger_1 = require("../utils/logger");
const prisma = new client_1.PrismaClient();
class AnalyticsController {
    async getStats(req, res) {
        try {
            const totalScans = await prisma.scanHistory.count();
            const savingsStats = await prisma.scanHistory.aggregate({
                _sum: {
                    potentialSavings: true
                },
                _avg: {
                    potentialSavings: true
                }
            });
            const scanResults = await prisma.scanHistory.findMany({
                select: {
                    scanResult: true
                },
                orderBy: {
                    createdAt: 'desc'
                },
                take: 1000
            });
            const categoryCounts = {};
            scanResults.forEach(scan => {
                if (scan.scanResult && typeof scan.scanResult === 'object') {
                    const result = scan.scanResult;
                    if (result.scannedItems && Array.isArray(result.scannedItems)) {
                        result.scannedItems.forEach((item) => {
                            if (item.category) {
                                categoryCounts[item.category] = (categoryCounts[item.category] || 0) + 1;
                            }
                        });
                    }
                }
            });
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
        }
        catch (error) {
            logger_1.logger.error('Error getting analytics stats', {
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
exports.AnalyticsController = AnalyticsController;
//# sourceMappingURL=AnalyticsController.js.map