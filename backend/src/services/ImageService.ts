import sharp from 'sharp';
import { promises as fs } from 'fs';
import path from 'path';
import { logger } from '../utils/logger';

export class ImageService {
  /**
   * Preprocess image for CLOVA AI processing
   */
  async preprocessImage(imagePath: string): Promise<string> {
    try {
      logger.info('Preprocessing image', { imagePath });

      const outputPath = this.generateOutputPath(imagePath);
      
      // Process image with Sharp
      await sharp(imagePath)
        .resize(800, 600, {
          fit: 'inside',
          withoutEnlargement: true
        })
        .jpeg({
          quality: 85,
          progressive: true
        })
        .toFile(outputPath);

      logger.info('Image preprocessing completed', { outputPath });
      return outputPath;

    } catch (error) {
      logger.error('Error preprocessing image', {
        error: error instanceof Error ? error.message : error,
        imagePath
      });
      
      // Return original path if preprocessing fails
      return imagePath;
    }
  }

  /**
   * Generate output path for processed image
   */
  private generateOutputPath(originalPath: string): string {
    const dir = path.dirname(originalPath);
    const ext = path.extname(originalPath);
    const name = path.basename(originalPath, ext);
    return path.join(dir, `${name}_processed${ext}`);
  }

  /**
   * Validate image file
   */
  async validateImage(imagePath: string): Promise<boolean> {
    try {
      const metadata = await sharp(imagePath).metadata();
      
      // Check if it's a valid image
      if (!metadata.width || !metadata.height) {
        return false;
      }

      // Check minimum size requirements
      if (metadata.width < 100 || metadata.height < 100) {
        return false;
      }

      // Check maximum size requirements
      if (metadata.width > 4000 || metadata.height > 4000) {
        return false;
      }

      return true;

    } catch (error) {
      logger.error('Error validating image', {
        error: error instanceof Error ? error.message : error,
        imagePath
      });
      return false;
    }
  }

  /**
   * Clean up temporary files
   */
  async cleanupTempFiles(filePaths: string[]): Promise<void> {
    for (const filePath of filePaths) {
      try {
        await fs.unlink(filePath);
        logger.debug('Cleaned up temp file', { filePath });
      } catch (error) {
        logger.warn('Failed to cleanup temp file', {
          error: error instanceof Error ? error.message : error,
          filePath
        });
      }
    }
  }
}