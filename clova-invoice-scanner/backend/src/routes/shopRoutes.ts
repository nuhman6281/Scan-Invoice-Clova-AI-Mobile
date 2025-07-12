import { Router, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import { logger } from "../utils/logger";

const router = Router();
const prisma = new PrismaClient();

// Get all shops
router.get("/", async (req: Request, res: Response) => {
  try {
    const { category, isPremium, search } = req.query;

    const where: any = {};

    if (category) {
      where.category = category;
    }

    if (isPremium !== undefined) {
      where.isPremium = isPremium === "true";
    }

    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: "insensitive" } },
        { address: { contains: search as string, mode: "insensitive" } },
        { description: { contains: search as string, mode: "insensitive" } },
      ];
    }

    const shops = await prisma.shop.findMany({
      where,
      orderBy: {
        createdAt: "desc",
      },
    });

    res.json({
      success: true,
      data: shops,
    });
  } catch (error) {
    logger.error("Shops error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Get shop by ID
router.get("/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Shop ID is required",
      });
    }

    const shop = await prisma.shop.findUnique({
      where: { id },
      include: {
        products: true,
      },
    });

    if (!shop) {
      return res.status(404).json({
        success: false,
        message: "Shop not found",
      });
    }

    res.json({
      success: true,
      data: shop,
    });
  } catch (error) {
    logger.error("Shop error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Create new shop
router.post("/", async (req: Request, res: Response) => {
  try {
    const shopData = req.body;

    const shop = await prisma.shop.create({
      data: shopData,
    });

    res.status(201).json({
      success: true,
      data: shop,
    });
  } catch (error) {
    logger.error("Create shop error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Update shop
router.put("/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const shopData = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Shop ID is required",
      });
    }

    const shop = await prisma.shop.update({
      where: { id },
      data: shopData,
    });

    res.json({
      success: true,
      data: shop,
    });
  } catch (error) {
    logger.error("Update shop error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// Delete shop
router.delete("/:id", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Shop ID is required",
      });
    }

    await prisma.shop.delete({
      where: { id },
    });

    res.json({
      success: true,
      message: "Shop deleted successfully",
    });
  } catch (error) {
    logger.error("Delete shop error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

export { router as shopRoutes };
