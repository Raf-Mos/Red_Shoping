from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def init_db(app):
    """Initialize database"""
    db.init_app(app)
    
    with app.app_context():
        # Create tables
        db.create_all()
        
        # Seed initial data if empty
        from models.product import Product
        if Product.query.count() == 0:
            seed_products()

def seed_products():
    """Seed initial products for testing"""
    from models.product import Product
    
    sample_products = [
        {
            'name': 'Laptop Dell XPS 13',
            'description': 'Powerful ultrabook with Intel i7, 16GB RAM, 512GB SSD',
            'price': 1299.99,
            'stock': 15,
            'category': 'Electronics',
            'image': 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45'
        },
        {
            'name': 'iPhone 15 Pro',
            'description': 'Latest iPhone with A17 chip, 256GB storage, titanium design',
            'price': 999.99,
            'stock': 25,
            'category': 'Electronics',
            'image': 'https://images.unsplash.com/photo-1592286927505-c45f8723b5c3'
        },
        {
            'name': 'Sony WH-1000XM5 Headphones',
            'description': 'Premium noise-cancelling wireless headphones',
            'price': 399.99,
            'stock': 30,
            'category': 'Electronics',
            'image': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b'
        },
        {
            'name': 'Nike Air Max 270',
            'description': 'Comfortable running shoes with air cushioning',
            'price': 159.99,
            'stock': 50,
            'category': 'Fashion',
            'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'
        },
        {
            'name': 'Samsung 55" 4K Smart TV',
            'description': 'Crystal UHD 4K TV with smart features',
            'price': 699.99,
            'stock': 10,
            'category': 'Electronics',
            'image': 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1'
        },
        {
            'name': 'Canon EOS R6 Camera',
            'description': 'Professional mirrorless camera with 20MP sensor',
            'price': 2499.99,
            'stock': 8,
            'category': 'Electronics',
            'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32'
        },
        {
            'name': 'Adidas Ultraboost',
            'description': 'Premium running shoes with boost technology',
            'price': 179.99,
            'stock': 40,
            'category': 'Fashion',
            'image': 'https://images.unsplash.com/photo-1608231387042-66d1773070a5'
        },
        {
            'name': 'Apple Watch Series 9',
            'description': 'Advanced smartwatch with health tracking',
            'price': 429.99,
            'stock': 20,
            'category': 'Electronics',
            'image': 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d'
        },
    ]
    
    for product_data in sample_products:
        product = Product(**product_data)
        db.session.add(product)
    
    db.session.commit()
    print("✅ Seeded initial products")
