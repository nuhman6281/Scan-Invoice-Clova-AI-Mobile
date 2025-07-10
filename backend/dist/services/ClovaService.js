"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ClovaService = void 0;
const axios_1 = __importDefault(require("axios"));
const logger_1 = require("../utils/logger");
class ClovaService {
    constructor() {
        this.baseUrl = process.env.CLOVA_SERVICE_URL || 'http://localhost:8000';
    }
    async extractItems(imagePath) {
        try {
            logger_1.logger.info('Sending image to CLOVA service', { imagePath });
            const FormData = require('form-data');
            const form = new FormData();
            form.append('file', require('fs').createReadStream(imagePath));
            const response = await axios_1.default.post(`${this.baseUrl}/process-invoice`, form, {
                headers: {
                    ...form.getHeaders(),
                    'Content-Type': 'multipart/form-data'
                },
                timeout: 30000
            });
            if (response.data.success) {
                const extractedItems = this.parseClovaResponse(response.data.items);
                logger_1.logger.info('Successfully extracted items from CLOVA service', {
                    itemsCount: extractedItems.length
                });
                return extractedItems;
            }
            else {
                throw new Error(response.data.error || 'CLOVA service returned an error');
            }
        }
        catch (error) {
            logger_1.logger.error('Error communicating with CLOVA service', {
                error: error instanceof Error ? error.message : error,
                imagePath
            });
            return [];
        }
    }
    parseClovaResponse(items) {
        return items.map(item => ({
            name: item.name || item.product_name || 'Unknown Item',
            normalizedName: this.normalizeProductName(item.name || item.product_name || ''),
            price: parseFloat(item.price || item.cost || '0'),
            quantity: parseInt(item.quantity || item.qty || '1'),
            category: item.category || undefined,
            confidence: parseFloat(item.confidence || item.score || '0.8')
        })).filter(item => item.name !== 'Unknown Item' && item.price > 0);
    }
    normalizeProductName(name) {
        return name
            .toLowerCase()
            .trim()
            .replace(/[^\w\s]/g, '')
            .replace(/\s+/g, ' ')
            .trim();
    }
    async healthCheck() {
        try {
            const response = await axios_1.default.get(`${this.baseUrl}/health`, {
                timeout: 5000
            });
            return response.data.status === 'healthy';
        }
        catch (error) {
            logger_1.logger.error('CLOVA service health check failed', {
                error: error instanceof Error ? error.message : error
            });
            return false;
        }
    }
}
exports.ClovaService = ClovaService;
//# sourceMappingURL=ClovaService.js.map