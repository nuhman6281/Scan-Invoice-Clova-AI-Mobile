"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScanController = void 0;
const ScanService_1 = require("../services/ScanService");
const logger_1 = require("../utils/logger");
class ScanController {
    constructor() {
        this.scanService = new ScanService_1.ScanService();
    }
    async scanInvoice(req, res) {
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
            const radius = parseFloat(req.query.radius) || 10;
            const premiumOnly = req.query.premiumOnly === 'true';
            logger_1.logger.info('Starting invoice scan', {
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
        }
        catch (error) {
            logger_1.logger.error('Error scanning invoice', { error: error instanceof Error ? error.message : error });
            res.status(500).json({
                success: false,
                error: {
                    message: 'Failed to process invoice',
                    ...(process.env.NODE_ENV !== 'production' && { details: error instanceof Error ? error.message : 'Unknown error' })
                }
            });
        }
    }
    async getScanHistory(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
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
        }
        catch (error) {
            logger_1.logger.error('Error getting scan history', { error: error instanceof Error ? error.message : error });
            res.status(500).json({
                success: false,
                error: {
                    message: 'Failed to retrieve scan history'
                }
            });
        }
    }
}
exports.ScanController = ScanController;
//# sourceMappingURL=ScanController.js.map