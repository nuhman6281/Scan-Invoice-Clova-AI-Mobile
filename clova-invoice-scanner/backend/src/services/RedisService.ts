import Redis from "ioredis";
import { logger } from "../utils/logger";

class RedisService {
  private static redis: Redis;

  public static async initialize(): Promise<void> {
    try {
      this.redis = new Redis(
        process.env.REDIS_URL || "redis://localhost:6380",
        {
          retryDelayOnFailover: 100,
          maxRetriesPerRequest: 3,
          lazyConnect: true,
        }
      );

      this.redis.on("connect", () => {
        logger.info("Redis connected successfully");
      });

      this.redis.on("error", (error) => {
        logger.error("Redis connection error:", error);
      });

      await this.redis.connect();
    } catch (error) {
      logger.error("Failed to connect to Redis:", error);
      throw error;
    }
  }

  public static async ping(): Promise<boolean> {
    try {
      await this.redis.ping();
      return true;
    } catch (error) {
      logger.error("Redis ping failed:", error);
      return false;
    }
  }

  public static getClient(): Redis {
    if (!this.redis) {
      throw new Error("Redis not initialized. Call initialize() first.");
    }
    return this.redis;
  }

  public static async disconnect(): Promise<void> {
    if (this.redis) {
      await this.redis.disconnect();
      logger.info("Redis connection closed");
    }
  }
}

export { RedisService };
