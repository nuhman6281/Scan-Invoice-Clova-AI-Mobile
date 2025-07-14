import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const shops = await prisma.shop.findMany({
    where: {
      name: { in: ["Smart Mart", "Budget Bazaar", "Value Store"] },
    },
    include: { products: true },
  });

  for (const shop of shops) {
    console.log(`\nShop: ${shop.name} (${shop.address})`);
    for (const product of shop.products) {
      console.log(`  - Product: ${product.name} | Price: ${product.price}`);
    }
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
