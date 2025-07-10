import { PrismaClient } from '@prisma/client';
import { Decimal } from '@prisma/client/runtime/library';

const prisma = new PrismaClient();

const sampleShops = [
  // Seoul Area - Cafes and Coffee Shops
  {
    name: "Seoul Premium Coffee",
    address: "123 Gangnam-gu, Seoul, South Korea",
    latitude: new Decimal(37.5665),
    longitude: new Decimal(126.9780),
    category: "Cafe",
    isPremium: true,
    rating: new Decimal(4.5),
    phone: "+82-2-1234-5678",
    imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400"
  },
  {
    name: "Busan Fresh Market",
    address: "456 Haeundae-gu, Busan, South Korea",
    latitude: new Decimal(35.1595),
    longitude: new Decimal(129.1605),
    category: "Grocery Store",
    isPremium: false,
    rating: new Decimal(4.2),
    phone: "+82-51-2345-6789",
    imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
  },
  {
    name: "Incheon Electronics Hub",
    address: "789 Yeonsu-gu, Incheon, South Korea",
    latitude: new Decimal(37.4138),
    longitude: new Decimal(126.6764),
    category: "Electronics Store",
    isPremium: true,
    rating: new Decimal(4.7),
    phone: "+82-32-3456-7890",
    imageUrl: "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400"
  },
  {
    name: "Daegu Fashion Center",
    address: "321 Jung-gu, Daegu, South Korea",
    latitude: new Decimal(35.8714),
    longitude: new Decimal(128.6014),
    category: "Fashion Store",
    isPremium: true,
    rating: new Decimal(4.3),
    phone: "+82-53-4567-8901",
    imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400"
  },
  {
    name: "Daejeon Tech Mart",
    address: "654 Yuseong-gu, Daejeon, South Korea",
    latitude: new Decimal(36.3504),
    longitude: new Decimal(127.3845),
    category: "Electronics Store",
    isPremium: false,
    rating: new Decimal(4.1),
    phone: "+82-42-5678-9012",
    imageUrl: "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400"
  },
  {
    name: "Gwangju Artisan Bakery",
    address: "987 Seo-gu, Gwangju, South Korea",
    latitude: new Decimal(35.1595),
    longitude: new Decimal(126.8526),
    category: "Bakery",
    isPremium: true,
    rating: new Decimal(4.6),
    phone: "+82-62-6789-0123",
    imageUrl: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400"
  },
  {
    name: "Suwon Traditional Market",
    address: "147 Paldal-gu, Suwon, South Korea",
    latitude: new Decimal(37.2636),
    longitude: new Decimal(127.0286),
    category: "Grocery Store",
    isPremium: false,
    rating: new Decimal(4.0),
    phone: "+82-31-7890-1234",
    imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
  },
  {
    name: "Ulsan Industrial Supply",
    address: "258 Nam-gu, Ulsan, South Korea",
    latitude: new Decimal(35.5384),
    longitude: new Decimal(129.3114),
    category: "Hardware Store",
    isPremium: false,
    rating: new Decimal(3.9),
    phone: "+82-52-8901-2345",
    imageUrl: "https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=400"
  },
  {
    name: "Jeju Island Coffee",
    address: "369 Jeju-si, Jeju, South Korea",
    latitude: new Decimal(33.4996),
    longitude: new Decimal(126.5312),
    category: "Cafe",
    isPremium: true,
    rating: new Decimal(4.8),
    phone: "+82-64-9012-3456",
    imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400"
  },
  {
    name: "Changwon Sports Center",
    address: "741 Masanhoewon-gu, Changwon, South Korea",
    latitude: new Decimal(35.2278),
    longitude: new Decimal(128.6817),
    category: "Sports Store",
    isPremium: false,
    rating: new Decimal(4.2),
    phone: "+82-55-0123-4567",
    imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400"
  },
  {
    name: "Seongnam Bookstore",
    address: "852 Bundang-gu, Seongnam, South Korea",
    latitude: new Decimal(37.3504),
    longitude: new Decimal(127.1085),
    category: "Bookstore",
    isPremium: true,
    rating: new Decimal(4.4),
    phone: "+82-31-1234-5678",
    imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"
  },
  {
    name: "Bucheon Pet Shop",
    address: "963 Wonmi-gu, Bucheon, South Korea",
    latitude: new Decimal(37.5035),
    longitude: new Decimal(126.7660),
    category: "Pet Store",
    isPremium: false,
    rating: new Decimal(4.1),
    phone: "+82-32-2345-6789",
    imageUrl: "https://images.unsplash.com/photo-1450778869180-41d0601e046e?w=400"
  },
  {
    name: "Ansan Multicultural Market",
    address: "159 Sangrok-gu, Ansan, South Korea",
    latitude: new Decimal(37.3219),
    longitude: new Decimal(126.8309),
    category: "Grocery Store",
    isPremium: false,
    rating: new Decimal(4.0),
    phone: "+82-31-3456-7890",
    imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
  },
  {
    name: "Anyang Tech Store",
    address: "357 Dongan-gu, Anyang, South Korea",
    latitude: new Decimal(37.3943),
    longitude: new Decimal(126.9569),
    category: "Electronics Store",
    isPremium: true,
    rating: new Decimal(4.3),
    phone: "+82-31-4567-8901",
    imageUrl: "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400"
  },
  {
    name: "Pohang Steel Mart",
    address: "486 Nam-gu, Pohang, South Korea",
    latitude: new Decimal(36.0320),
    longitude: new Decimal(129.3650),
    category: "Hardware Store",
    isPremium: false,
    rating: new Decimal(3.8),
    phone: "+82-54-5678-9012",
    imageUrl: "https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=400"
  },
  {
    name: "Jeonju Hanok Village Shop",
    address: "753 Wansan-gu, Jeonju, South Korea",
    latitude: new Decimal(35.8242),
    longitude: new Decimal(127.1480),
    category: "Traditional Store",
    isPremium: true,
    rating: new Decimal(4.7),
    phone: "+82-63-6789-0123",
    imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400"
  },
  {
    name: "Cheongju University Bookstore",
    address: "951 Heungdeok-gu, Cheongju, South Korea",
    latitude: new Decimal(36.6424),
    longitude: new Decimal(127.4890),
    category: "Bookstore",
    isPremium: false,
    rating: new Decimal(4.2),
    phone: "+82-43-7890-1234",
    imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"
  },
  {
    name: "Jinju Castle Market",
    address: "147 Jinju-si, Jinju, South Korea",
    latitude: new Decimal(35.1927),
    longitude: new Decimal(128.0847),
    category: "Grocery Store",
    isPremium: false,
    rating: new Decimal(4.1),
    phone: "+82-55-8901-2345",
    imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
  },
  {
    name: "Mokpo Harbor Fish Market",
    address: "258 Mokpo-si, Mokpo, South Korea",
    latitude: new Decimal(34.7936),
    longitude: new Decimal(126.3888),
    category: "Fish Market",
    isPremium: false,
    rating: new Decimal(4.3),
    phone: "+82-61-9012-3456",
    imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
  },
  {
    name: "Gunsan Industrial Electronics",
    address: "369 Gunsan-si, Gunsan, South Korea",
    latitude: new Decimal(35.9675),
    longitude: new Decimal(126.7368),
    category: "Electronics Store",
    isPremium: true,
    rating: new Decimal(4.4),
    phone: "+82-63-0123-4567",
    imageUrl: "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400"
  },
  {
    name: "Yeosu Ocean View Cafe",
    address: "741 Yeosu-si, Yeosu, South Korea",
    latitude: new Decimal(34.7604),
    longitude: new Decimal(127.6622),
    category: "Cafe",
    isPremium: true,
    rating: new Decimal(4.6),
    phone: "+82-61-1234-5678",
    imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400"
  },
  {
    name: "Gangneung Beach Sports",
    address: "852 Gangneung-si, Gangneung, South Korea",
    latitude: new Decimal(37.7519),
    longitude: new Decimal(128.8760),
    category: "Sports Store",
    isPremium: false,
    rating: new Decimal(4.2),
    phone: "+82-33-2345-6789",
    imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400"
  },
  {
    name: "Tongyeong Marine Supply",
    address: "963 Tongyeong-si, Tongyeong, South Korea",
    latitude: new Decimal(34.8454),
    longitude: new Decimal(128.4234),
    category: "Marine Store",
    isPremium: false,
    rating: new Decimal(4.0),
    phone: "+82-55-3456-7890",
    imageUrl: "https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=400"
  },
  {
    name: "Gongju Historical Market",
    address: "159 Gongju-si, Gongju, South Korea",
    latitude: new Decimal(36.4550),
    longitude: new Decimal(127.1247),
    category: "Traditional Store",
    isPremium: true,
    rating: new Decimal(4.5),
    phone: "+82-41-4567-8901",
    imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400"
  },
  {
    name: "Nonsan Agricultural Market",
    address: "357 Nonsan-si, Nonsan, South Korea",
    latitude: new Decimal(36.2034),
    longitude: new Decimal(127.0847),
    category: "Grocery Store",
    isPremium: false,
    rating: new Decimal(4.1),
    phone: "+82-41-5678-9012",
    imageUrl: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400"
  },
  {
    name: "Jeongeup Traditional Market",
    address: "486 Jeongeup-si, Jeongeup, South Korea",
    latitude: new Decimal(35.5699),
    longitude: new Decimal(126.8560),
    category: "Traditional Store",
    isPremium: false,
    rating: new Decimal(4.0),
    phone: "+82-63-6789-0123",
    imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400"
  }
];

const sampleProducts = [
  // Beverages
  {
    name: "Americano",
    normalizedName: "americano",
    category: "Beverages",
    price: new Decimal(4500),
    brand: "House Blend",
    keywords: ["coffee", "americano", "hot", "caffeine", "espresso"],
    imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300"
  },
  {
    name: "Cappuccino",
    normalizedName: "cappuccino",
    category: "Beverages",
    price: new Decimal(5000),
    brand: "Premium",
    keywords: ["coffee", "cappuccino", "milk", "foam", "italian"],
    imageUrl: "https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=300"
  },
  {
    name: "Green Tea Latte",
    normalizedName: "green tea latte",
    category: "Beverages",
    price: new Decimal(4800),
    brand: "Organic",
    keywords: ["tea", "green tea", "latte", "milk", "matcha"],
    imageUrl: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=300"
  },
  {
    name: "Hot Chocolate",
    normalizedName: "hot chocolate",
    category: "Beverages",
    price: new Decimal(5200),
    brand: "Belgian",
    keywords: ["chocolate", "hot", "sweet", "warm", "cocoa"],
    imageUrl: "https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=300"
  },
  {
    name: "Iced Coffee",
    normalizedName: "iced coffee",
    category: "Beverages",
    price: new Decimal(4700),
    brand: "Cold Brew",
    keywords: ["coffee", "iced", "cold", "refreshing", "summer"],
    imageUrl: "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=300"
  },
  {
    name: "Orange Juice",
    normalizedName: "orange juice",
    category: "Beverages",
    price: new Decimal(3500),
    brand: "Fresh Daily",
    keywords: ["juice", "orange", "vitamin c", "fresh", "healthy"],
    imageUrl: "https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300"
  },
  {
    name: "Smoothie",
    normalizedName: "smoothie",
    category: "Beverages",
    price: new Decimal(6500),
    brand: "Fruit Blend",
    keywords: ["smoothie", "fruit", "healthy", "blended", "vitamins"],
    imageUrl: "https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=300"
  },
  {
    name: "Bubble Tea",
    normalizedName: "bubble tea",
    category: "Beverages",
    price: new Decimal(5500),
    brand: "Tapioca",
    keywords: ["bubble tea", "tapioca", "sweet", "taiwanese", "pearls"],
    imageUrl: "https://images.unsplash.com/photo-1558857563-b371033873b8?w=300"
  },

  // Food Items
  {
    name: "Chicken Sandwich",
    normalizedName: "chicken sandwich",
    category: "Food",
    price: new Decimal(8500),
    brand: "Fresh Daily",
    keywords: ["sandwich", "chicken", "lunch", "bread", "protein"],
    imageUrl: "https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=300"
  },
  {
    name: "Caesar Salad",
    normalizedName: "caesar salad",
    category: "Food",
    price: new Decimal(12000),
    brand: "Garden Fresh",
    keywords: ["salad", "caesar", "lettuce", "healthy", "vegetables"],
    imageUrl: "https://images.unsplash.com/photo-1546793665-c74683f339c1?w=300"
  },
  {
    name: "Pizza Margherita",
    normalizedName: "pizza margherita",
    category: "Food",
    price: new Decimal(18000),
    brand: "Italian Style",
    keywords: ["pizza", "margherita", "cheese", "tomato", "italian"],
    imageUrl: "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=300"
  },
  {
    name: "Beef Burger",
    normalizedName: "beef burger",
    category: "Food",
    price: new Decimal(15000),
    brand: "Gourmet",
    keywords: ["burger", "beef", "patty", "bun", "fast food"],
    imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300"
  },
  {
    name: "Pasta Carbonara",
    normalizedName: "pasta carbonara",
    category: "Food",
    price: new Decimal(16000),
    brand: "Authentic",
    keywords: ["pasta", "carbonara", "cream", "bacon", "italian"],
    imageUrl: "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=300"
  },
  {
    name: "Sushi Roll",
    normalizedName: "sushi roll",
    category: "Food",
    price: new Decimal(22000),
    brand: "Fresh Fish",
    keywords: ["sushi", "roll", "fish", "rice", "japanese"],
    imageUrl: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300"
  },
  {
    name: "Kimchi Fried Rice",
    normalizedName: "kimchi fried rice",
    category: "Food",
    price: new Decimal(11000),
    brand: "Traditional",
    keywords: ["kimchi", "fried rice", "korean", "spicy", "rice"],
    imageUrl: "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300"
  },
  {
    name: "Bibimbap",
    normalizedName: "bibimbap",
    category: "Food",
    price: new Decimal(13000),
    brand: "Korean Bowl",
    keywords: ["bibimbap", "rice", "vegetables", "korean", "bowl"],
    imageUrl: "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=300"
  },

  // Electronics
  {
    name: "USB-C Cable",
    normalizedName: "usb c cable",
    category: "Electronics",
    price: new Decimal(15000),
    brand: "TechPro",
    keywords: ["cable", "usb", "charging", "connector", "phone"],
    imageUrl: "https://images.unsplash.com/photo-1601972599720-36938d4ecd31?w=300"
  },
  {
    name: "Wireless Mouse",
    normalizedName: "wireless mouse",
    category: "Electronics",
    price: new Decimal(35000),
    brand: "ComputerMax",
    keywords: ["mouse", "wireless", "computer", "bluetooth", "office"],
    imageUrl: "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=300"
  },
  {
    name: "Bluetooth Headphones",
    normalizedName: "bluetooth headphones",
    category: "Electronics",
    price: new Decimal(120000),
    brand: "AudioTech",
    keywords: ["headphones", "bluetooth", "wireless", "audio", "music"],
    imageUrl: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300"
  },
  {
    name: "Power Bank",
    normalizedName: "power bank",
    category: "Electronics",
    price: new Decimal(45000),
    brand: "ChargeMax",
    keywords: ["power bank", "battery", "charging", "portable", "phone"],
    imageUrl: "https://images.unsplash.com/photo-1609592806596-b43bada2f2a2?w=300"
  },
  {
    name: "Laptop Stand",
    normalizedName: "laptop stand",
    category: "Electronics",
    price: new Decimal(25000),
    brand: "ErgoTech",
    keywords: ["laptop stand", "ergonomic", "desk", "computer", "accessory"],
    imageUrl: "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=300"
  },
  {
    name: "Webcam",
    normalizedName: "webcam",
    category: "Electronics",
    price: new Decimal(80000),
    brand: "VideoPro",
    keywords: ["webcam", "camera", "video", "streaming", "meeting"],
    imageUrl: "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=300"
  },
  {
    name: "Mechanical Keyboard",
    normalizedName: "mechanical keyboard",
    category: "Electronics",
    price: new Decimal(180000),
    brand: "KeyTech",
    keywords: ["keyboard", "mechanical", "gaming", "typing", "computer"],
    imageUrl: "https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=300"
  },
  {
    name: "Gaming Mouse",
    normalizedName: "gaming mouse",
    category: "Electronics",
    price: new Decimal(95000),
    brand: "GameTech",
    keywords: ["mouse", "gaming", "rgb", "computer", "gamer"],
    imageUrl: "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=300"
  },

  // Groceries
  {
    name: "Organic Bananas",
    normalizedName: "organic bananas",
    category: "Groceries",
    price: new Decimal(3500),
    brand: "Fresh Farm",
    keywords: ["bananas", "organic", "fruit", "healthy", "potassium"],
    imageUrl: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300"
  },
  {
    name: "Whole Milk",
    normalizedName: "whole milk",
    category: "Groceries",
    price: new Decimal(2800),
    brand: "Dairy Fresh",
    keywords: ["milk", "dairy", "calcium", "protein", "fresh"],
    imageUrl: "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300"
  },
  {
    name: "Whole Grain Bread",
    normalizedName: "whole grain bread",
    category: "Groceries",
    price: new Decimal(4200),
    brand: "Bakery Fresh",
    keywords: ["bread", "whole grain", "healthy", "fiber", "bakery"],
    imageUrl: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300"
  },
  {
    name: "Free Range Eggs",
    normalizedName: "free range eggs",
    category: "Groceries",
    price: new Decimal(6500),
    brand: "Farm Fresh",
    keywords: ["eggs", "free range", "protein", "organic", "farm"],
    imageUrl: "https://images.unsplash.com/photo-1569288063648-850c6c2a94d5?w=300"
  },
  {
    name: "Organic Spinach",
    normalizedName: "organic spinach",
    category: "Groceries",
    price: new Decimal(3800),
    brand: "Green Farm",
    keywords: ["spinach", "organic", "vegetables", "iron", "healthy"],
    imageUrl: "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300"
  },
  {
    name: "Salmon Fillet",
    normalizedName: "salmon fillet",
    category: "Groceries",
    price: new Decimal(25000),
    brand: "Ocean Fresh",
    keywords: ["salmon", "fish", "protein", "omega 3", "fresh"],
    imageUrl: "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300"
  },
  {
    name: "Greek Yogurt",
    normalizedName: "greek yogurt",
    category: "Groceries",
    price: new Decimal(4500),
    brand: "Dairy Delight",
    keywords: ["yogurt", "greek", "protein", "probiotic", "healthy"],
    imageUrl: "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300"
  },
  {
    name: "Quinoa",
    normalizedName: "quinoa",
    category: "Groceries",
    price: new Decimal(8500),
    brand: "Ancient Grains",
    keywords: ["quinoa", "grain", "protein", "healthy", "superfood"],
    imageUrl: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300"
  },

  // Fashion
  {
    name: "Cotton T-Shirt",
    normalizedName: "cotton t shirt",
    category: "Fashion",
    price: new Decimal(25000),
    brand: "Fashion Brand",
    keywords: ["t-shirt", "cotton", "casual", "clothing", "comfortable"],
    imageUrl: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300"
  },
  {
    name: "Denim Jeans",
    normalizedName: "denim jeans",
    category: "Fashion",
    price: new Decimal(89000),
    brand: "Denim Co",
    keywords: ["jeans", "denim", "pants", "casual", "fashion"],
    imageUrl: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=300"
  },
  {
    name: "Running Shoes",
    normalizedName: "running shoes",
    category: "Fashion",
    price: new Decimal(120000),
    brand: "SportMax",
    keywords: ["shoes", "running", "sports", "comfortable", "athletic"],
    imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300"
  },
  {
    name: "Leather Wallet",
    normalizedName: "leather wallet",
    category: "Fashion",
    price: new Decimal(45000),
    brand: "Leather Craft",
    keywords: ["wallet", "leather", "accessory", "money", "card holder"],
    imageUrl: "https://images.unsplash.com/photo-1627123424574-724758594e93?w=300"
  },
  {
    name: "Sunglasses",
    normalizedName: "sunglasses",
    category: "Fashion",
    price: new Decimal(180000),
    brand: "SunStyle",
    keywords: ["sunglasses", "eyewear", "fashion", "accessory", "sun protection"],
    imageUrl: "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300"
  },
  {
    name: "Winter Jacket",
    normalizedName: "winter jacket",
    category: "Fashion",
    price: new Decimal(250000),
    brand: "WarmStyle",
    keywords: ["jacket", "winter", "warm", "outerwear", "cold weather"],
    imageUrl: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300"
  },

  // Books
  {
    name: "Programming Book",
    normalizedName: "programming book",
    category: "Books",
    price: new Decimal(35000),
    brand: "Tech Books",
    keywords: ["book", "programming", "coding", "education", "technology"],
    imageUrl: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300"
  },
  {
    name: "Novel",
    normalizedName: "novel",
    category: "Books",
    price: new Decimal(18000),
    brand: "Fiction Press",
    keywords: ["book", "novel", "fiction", "reading", "literature"],
    imageUrl: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300"
  },
  {
    name: "Cookbook",
    normalizedName: "cookbook",
    category: "Books",
    price: new Decimal(28000),
    brand: "Culinary Arts",
    keywords: ["book", "cookbook", "recipes", "cooking", "food"],
    imageUrl: "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=300"
  },
  {
    name: "Travel Guide",
    normalizedName: "travel guide",
    category: "Books",
    price: new Decimal(22000),
    brand: "Travel Books",
    keywords: ["book", "travel", "guide", "tourism", "vacation"],
    imageUrl: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300"
  },

  // Sports
  {
    name: "Yoga Mat",
    normalizedName: "yoga mat",
    category: "Sports",
    price: new Decimal(35000),
    brand: "FitLife",
    keywords: ["yoga mat", "exercise", "fitness", "workout", "yoga"],
    imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300"
  },
  {
    name: "Dumbbells",
    normalizedName: "dumbbells",
    category: "Sports",
    price: new Decimal(45000),
    brand: "GymPro",
    keywords: ["dumbbells", "weights", "exercise", "fitness", "strength"],
    imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300"
  },
  {
    name: "Basketball",
    normalizedName: "basketball",
    category: "Sports",
    price: new Decimal(25000),
    brand: "SportBall",
    keywords: ["basketball", "sports", "ball", "game", "outdoor"],
    imageUrl: "https://images.unsplash.com/photo-1546519638-68e109498ffc?w=300"
  },
  {
    name: "Tennis Racket",
    normalizedName: "tennis racket",
    category: "Sports",
    price: new Decimal(120000),
    brand: "Tennis Pro",
    keywords: ["tennis racket", "tennis", "sports", "racket", "game"],
    imageUrl: "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=300"
  }
];

async function main() {
  console.log('🌱 Starting database seeding...');

  // Clear existing data
  await prisma.scanHistory.deleteMany();
  await prisma.product.deleteMany();
  await prisma.shop.deleteMany();

  console.log('🗑️ Cleared existing data');

  // Create shops
  console.log('🏪 Creating shops...');
  const createdShops = [];
  for (const shopData of sampleShops) {
    const shop = await prisma.shop.create({
      data: shopData
    });
    createdShops.push(shop);
    console.log(`✅ Created shop: ${shop.name}`);
  }

  // Create products and assign to shops
  console.log('🛍️ Creating products...');
  let productCount = 0;
  for (const productData of sampleProducts) {
    // Assign products to different shops in a round-robin fashion
    const shopIndex = productCount % createdShops.length;
    const shop = createdShops[shopIndex];

    const product = await prisma.product.create({
      data: {
        ...productData,
        shopId: shop.id
      }
    });
    
    productCount++;
    console.log(`✅ Created product: ${product.name} at ${shop.name}`);
  }

  console.log('🎉 Database seeding completed!');
  console.log(`📊 Created ${createdShops.length} shops and ${productCount} products`);
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });