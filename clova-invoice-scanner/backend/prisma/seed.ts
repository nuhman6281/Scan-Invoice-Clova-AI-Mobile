import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Starting database seeding...");

  // Clear existing data
  await prisma.analytics.deleteMany();
  await prisma.scanHistory.deleteMany();
  await prisma.product.deleteMany();
  await prisma.shop.deleteMany();
  await prisma.user.deleteMany();
  await prisma.apiKey.deleteMany();

  console.log("🗑️  Cleared existing data");

  // Create test shops
  const shops = await Promise.all([
    prisma.shop.create({
      data: {
        name: "TechMart Electronics",
        address: "123 Main Street, Downtown, NY 10001",
        latitude: 40.7589,
        longitude: -73.9851,
        phone: "+1-555-0101",
        rating: 4.5,
        isPremium: true,
        category: "Electronics",
        imageUrl: "https://example.com/techmart.jpg",
        description:
          "Premium electronics store with the latest gadgets and accessories",
        openingHours: "Mon-Fri: 9AM-9PM, Sat-Sun: 10AM-8PM",
      },
    }),
    prisma.shop.create({
      data: {
        name: "Budget Electronics",
        address: "456 Oak Avenue, Midtown, NY 10002",
        latitude: 40.7505,
        longitude: -73.9934,
        phone: "+1-555-0102",
        rating: 3.8,
        isPremium: false,
        category: "Electronics",
        imageUrl: "https://example.com/budget.jpg",
        description: "Affordable electronics and accessories",
        openingHours: "Mon-Sat: 10AM-8PM, Sun: 11AM-6PM",
      },
    }),
    prisma.shop.create({
      data: {
        name: "Grocery Plus",
        address: "789 Pine Street, Uptown, NY 10003",
        latitude: 40.7648,
        longitude: -73.9808,
        phone: "+1-555-0103",
        rating: 4.2,
        isPremium: false,
        category: "Grocery",
        imageUrl: "https://example.com/grocery.jpg",
        description: "Fresh groceries and household items",
        openingHours: "Daily: 7AM-11PM",
      },
    }),
    prisma.shop.create({
      data: {
        name: "Premium Grocery",
        address: "321 Elm Street, Upper East Side, NY 10004",
        latitude: 40.7736,
        longitude: -73.9712,
        phone: "+1-555-0104",
        rating: 4.7,
        isPremium: true,
        category: "Grocery",
        imageUrl: "https://example.com/premium-grocery.jpg",
        description:
          "High-end grocery store with organic and imported products",
        openingHours: "Mon-Sat: 8AM-10PM, Sun: 9AM-9PM",
      },
    }),
    prisma.shop.create({
      data: {
        name: "Fashion Outlet",
        address: "654 Maple Drive, Fashion District, NY 10005",
        latitude: 40.7568,
        longitude: -73.9945,
        phone: "+1-555-0105",
        rating: 4.0,
        isPremium: false,
        category: "Fashion",
        imageUrl: "https://example.com/fashion.jpg",
        description: "Trendy fashion items at outlet prices",
        openingHours: "Mon-Sat: 10AM-9PM, Sun: 12PM-6PM",
      },
    }),
  ]);

  console.log("🏪 Created shops:", shops.length);

  // Create test products
  const products = await Promise.all([
    // Electronics - iPhone
    prisma.product.create({
      data: {
        shopId: shops[0].id, // TechMart
        name: "iPhone 15 Pro",
        normalizedName: "iphone 15 pro",
        category: "Smartphones",
        price: 999.99,
        imageUrl: "https://example.com/iphone15pro.jpg",
        brand: "Apple",
        description: "Latest iPhone with advanced camera system",
        keywords: [
          "iphone",
          "smartphone",
          "apple",
          "mobile",
          "phone",
          "camera",
        ],
        isAvailable: true,
        stockQuantity: 25,
        barcode: "1234567890123",
        weight: 187.0,
        unit: "g",
      },
    }),
    prisma.product.create({
      data: {
        shopId: shops[1].id, // Budget Electronics
        name: "iPhone 15 Pro",
        normalizedName: "iphone 15 pro",
        category: "Smartphones",
        price: 949.99,
        imageUrl: "https://example.com/iphone15pro-budget.jpg",
        brand: "Apple",
        description: "iPhone 15 Pro at competitive price",
        keywords: [
          "iphone",
          "smartphone",
          "apple",
          "mobile",
          "phone",
          "camera",
        ],
        isAvailable: true,
        stockQuantity: 15,
        barcode: "1234567890123",
        weight: 187.0,
        unit: "g",
      },
    }),
    // Electronics - MacBook
    prisma.product.create({
      data: {
        shopId: shops[0].id, // TechMart
        name: 'MacBook Pro 14"',
        normalizedName: "macbook pro 14",
        category: "Laptops",
        price: 1999.99,
        imageUrl: "https://example.com/macbook-pro.jpg",
        brand: "Apple",
        description: "Professional laptop for developers and creatives",
        keywords: [
          "macbook",
          "laptop",
          "apple",
          "computer",
          "pro",
          "development",
        ],
        isAvailable: true,
        stockQuantity: 10,
        barcode: "9876543210987",
        weight: 1600.0,
        unit: "g",
      },
    }),
    prisma.product.create({
      data: {
        shopId: shops[1].id, // Budget Electronics
        name: 'MacBook Pro 14"',
        normalizedName: "macbook pro 14",
        category: "Laptops",
        price: 1899.99,
        imageUrl: "https://example.com/macbook-pro-budget.jpg",
        brand: "Apple",
        description: "MacBook Pro at a better price",
        keywords: [
          "macbook",
          "laptop",
          "apple",
          "computer",
          "pro",
          "development",
        ],
        isAvailable: true,
        stockQuantity: 8,
        barcode: "9876543210987",
        weight: 1600.0,
        unit: "g",
      },
    }),
    // Grocery - Coffee
    prisma.product.create({
      data: {
        shopId: shops[2].id, // Grocery Plus
        name: "Starbucks Coffee Beans",
        normalizedName: "starbucks coffee beans",
        category: "Coffee",
        price: 12.99,
        imageUrl: "https://example.com/starbucks-coffee.jpg",
        brand: "Starbucks",
        description: "Premium coffee beans for home brewing",
        keywords: ["coffee", "beans", "starbucks", "brew", "caffeine"],
        isAvailable: true,
        stockQuantity: 50,
        barcode: "4567891234567",
        weight: 454.0,
        unit: "g",
      },
    }),
    prisma.product.create({
      data: {
        shopId: shops[3].id, // Premium Grocery
        name: "Starbucks Coffee Beans",
        normalizedName: "starbucks coffee beans",
        category: "Coffee",
        price: 14.99,
        imageUrl: "https://example.com/starbucks-coffee-premium.jpg",
        brand: "Starbucks",
        description: "Premium coffee beans with organic certification",
        keywords: [
          "coffee",
          "beans",
          "starbucks",
          "brew",
          "caffeine",
          "organic",
        ],
        isAvailable: true,
        stockQuantity: 30,
        barcode: "4567891234567",
        weight: 454.0,
        unit: "g",
      },
    }),
    // Grocery - Milk
    prisma.product.create({
      data: {
        shopId: shops[2].id, // Grocery Plus
        name: "Organic Whole Milk",
        normalizedName: "organic whole milk",
        category: "Dairy",
        price: 4.99,
        imageUrl: "https://example.com/organic-milk.jpg",
        brand: "Organic Valley",
        description: "Fresh organic whole milk",
        keywords: ["milk", "organic", "dairy", "whole", "fresh"],
        isAvailable: true,
        stockQuantity: 100,
        barcode: "7891234567890",
        weight: 946.0,
        unit: "ml",
      },
    }),
    prisma.product.create({
      data: {
        shopId: shops[3].id, // Premium Grocery
        name: "Organic Whole Milk",
        normalizedName: "organic whole milk",
        category: "Dairy",
        price: 5.99,
        imageUrl: "https://example.com/organic-milk-premium.jpg",
        brand: "Organic Valley",
        description: "Premium organic whole milk from grass-fed cows",
        keywords: ["milk", "organic", "dairy", "whole", "fresh", "grass-fed"],
        isAvailable: true,
        stockQuantity: 75,
        barcode: "7891234567890",
        weight: 946.0,
        unit: "ml",
      },
    }),
    // Fashion - Shoes
    prisma.product.create({
      data: {
        shopId: shops[4].id, // Fashion Outlet
        name: "Nike Air Max 270",
        normalizedName: "nike air max 270",
        category: "Shoes",
        price: 129.99,
        imageUrl: "https://example.com/nike-airmax.jpg",
        brand: "Nike",
        description: "Comfortable running shoes with Air Max technology",
        keywords: [
          "nike",
          "shoes",
          "running",
          "air max",
          "sneakers",
          "athletic",
        ],
        isAvailable: true,
        stockQuantity: 40,
        barcode: "3216549873210",
        weight: 300.0,
        unit: "g",
      },
    }),
  ]);

  console.log("📦 Created products:", products.length);

  // Create test users
  const users = await Promise.all([
    prisma.user.create({
      data: {
        email: "test@example.com",
        password: await bcrypt.hash("test123", 12),
        name: "Test User",
        phone: "+1-555-0001",
        isActive: true,
        isAdmin: false,
      },
    }),
    prisma.user.create({
      data: {
        email: "admin@example.com",
        password: await bcrypt.hash("admin123", 12),
        name: "Admin User",
        phone: "+1-555-0002",
        isActive: true,
        isAdmin: true,
      },
    }),
  ]);

  console.log("👥 Created users:", users.length);

  // Create test scan history
  const scanHistory = await Promise.all([
    prisma.scanHistory.create({
      data: {
        imagePath: "/uploads/invoice_001.jpg",
        scanResult: {
          invoice_number: "INV-2024-001",
          total_amount: 125.5,
          currency: "USD",
          merchant: "TechMart Electronics",
          items: [
            { name: "iPhone 15 Pro", price: 999.99, quantity: 1 },
            { name: 'MacBook Pro 14"', price: 1999.99, quantity: 1 },
          ],
        },
        itemsFound: 2,
        alternativesFound: 3,
        potentialSavings: 150.0,
        confidenceScore: 0.95,
        processingTime: 2500,
        userLatitude: 40.7589,
        userLongitude: -73.9851,
        userId: users[0].id,
        deviceInfo: {
          device: "iPhone 16 Pro Max",
          os: "iOS 18.0",
          app_version: "1.0.0",
        },
      },
    }),
    prisma.scanHistory.create({
      data: {
        imagePath: "/uploads/invoice_002.jpg",
        scanResult: {
          invoice_number: "INV-2024-002",
          total_amount: 45.98,
          currency: "USD",
          merchant: "Grocery Plus",
          items: [
            { name: "Starbucks Coffee Beans", price: 12.99, quantity: 2 },
            { name: "Organic Whole Milk", price: 4.99, quantity: 4 },
          ],
        },
        itemsFound: 2,
        alternativesFound: 2,
        potentialSavings: 8.0,
        confidenceScore: 0.88,
        processingTime: 1800,
        userLatitude: 40.7505,
        userLongitude: -73.9934,
        userId: users[0].id,
        deviceInfo: {
          device: "iPhone 16 Pro Max",
          os: "iOS 18.0",
          app_version: "1.0.0",
        },
      },
    }),
  ]);

  console.log("📊 Created scan history:", scanHistory.length);

  // Create test analytics
  const analytics = await Promise.all([
    prisma.analytics.create({
      data: {
        date: new Date("2024-01-15"),
        totalScans: 150,
        successfulScans: 142,
        totalSavings: 1250.75,
        avgProcessingTime: 2200,
        uniqueUsers: 45,
        popularItems: [
          "iPhone 15 Pro",
          'MacBook Pro 14"',
          "Starbucks Coffee Beans",
        ],
        errorRate: 0.053,
      },
    }),
    prisma.analytics.create({
      data: {
        date: new Date("2024-01-16"),
        totalScans: 180,
        successfulScans: 171,
        totalSavings: 1580.25,
        avgProcessingTime: 2100,
        uniqueUsers: 52,
        popularItems: [
          "iPhone 15 Pro",
          "Organic Whole Milk",
          "Nike Air Max 270",
        ],
        errorRate: 0.05,
      },
    }),
  ]);

  console.log("📈 Created analytics:", analytics.length);

  // Create test API key
  await prisma.apiKey.create({
    data: {
      name: "Test API Key",
      key: "test_api_key_123456789",
      isActive: true,
      permissions: ["scan", "read", "analytics"],
      expiresAt: new Date("2025-12-31"),
    },
  });

  console.log("🔑 Created API key");

  console.log("✅ Database seeding completed successfully!");
  console.log("\n📋 Summary:");
  console.log(`- Shops: ${shops.length}`);
  console.log(`- Products: ${products.length}`);
  console.log(`- Users: ${users.length}`);
  console.log(`- Scan History: ${scanHistory.length}`);
  console.log(`- Analytics: ${analytics.length}`);
  console.log(`- API Keys: 1`);

  console.log("\n🧪 Test Data Available:");
  console.log("- Test User: test@example.com");
  console.log("- Admin User: admin@example.com");
  console.log(
    "- Sample products: iPhone 15 Pro, MacBook Pro, Coffee, Milk, Nike Shoes"
  );
  console.log("- Sample scan history with realistic data");
  console.log("- Analytics data for testing reports");
}

main()
  .catch((e) => {
    console.error("❌ Error during seeding:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
