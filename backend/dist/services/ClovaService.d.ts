import { ScannedItem } from './ScanService';
export declare class ClovaService {
    private baseUrl;
    constructor();
    extractItems(imagePath: string): Promise<ScannedItem[]>;
    private parseClovaResponse;
    private normalizeProductName;
    healthCheck(): Promise<boolean>;
}
//# sourceMappingURL=ClovaService.d.ts.map