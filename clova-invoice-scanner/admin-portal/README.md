# CLOVA AI Invoice Scanner - Admin Portal

A modern web-based admin interface for managing shops, products, and system analytics for the CLOVA AI Invoice Scanner system.

## 🚀 Features

### **🔐 Authentication**

- Secure login with admin credentials
- JWT token-based session management
- Admin-only access protection

### **📊 Dashboard**

- Real-time system overview
- Key performance metrics
- Quick action buttons
- Success rates and processing statistics

### **🏪 Shop Management**

- **List View**: Search and filter shops by category
- **Add New Shop**: Complete form with all fields:
  - Name, address, coordinates (latitude/longitude)
  - Phone, rating, category selection
  - Premium status, image URL
  - Opening hours, description
- **Edit/Delete**: Full CRUD operations
- **Visual Indicators**: Premium badges, ratings, categories

### **📦 Product Management**

- **List View**: Search by name/brand/keywords, filter by category/shop
- **Add New Product**: Comprehensive form with:
  - Name, shop assignment, category, price
  - Brand, description, keywords array
  - Stock quantity, availability status
  - Barcode, weight, unit, image URL
- **Edit/Delete**: Full CRUD operations
- **Visual Features**: Product images, stock status, price display

### **🎨 Modern UI/UX**

- Responsive design (desktop, tablet, mobile)
- Clean, modern styling with Tailwind CSS
- Professional icon set (Heroicons)
- Form validation with error messages
- Toast notifications for feedback
- Loading states and skeleton screens

## 🛠️ Technical Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS
- **Forms**: React Hook Form with Zod validation
- **Icons**: Heroicons
- **HTTP Client**: Axios with interceptors
- **Notifications**: React Hot Toast
- **State Management**: React hooks

## 📋 Prerequisites

1. **Backend Server**: The CLOVA AI Invoice Scanner backend must be running
2. **Database**: PostgreSQL with seeded data
3. **Node.js**: Version 18 or higher
4. **Yarn**: Package manager

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd admin-portal
yarn install
```

### 2. Environment Configuration

Create `.env.local` file:

```env
NEXT_PUBLIC_API_URL=http://localhost:3001
```

### 3. Start Development Server

```bash
yarn dev
```

The admin portal will be available at: **http://localhost:3000**

### 4. Login

Use the admin credentials from the seeded data:

- **Email**: `admin@clova.com`
- **Password**: `admin123`

## 📱 Usage Guide

### **Dashboard**

- View system overview and statistics
- Access quick actions for common tasks
- Monitor performance metrics

### **Managing Shops**

1. Navigate to **Shops** in the sidebar
2. Use search and filters to find specific shops
3. Click **Add Shop** to create new entries
4. Use action buttons (view, edit, delete) for existing shops

### **Managing Products**

1. Navigate to **Products** in the sidebar
2. Search by name, brand, or keywords
3. Filter by category or shop
4. Click **Add Product** to create new entries
5. Assign products to specific shops
6. Manage inventory levels and pricing

### **Form Features**

- **Validation**: All forms include client-side validation
- **Auto-save**: Forms preserve data on navigation
- **Error Handling**: Clear error messages and feedback
- **Responsive**: Works on all device sizes

## 🔧 API Integration

The admin portal connects to the backend API endpoints:

- **Authentication**: `/auth/login`, `/auth/me`, `/auth/logout`
- **Shops**: `/shops` (GET, POST, PUT, DELETE)
- **Products**: `/products` (GET, POST, PUT, DELETE)
- **Analytics**: `/analytics/dashboard`

## 🎯 Key Features

### **Search & Filtering**

- Real-time search across multiple fields
- Category-based filtering
- Shop-based filtering for products
- Responsive filter UI

### **Data Management**

- Bulk operations support
- Confirmation dialogs for destructive actions
- Optimistic updates for better UX
- Error recovery and retry mechanisms

### **Security**

- Admin-only access
- JWT token management
- Automatic logout on token expiration
- Secure API communication

## 🐛 Troubleshooting

### **Common Issues**

1. **Server Not Starting**

   - Check if backend is running on port 3001
   - Verify database connection
   - Check environment variables

2. **Login Issues**

   - Ensure admin user exists in database
   - Check JWT secret configuration
   - Verify API endpoint accessibility

3. **Form Validation Errors**
   - Check required fields
   - Verify data types (numbers, URLs, etc.)
   - Ensure proper format for coordinates

### **Development Tips**

- Use browser dev tools to check network requests
- Monitor console for error messages
- Check API response format matches expected schema
- Verify CORS configuration on backend

## 📈 Future Enhancements

- **User Management**: Add/remove admin users
- **Advanced Analytics**: Detailed reporting and charts
- **Bulk Operations**: Import/export data
- **Real-time Updates**: WebSocket integration
- **Audit Logs**: Track all admin actions
- **Role-based Access**: Different permission levels

## 🤝 Contributing

1. Follow the existing code style
2. Add proper TypeScript types
3. Include form validation
4. Test on different screen sizes
5. Add error handling for all API calls

## 📄 License

This admin portal is part of the CLOVA AI Invoice Scanner system.
