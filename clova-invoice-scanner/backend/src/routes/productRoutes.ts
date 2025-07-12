import { Router, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import { logger } from "../utils/logger";

const router = Router();
const prisma = new PrismaClient();

// Get all products
router.get("/", async (req: Request, res: Response) => {
  try {
    const { category, brand, shopId, search, isAvailable } = req.query;

    const where: any = {};

    if (category) {
      where.category = category;
    }

    if (brand) {
      where.brand = brand;
    }

    if (shopId) {
      where.shopId = shopId;
    }

    if (isAvailable !== undefined) {
      where.isAvailable = isAvailable === "true";
    }

    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: "insensitive" } },
        { normalizedName: { contains: search as string, mode: "insensitive" } },
        { brand: { contains: search as string, mode: "insensitive" } },
        { description: { contains: search as string, mode: "insensitive" } },
        { keywords: { has: search as string } },
      ];
    }

    const products = await prisma.product.findMany({
      where,
      include: {
        shop: {
          select: {
            id: true,
            name: true,
          },
        },
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    res.json({
      success: true,
      data: products,
    });
  } catch (error) {
    logger.error("Products error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get product by ID
router.get("/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Product ID is required",
      });
    }

    const product = await prisma.product.findUnique({
      where: { id },
      include: {
        shop: true,
      },
    });

    if (!product) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.json({
      success: true,
      data: product,
    });
  } catch (error) {
    logger.error("Product error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get products by shop
router.get("/shop/:shopId", async (req: Request, res: Response) => {
  try {
    const { shopId } = req.params;

    if (!shopId) {
      return res.status(400).json({
        success: false,
        message: "Shop ID is required",
      });
    }

    const products = await prisma.product.findMany({
      where: { shopId },
      include: {
        shop: {
          select: {
            id: true,
            name: true,
          },
        },
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    res.json({
      success: true,
      data: products,
    });
  } catch (error) {
    logger.error("Shop products error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Create new product
router.post("/", async (req: Request, res: Response) => {
  try {
    const productData = req.body;

    const product = await prisma.product.create({
      data: productData,
      include: {
        shop: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });

    res.status(201).json({
      success: true,
      data: product,
    });
  } catch (error) {
    logger.error("Create product error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Update product
router.put("/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const productData = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Product ID is required",
      });
    }

    const product = await prisma.product.update({
      where: { id },
      data: productData,
      include: {
        shop: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });

    res.json({
      success: true,
      data: product,
    });
  } catch (error) {
    logger.error("Update product error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Delete product
router.delete("/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Product ID is required",
      });
    }

    await prisma.product.delete({
      where: { id },
    });

    res.json({
      success: true,
      message: "Product deleted successfully",
    });
  } catch (error) {
    logger.error("Delete product error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

export { router as productRoutes };
