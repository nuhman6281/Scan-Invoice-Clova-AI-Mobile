import { logger } from "./logger";

const requiredEnvVars = [
  "DATABASE_URL",
  "REDIS_URL",
  "JWT_SECRET",
  "CLOVA_SERVICE_URL",
];

export const validateEnv = (): void => {
  const missingVars = requiredEnvVars.filter(
    (varName) => !process.env[varName]
  );

  if (missingVars.length > 0) {
    logger.error(
      `Missing required environment variables: ${missingVars.join(", ")}`
    );
    process.exit(1);
  }

  logger.info("Environment variables validated successfully");
};
