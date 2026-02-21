# Red Shopping API Documentation

Complete API documentation for Red Shopping microservices platform.

**Base URL**: `http://localhost:8000` (API Gateway)

---

## 📑 Table of Contents

1. [Authentication](#authentication)
2. [Products](#products)
3. [Orders](#orders)
4. [Users](#users)
5. [Error Handling](#error-handling)

---

## 🔐 Authentication

All authenticated endpoints require a JWT token in the `Authorization` header:
```
Authorization: Bearer <token>
```

### Register

**POST** `/api/auth/register`

Create a new user account.

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response** (201):
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "user123",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Errors**:
- 400: Validation error or email already exists

---

### Login

**POST** `/api/auth/login`

Authenticate user and get JWT token.

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response** (200):
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "user123",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Errors**:
- 401: Invalid email or password

---

### Verify Token

**GET** `/api/auth/verify`

Verify JWT token validity.

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200):
```json
{
  "success": true,
  "user": {
    "userId": "user123",
    "email": "john@example.com",
    "name": "John Doe"
  }
}
```

---

## 🛍️ Products

### Get All Products

**GET** `/api/products`

Get list of products with optional filters.

**Query Parameters**:
- `search` (string): Search by name or description
- `category` (string): Filter by category
- `minPrice` (number): Minimum price
- `maxPrice` (number): Maximum price
- `page` (number, default: 1): Page number
- `per_page` (number, default: 20): Items per page

**Example**:
```
GET /api/products?search=laptop&category=Electronics&minPrice=500&maxPrice=2000
```

**Response** (200):
```json
{
  "success": true,
  "products": [
    {
      "id": 1,
      "name": "Laptop Dell XPS 13",
      "description": "Powerful ultrabook with Intel i7, 16GB RAM, 512GB SSD",
      "price": 1299.99,
      "stock": 15,
      "category": "Electronics",
      "image": "https://example.com/image.jpg",
      "created_at": "2024-01-01T00:00:00",
      "updated_at": "2024-01-01T00:00:00"
    }
  ],
  "total": 50,
  "page": 1,
  "per_page": 20,
  "pages": 3
}
```

---

### Get Product by ID

**GET** `/api/products/:id`

Get single product details.

**Response** (200):
```json
{
  "success": true,
  "product": {
    "id": 1,
    "name": "Laptop Dell XPS 13",
    "description": "Powerful ultrabook",
    "price": 1299.99,
    "stock": 15,
    "category": "Electronics",
    "image": "https://example.com/image.jpg"
  }
}
```

**Errors**:
- 404: Product not found

---

### Create Product

**POST** `/api/products` 🔒 (Authentication required)

Create a new product.

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**:
```json
{
  "name": "New Product",
  "description": "Product description",
  "price": 99.99,
  "stock": 50,
  "category": "Electronics",
  "image": "https://example.com/image.jpg"
}
```

**Response** (201):
```json
{
  "success": true,
  "message": "Product created successfully",
  "product": {
    "id": 10,
    "name": "New Product",
    "price": 99.99,
    "stock": 50
  }
}
```

---

### Update Product

**PUT** `/api/products/:id` 🔒 (Authentication required)

Update existing product.

**Request Body**:
```json
{
  "name": "Updated Product Name",
  "price": 89.99,
  "stock": 30
}
```

**Response** (200):
```json
{
  "success": true,
  "message": "Product updated successfully",
  "product": { ... }
}
```

---

### Delete Product

**DELETE** `/api/products/:id` 🔒 (Authentication required)

Delete a product.

**Response** (200):
```json
{
  "success": true,
  "message": "Product deleted successfully"
}
```

---

## 📦 Orders

All order endpoints require authentication.

### Get User Orders

**GET** `/api/orders` 🔒

Get all orders for authenticated user.

**Headers**:
```
Authorization: Bearer <token>
```

**Query Parameters**:
- `page` (number, default: 1)
- `per_page` (number, default: 20)

**Response** (200):
```json
{
  "success": true,
  "orders": [
    {
      "id": 1,
      "user_id": "user123",
      "user_email": "john@example.com",
      "items": [
        {
          "product_id": 1,
          "product_name": "Laptop Dell XPS 13",
          "quantity": 1,
          "price": 1299.99,
          "subtotal": 1299.99
        }
      ],
      "total": 1299.99,
      "status": "pending",
      "created_at": "2024-01-01T10:00:00",
      "updated_at": "2024-01-01T10:00:00"
    }
  ],
  "total": 10,
  "page": 1,
  "pages": 1
}
```

---

### Get Order by ID

**GET** `/api/orders/:id` 🔒

Get single order details.

**Response** (200):
```json
{
  "success": true,
  "order": {
    "id": 1,
    "items": [...],
    "total": 1299.99,
    "status": "pending"
  }
}
```

---

### Create Order

**POST** `/api/orders` 🔒

Create a new order.

**Request Body**:
```json
{
  "items": [
    {
      "product_id": 1,
      "quantity": 2
    },
    {
      "product_id": 5,
      "quantity": 1
    }
  ]
}
```

**Response** (201):
```json
{
  "success": true,
  "message": "Order created successfully",
  "order": {
    "id": 15,
    "items": [
      {
        "product_id": 1,
        "product_name": "Laptop Dell XPS 13",
        "quantity": 2,
        "price": 1299.99,
        "subtotal": 2599.98
      }
    ],
    "total": 2599.98,
    "status": "pending"
  }
}
```

**Process**:
1. Validates products exist
2. Checks stock availability
3. Calculates total
4. Creates order in database
5. Publishes event to RabbitMQ
6. Notification service sends confirmation email

**Errors**:
- 400: Invalid items or insufficient stock
- 404: Product not found

---

### Cancel Order

**PATCH** `/api/orders/:id/cancel` 🔒

Cancel an order.

**Response** (200):
```json
{
  "success": true,
  "message": "Order cancelled successfully",
  "order": {
    "id": 15,
    "status": "cancelled"
  }
}
```

**Rules**:
- Can only cancel orders with status: `pending` or `confirmed`
- Cannot cancel `shipped`, `delivered`, or already `cancelled` orders

---

## 👤 Users

### Get Profile

**GET** `/api/users/profile` 🔒

Get authenticated user profile.

**Response** (200):
```json
{
  "success": true,
  "user": {
    "id": "user123",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "user",
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00"
  }
}
```

---

### Update Profile

**PUT** `/api/users/profile` 🔒

Update user profile.

**Request Body**:
```json
{
  "name": "Jane Doe",
  "email": "jane@example.com"
}
```

**Response** (200):
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": {
    "id": "user123",
    "name": "Jane Doe",
    "email": "jane@example.com"
  }
}
```

---

### Logout

**POST** `/api/users/logout` 🔒

Logout user (clears Redis session).

**Response** (200):
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## ❌ Error Handling

All errors follow this format:

```json
{
  "success": false,
  "message": "Error description"
}
```

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `401` - Unauthorized (missing or invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `429` - Too Many Requests (rate limit exceeded)
- `500` - Internal Server Error

### Rate Limits

- **General API**: 100 requests per 15 minutes
- **Authentication**: 5 attempts per 15 minutes
- **Search**: 30 requests per minute

When rate limited:
```json
{
  "success": false,
  "message": "Too many requests, please try again later."
}
```

---

## 🔗 Postman Collection

Import this collection to test all endpoints:

1. Create new collection in Postman
2. Add environment variable: `base_url` = `http://localhost:8000`
3. Add environment variable: `token` = (will be set after login)
4. Import endpoints from this documentation

### Quick Test Flow

1. **Register**: POST `/api/auth/register`
2. **Login**: POST `/api/auth/login` → Save token
3. **Get Products**: GET `/api/products`
4. **Create Order**: POST `/api/orders`
5. **Get Orders**: GET `/api/orders`

---

## 📊 Architecture Overview

```
Client → API Gateway (8000) → Microservices
                            ├─ Product Service (8001)
                            ├─ User Service (8002)
                            └─ Order Service (8003)
                                     ↓
                                 RabbitMQ
                                     ↓
                            Notification Service (8004)
```

---

## 🔧 Development URLs

- Frontend: http://localhost:3000
- API Gateway: http://localhost:8000
- Product Service: http://localhost:8001
- User Service: http://localhost:8002
- Order Service: http://localhost:8003
- Notification Service: http://localhost:8004
- RabbitMQ Management: http://localhost:15672 (guest/guest)

---

## 📝 Notes

- All timestamps are in ISO 8601 format (UTC)
- Prices are in USD with 2 decimal places
- JWT tokens expire after 24 hours (configurable)
- In development, notification emails are logged to console
