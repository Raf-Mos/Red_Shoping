# User Service

Node.js/Express microservice for user management and authentication with MongoDB.

## Features

- ✅ **User Registration** - Create new user accounts
- ✅ **User Login** - Authenticate users
- ✅ **Profile Management** - View and update user profiles
- ✅ **Password Hashing** - Bcrypt for secure password storage
- ✅ **Session Management** - Redis for session storage
- ✅ **Input Validation** - Express-validator
- ✅ **MongoDB with Mongoose** - User data persistence

## Environment Variables

```env
NODE_ENV=development
PORT=8002
MONGO_URI=mongodb://localhost:27017/users_db
REDIS_HOST=localhost
REDIS_PORT=6379
```

## API Endpoints

### Authentication
- `POST /api/users/register` - Register new user
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `POST /api/users/login` - Login user
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `POST /api/users/logout` - Logout user (requires X-User-Id header)

### Profile Management
- `GET /api/users/profile` - Get user profile (requires X-User-Id header)
- `PUT /api/users/profile` - Update user profile (requires X-User-Id header)
  ```json
  {
    "name": "Jane Doe",
    "email": "jane@example.com"
  }
  ```

### Admin
- `GET /api/users` - Get all users (admin only)
  - Query params: `page`, `limit`

## User Model

```javascript
{
  name: String (required, 2-100 chars),
  email: String (required, unique, valid email),
  password: String (required, min 6 chars, hashed),
  role: String (enum: ['user', 'admin'], default: 'user'),
  isActive: Boolean (default: true),
  createdAt: Date,
  updatedAt: Date
}
```

## Development

```bash
npm install
npm run dev
```

## Docker

```bash
docker build -t red-shopping-user-service .
docker run -p 8002:8002 red-shopping-user-service
```

## Security Features

- Password hashing with bcrypt (10 salt rounds)
- Email validation and normalization
- Input sanitization
- Session management with Redis
- Password excluded from API responses
- Helmet for HTTP security headers
