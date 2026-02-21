# Product Service

Python/Flask microservice for product catalog management with PostgreSQL.

## Features

- ✅ **CRUD Operations** - Create, Read, Update, Delete products
- ✅ **Search & Filters** - Search by name/description, filter by category/price
- ✅ **Pagination** - Efficient data retrieval
- ✅ **Stock Management** - Track inventory levels
- ✅ **SQLAlchemy ORM** - Database abstraction
- ✅ **Auto-seeding** - Sample products for testing

## Environment Variables

```env
FLASK_ENV=development
PORT=8001
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/products_db
SECRET_KEY=your-secret-key
```

## API Endpoints

### Products
- `GET /api/products` - Get all products (with filters)
  - Query params: `search`, `category`, `minPrice`, `maxPrice`, `page`, `per_page`
- `GET /api/products/:id` - Get product by ID
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product
- `PATCH /api/products/:id/stock` - Update stock
- `GET /api/products/categories` - Get all categories

### Sample Product Object
```json
{
  "id": 1,
  "name": "Laptop Dell XPS 13",
  "description": "Powerful ultrabook",
  "price": 1299.99,
  "stock": 15,
  "category": "Electronics",
  "image": "https://example.com/image.jpg",
  "created_at": "2024-01-01T00:00:00",
  "updated_at": "2024-01-01T00:00:00"
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
docker build -t red-shopping-product-service .
docker run -p 8001:8001 red-shopping-product-service
```

## Database Schema

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price FLOAT NOT NULL,
    stock INTEGER DEFAULT 0,
    category VARCHAR(100),
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
