"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ImageService = void 0;
const sharp_1 = __importDefault(require("sharp"));
const fs_1 = require("fs");
const path_1 = __importDefault(require("path"));
const logger_1 = require("../utils/logger");
class ImageService {
    async preprocessImage(imagePath) {
        try {
            logger_1.logger.info('Preprocessing image', { imagePath });
            const outputPath = this.generateOutputPath(imagePath);
            await (0, sharp_1.default)(imagePath)
                .resize(800, 600, {
                fit: 'inside',
                withoutEnlargement: true
            })
                .jpeg({
                quality: 85,
                progressive: true
            })
                .toFile(outputPath);
            logger_1.logger.info('Image preprocessing completed', { outputPath });
            return outputPath;
        }
        catch (error) {
            logger_1.logger.error('Error preprocessing image', {
                error: error instanceof Error ? error.message : error,
                imagePath
            });
            return imagePath;
        }
    }
    generateOutputPath(originalPath) {
        const dir = path_1.default.dirname(originalPath);
        const ext = path_1.default.extname(originalPath);
        const name = path_1.default.basename(originalPath, ext);
        return path_1.default.join(dir, `${name}_processed${ext}`);
    }
    async validateImage(imagePath) {
        try {
            const metadata = await (0, sharp_1.default)(imagePath).metadata();
            if (!metadata.width || !metadata.height) {
                return false;
            }
            if (metadata.width < 100 || metadata.height < 100) {
                return false;
            }
            if (metadata.width > 4000 || metadata.height > 4000) {
                return false;
            }
            return true;
        }
        catch (error) {
            logger_1.logger.error('Error validating image', {
                error: error instanceof Error ? error.message : error,
                imagePath
            });
            return false;
        }
    }
    async cleanupTempFiles(filePaths) {
        for (const filePath of filePaths) {
            try {
                await fs_1.promises.unlink(filePath);
                logger_1.logger.debug('Cleaned up temp file', { filePath });
            }
            catch (error) {
                logger_1.logger.warn('Failed to cleanup temp file', {
                    error: error instanceof Error ? error.message : error,
                    filePath
                });
            }
        }
    }
}
exports.ImageService = ImageService;
//# sourceMappingURL=ImageService.js.map