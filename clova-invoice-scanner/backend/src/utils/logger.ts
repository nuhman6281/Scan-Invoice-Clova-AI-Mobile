import winston from "winston";
import { config } from "../config";

// Custom replacer function to handle circular references
const safeStringify = (obj: any, space?: number) => {
  const seen = new WeakSet();
  return JSON.stringify(
    obj,
    (key, value) => {
      if (typeof value === "object" && value !== null) {
        if (seen.has(value)) {
          return "[Circular Reference]";
        }
        seen.add(value);
      }
      return value;
    },
    space
  );
};

const logFormat = winston.format.combine(
  winston.format.timestamp(),
  winston.format.errors({ stack: true }),
  winston.format.json()
);

const consoleFormat = winston.format.combine(
  winston.format.colorize(),
  winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss" }),
  winston.format.printf(({ timestamp, level, message, ...meta }) => {
    return `${timestamp} [${level}]: ${message} ${
      Object.keys(meta).length ? safeStringify(meta, 2) : ""
    }`;
  })
);

export const logger = winston.createLogger({
  level: config.logging.level,
  format: logFormat,
  defaultMeta: { service: "clova-invoice-scanner" },
  transports: [
    // Console transport
    new winston.transports.Console({
      format: consoleFormat,
    }),

    // File transport for errors
    new winston.transports.File({
      filename: "logs/error.log",
      level: "error",
      maxsize: 5242880, // 5MB
      maxFiles: 5,
    }),

    // File transport for all logs
    new winston.transports.File({
      filename: "logs/combined.log",
      maxsize: 5242880, // 5MB
      maxFiles: 5,
    }),
  ],
});

// Create a stream object for Morgan
export const stream = {
  write: (message: string) => {
    logger.info(message.trim());
  },
};

// Handle uncaught exceptions
logger.exceptions.handle(
  new winston.transports.File({ filename: "logs/exceptions.log" })
);

// Handle unhandled promise rejections
logger.rejections.handle(
  new winston.transports.File({ filename: "logs/rejections.log" })
);

export default logger;
