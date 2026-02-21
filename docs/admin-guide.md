# Red Shopping - Admin Dashboard

## 🔐 Admin Access

### Default Admin Credentials

```
Email: admin@redshoping.com
Password: admin123
```

⚠️ **Important**: Change the password after first login!

---

## 🎯 Admin Features

### Dashboard
- **Statistics Overview**: Total products, orders, revenue, users
- **Recent Orders**: View last 5 orders with status
- **Quick Actions**: Navigate to products, orders, analytics

### Product Management (`/admin/products`)
- ✅ View all products
- ✅ Create new products
- ✅ Edit existing products
- ✅ Delete products
- ✅ Search products by name
- ✅ Monitor stock levels

### Order Management (`/admin/orders`)
- ✅ View all orders
- ✅ Update order status (pending, confirmed, shipped, delivered, cancelled)
- ✅ View order details
- ✅ Search orders by ID or customer email
- ✅ Track order items and totals

---

## 🚀 Creating Admin User

### Method 1: Using the Script

```bash
# Enter the user-service container
docker exec -it red-shopping-user-service sh

# Run the create-admin script
node src/scripts/create-admin.js
```

### Method 2: Manual Creation via MongoDB

```javascript
// Connect to MongoDB
docker exec -it red-shopping-mongodb mongosh users_db

// Create admin user
db.users.insertOne({
  name: "Admin User",
  email: "admin@redshoping.com",
  password: "$2a$10$xyz...", // Hash of "admin123"
  role: "admin",
  isActive: true,
  createdAt: new Date(),
  updatedAt: new Date()
})
```

### Method 3: Register then Update Role

1. Register a normal user via `/register`
2. Update the role in MongoDB:

```javascript
db.users.updateOne(
  { email: "your@email.com" },
  { $set: { role: "admin" } }
)
```

---

## 📊 Admin Routes

| Route | Description |
|-------|-------------|
| `/admin` | Main dashboard with statistics |
| `/admin/products` | Product management interface |
| `/admin/orders` | Order management interface |

---

## 🛡️ Security Features

- ✅ Role-based access control
- ✅ Admin routes protected (check role in frontend)
- ✅ JWT authentication required
- ✅ Separate admin navigation link

---

## 🎨 Admin UI Features

### Dashboard Cards
- Product counter with icon
- Order counter with icon
- Revenue display with icon
- User counter (placeholder)

### Quick Actions
- Navigate to product management
- Navigate to order management
- Navigate to analytics (placeholder)

### Data Tables
- Sortable columns
- Search functionality
- Pagination support
- Status indicators with color coding

---

## 📝 Order Status Flow

```
pending → confirmed → shipped → delivered
         ↓
      cancelled
```

### Status Colors
- **Pending**: Yellow
- **Confirmed**: Blue
- **Shipped**: Purple
- **Delivered**: Green
- **Cancelled**: Gray

---

## 🔧 Development

### Testing Admin Features

1. **Login as admin**
   ```bash
   Email: admin@redshoping.com
   Password: admin123
   ```

2. **Access admin dashboard**
   - Navigate to `/admin`
   - Check statistics
   - Test quick actions

3. **Test product management**
   - Create a new product
   - Edit existing product
   - Delete a product
   - Search products

4. **Test order management**
   - View orders
   - Update order status
   - View order details

---

## 🚨 Troubleshooting

### "Access Denied" Error
- Make sure you're logged in with an admin account
- Check user role in localStorage: `localStorage.getItem('user')`
- Verify role is set to "admin"

### Admin Link Not Showing
- Logout and login again
- Clear browser cache
- Check if role is included in JWT token

### Cannot Update Products/Orders
- Verify authentication token is valid
- Check API endpoints are accessible
- Review browser console for errors

---

## 📚 API Endpoints

### Products
- `GET /api/products` - List all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product (auth required)
- `PUT /api/products/:id` - Update product (auth required)
- `DELETE /api/products/:id` - Delete product (auth required)

### Orders
- `GET /api/orders` - List all orders (auth required)
- `GET /api/orders/:id` - Get single order (auth required)
- `PATCH /api/orders/:id` - Update order status (auth required)

---

## 🎯 Future Enhancements

- [ ] Analytics dashboard with charts
- [ ] User management interface
- [ ] Bulk product import/export
- [ ] Order filtering by date range
- [ ] Email notifications for order updates
- [ ] Advanced reporting
- [ ] Role permissions configuration
- [ ] Activity logs
- [ ] Dashboard widgets customization
