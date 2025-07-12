import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { createServer } from 'http';
import { Server } from 'socket.io';

// Import configurations
import { config } from './config';
import { logger } from './utils/logger';
import { errorHandler } from './middleware/errorHandler';
import { requestLogger } from './middleware/requestLogger';
import { validateEnv } from './utils/validateEnv';

// Import routes
import { scanRoutes } from './routes/scanRoutes';
import { shopRoutes } from './routes/shopRoutes';
import { productRoutes } from './routes/productRoutes';
import { authRoutes } from './routes/authRoutes';
import { analyticsRoutes } from './routes/analyticsRoutes';
import { healthRoutes } from './routes/healthRoutes';

// Import services
import { DatabaseService } from './services/DatabaseService';
import { RedisService } from './services/RedisService';
import { ClovaService } from './services/ClovaService';

// Load environment variables
dotenv.config();

// Validate environment variables
validateEnv();

class App {
  public app: express.Application;
  public server: any;
  public io: Server;

  constructor() {
    this.app = express();
    this.server = createServer(this.app);
    this.io = new Server(this.server, {
      cors: {
        origin: config.cors.allowedOrigins,
        methods: ['GET', 'POST']
      }
    });

    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeErrorHandling();
    this.initializeServices();
  }

  private initializeMiddlewares(): void {
    // Security middleware
    this.app.use(helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          scriptSrc: ["'self'"],
          imgSrc: ["'self'", "data:", "https:"],
        },
      },
    }));

    // CORS configuration
    this.app.use(cors({
      origin: config.cors.allowedOrigins,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
    }));

    // Compression
    this.app.use(compression());

    // Rate limiting
    const limiter = rateLimit({
      windowMs: config.rateLimit.windowMs,
      max: config.rateLimit.maxRequests,
      message: {
        error: 'Too many requests from this IP, please try again later.',
        retryAfter: Math.ceil(config.rateLimit.windowMs / 1000)
      },
      standardHeaders: true,
      legacyHeaders: false,
    });
    this.app.use('/api/', limiter);

    // Body parsing
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));

    // Request logging
    this.app.use(requestLogger);

    // Static files
    this.app.use('/uploads', express.static(config.upload.dir));
  }

  private initializeRoutes(): void {
    // Health check route
    this.app.use('/health', healthRoutes);

    // API routes
    this.app.use('/api/scan', scanRoutes);
    this.app.use('/api/shops', shopRoutes);
    this.app.use('/api/products', productRoutes);
    this.app.use('/api/auth', authRoutes);
    this.app.use('/api/analytics', analyticsRoutes);

    // API documentation
    this.app.use('/api-docs', (req, res) => {
      res.redirect('/api-docs/index.html');
    });

    // 404 handler
    this.app.use('*', (req, res) => {
      res.status(404).json({
        success: false,
        message: 'Route not found',
        path: req.originalUrl
      });
    });
  }

  private initializeErrorHandling(): void {
    this.app.use(errorHandler);
  }

  private async initializeServices(): Promise<void> {
    try {
      // Initialize database
      await DatabaseService.initialize();
      logger.info('Database connected successfully');

      // Initialize Redis
      await RedisService.initialize();
      logger.info('Redis connected successfully');

      // Initialize CLOVA service connection
      await ClovaService.initialize();
      logger.info('CLOVA service connected successfully');

    } catch (error) {
      logger.error('Failed to initialize services:', error);
      process.exit(1);
    }
  }

  public async start(): Promise<void> {
    try {
      const port = config.server.port;
      
      this.server.listen(port, () => {
        logger.info(`🚀 Server running on port ${port}`);
        logger.info(`📚 API Documentation: http://localhost:${port}/api-docs`);
        logger.info(`🏥 Health Check: http://localhost:${port}/health`);
        logger.info(`🌍 Environment: ${config.env}`);
      });

      // Graceful shutdown
      process.on('SIGTERM', () => {
        logger.info('SIGTERM received, shutting down gracefully');
        this.shutdown();
      });

      process.on('SIGINT', () => {
        logger.info('SIGINT received, shutting down gracefully');
        this.shutdown();
      });

    } catch (error) {
      logger.error('Failed to start server:', error);
      process.exit(1);
    }
  }

  private async shutdown(): Promise<void> {
    try {
      logger.info('Shutting down server...');
      
      // Close database connections
      await DatabaseService.disconnect();
      logger.info('Database connections closed');

      // Close Redis connections
      await RedisService.disconnect();
      logger.info('Redis connections closed');

      // Close server
      this.server.close(() => {
        logger.info('Server closed');
        process.exit(0);
      });

    } catch (error) {
      logger.error('Error during shutdown:', error);
      process.exit(1);
    }
  }
}

// Start the application
const app = new App();
app.start().catch((error) => {
  logger.error('Failed to start application:', error);
  process.exit(1);
});

export default app; 