# CLOVA AI Invoice Scanner

A complete, production-ready invoice scanning system that uses CLOVA AI to extract items from receipts and find better-priced alternatives from nearby shops.

## 🚀 Features

- **AI-Powered Scanning**: Uses CLOVA Donut and CRAFT models for accurate receipt parsing
- **Smart Product Matching**: Finds similar products with better prices from nearby shops
- **Location-Based Search**: Spatial queries to find shops within specified radius
- **Mobile-First Design**: Flutter app with camera integration and modern UI
- **Real-Time Processing**: Fast API responses with intelligent fallbacks
- **Comprehensive Analytics**: Track scan history and savings potential

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │  Node.js API    │    │  Python CLOVA   │
│                 │◄──►│                 │◄──►│     Service     │
│ - Camera        │    │ - Express       │    │ - FastAPI       │
│ - BLoC State    │    │ - TypeScript    │    │ - Donut Model   │
│ - Location      │    │ - Prisma ORM    │    │ - CRAFT Model   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   PostgreSQL    │
                       │                 │
                       │ - Shops         │
                       │ - Products      │
                       │ - Scan History  │
                       └─────────────────┘
```

## 🛠️ Tech Stack

### Backend
- **Node.js** with Express and TypeScript
- **Prisma ORM** with PostgreSQL
- **JWT Authentication**
- **Multer** for file uploads
- **Sharp** for image processing

### AI Service
- **FastAPI** with Python 3.9
- **CLOVA Donut** for receipt understanding
- **CRAFT** for text detection
- **PyTorch** for model inference

### Mobile App
- **Flutter** with Dart
- **BLoC** for state management
- **Camera** integration
- **Geolocation** services
- **Retrofit** for API calls

## 📦 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+
- Python 3.9+
- Flutter 3.0+

### 1. Clone and Setup
```bash
git clone <repository-url>
cd clova-invoice-scanner
chmod +x setup.sh
./setup.sh
```

### 2. Start Services
```bash
docker-compose up -d
```

### 3. Run Database Migrations
```bash
cd backend
npm run db:migrate
npm run db:seed
```

### 4. Build Flutter App
```bash
cd mobile
flutter pub get
flutter build apk --release
```

## 🔧 Configuration

### Environment Variables

Create `.env` files in each service directory:

**Backend (.env)**
```bash
DATABASE_URL=postgresql://scanner:password123@localhost:5432/invoice_scanner
JWT_SECRET=your-super-secret-jwt-key-change-in-production
CLOVA_SERVICE_URL=http://localhost:8000
UPLOAD_DIR=./uploads
```

**CLOVA Service (.env)**
```bash
MODEL_CACHE_DIR=/app/models
CUDA_AVAILABLE=false
```

## 📱 API Documentation

Once the services are running, visit:
- **Backend API**: http://localhost:3000/api/docs
- **CLOVA Service**: http://localhost:8000/docs

### Key Endpoints

#### Scan Invoice
```http
POST /api/scan/invoice
Content-Type: multipart/form-data

Parameters:
- image: File (required)
- latitude: number (required)
- longitude: number (required)
- radius: number (optional, default: 10)
- premiumOnly: boolean (optional, default: false)
```

#### Get Nearby Shops
```http
GET /api/shops/nearby?lat=37.5665&lng=126.9780&radius=10
```

#### Get Scan History
```http
GET /api/scan/history?page=1&limit=20
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Python Service Tests
```bash
cd clova-service
pytest
```

### Flutter Tests
```bash
cd mobile
flutter test
```

## 📊 Sample Data

The system comes with comprehensive sample data:
- **25+ Shops** across different categories and locations
- **150+ Products** with realistic pricing and keywords
- **Multiple Categories**: Cafes, Grocery Stores, Electronics, etc.

## 🚀 Deployment

### Production Setup
1. Update environment variables for production
2. Set up SSL certificates
3. Configure reverse proxy (nginx)
4. Set up monitoring and logging
5. Configure backup strategies

### Docker Production
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 📈 Performance

- **Scan Processing**: < 5 seconds average
- **Product Matching**: < 2 seconds average
- **API Response Time**: < 1 second average
- **Model Loading**: Optimized with caching

## 🔒 Security

- JWT-based authentication
- Rate limiting on API endpoints
- Input validation and sanitization
- Secure file upload handling
- CORS configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the API docs

## 🔄 Updates

Stay updated with the latest features and improvements by checking the releases page and following the changelog.