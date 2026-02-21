from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def init_db(app):
    """Initialize database"""
    db.init_app(app)
    
    with app.app_context():
        # Create tables
        db.create_all()
        print("✅ Database initialized")
