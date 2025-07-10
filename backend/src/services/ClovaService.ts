import axios from 'axios';
import { logger } from '../utils/logger';
import { ScannedItem } from './ScanService';

export class ClovaService {
  private baseUrl: string;

  constructor() {
    this.baseUrl = process.env.CLOVA_SERVICE_URL || 'http://localhost:8000';
  }

  /**
   * Extract items from an invoice image using CLOVA AI
   */
  async extractItems(imagePath: string): Promise<ScannedItem[]> {
    try {
      logger.info('Sending image to CLOVA service', { imagePath });

      // Create form data with the image
      const FormData = require('form-data');
      const form = new FormData();
      form.append('file', require('fs').createReadStream(imagePath));

      const response = await axios.post(`${this.baseUrl}/process-invoice`, form, {
        headers: {
          ...form.getHeaders(),
          'Content-Type': 'multipart/form-data'
        },
        timeout: 30000 // 30 second timeout
      });

      if (response.data.success) {
        const extractedItems = this.parseClovaResponse(response.data.items);
        logger.info('Successfully extracted items from CLOVA service', {
          itemsCount: extractedItems.length
        });
        return extractedItems;
      } else {
        throw new Error(response.data.error || 'CLOVA service returned an error');
      }

    } catch (error) {
      logger.error('Error communicating with CLOVA service', {
        error: error instanceof Error ? error.message : error,
        imagePath
      });

      // Return empty array as fallback
      return [];
    }
  }

  /**
   * Parse the response from CLOVA service into ScannedItem format
   */
  private parseClovaResponse(items: any[]): ScannedItem[] {
    return items.map(item => ({
      name: item.name || item.product_name || 'Unknown Item',
      normalizedName: this.normalizeProductName(item.name || item.product_name || ''),
      price: parseFloat(item.price || item.cost || '0'),
      quantity: parseInt(item.quantity || item.qty || '1'),
      category: item.category || undefined,
      confidence: parseFloat(item.confidence || item.score || '0.8')
    })).filter(item => item.name !== 'Unknown Item' && item.price > 0);
  }

  /**
   * Normalize product name for better matching
   */
  private normalizeProductName(name: string): string {
    return name
      .toLowerCase()
      .trim()
      .replace(/[^\w\s]/g, '') // Remove special characters
      .replace(/\s+/g, ' ') // Normalize whitespace
      .trim();
  }

  /**
   * Check if CLOVA service is healthy
   */
  async healthCheck(): Promise<boolean> {
    try {
      const response = await axios.get(`${this.baseUrl}/health`, {
        timeout: 5000
      });
      return response.data.status === 'healthy';
    } catch (error) {
      logger.error('CLOVA service health check failed', {
        error: error instanceof Error ? error.message : error
      });
      return false;
    }
  }
}