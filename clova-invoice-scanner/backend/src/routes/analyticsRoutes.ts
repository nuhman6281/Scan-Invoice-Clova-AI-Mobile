import { Router, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import { logger } from "../utils/logger";

const router = Router();
const prisma = new PrismaClient();

// Get dashboard analytics
router.get("/dashboard", async (req: Request, res: Response) => {
  try {
    // Get total counts
    const [totalShops, totalProducts, totalUsers, totalScans] =
      await Promise.all([
        prisma.shop.count(),
        prisma.product.count(),
        prisma.user.count(),
        prisma.scanHistory.count(),
      ]);

    // Get recent analytics (last 7 days)
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const recentAnalytics = await prisma.analytics.findMany({
      where: {
        date: {
          gte: sevenDaysAgo,
        },
      },
      orderBy: {
        date: "desc",
      },
      take: 7,
    });

    // Calculate totals from recent analytics
    const totalScans7Days = recentAnalytics.reduce(
      (sum, a) => sum + a.totalScans,
      0
    );
    const successfulScans7Days = recentAnalytics.reduce(
      (sum, a) => sum + a.successfulScans,
      0
    );
    const totalSavings7Days = recentAnalytics.reduce(
      (sum, a) => sum + Number(a.totalSavings),
      0
    );
    const avgProcessingTime =
      recentAnalytics.length > 0
        ? recentAnalytics.reduce((sum, a) => sum + a.avgProcessingTime, 0) /
          recentAnalytics.length
        : 0;

    // Get popular products (from scan history - using scanResult JSON)
    const recentScans = await prisma.scanHistory.findMany({
      take: 100,
      orderBy: {
        createdAt: "desc",
      },
      select: {
        id: true,
        scanResult: true,
        itemsFound: true,
        alternativesFound: true,
        potentialSavings: true,
        confidenceScore: true,
        processingTime: true,
        createdAt: true,
        userId: true,
      },
    });

    // Extract product names from scan results (simplified approach)
    const productCounts: { [key: string]: number } = {};
    recentScans.forEach((scan) => {
      if (scan.scanResult && typeof scan.scanResult === "object") {
        // Try to extract product names from scan result
        const result = scan.scanResult as any;
        if (result.items && Array.isArray(result.items)) {
          result.items.forEach((item: any) => {
            if (item.name) {
              productCounts[item.name] = (productCounts[item.name] || 0) + 1;
            }
          });
        }
      }
    });

    const popularProducts = Object.entries(productCounts)
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);

    res.json({
      success: true,
      data: {
        overview: {
          totalShops,
          totalProducts,
          totalUsers,
          totalScans,
        },
        last7Days: {
          totalScans: totalScans7Days,
          successfulScans: successfulScans7Days,
          totalSavings: totalSavings7Days,
          avgProcessingTime: Math.round(avgProcessingTime),
          successRate:
            totalScans7Days > 0
              ? ((successfulScans7Days / totalScans7Days) * 100).toFixed(1)
              : 0,
        },
        popularProducts,
        recentScans,
        analytics: recentAnalytics,
      },
    });
  } catch (error) {
    logger.error("Dashboard analytics error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get analytics by date range
router.get("/", async (req: Request, res: Response) => {
  try {
    const { startDate, endDate, limit = 30 } = req.query;

    const where: any = {};

    if (startDate && endDate) {
      where.date = {
        gte: new Date(startDate as string),
        lte: new Date(endDate as string),
      };
    }

    const analytics = await prisma.analytics.findMany({
      where,
      orderBy: {
        date: "desc",
      },
      take: parseInt(limit as string),
    });

    res.json({
      success: true,
      data: analytics,
    });
  } catch (error) {
    logger.error("Analytics error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get scan statistics
router.get("/scans", async (req: Request, res: Response) => {
  try {
    const { period = "7d" } = req.query;

    let startDate = new Date();
    switch (period) {
      case "1d":
        startDate.setDate(startDate.getDate() - 1);
        break;
      case "7d":
        startDate.setDate(startDate.getDate() - 7);
        break;
      case "30d":
        startDate.setDate(startDate.getDate() - 30);
        break;
      case "90d":
        startDate.setDate(startDate.getDate() - 90);
        break;
      default:
        startDate.setDate(startDate.getDate() - 7);
    }

    const scans = await prisma.scanHistory.findMany({
      where: {
        createdAt: {
          gte: startDate,
        },
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    const totalScans = scans.length;
    const successfulScans = scans.filter(
      (s) => s.confidenceScore && Number(s.confidenceScore) > 0.5
    ).length;
    const totalSavings = scans.reduce(
      (sum, s) => sum + Number(s.potentialSavings),
      0
    );

    res.json({
      success: true,
      data: {
        period,
        totalScans,
        successfulScans,
        failedScans: totalScans - successfulScans,
        successRate:
          totalScans > 0
            ? ((successfulScans / totalScans) * 100).toFixed(1)
            : 0,
        totalSavings,
        scans,
      },
    });
  } catch (error) {
    logger.error("Scan statistics error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

export { router as analyticsRoutes };
