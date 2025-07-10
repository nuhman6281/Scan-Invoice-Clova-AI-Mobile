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
export declare class ScanService {
    private clovaService;
    private productMatchingService;
    private imageService;
    constructor();
    processInvoice(request: ScanRequest): Promise<ScanResult>;
    getScanHistory(page: number, limit: number): Promise<{
        scans: {
            id: string;
            createdAt: Date;
            imagePath: string | null;
            scanResult: import("@prisma/client/runtime/library").JsonValue | null;
            itemsFound: number;
            alternativesFound: number;
            potentialSavings: import("@prisma/client/runtime/library").Decimal;
            confidenceScore: import("@prisma/client/runtime/library").Decimal | null;
            userLatitude: import("@prisma/client/runtime/library").Decimal | null;
            userLongitude: import("@prisma/client/runtime/library").Decimal | null;
        }[];
        total: number;
    }>;
}
//# sourceMappingURL=ScanService.d.ts.map