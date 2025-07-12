import { Router, Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt, { Secret, SignOptions } from "jsonwebtoken";
import { PrismaClient } from "@prisma/client";
import { logger } from "../utils/logger";
import { config } from "../config";

const router = Router();
const prisma = new PrismaClient();

// Login endpoint
router.post("/login", async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email and password are required",
      });
    }

    // Find user by email
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    // Check if user is active
    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        message: "Account is deactivated",
      });
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    // Generate JWT token
    const jwtSecret: Secret = config.jwt.secret;
    const jwtOptions: SignOptions = { expiresIn: config.jwt.expiresIn as any };
    const token = jwt.sign(
      {
        userId: user.id,
        email: user.email,
        isAdmin: user.isAdmin,
      },
      jwtSecret,
      jwtOptions
    );

    // Return user data (without password) and token
    const { password: _, ...userWithoutPassword } = user;

    res.json({
      success: true,
      message: "Login successful",
      data: {
        user: userWithoutPassword,
        token,
      },
    });
  } catch (error) {
    logger.error("Login error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Register endpoint
router.post("/register", async (req: Request, res: Response) => {
  try {
    const { email, password, name, phone } = req.body;

    // Validate input
    if (!email || !password || !name) {
      return res.status(400).json({
        success: false,
        message: "Email, password, and name are required",
      });
    }

    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: "User with this email already exists",
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user = await prisma.user.create({
      data: {
        email: email.toLowerCase(),
        password: hashedPassword,
        name,
        phone: phone || null,
        isActive: true,
        isAdmin: false,
      },
    });

    // Generate JWT token
    const jwtSecret2: Secret = config.jwt.secret;
    const jwtOptions2: SignOptions = { expiresIn: config.jwt.expiresIn as any };
    const token = jwt.sign(
      {
        userId: user.id,
        email: user.email,
        isAdmin: user.isAdmin,
      },
      jwtSecret2,
      jwtOptions2
    );

    // Return user data (without password) and token
    const { password: _, ...userWithoutPassword } = user;

    res.status(201).json({
      success: true,
      message: "User registered successfully",
      data: {
        user: userWithoutPassword,
        token,
      },
    });
  } catch (error) {
    logger.error("Register error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get current user endpoint
router.get("/me", async (req: Request, res: Response) => {
  try {
    const token = req.headers.authorization?.replace("Bearer ", "");

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "No token provided",
      });
    }

    // Verify token
    const decoded = jwt.verify(token, config.jwt.secret) as any;
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid token",
      });
    }

    // Return user data (without password)
    const { password: _, ...userWithoutPassword } = user;

    res.json({
      success: true,
      data: {
        user: userWithoutPassword,
      },
    });
  } catch (error) {
    logger.error("Get user error:", error);
    res.status(401).json({
      success: false,
      message: "Invalid token",
    });
  }
});

// Logout endpoint (client-side token removal)
router.post("/logout", async (req: Request, res: Response) => {
  try {
    // In a stateless JWT setup, logout is handled client-side
    // by removing the token from storage
    res.json({
      success: true,
      message: "Logout successful",
    });
  } catch (error) {
    logger.error("Logout error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

export { router as authRoutes };
