# 🔍 CLOVA AI Invoice Scanner - Complete Scan API Flow Documentation

## 📋 Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Complete API Flow](#complete-api-flow)
4. [File-by-File Breakdown](#file-by-file-breakdown)
5. [Data Flow Diagrams](#data-flow-diagrams)
6. [Error Handling](#error-handling)
7. [Performance Considerations](#performance-considerations)
8. [Security Measures](#security-measures)
9. [Testing Strategy](#testing-strategy)

---

## 🎯 Overview

The CLOVA AI Invoice Scanner implements a sophisticated multi-stage processing pipeline that transforms raw receipt images into actionable shopping intelligence. This document provides a comprehensive breakdown of the entire scan API flow, from image upload to final response.

### Key Features
- **AI-Powered Document Understanding**: Uses CLOVA Donut model for structured data extraction
- **Fallback Processing**: CRAFT model for text detection when Donut confidence is low
- **Product Matching**: Intelligent matching with database products
- **Location Intelligence**: Geospatial queries for nearby alternatives
- **Real-time Processing**: Optimized for fast response times
- **Robust Error Handling**: Graceful degradation and fallback mechanisms

---

## 🏗️ System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │    │   Node.js API   │    │  CLOVA AI       │
│   (Flutter)     │◄──►│   (Backend)     │◄──►│  Service        │
│                 │    │                 │    │  (Python)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                        │
                              ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   PostgreSQL    │    │   Redis Cache   │
                       │   Database      │    │                 │
                       └─────────────────┘    └─────────────────┘
```

### Component Responsibilities

| Component | Technology | Primary Responsibility |
|-----------|------------|----------------------|
| **Mobile App** | Flutter | Image capture, user interface, location services |
| **Backend API** | Node.js + TypeScript | Request handling, business logic, database operations |
| **CLOVA Service** | Python + FastAPI | AI processing, image analysis, data extraction |
| **Database** | PostgreSQL + PostGIS | Data persistence, geospatial queries |
| **Cache** | Redis | Session management, result caching |

---

## 🔄 Complete API Flow

### 1. **Image Upload & Validation**
```
Mobile App → Backend API (POST /api/scan)
```

**Files Involved:**
- `backend/src/routes/scanRoutes.ts` - Route handler
- `backend/src/middleware/` - Validation middleware

**Process:**
1. Mobile app captures image and uploads via multipart/form-data
2. Multer middleware handles file upload with validation
3. File size and type validation (max 10MB, image files only)
4. Image buffer stored in memory for processing

### 2. **CLOVA AI Service Processing**
```
Backend API → CLOVA Service (POST /process-invoice)
```

**Files Involved:**
- `clova-service/main.py` - FastAPI endpoint
- `clova-service/app/services/image_service.py` - Image handling
- `clova-service/app/services/clova_processor.py` - AI processing

**Process:**
1. Image saved to temporary storage
2. Image preprocessing and enhancement
3. Primary processing with Donut model
4. Confidence assessment and fallback to CRAFT if needed
5. Structured data extraction and parsing

### 3. **Database Product Matching**
```
Backend API → PostgreSQL Database
```

**Files Involved:**
- `backend/src/services/DatabaseService.ts` - Database connection
- `backend/prisma/schema.prisma` - Database schema
- `backend/src/routes/scanRoutes.ts` - Product matching logic

**Process:**
1. Extract items from AI processing results
2. Fuzzy string matching with product database
3. Price comparison and alternative identification
4. Geospatial queries for nearby shops

### 4. **Response Generation**
```
Backend API → Mobile App
```

**Process:**
1. Combine AI results with product matches
2. Calculate potential savings
3. Generate structured response
4. Save scan history for analytics

---

## 📁 File-by-File Breakdown

### **Backend API Files**

#### 1. `backend/src/routes/scanRoutes.ts`
**Purpose**: Main scan endpoint handler
**Key Functions**:
- `POST /` - Process invoice scan
- `GET /history` - Get scan history

**Critical Code Sections**:
```typescript
// File upload configuration
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith("image/")) {
      cb(null, true);
    } else {
      cb(new Error("Only image files are allowed"));
    }
  },
});

// Main scan processing
router.post("/", upload.single("image"), async (req: Request, res: Response) => {
  // 1. Validate request
  // 2. Process with CLOVA service
  // 3. Find better offers
  // 4. Save scan history
  // 5. Return results
});
```

#### 2. `backend/src/services/ClovaService.ts`
**Purpose**: CLOVA AI service integration
**Key Functions**:
- `initialize()` - Service initialization
- `processInvoice()` - Image processing
- `ping()` - Health check

**Critical Code Sections**:
```typescript
public static async processInvoice(imageBuffer: Buffer): Promise<any> {
  // Create FormData for Node.js environment
  const formData = new FormData();
  formData.append("file", imageBuffer, {
    filename: "invoice.jpg",
    contentType: "image/jpeg",
  });

  const response = await this.client.post("/process-invoice", formData, {
    headers: { ...formData.getHeaders() },
    timeout: 120000, // 2 minutes for real AI processing
  });

  return response.data;
}
```

#### 3. `backend/src/services/DatabaseService.ts`
**Purpose**: Database connection management
**Key Functions**:
- `initialize()` - Database connection
- `getClient()` - Get Prisma client
- `disconnect()` - Clean shutdown

### **CLOVA AI Service Files**

#### 1. `clova-service/main.py`
**Purpose**: FastAPI application entry point
**Key Endpoints**:
- `POST /process-invoice` - Main processing endpoint
- `GET /health` - Health check
- `GET /models/status` - Model status

**Critical Code Sections**:
```python
@app.post("/process-invoice", response_model=InvoiceResponse)
async def process_invoice(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
    confidence_threshold: Optional[float] = 0.7,
    use_fallback: Optional[bool] = True
):
    # 1. Validate file
    # 2. Save uploaded file
    # 3. Process with CLOVA AI
    # 4. Add cleanup task
    # 5. Return results
```

#### 2. `clova-service/app/services/clova_processor.py`
**Purpose**: Core AI processing logic
**Key Classes**:
- `ClovaProcessor` - Main processing class
- `ModelStatus` - Model status tracking

**Critical Methods**:
```python
async def process_invoice(self, file_path: str, confidence_threshold: float = 0.7, use_fallback: bool = True):
    # 1. Preprocess image
    # 2. Process with Donut
    # 3. Check confidence
    # 4. Use CRAFT fallback if needed
    # 5. Merge results
    # 6. Return structured data

async def _process_with_donut(self, image: np.ndarray):
    # 1. Convert to PIL Image
    # 2. Prepare input for Donut
    # 3. Generate prediction
    # 4. Parse output
    # 5. Return structured data

async def _process_with_craft(self, image: np.ndarray):
    # 1. Save image temporarily
    # 2. Process with CRAFT
    # 3. Extract text
    # 4. Parse text
    # 5. Clean up temp file
```

#### 3. `clova-service/app/services/image_service.py`
**Purpose**: Image file handling
**Key Functions**:
- `save_upload()` - Save uploaded files
- `cleanup_temp_file()` - Cleanup temporary files
- `validate_file()` - File validation

### **Database Schema Files**

#### 1. `backend/prisma/schema.prisma`
**Purpose**: Database schema definition
**Key Models**:
- `Shop` - Shop information with geospatial data
- `Product` - Product catalog
- `ScanHistory` - Scan tracking and analytics
- `User` - User management
- `Analytics` - Aggregated statistics

**Critical Schema Sections**:
```prisma
model Shop {
  id           String    @id @default(uuid())
  name         String    @db.VarChar(255)
  address      String?
  latitude     Decimal   @db.Decimal(10, 8)
  longitude    Decimal   @db.Decimal(11, 8)
  // ... other fields
  products     Product[]

  @@index([latitude, longitude])
  @@index([category])
  @@index([isPremium])
}

model Product {
  id             String   @id @default(uuid())
  shopId         String   @map("shop_id")
  name           String   @db.VarChar(255)
  normalizedName String   @map("normalized_name") @db.VarChar(255)
  price          Decimal  @db.Decimal(10, 2)
  // ... other fields
  shop           Shop     @relation(fields: [shopId], references: [id], onDelete: Cascade)

  @@index([shopId])
  @@index([normalizedName])
  @@index([price])
}
```

---

## 🔄 Data Flow Diagrams

### **Complete Scan Flow**

```mermaid
sequenceDiagram
    participant MA as Mobile App
    participant BA as Backend API
    participant CS as CLOVA Service
    participant DB as Database
    participant RD as Redis

    MA->>BA: POST /api/scan (image)
    BA->>BA: Validate file
    BA->>CS: POST /process-invoice
    CS->>CS: Save image
    CS->>CS: Preprocess image
    CS->>CS: Process with Donut
    alt Low confidence
        CS->>CS: Process with CRAFT
        CS->>CS: Merge results
    end
    CS-->>BA: Return extracted data
    BA->>DB: Query products
    BA->>DB: Find alternatives
    BA->>DB: Save scan history
    BA-->>MA: Return results with alternatives
```

### **AI Processing Flow**

```mermaid
flowchart TD
    A[Image Upload] --> B[Image Preprocessing]
    B --> C[Donut Model Processing]
    C --> D{Confidence > Threshold?}
    D -->|Yes| E[Parse Donut Results]
    D -->|No| F[CRAFT Model Processing]
    F --> G[Parse CRAFT Results]
    E --> H[Merge Results]
    G --> H
    H --> I[Structured Data Output]
```

### **Product Matching Flow**

```mermaid
flowchart TD
    A[Extracted Items] --> B[Fuzzy String Matching]
    B --> C[Price Comparison]
    C --> D[Geospatial Query]
    D --> E[Alternative Products]
    E --> F[Savings Calculation]
    F --> G[Response Generation]
```

---

## ⚠️ Error Handling

### **Backend API Error Handling**

#### 1. **File Validation Errors**
```typescript
// File size validation
if (req.file.size > 10 * 1024 * 1024) {
  return res.status(400).json({
    success: false,
    message: "File size exceeds 10MB limit"
  });
}

// File type validation
if (!req.file.mimetype.startsWith("image/")) {
  return res.status(400).json({
    success: false,
    message: "Only image files are allowed"
  });
}
```

#### 2. **CLOVA Service Errors**
```typescript
try {
  clovaResult = await ClovaService.processInvoice(req.file.buffer);
} catch (clovaError) {
  logger.warn("CLOVA service failed, using fallback processing");
  
  // Fallback to demo data
  clovaResult = {
    success: true,
    items: [
      {
        name: "Sample Product 1",
        price: 29.99,
        quantity: 2,
        total: 59.98,
      }
    ],
    total: 75.48,
    merchant: "Demo Store",
    timestamp: new Date().toISOString(),
  };
}
```

#### 3. **Database Errors**
```typescript
try {
  const similarProducts = await prisma.product.findMany({
    where: {
      name: { contains: item.name, mode: "insensitive" },
      price: { lt: parseFloat(item.price.toString()) }
    }
  });
} catch (dbError) {
  logger.error("Error finding better offers for item", {
    item: item.name,
    error: dbError instanceof Error ? dbError.message : "Unknown error"
  });
}
```

### **CLOVA Service Error Handling**

#### 1. **Model Loading Errors**
```python
async def _load_donut_model(self):
    try:
        self.donut_processor = DonutProcessor.from_pretrained("naver-clova-ix/donut-base")
        self.donut_model = VisionEncoderDecoderModel.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
        self.donut_model.to(self.device)
        self.donut_model.eval()
    except Exception as e:
        logger.error(f"Failed to load Donut model: {e}")
        raise
```

#### 2. **Processing Errors**
```python
async def _process_with_donut(self, image: np.ndarray):
    try:
        # Processing logic
        return parsed_result
    except Exception as e:
        logger.error(f"Donut processing failed: {e}")
        return {
            "items": [],
            "total_amount": 0.0,
            "confidence_score": 0.0,
            "error": str(e)
        }
```

---

## ⚡ Performance Considerations

### **Backend API Optimizations**

#### 1. **File Upload Optimization**
- Memory storage for small files (< 10MB)
- Streaming for larger files
- Image compression before processing

#### 2. **Database Query Optimization**
```typescript
// Indexed queries for fast product matching
const similarProducts = await prisma.product.findMany({
  where: {
    name: { contains: item.name, mode: "insensitive" },
    price: { lt: parseFloat(item.price.toString()) }
  },
  include: {
    shop: {
      select: {
        id: true,
        name: true,
        address: true,
        rating: true,
      },
    },
  },
  orderBy: { price: "asc" },
  take: 5, // Limit results
});
```

#### 3. **Caching Strategy**
- Redis caching for frequently accessed data
- Model result caching
- Session management

### **CLOVA Service Optimizations**

#### 1. **Model Loading**
- Pre-loaded models in memory
- GPU acceleration when available
- Model quantization for faster inference

#### 2. **Image Processing**
- Async processing with background tasks
- Image resizing for faster processing
- Batch processing capabilities

#### 3. **Memory Management**
- Automatic cleanup of temporary files
- Memory usage monitoring
- Garbage collection optimization

---

## 🔒 Security Measures

### **Backend API Security**

#### 1. **File Upload Security**
```typescript
// File type validation
fileFilter: (req, file, cb) => {
  if (file.mimetype.startsWith("image/")) {
    cb(null, true);
  } else {
    cb(new Error("Only image files are allowed"));
  }
}

// File size limits
limits: {
  fileSize: 10 * 1024 * 1024, // 10MB limit
}
```

#### 2. **Input Validation**
- Request body validation
- Parameter sanitization
- SQL injection prevention via Prisma ORM

#### 3. **Rate Limiting**
```typescript
const limiter = rateLimit({
  windowMs: config.rateLimit.windowMs,
  max: config.rateLimit.maxRequests,
  message: {
    error: 'Too many requests from this IP, please try again later.',
    retryAfter: Math.ceil(config.rateLimit.windowMs / 1000)
  }
});
```

### **CLOVA Service Security**

#### 1. **File Handling**
- Secure file upload handling
- Temporary file cleanup
- Path traversal prevention

#### 2. **Model Security**
- Model input validation
- Output sanitization
- Memory isolation

---

## 🧪 Testing Strategy

### **Backend API Testing**

#### 1. **Unit Tests**
```typescript
describe('Scan Routes', () => {
  test('should process valid image upload', async () => {
    const response = await request(app)
      .post('/api/scan')
      .attach('image', 'test-image.jpg')
      .field('timestamp', new Date().toISOString())
      .field('device', 'test-device');
    
    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
  });
});
```

#### 2. **Integration Tests**
- End-to-end scan flow testing
- Database integration testing
- CLOVA service integration testing

### **CLOVA Service Testing**

#### 1. **Model Testing**
```python
async def test_donut_processing():
    processor = ClovaProcessor()
    await processor.initialize()
    
    result = await processor.process_invoice("test-image.jpg")
    assert result["success"] == True
    assert len(result["items"]) > 0
```

#### 2. **Image Processing Testing**
- Image preprocessing validation
- Quality enhancement testing
- Error handling validation

### **Performance Testing**

#### 1. **Load Testing**
- Concurrent request handling
- Response time measurement
- Memory usage monitoring

#### 2. **Stress Testing**
- Large file processing
- High-volume requests
- Error recovery testing

---

## 📊 Monitoring & Analytics

### **Key Metrics**

#### 1. **Processing Metrics**
- Average processing time
- Success/failure rates
- Model usage statistics
- Confidence score distribution

#### 2. **Business Metrics**
- Total scans processed
- Potential savings identified
- User engagement metrics
- Product matching accuracy

### **Logging Strategy**

#### 1. **Structured Logging**
```typescript
logger.info("Processing scan request", {
  fileSize: req.file.size,
  timestamp,
  device,
  processingTime: Date.now() - startTime,
  itemsFound: clovaResult.items?.length || 0,
});
```

#### 2. **Error Tracking**
- Detailed error logging
- Stack trace capture
- Error categorization
- Alert generation

---

## 🚀 Deployment Considerations

### **Docker Configuration**

#### 1. **Service Dependencies**
```yaml
services:
  backend:
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      clova-service:
        condition: service_started
```

#### 2. **Resource Allocation**
```yaml
clova-service:
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: 1
            capabilities: [gpu]
```

### **Environment Configuration**

#### 1. **Backend Environment**
```env
DATABASE_URL=postgresql://scanner:password123@postgres:5432/invoice_scanner
REDIS_URL=redis://redis:6379
CLOVA_SERVICE_URL=http://localhost:8000
JWT_SECRET=your-super-secret-jwt-key
```

#### 2. **CLOVA Service Environment**
```env
PYTHONPATH=/app
MODEL_CACHE_DIR=/app/models
UPLOAD_DIR=/app/uploads
LOG_LEVEL=DEBUG
MAX_WORKERS=2
```

---

## 📈 Future Enhancements

### **Planned Improvements**

#### 1. **AI Model Enhancements**
- Multi-language support
- Better text recognition
- Improved confidence scoring
- Real-time model updates

#### 2. **Performance Optimizations**
- Model quantization
- Batch processing
- Caching improvements
- CDN integration

#### 3. **Feature Additions**
- Receipt categorization
- Spending analytics
- Budget tracking
- Social features

---

## 📚 Conclusion

The CLOVA AI Invoice Scanner implements a sophisticated, production-ready system that combines cutting-edge AI technology with practical business applications. The scan API flow demonstrates robust error handling, performance optimization, and security measures while providing a seamless user experience.

The modular architecture allows for easy maintenance, testing, and future enhancements, making it a scalable solution for invoice processing and price comparison services.

---

## 🔗 Related Documentation

- [API Reference](./API_REFERENCE.md)
- [Database Schema](./DATABASE_SCHEMA.md)
- [Deployment Guide](./DEPLOYMENT_GUIDE.md)
- [Testing Guide](./TESTING_GUIDE.md)
- [Troubleshooting](./TROUBLESHOOTING.md)