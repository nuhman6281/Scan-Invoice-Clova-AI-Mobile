import { Router, Request, Response } from "express";
import { DatabaseService } from "../services/DatabaseService";
import { RedisService } from "../services/RedisService";
import { ClovaService } from "../services/ClovaService";
import { logger } from "../utils/logger";

const router = Router();

router.get("/", async (req: Request, res: Response) => {
  try {
    const health = {
      status: "healthy",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || "development",
      services: {
        database: "unknown",
        redis: "unknown",
        clova: "unknown",
      },
    };

    // Check database
    try {
      await DatabaseService.ping();
      health.services.database = "healthy";
    } catch (error) {
      health.services.database = "unhealthy";
      health.status = "degraded";
    }

    // Check Redis
    try {
      await RedisService.ping();
      health.services.redis = "healthy";
    } catch (error) {
      health.services.redis = "unhealthy";
      health.status = "degraded";
    }

    // Check CLOVA service
    try {
      await ClovaService.ping();
      health.services.clova = "healthy";
    } catch (error) {
      health.services.clova = "unhealthy";
      health.status = "degraded";
    }

    const statusCode = health.status === "healthy" ? 200 : 503;
    res.status(statusCode).json(health);
  } catch (error) {
    logger.error("Health check failed:", error);
    res.status(503).json({
      status: "unhealthy",
      timestamp: new Date().toISOString(),
      error: "Health check failed",
    });
  }
});

export { router as healthRoutes };
