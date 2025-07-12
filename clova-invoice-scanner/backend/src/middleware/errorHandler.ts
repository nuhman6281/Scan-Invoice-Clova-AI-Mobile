import { Request, Response, NextFunction } from "express";
import { logger } from "../utils/logger";

export interface AppError extends Error {
  statusCode?: number;
  isOperational?: boolean;
}

export const errorHandler = (
  error: AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const statusCode = error.statusCode || 500;
  const message = error.message || "Internal Server Error";

  // Log error
  logger.error(`Error ${statusCode}: ${message}`, {
    error: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get("User-Agent"),
  });

  // Don't leak error details in production
  const errorResponse = {
    success: false,
    message: statusCode === 500 ? "Internal Server Error" : message,
    ...(process.env.NODE_ENV === "development" && { stack: error.stack }),
  };

  res.status(statusCode).json(errorResponse);
};
