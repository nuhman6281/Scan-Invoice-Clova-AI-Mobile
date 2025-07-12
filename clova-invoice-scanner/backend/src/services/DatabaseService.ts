import { PrismaClient } from "@prisma/client";
import { logger } from "../utils/logger";

class DatabaseService {
  private static prisma: PrismaClient;

  public static async initialize(): Promise<void> {
    try {
      this.prisma = new PrismaClient({
        log: ["error", "warn"],
        errorFormat: "pretty",
      });

      await this.prisma.$connect();
      logger.info("Database connection established");
    } catch (error) {
      logger.error("Failed to connect to database:", error);
      throw error;
    }
  }

  public static async ping(): Promise<boolean> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return true;
    } catch (error) {
      logger.error("Database ping failed:", error);
      return false;
    }
  }

  public static getClient(): PrismaClient {
    if (!this.prisma) {
      throw new Error("Database not initialized. Call initialize() first.");
    }
    return this.prisma;
  }

  public static async disconnect(): Promise<void> {
    if (this.prisma) {
      await this.prisma.$disconnect();
      logger.info("Database connection closed");
    }
  }
}

export { DatabaseService };
