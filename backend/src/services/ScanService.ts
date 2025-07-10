import { PrismaClient } from '@prisma/client';
import { ClovaService } from './ClovaService';
import { ProductMatchingService } from './ProductMatchingService';
import { ImageService } from './ImageService';
import { logger } from '../utils/logger';

const prisma = new PrismaClient();

export interface ScanRequest {
  imagePath: string;
  userLocation: {
    latitude: number;
    longitude: number;
  };
  radius: number;
  premiumOnly: boolean;
}

export interface ScannedItem {
  name: string;
  normalizedName: string;
  price: number;
  quantity: number;
  category?: string;
  confidence?: number;
}

export interface Alternative {
  originalItem: string;
  shop: {
    id: string;
    name: string;
    address?: string;
    latitude: number;
    longitude: number;
    rating?: number;
    isPremium: boolean;
    category?: string;
    imageUrl?: string;
  };
  product: {
    id: string;
    name: string;
    price: number;
    category?: string;
    brand?: string;
    imageUrl?: string;
  };
  savings: number;
  savingsPercentage: number;
  distance: number;
}

export interface ScanResult {
  scanId: string;
  scannedItems: ScannedItem[];
  alternatives: Alternative[];
  summary: {
    itemsFound: number;
    alternativesFound: number;
    potentialSavings: number;
    confidenceScore: number;
    processingTimeMs: number;
  };
}

export class ScanService {
  private clovaService: ClovaService;
  private productMatchingService: ProductMatchingService;
  private imageService: ImageService;

  constructor() {
    this.clovaService = new ClovaService();
    this.productMatchingService = new ProductMatchingService();
    this.imageService = new ImageService();
  }

  /**
   * Process an invoice and find product alternatives
   */
  async processInvoice(request: ScanRequest): Promise<ScanResult> {
    const startTime = Date.now();
    
    try {
      logger.info('Processing invoice', { imagePath: request.imagePath });

      // Step 1: Preprocess image
      const processedImagePath = await this.imageService.preprocessImage(request.imagePath);

      // Step 2: Extract items using CLOVA AI
      const extractedItems = await this.clovaService.extractItems(processedImagePath);

      // Step 3: Find product alternatives
      const alternatives = await this.productMatchingService.findAlternatives(
        extractedItems,
        request.userLocation,
        request.radius,
        request.premiumOnly
      );

      // Step 4: Calculate summary
      const totalSavings = alternatives.reduce((sum, alt) => sum + alt.savings, 0);
      const avgConfidence = extractedItems.length > 0 
        ? extractedItems.reduce((sum, item) => sum + (item.confidence || 0), 0) / extractedItems.length
        : 0;

      const processingTime = Date.now() - startTime;

      // Step 5: Save scan history
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

      logger.info('Invoice processing completed', {
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

    } catch (error) {
      logger.error('Error processing invoice', { error: error instanceof Error ? error.message : error });
      throw error;
    }
  }

  /**
   * Get scan history with pagination
   */
  async getScanHistory(page: number, limit: number) {
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