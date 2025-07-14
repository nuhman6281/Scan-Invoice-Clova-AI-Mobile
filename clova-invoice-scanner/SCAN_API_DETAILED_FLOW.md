# 🔍 CLOVA AI Invoice Scanner - Detailed Step-by-Step Flow

## 📋 Overview

This document provides a detailed, step-by-step breakdown of the complete scan API flow, showing exactly what happens at each stage, which files are involved, and how data is transformed throughout the process.

---

## 🔄 Complete Step-by-Step Flow

### **Step 1: Mobile App Image Capture & Upload**

**File**: `mobile/lib/` (Flutter app)
**Process**: User takes photo of receipt

```dart
// Mobile app captures image
final image = await ImagePicker().pickImage(source: ImageSource.camera);

// Compress image for upload
final compressedImage = await FlutterImageCompress.compressWithFile(
  image.path,
  quality: 85,
  minWidth: 1024,
  minHeight: 1024,
);

// Upload to backend API
final formData = FormData.fromMap({
  'image': await MultipartFile.fromFile(compressedImage.path),
  'timestamp': DateTime.now().toIso8601String(),
  'device': deviceInfo,
});

final response = await dio.post('/api/scan', data: formData);
```

**Data Flow**: `Image File` → `Compressed Image` → `FormData` → `HTTP Request`

---

### **Step 2: Backend API Request Reception**

**File**: `backend/src/routes/scanRoutes.ts`
**Process**: Request validation and file handling

```typescript
// 1. Multer middleware processes file upload
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

// 2. Route handler receives request
router.post("/", upload.single("image"), async (req: Request, res: Response) => {
  const startTime = Date.now();
  
  // 3. Validate request
  if (!req.file) {
    return res.status(400).json({
      success: false,
      message: "No image file provided",
    });
  }

  const { timestamp, device } = req.body;
  
  // 4. Log processing start
  logger.info("Processing scan request", {
    fileSize: req.file.size,
    timestamp,
    device,
  });
});
```

**Data Flow**: `HTTP Request` → `Multer Validation` → `File Buffer` → `Request Handler`

---

### **Step 3: CLOVA AI Service Communication**

**File**: `backend/src/services/ClovaService.ts`
**Process**: Forward image to AI service

```typescript
// 1. Create FormData for CLOVA service
const formData = new FormData();
formData.append("file", req.file.buffer, {
  filename: "invoice.jpg",
  contentType: "image/jpeg",
});

// 2. Send to CLOVA service
let clovaResult;
try {
  clovaResult = await ClovaService.processInvoice(req.file.buffer);
  
  logger.info("CLOVA processing completed", {
    processingTime: Date.now() - startTime,
    itemsFound: clovaResult.items?.length || 0,
  });
} catch (clovaError) {
  logger.warn("CLOVA service failed, using fallback processing");
  
  // 3. Fallback to demo data
  clovaResult = {
    success: true,
    items: [
      {
        name: "Sample Product 1",
        price: 29.99,
        quantity: 2,
        total: 59.98,
      },
      {
        name: "Sample Product 2",
        price: 15.5,
        quantity: 1,
        total: 15.5,
      },
    ],
    total: 75.48,
    merchant: "Demo Store",
    timestamp: new Date().toISOString(),
  };
}
```

**Data Flow**: `File Buffer` → `FormData` → `HTTP Request` → `CLOVA Service`

---

### **Step 4: CLOVA Service Image Processing**

**File**: `clova-service/main.py`
**Process**: Receive and process image

```python
@app.post("/process-invoice", response_model=InvoiceResponse)
async def process_invoice(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
    confidence_threshold: Optional[float] = 0.7,
    use_fallback: Optional[bool] = True
):
    start_time = time.time()
    
    try:
        # 1. Validate file
        if not file.content_type.startswith('image/'):
            raise HTTPException(
                status_code=400, 
                detail="File must be an image (JPEG, PNG, WebP)"
            )
        
        logger.info(f"Processing invoice: {file.filename}")
        
        # 2. Save uploaded file
        file_path = await image_service.save_upload(file)
        
        # 3. Process with CLOVA AI
        result = await clova_processor.process_invoice(
            file_path=file_path,
            confidence_threshold=confidence_threshold,
            use_fallback=use_fallback
        )
        
        processing_time = time.time() - start_time
        
        # 4. Add cleanup task
        background_tasks.add_task(image_service.cleanup_temp_file, file_path)
        
        return InvoiceResponse(
            success=True,
            scan_id=result.get("scan_id"),
            items=result.get("items", []),
            total_amount=result.get("total_amount"),
            confidence_score=result.get("confidence_score"),
            processing_time_ms=int(processing_time * 1000),
            model_used=result.get("model_used"),
            metadata=result.get("metadata", {})
        )
        
    except Exception as e:
        logger.error(f"Failed to process invoice: {e}")
        processing_time = time.time() - start_time
        
        return InvoiceResponse(
            success=False,
            error=str(e),
            processing_time_ms=int(processing_time * 1000)
        )
```

**Data Flow**: `UploadFile` → `File Validation` → `File Save` → `AI Processing` → `Response`

---

### **Step 5: Image Service File Handling**

**File**: `clova-service/app/services/image_service.py`
**Process**: Save and manage uploaded files

```python
async def save_upload(self, file: UploadFile) -> str:
    try:
        # 1. Generate unique filename
        file_extension = Path(file.filename).suffix if file.filename else ".jpg"
        filename = f"{uuid.uuid4()}{file_extension}"
        file_path = self.upload_dir / filename
        
        # 2. Save file
        async with aiofiles.open(file_path, 'wb') as f:
            content = await file.read()
            await f.write(content)
        
        logger.info(f"Saved uploaded file: {file_path}")
        return str(file_path)
        
    except Exception as e:
        logger.error(f"Failed to save uploaded file: {e}")
        raise
```

**Data Flow**: `UploadFile` → `Unique Filename` → `File Save` → `File Path`

---

### **Step 6: CLOVA AI Processing Pipeline**

**File**: `clova-service/app/services/clova_processor.py`
**Process**: AI-powered image analysis

```python
async def process_invoice(self, file_path: str, confidence_threshold: float = 0.7, use_fallback: bool = True):
    start_time = time.time()
    scan_id = str(uuid.uuid4())
    
    try:
        logger.info(f"Processing invoice: {file_path}")
        
        # 1. Preprocess image
        image = await self._preprocess_image(file_path)
        
        # 2. Primary processing with Donut
        donut_result = await self._process_with_donut(image)
        
        # 3. Check confidence and use fallback if needed
        if use_fallback and donut_result.get('confidence_score', 0) < confidence_threshold:
            logger.info("Low confidence, using CRAFT fallback")
            craft_result = await self._process_with_craft(image)
            final_result = self._merge_results(donut_result, craft_result)
            model_used = "donut+craft"
            self.processing_stats["craft_usage"] += 1
        else:
            final_result = donut_result
            model_used = "donut"
            self.processing_stats["donut_usage"] += 1
        
        # 4. Update processing stats
        processing_time = time.time() - start_time
        self._update_stats(processing_time, True)
        
        return {
            "scan_id": scan_id,
            "items": final_result.get("items", []),
            "total_amount": final_result.get("total_amount"),
            "confidence_score": final_result.get("confidence_score"),
            "model_used": model_used,
            "processing_time": processing_time,
            "metadata": {
                "image_path": file_path,
                "image_size": image.shape if hasattr(image, 'shape') else None,
                "confidence_threshold": confidence_threshold,
                "use_fallback": use_fallback
            }
        }
        
    except Exception as e:
        logger.error(f"Failed to process invoice: {e}")
        processing_time = time.time() - start_time
        self._update_stats(processing_time, False)
        
        return {
            "scan_id": scan_id,
            "error": str(e),
            "items": [],
            "total_amount": 0.0,
            "confidence_score": 0.0,
            "model_used": "none",
            "processing_time": processing_time
        }
```

**Data Flow**: `File Path` → `Image Preprocessing` → `Donut Processing` → `Confidence Check` → `CRAFT Fallback` → `Result Merging` → `Structured Data`

---

### **Step 7: Donut Model Processing**

**File**: `clova-service/app/services/clova_processor.py`
**Process**: Primary AI document understanding

```python
async def _process_with_donut(self, image: np.ndarray) -> Dict[str, Any]:
    try:
        # 1. Convert to PIL Image
        pil_image = Image.fromarray(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
        
        # 2. Prepare input for Donut
        pixel_values = self.donut_processor(
            pil_image, 
            return_tensors="pt"
        ).pixel_values
        
        # 3. Move to device
        pixel_values = pixel_values.to(self.device)
        
        # 4. Generate with task prompt for receipts
        task_prompt = "<s_cord-v2>"
        decoder_input_ids = self.donut_processor.tokenizer(
            task_prompt, 
            add_special_tokens=False, 
            return_tensors="pt"
        ).input_ids.to(self.device)
        
        # 5. Generate prediction
        with torch.no_grad():
            outputs = self.donut_model.generate(
                pixel_values,
                decoder_input_ids=decoder_input_ids,
                max_length=self.donut_model.decoder.config.max_position_embeddings,
                pad_token_id=self.donut_processor.tokenizer.pad_token_id,
                eos_token_id=self.donut_processor.tokenizer.eos_token_id,
                use_cache=True,
                early_stopping=True,
                do_sample=False
            )
        
        # 6. Decode result
        sequence = self.donut_processor.batch_decode(outputs.sequences)[0]
        
        # 7. Parse the result
        parsed_result = self._parse_donut_output(sequence)
        
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

**Data Flow**: `NumPy Array` → `PIL Image` → `Tensor Input` → `Model Generation` → `Text Output` → `Parsed Data`

---

### **Step 8: CRAFT Model Fallback Processing**

**File**: `clova-service/app/services/clova_processor.py`
**Process**: Text detection and OCR fallback

```python
async def _process_with_craft(self, image: np.ndarray) -> Dict[str, Any]:
    try:
        # 1. Save image temporarily for CRAFT
        temp_path = f"/tmp/craft_temp_{uuid.uuid4()}.jpg"
        cv2.imwrite(temp_path, image)
        
        # 2. Process with CRAFT
        prediction_result = get_prediction(
            image=temp_path,
            craft_net=self.craft_net,
            refine_net=self.refine_net,
            text_threshold=0.7,
            link_threshold=0.4,
            low_text=0.4,
            cuda=torch.cuda.is_available(),
            canvas_size=1280,
            mag_ratio=1.5,
            poly=False
        )
        
        # 3. Clean up temp file
        os.remove(temp_path)
        
        # 4. Extract text from CRAFT result
        extracted_text = self._extract_text_from_craft(prediction_result)
        
        # 5. Parse text into structured data
        parsed_result = self._parse_craft_text(extracted_text)
        
        return parsed_result
        
    except Exception as e:
        logger.error(f"CRAFT processing failed: {e}")
        return {
            "items": [],
            "total_amount": 0.0,
            "confidence_score": 0.5,  # Lower confidence for CRAFT
            "error": str(e)
        }
```

**Data Flow**: `NumPy Array` → `Temp File` → `CRAFT Processing` → `Text Extraction` → `Text Parsing` → `Structured Data`

---

### **Step 9: Result Parsing and Merging**

**File**: `clova-service/app/services/clova_processor.py`
**Process**: Parse AI outputs into structured data

```python
def _parse_donut_output(self, sequence: str) -> Dict[str, Any]:
    try:
        # 1. Remove task prompt
        if sequence.startswith("<s_cord-v2>"):
            sequence = sequence[len("<s_cord-v2>"):]
        
        # 2. Try to parse as JSON
        try:
            data = json.loads(sequence)
            return self._extract_items_from_json(data)
        except json.JSONDecodeError:
            # 3. Fallback: parse as text
            return self._extract_items_from_text(sequence)
            
    except Exception as e:
        logger.error(f"Failed to parse Donut output: {e}")
        return {
            "items": [],
            "total_amount": 0.0,
            "confidence_score": 0.0,
            "error": str(e)
        }

def _extract_items_from_json(self, data: Dict[str, Any]) -> Dict[str, Any]:
    items = []
    total_amount = 0.0
    
    # 1. Extract menu items
    if "menu" in data:
        for item in data["menu"]:
            if isinstance(item, dict):
                name = item.get("nm", "")
                price = float(item.get("price", 0))
                quantity = int(item.get("cnt", 1))
                
                items.append(InvoiceItem(
                    name=name,
                    price=price,
                    quantity=quantity,
                    category="food"
                ))
                
                total_amount += price * quantity
    
    # 2. Extract total
    if "total" in data and isinstance(data["total"], dict):
        total = data["total"].get("total_price", 0)
        if isinstance(total, str):
            total = float(total.replace(",", ""))
        total_amount = float(total)
    
    return {
        "items": items,
        "total_amount": total_amount,
        "confidence_score": 0.9,  # High confidence for structured data
        "raw_data": data
    }
```

**Data Flow**: `Text Output` → `JSON Parsing` → `Item Extraction` → `Structured Items`

---

### **Step 10: Backend Database Product Matching**

**File**: `backend/src/routes/scanRoutes.ts`
**Process**: Find better-priced alternatives

```typescript
// Find better offers for extracted items
const betterOffers: any[] = [];
if (clovaResult.items && clovaResult.items.length > 0) {
  for (const item of clovaResult.items) {
    try {
      // 1. Search for similar products with better prices
      const similarProducts = await prisma.product.findMany({
        where: {
          name: {
            contains: item.name,
            mode: "insensitive",
          },
          price: {
            lt: parseFloat(item.price.toString()),
          },
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
        orderBy: {
          price: "asc",
        },
        take: 5,
      });

      if (similarProducts.length > 0) {
        // 2. Calculate savings
        betterOffers.push({
          originalItem: item,
          betterOffers: similarProducts.map((product) => ({
            productId: product.id,
            productName: product.name,
            shopName: product.shop.name,
            shopAddress: product.shop.address,
            shopRating: product.shop.rating,
            price: parseFloat(product.price.toString()),
            savings: parseFloat(item.price.toString()) - parseFloat(product.price.toString()),
            savingsPercentage: (
              ((parseFloat(item.price.toString()) - parseFloat(product.price.toString())) /
                parseFloat(item.price.toString())) *
              100
            ).toFixed(1),
          })),
        });
      }
    } catch (dbError) {
      logger.error("Error finding better offers for item", {
        item: item.name,
        error: dbError instanceof Error ? dbError.message : "Unknown error",
      });
    }
  }
}
```

**Data Flow**: `Extracted Items` → `Database Query` → `Product Matching` → `Price Comparison` → `Savings Calculation` → `Better Offers`

---

### **Step 11: Scan History Storage**

**File**: `backend/src/routes/scanRoutes.ts`
**Process**: Save scan data for analytics

```typescript
// Save scan history
try {
  await prisma.scanHistory.create({
    data: {
      userId: "anonymous", // In real app, get from auth middleware
      imagePath: "processed", // In real app, save to cloud storage
      scanResult: clovaResult,
      deviceInfo: { device: device || "unknown", timestamp },
      processingTime: Date.now() - startTime,
      itemsFound: clovaResult.items?.length || 0,
      alternativesFound: betterOffers.length,
    },
  });
} catch (dbError) {
  logger.error("Error saving scan history", {
    error: dbError instanceof Error ? dbError.message : "Unknown error",
  });
}
```

**Data Flow**: `Scan Results` → `History Object` → `Database Storage` → `Analytics Data`

---

### **Step 12: Response Generation**

**File**: `backend/src/routes/scanRoutes.ts`
**Process**: Generate final API response

```typescript
// Return results
res.json({
  success: true,
  data: {
    extractedItems: clovaResult.items || [],
    total: clovaResult.total || 0,
    merchant: clovaResult.merchant || "Unknown",
    betterOffers,
    processingTime: Date.now() - startTime,
  },
});
```

**Data Flow**: `Processed Data` → `Response Object` → `JSON Response` → `Mobile App`

---

## 📊 Data Transformation Summary

### **Input → Output Flow**

| Stage | Input | Processing | Output |
|-------|-------|------------|--------|
| **Mobile Capture** | Camera Image | Compression | Compressed Image |
| **Upload** | Compressed Image | HTTP Upload | File Buffer |
| **CLOVA Processing** | File Buffer | AI Analysis | Structured Items |
| **Database Matching** | Structured Items | Product Search | Better Offers |
| **Response** | All Data | JSON Formatting | API Response |

### **Key Data Structures**

#### **1. Upload Request**
```typescript
{
  image: File,           // Multipart file
  timestamp: string,     // ISO timestamp
  device: string         // Device identifier
}
```

#### **2. CLOVA Service Response**
```typescript
{
  success: boolean,
  scan_id: string,
  items: InvoiceItem[],
  total_amount: number,
  confidence_score: number,
  model_used: string,
  processing_time: number,
  metadata: object
}
```

#### **3. Database Product Match**
```typescript
{
  productId: string,
  productName: string,
  shopName: string,
  shopAddress: string,
  shopRating: number,
  price: number,
  savings: number,
  savingsPercentage: string
}
```

#### **4. Final API Response**
```typescript
{
  success: boolean,
  data: {
    extractedItems: InvoiceItem[],
    total: number,
    merchant: string,
    betterOffers: BetterOffer[],
    processingTime: number
  }
}
```

---

## ⚡ Performance Metrics

### **Processing Times**

| Stage | Typical Time | Optimization |
|-------|-------------|--------------|
| **Image Upload** | 1-3 seconds | Compression, CDN |
| **CLOVA Processing** | 5-15 seconds | GPU acceleration, model caching |
| **Database Query** | 100-500ms | Indexing, query optimization |
| **Response Generation** | 50-100ms | Caching, efficient serialization |

### **Resource Usage**

| Component | CPU | Memory | Storage |
|-----------|-----|--------|---------|
| **Backend API** | Low | 100-200MB | Minimal |
| **CLOVA Service** | High (GPU) | 2-4GB | Model files |
| **Database** | Medium | 500MB-1GB | Data files |
| **Redis Cache** | Low | 100-200MB | In-memory |

---

## 🔧 Error Handling Points

### **Critical Error Points**

1. **File Upload Errors**
   - Invalid file type
   - File size exceeded
   - Network timeout

2. **CLOVA Service Errors**
   - Model loading failure
   - Processing timeout
   - Memory exhaustion

3. **Database Errors**
   - Connection failure
   - Query timeout
   - Constraint violations

4. **Response Errors**
   - Serialization failure
   - Network timeout
   - Client disconnection

### **Fallback Mechanisms**

1. **CLOVA Service Fallback**
   - Demo data when AI fails
   - CRAFT model when Donut fails
   - Graceful degradation

2. **Database Fallback**
   - Connection retry
   - Query timeout handling
   - Partial results

3. **Response Fallback**
   - Error response with details
   - Partial success handling
   - Client retry guidance

---

## 📈 Monitoring Points

### **Key Metrics to Track**

1. **Processing Success Rate**
   - Successful scans / Total scans
   - Model usage distribution
   - Error rate by type

2. **Performance Metrics**
   - Average processing time
   - Response time percentiles
   - Resource utilization

3. **Business Metrics**
   - Items extracted per scan
   - Alternatives found per item
   - Potential savings identified

4. **System Health**
   - Service availability
   - Database performance
   - Memory usage trends

---

## 🚀 Optimization Opportunities

### **Current Optimizations**

1. **Image Processing**
   - Compression before upload
   - Quality enhancement
   - Format optimization

2. **AI Processing**
   - Model caching
   - GPU acceleration
   - Batch processing

3. **Database Queries**
   - Indexed searches
   - Query optimization
   - Connection pooling

### **Future Optimizations**

1. **Caching Strategy**
   - Result caching
   - Model output caching
   - Database query caching

2. **Parallel Processing**
   - Concurrent item processing
   - Async database queries
   - Background tasks

3. **CDN Integration**
   - Static asset delivery
   - Image optimization
   - Global distribution

---

This detailed flow documentation provides a comprehensive understanding of how the scan API processes images from capture to final response, enabling developers to understand, debug, and optimize the system effectively.