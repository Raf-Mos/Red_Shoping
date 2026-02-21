from flask import Flask, jsonify
from flask_cors import CORS
from config import config
from utils.database import db, init_db
from routes.products import products_bp
import os

def create_app(config_name='default'):
    """Application factory"""
    app = Flask(__name__)
    
    # Load config
    config_name = os.getenv('FLASK_ENV', 'development')
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    CORS(app)
    
    # Initialize database and seed data
    init_db(app)
    
    # Register blueprints
    app.register_blueprint(products_bp, url_prefix='/api/products')
    
    # Health check
    @app.route('/health')
    def health():
        return jsonify({
            'status': 'healthy',
            'service': 'product-service'
        }), 200
    
    # Root endpoint
    @app.route('/')
    def index():
        return jsonify({
            'service': 'Product Service',
            'version': '1.0.0',
            'endpoints': {
                'health': '/health',
                'products': '/api/products'
            }
        }), 200
    
    return app

if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('PORT', 8001))
    app.run(host='0.0.0.0', port=port, debug=True)
