import { ScannedItem, Alternative } from './ScanService';
export declare class ProductMatchingService {
    findAlternatives(scannedItems: ScannedItem[], userLocation: {
        latitude: number;
        longitude: number;
    }, radius?: number, premiumOnly?: boolean): Promise<Alternative[]>;
    private findAlternativesForItem;
    private extractKeywords;
    private calculateDistance;
    private toRadians;
}
//# sourceMappingURL=ProductMatchingService.d.ts.map