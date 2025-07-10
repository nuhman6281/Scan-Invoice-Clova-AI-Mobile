export declare class ImageService {
    preprocessImage(imagePath: string): Promise<string>;
    private generateOutputPath;
    validateImage(imagePath: string): Promise<boolean>;
    cleanupTempFiles(filePaths: string[]): Promise<void>;
}
//# sourceMappingURL=ImageService.d.ts.map