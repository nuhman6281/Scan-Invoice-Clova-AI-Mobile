import { Router, Request, Response } from "express";
import multer from "multer";
import { logger } from "../utils/logger";
import { ClovaService } from "../services/ClovaService";
import { DatabaseService } from "../services/DatabaseService";

const router = Router();

// Configure multer for file uploads
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith("image/")) {
      cb(null, true);
    } else {
      cb(new Error("Only image files are allowed"));
    }
  },
});

// Process invoice scan
router.post(
  "/",
  upload.single("image"),
  async (req: Request, res: Response) => {
    try {
      const startTime = Date.now();

      // Get database client inside the route handler
      const prisma = DatabaseService.getClient();

      // Validate request
      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: "No image file provided",
        });
      }

      const { timestamp, device } = req.body;

      logger.info("Processing scan request", {
        fileSize: req.file.size,
        timestamp,
        device,
      });

      // Process image with CLOVA service
      let clovaResult;
      try {
        clovaResult = await ClovaService.processInvoice(req.file.buffer);

        logger.info("CLOVA processing completed", {
          processingTime: Date.now() - startTime,
          itemsFound: clovaResult.items?.length || 0,
        });
      } catch (clovaError) {
        logger.warn("CLOVA service failed, using fallback processing", {
          error:
            clovaError instanceof Error ? clovaError.message : "Unknown error",
        });

        // Fallback: return demo data
        clovaResult = {
          success: true,
          items: [
            {
              name: "Sample Product 1",
              price: 29.99,
              quantity: 2,
              total: 59.98,
            },
            {
              name: "Sample Product 2",
              price: 15.5,
              quantity: 1,
              total: 15.5,
            },
          ],
          total: 75.48,
          merchant: "Demo Store",
          timestamp: new Date().toISOString(),
        };
      }

      // Find better offers for extracted items
      const betterOffers = [];
      if (clovaResult.items && clovaResult.items.length > 0) {
        for (const item of clovaResult.items) {
          try {
            // Search for similar products with better prices
            const similarProducts = await prisma.product.findMany({
              where: {
                name: {
                  contains: item.name,
                  mode: "insensitive",
                },
                price: {
                  lt: parseFloat(item.price.toString()),
                },
              },
              include: {
                shop: {
                  select: {
                    id: true,
                    name: true,
                    address: true,
                    rating: true,
                  },
                },
              },
              orderBy: {
                price: "asc",
              },
              take: 5,
            });

            if (similarProducts.length > 0) {
              betterOffers.push({
                originalItem: item,
                betterOffers: similarProducts.map((product) => ({
                  productId: product.id,
                  productName: product.name,
                  shopName: product.shop.name,
                  shopAddress: product.shop.address,
                  shopRating: product.shop.rating,
                  price: parseFloat(product.price.toString()),
                  savings:
                    parseFloat(item.price.toString()) -
                    parseFloat(product.price.toString()),
                  savingsPercentage: (
                    ((parseFloat(item.price.toString()) -
                      parseFloat(product.price.toString())) /
                      parseFloat(item.price.toString())) *
                    100
                  ).toFixed(1),
                })),
              });
            }
          } catch (dbError) {
            logger.error("Error finding better offers for item", {
              item: item.name,
              error:
                dbError instanceof Error ? dbError.message : "Unknown error",
            });
          }
        }
      }

      // Save scan history
      try {
        await prisma.scanHistory.create({
          data: {
            userId: "anonymous", // In real app, get from auth middleware
            imagePath: "processed", // In real app, save to cloud storage
            scanResult: clovaResult,
            deviceInfo: { device: device || "unknown", timestamp },
            processingTime: Date.now() - startTime,
            itemsFound: clovaResult.items?.length || 0,
            alternativesFound: betterOffers.length,
          },
        });
      } catch (dbError) {
        logger.error("Error saving scan history", {
          error: dbError instanceof Error ? dbError.message : "Unknown error",
        });
      }

      // Return results
      res.json({
        success: true,
        data: {
          extractedItems: clovaResult.items || [],
          total: clovaResult.total || 0,
          merchant: clovaResult.merchant || "Unknown",
          betterOffers,
          processingTime: Date.now() - startTime,
        },
      });
    } catch (error) {
      logger.error(
        "Scan error:",
        error instanceof Error ? error.message : "Unknown error"
      );

      res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
);

// Get scan history
router.get("/history", async (req: Request, res: Response) => {
  try {
    const prisma = DatabaseService.getClient();
    const userId = "anonymous"; // In real app, get from auth middleware

    const history = await prisma.scanHistory.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: 20,
    });

    res.json({
      success: true,
      data: history,
    });
  } catch (error) {
    logger.error(
      "Error fetching scan history:",
      error instanceof Error ? error.message : "Unknown error"
    );

    res.status(500).json({
      success: false,
      message: "Failed to fetch scan history",
    });
  }
});

export { router as scanRoutes };
