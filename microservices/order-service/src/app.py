from flask import Flask, jsonify
from flask_cors import CORS
from config import config
from utils.database import db, init_db
from routes.orders import orders_bp
import os

def create_app(config_name='default'):
    """Application factory"""
    app = Flask(__name__)
    
    # Load config
    config_name = os.getenv('FLASK_ENV', 'development')
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    CORS(app)
    
    # Initialize database
    init_db(app)
    
    # Register blueprints
    app.register_blueprint(orders_bp, url_prefix='/api/orders')
    
    # Health check
    @app.route('/health')
    def health():
        return jsonify({
            'status': 'healthy',
            'service': 'order-service'
        }), 200
    
    # Root endpoint
    @app.route('/')
    def index():
        return jsonify({
            'service': 'Order Service',
            'version': '1.0.0',
            'endpoints': {
                'health': '/health',
                'orders': '/api/orders'
            }
        }), 200
    
    return app

if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('PORT', 8003))
    app.run(host='0.0.0.0', port=port, debug=True)
