"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScanService = void 0;
const client_1 = require("@prisma/client");
const ClovaService_1 = require("./ClovaService");
const ProductMatchingService_1 = require("./ProductMatchingService");
const ImageService_1 = require("./ImageService");
const logger_1 = require("../utils/logger");
const prisma = new client_1.PrismaClient();
class ScanService {
    constructor() {
        this.clovaService = new ClovaService_1.ClovaService();
        this.productMatchingService = new ProductMatchingService_1.ProductMatchingService();
        this.imageService = new ImageService_1.ImageService();
    }
    async processInvoice(request) {
        const startTime = Date.now();
        try {
            logger_1.logger.info('Processing invoice', { imagePath: request.imagePath });
            const processedImagePath = await this.imageService.preprocessImage(request.imagePath);
            const extractedItems = await this.clovaService.extractItems(processedImagePath);
            const alternatives = await this.productMatchingService.findAlternatives(extractedItems, request.userLocation, request.radius, request.premiumOnly);
            const totalSavings = alternatives.reduce((sum, alt) => sum + alt.savings, 0);
            const avgConfidence = extractedItems.length > 0
                ? extractedItems.reduce((sum, item) => sum + (item.confidence || 0), 0) / extractedItems.length
                : 0;
            const processingTime = Date.now() - startTime;
            const scanHistory = await prisma.scanHistory.create({
                data: {
                    imagePath: request.imagePath,
                    scanResult: {
                        scannedItems: extractedItems,
                        alternatives: alternatives,
                        summary: {
                            itemsFound: extractedItems.length,
                            alternativesFound: alternatives.length,
                            potentialSavings: totalSavings,
                            confidenceScore: avgConfidence,
                            processingTimeMs: processingTime
                        }
                    },
                    itemsFound: extractedItems.length,
                    alternativesFound: alternatives.length,
                    potentialSavings: totalSavings,
                    confidenceScore: avgConfidence,
                    userLatitude: request.userLocation.latitude,
                    userLongitude: request.userLocation.longitude
                }
            });
            logger_1.logger.info('Invoice processing completed', {
                scanId: scanHistory.id,
                itemsFound: extractedItems.length,
                alternativesFound: alternatives.length,
                processingTime
            });
            return {
                scanId: scanHistory.id,
                scannedItems: extractedItems,
                alternatives: alternatives,
                summary: {
                    itemsFound: extractedItems.length,
                    alternativesFound: alternatives.length,
                    potentialSavings: totalSavings,
                    confidenceScore: avgConfidence,
                    processingTimeMs: processingTime
                }
            };
        }
        catch (error) {
            logger_1.logger.error('Error processing invoice', { error: error instanceof Error ? error.message : error });
            throw error;
        }
    }
    async getScanHistory(page, limit) {
        const skip = (page - 1) * limit;
        const [scans, total] = await Promise.all([
            prisma.scanHistory.findMany({
                skip,
                take: limit,
                orderBy: { createdAt: 'desc' }
            }),
            prisma.scanHistory.count()
        ]);
        return {
            scans,
            total
        };
    }
}
exports.ScanService = ScanService;
//# sourceMappingURL=ScanService.js.map