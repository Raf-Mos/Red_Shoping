# Order Service

Python/Flask microservice for order management with PostgreSQL and RabbitMQ.

## Features

- ✅ **Order Management** - Create, view, cancel orders
- ✅ **Product Verification** - Check stock before order creation
- ✅ **Order History** - View user's order history
- ✅ **Status Updates** - Track order lifecycle
- ✅ **Event Publishing** - RabbitMQ for async notifications
- ✅ **PostgreSQL** - Order data persistence

## Environment Variables

```env
FLASK_ENV=development
PORT=8003
DATABASE_URL=postgresql://postgres:postgres@localhost:5433/orders_db
SECRET_KEY=your-secret-key
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
RABBITMQ_QUEUE=notifications
PRODUCT_SERVICE_URL=http://localhost:8001
```

## API Endpoints

### Orders
- `GET /api/orders` - Get user orders (requires X-User-Id header)
  - Query params: `page`, `per_page`
- `GET /api/orders/:id` - Get order by ID (requires X-User-Id)
- `POST /api/orders` - Create order (requires X-User-Id, X-User-Email)
  ```json
  {
    "items": [
      {
        "product_id": 1,
        "quantity": 2
      }
    ]
  }
  ```
- `PATCH /api/orders/:id/cancel` - Cancel order (requires X-User-Id)
- `PATCH /api/orders/:id/status` - Update order status (admin)
  ```json
  {
    "status": "shipped"
  }
  ```

### Order Statuses
- `pending` - Order created, awaiting confirmation
- `confirmed` - Order confirmed
- `shipped` - Order shipped
- `delivered` - Order delivered
- `cancelled` - Order cancelled

### Sample Order Object
```json
{
  "id": 1,
  "user_id": "user123",
  "user_email": "user@example.com",
  "items": [
    {
      "product_id": 1,
      "product_name": "Laptop",
      "quantity": 1,
      "price": 1299.99,
      "subtotal": 1299.99
    }
  ],
  "total": 1299.99,
  "status": "pending",
  "created_at": "2024-01-01T00:00:00",
  "updated_at": "2024-01-01T00:00:00"
}
```

## RabbitMQ Events

The service publishes these events:
- `order_created` - New order created
- `order_cancelled` - Order cancelled by user
- `order_status_updated` - Order status changed

Event payload:
```json
{
  "event_type": "order_created",
  "order_id": 1,
  "user_email": "user@example.com",
  "total": 1299.99,
  "items": [...]
}
```

## Development

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run server
python src/app.py
```

## Docker

```bash
docker build -t red-shopping-order-service .
docker run -p 8003:8003 red-shopping-order-service
```

## Database Schema

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    user_email VARCHAR(200) NOT NULL,
    items TEXT NOT NULL,
    total FLOAT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
