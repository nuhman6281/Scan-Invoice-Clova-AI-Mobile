-- CreateTable
CREATE TABLE "shops" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "address" TEXT,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "phone" VARCHAR(20),
    "rating" DECIMAL(3,2),
    "is_premium" BOOLEAN NOT NULL DEFAULT false,
    "category" VARCHAR(100),
    "image_url" VARCHAR(500),
    "description" TEXT,
    "opening_hours" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "shops_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" TEXT NOT NULL,
    "shop_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "normalized_name" VARCHAR(255) NOT NULL,
    "category" VARCHAR(100),
    "price" DECIMAL(10,2) NOT NULL,
    "image_url" VARCHAR(500),
    "brand" VARCHAR(100),
    "description" TEXT,
    "keywords" VARCHAR(100)[],
    "is_available" BOOLEAN NOT NULL DEFAULT true,
    "stock_quantity" INTEGER,
    "barcode" VARCHAR(50),
    "weight" DECIMAL(8,3),
    "unit" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scan_history" (
    "id" TEXT NOT NULL,
    "image_path" VARCHAR(500),
    "scan_result" JSONB,
    "items_found" INTEGER NOT NULL DEFAULT 0,
    "alternatives_found" INTEGER NOT NULL DEFAULT 0,
    "potential_savings" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "confidence_score" DECIMAL(3,2),
    "processing_time" INTEGER,
    "user_latitude" DECIMAL(10,8),
    "user_longitude" DECIMAL(11,8),
    "user_id" VARCHAR(100),
    "device_info" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "scan_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(20),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_admin" BOOLEAN NOT NULL DEFAULT false,
    "last_login" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_keys" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "key" VARCHAR(255) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "permissions" JSONB,
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "api_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "analytics" (
    "id" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "total_scans" INTEGER NOT NULL DEFAULT 0,
    "successful_scans" INTEGER NOT NULL DEFAULT 0,
    "total_savings" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "avg_processing_time" INTEGER NOT NULL DEFAULT 0,
    "unique_users" INTEGER NOT NULL DEFAULT 0,
    "popular_items" JSONB,
    "error_rate" DECIMAL(5,4) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "analytics_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "shops_latitude_longitude_idx" ON "shops"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "shops_category_idx" ON "shops"("category");

-- CreateIndex
CREATE INDEX "shops_is_premium_idx" ON "shops"("is_premium");

-- CreateIndex
CREATE INDEX "products_shop_id_idx" ON "products"("shop_id");

-- CreateIndex
CREATE INDEX "products_normalized_name_idx" ON "products"("normalized_name");

-- CreateIndex
CREATE INDEX "products_category_idx" ON "products"("category");

-- CreateIndex
CREATE INDEX "products_price_idx" ON "products"("price");

-- CreateIndex
CREATE INDEX "products_is_available_idx" ON "products"("is_available");

-- CreateIndex
CREATE INDEX "products_keywords_idx" ON "products"("keywords");

-- CreateIndex
CREATE INDEX "scan_history_user_id_idx" ON "scan_history"("user_id");

-- CreateIndex
CREATE INDEX "scan_history_created_at_idx" ON "scan_history"("created_at");

-- CreateIndex
CREATE INDEX "scan_history_user_latitude_user_longitude_idx" ON "scan_history"("user_latitude", "user_longitude");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_is_active_idx" ON "users"("is_active");

-- CreateIndex
CREATE UNIQUE INDEX "api_keys_key_key" ON "api_keys"("key");

-- CreateIndex
CREATE INDEX "api_keys_key_idx" ON "api_keys"("key");

-- CreateIndex
CREATE INDEX "api_keys_is_active_idx" ON "api_keys"("is_active");

-- CreateIndex
CREATE UNIQUE INDEX "analytics_date_key" ON "analytics"("date");

-- CreateIndex
CREATE INDEX "analytics_date_idx" ON "analytics"("date");

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;

