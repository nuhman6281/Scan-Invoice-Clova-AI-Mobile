import dotenv from "dotenv";

dotenv.config();

export const config = {
  env: process.env["NODE_ENV"] || "development",

  server: {
    port: parseInt(process.env["PORT"] || "3000", 10),
    host: process.env["HOST"] || "0.0.0.0",
  },

  database: {
    url:
      process.env["DATABASE_URL"] ||
      "postgresql://scanner:password123@localhost:5432/invoice_scanner",
  },

  redis: {
    url: process.env["REDIS_URL"] || "redis://localhost:6380",
    ttl: parseInt(process.env["REDIS_TTL"] || "3600", 10), // 1 hour
  },

  jwt: {
    secret:
      process.env["JWT_SECRET"] ||
      "your-super-secret-jwt-key-change-in-production",
    expiresIn: process.env["JWT_EXPIRES_IN"] || "7d",
    refreshExpiresIn: process.env["JWT_REFRESH_EXPIRES_IN"] || "30d",
  },

  clova: {
    serviceUrl: process.env["CLOVA_SERVICE_URL"] || "http://localhost:8000",
    timeout: parseInt(process.env["CLOVA_TIMEOUT"] || "30000", 10), // 30 seconds
    retries: parseInt(process.env["CLOVA_RETRIES"] || "3", 10),
  },

  upload: {
    dir: process.env["UPLOAD_DIR"] || "./uploads",
    maxSize: parseInt(process.env["UPLOAD_MAX_SIZE"] || "10485760", 10), // 10MB
    allowedTypes: ["image/jpeg", "image/png", "image/webp"],
    maxFiles: parseInt(process.env["UPLOAD_MAX_FILES"] || "1", 10),
  },

  cors: {
    allowedOrigins: process.env["ALLOWED_ORIGINS"]?.split(",") || [
      "http://localhost:3000",
      "http://localhost:8080",
      "capacitor://localhost",
    ],
  },

  rateLimit: {
    windowMs: parseInt(process.env["RATE_LIMIT_WINDOW_MS"] || "900000", 10), // 15 minutes
    maxRequests: parseInt(process.env["RATE_LIMIT_MAX_REQUESTS"] || "100", 10),
  },

  logging: {
    level: process.env["LOG_LEVEL"] || "info",
    format: process.env["LOG_FORMAT"] || "json",
  },

  analytics: {
    enabled: process.env["ANALYTICS_ENABLED"] === "true",
    retentionDays: parseInt(
      process.env["ANALYTICS_RETENTION_DAYS"] || "90",
      10
    ),
  },

  security: {
    bcryptRounds: parseInt(process.env["BCRYPT_ROUNDS"] || "12", 10),
    sessionSecret: process.env["SESSION_SECRET"] || "your-session-secret",
  },
} as const;

export type Config = typeof config;
