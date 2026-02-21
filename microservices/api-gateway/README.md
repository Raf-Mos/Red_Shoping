# API Gateway

Node.js/Express API Gateway for Red Shopping microservices platform.

## Features

- ✅ **Authentication** - JWT token generation and validation
- ✅ **Rate Limiting** - Redis-based rate limiting
- ✅ **Routing** - Proxy requests to microservices
- ✅ **Validation** - Request validation with express-validator
- ✅ **Security** - Helmet, CORS, input sanitization
- ✅ **Logging** - Winston for structured logging
- ✅ **Error Handling** - Centralized error handling

## Environment Variables

```env
NODE_ENV=development
PORT=8000
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRATION=24h
REDIS_HOST=localhost
REDIS_PORT=6379
PRODUCT_SERVICE_URL=http://localhost:8001
USER_SERVICE_URL=http://localhost:8002
ORDER_SERVICE_URL=http://localhost:8003
LOG_LEVEL=info
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/verify` - Verify JWT token

### Products
- `GET /api/products` - Get all products (with search/filters)
- `GET /api/products/:id` - Get product by ID
- `POST /api/products` - Create product (auth required)
- `PUT /api/products/:id` - Update product (auth required)
- `DELETE /api/products/:id` - Delete product (auth required)

### Orders
- `GET /api/orders` - Get user orders (auth required)
- `GET /api/orders/:id` - Get order by ID (auth required)
- `POST /api/orders` - Create order (auth required)
- `PATCH /api/orders/:id/cancel` - Cancel order (auth required)

## Rate Limits

- **API calls**: 100 requests per 15 minutes
- **Authentication**: 5 attempts per 15 minutes
- **Search**: 30 requests per minute

## Development

```bash
npm install
npm run dev
```

## Docker

```bash
docker build -t red-shopping-api-gateway .
docker run -p 8000:8000 red-shopping-api-gateway
```
