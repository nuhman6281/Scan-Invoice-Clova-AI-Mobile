# 🧾 CLOVA AI Invoice Scanner

A complete, production-ready invoice scanning system that uses CLOVA AI to extract items from receipts and find better-priced alternatives from nearby shops.

## 🚀 Features

- **AI-Powered Scanning**: Uses CLOVA Donut and CRAFT models for accurate receipt parsing
- **Product Matching**: Intelligent matching of scanned items with database products
- **Location-Based Alternatives**: Find better prices from nearby shops
- **Real-Time Processing**: Fast image processing with confidence scoring
- **Mobile-First**: Flutter app with camera integration and offline support
- **Scalable Backend**: Node.js with TypeScript, PostgreSQL, and Redis
- **Docker Ready**: Complete containerization for easy deployment

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Node.js API   │    │  CLOVA AI       │
│   (Mobile)      │◄──►│   (Backend)     │◄──►│  Service        │
│                 │    │                 │    │  (Python)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                        │
                              ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   PostgreSQL    │    │   Redis Cache   │
                       │   Database      │    │                 │
                       └─────────────────┘    └─────────────────┘
```

## 📋 Prerequisites

- **Docker & Docker Compose**
- **Node.js 18+**
- **Python 3.10+**
- **Flutter 3.10+** (optional, for mobile app)

## 🛠️ Quick Setup

### For macOS/Linux

#### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd clova-invoice-scanner

# Run the complete setup script
./setup.sh
```

#### 2. Start the System

```bash
# Start all services
./start_all.sh
```

### For Windows

#### 1. Clone and Setup

```cmd
# Clone the repository
git clone <repository-url>
cd clova-invoice-scanner

# Run the Windows setup script
start_windows.bat
```

#### 2. Start the System

```cmd
# Start all services with Windows-specific configuration
docker-compose -f docker-compose.yml -f docker-compose.windows.yml up --build -d
```

**📖 For detailed Windows setup instructions, see [WINDOWS_SETUP.md](WINDOWS_SETUP.md)**

### 3. Access Services

- **Backend API**: http://localhost:3000
- **API Documentation**: http://localhost:3000/docs
- **CLOVA Service**: http://localhost:8000
- **CLOVA Documentation**: http://localhost:8000/docs

### 4. Mobile App (Optional)

```bash
cd mobile
flutter run
```

## 🏛️ System Components

### Backend (Node.js + TypeScript)

**Location**: `backend/`

**Features**:

- RESTful API with Express.js
- TypeScript for type safety
- Prisma ORM with PostgreSQL
- JWT authentication
- Rate limiting and security
- Swagger documentation
- Redis caching
- File upload handling

**Key Endpoints**:

- `POST /api/scan` - Process invoice scan
- `GET /api/shops` - Get nearby shops
- `GET /api/products` - Search products
- `GET /api/analytics` - Get scan analytics

### CLOVA AI Service (Python + FastAPI)

**Location**: `clova-service/`

**Features**:

- FastAPI for high-performance API
- CLOVA Donut model for document understanding
- CRAFT model for text detection
- Image preprocessing and enhancement
- Confidence scoring and fallback processing
- Async processing with background tasks
- Comprehensive logging and metrics

**AI Models**:

- **Donut**: Document understanding and structured data extraction
- **CRAFT**: Text detection and OCR fallback
- **Image Enhancement**: Quality improvement for better recognition

### Mobile App (Flutter)

**Location**: `mobile/`

**Features**:

- Camera integration with real-time preview
- Image capture and compression
- Location services for nearby shop detection
- Offline support with local storage
- Beautiful Material Design UI
- BLoC state management
- Multi-language support

**Key Screens**:

- Camera scanner with overlay
- Results display with alternatives
- Shop map with directions
- Scan history and analytics
- Settings and preferences

## 🔧 Development

### Backend Development

```bash
cd backend
npm install
npm run dev
```

### CLOVA Service Development

```bash
cd clova-service
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Mobile App Development

```bash
cd mobile
flutter pub get
flutter run
```

## 📊 Database Schema

### Core Tables

- **shops**: Store information about shops and their locations
- **products**: Product catalog with prices and availability
- **scan_history**: Track all scan attempts and results
- **users**: User management and authentication
- **analytics**: Aggregated scan statistics

### Key Relationships

- Shops have many products
- Scan history links to users and scan results
- Products are matched to scanned items
- Analytics aggregate scan data over time

## 🤖 AI Processing Pipeline

### 1. Image Preprocessing

- Quality enhancement
- Noise reduction
- Contrast adjustment
- Resolution optimization

### 2. Primary Processing (Donut)

- Document structure understanding
- Item and price extraction
- Confidence scoring
- Structured data output

### 3. Fallback Processing (CRAFT)

- Text detection and extraction
- OCR processing
- Pattern matching
- Price and item parsing

### 4. Result Merging

- Combine Donut and CRAFT results
- Remove duplicates
- Confidence-based weighting
- Final structured output

## 🗺️ Location Services

### Shop Discovery

- Geospatial queries using PostGIS
- Radius-based search
- Premium shop filtering
- Distance calculation

### Product Matching

- Fuzzy string matching
- Category-based filtering
- Price range filtering
- Availability checking

## 📱 Mobile Features

### Camera Integration

- Real-time preview
- Auto-focus and exposure
- Flash control
- Image compression

### Location Services

- GPS positioning
- Permission handling
- Location accuracy optimization
- Offline location caching

### Offline Support

- Local scan history
- Cached shop data
- Offline image capture
- Sync when online

## 🔒 Security Features

### Authentication

- JWT token-based auth
- Refresh token rotation
- Secure password hashing
- Session management

### API Security

- Rate limiting
- CORS configuration
- Input validation
- SQL injection prevention

### Data Protection

- Encrypted data storage
- Secure file uploads
- Privacy-compliant logging
- GDPR considerations

## 📈 Analytics & Monitoring

### Scan Analytics

- Success/failure rates
- Processing time metrics
- Popular items tracking
- User engagement data

### System Monitoring

- Service health checks
- Performance metrics
- Error tracking
- Resource utilization

## 🚀 Deployment

### Docker Deployment

```bash
# Build and run with Docker Compose
docker-compose up -d

# Scale services
docker-compose up -d --scale backend=3 --scale clova-service=2
```

### Production Considerations

- Environment-specific configurations
- SSL/TLS certificates
- Load balancing
- Database clustering
- Monitoring and alerting
- Backup strategies

## 🧪 Testing

### Backend Testing

```bash
cd backend
npm test
npm run test:integration
npm run test:e2e
```

### CLOVA Service Testing

```bash
cd clova-service
pytest
pytest --cov=app
```

### Mobile App Testing

```bash
cd mobile
flutter test
flutter test integration_test
```

## 📚 API Documentation

### Backend API

Visit http://localhost:3000/docs for interactive API documentation.

### CLOVA Service API

Visit http://localhost:8000/docs for CLOVA service documentation.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **CLOVA AI Team** for the Donut and CRAFT models
- **Hugging Face** for the transformers library
- **FastAPI** for the excellent Python web framework
- **Flutter Team** for the amazing mobile framework

## 📞 Support

For support and questions:

- Create an issue on GitHub
- Check the documentation
- Review the troubleshooting guide

---

**Built with ❤️ using CLOVA AI technology**
