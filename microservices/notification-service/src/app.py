from flask import Flask, jsonify
from flask_cors import CORS
from config import config
import os

def create_app(config_name='default'):
    """Application factory"""
    app = Flask(__name__)
    
    # Load config
    config_name = os.getenv('FLASK_ENV', 'development')
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    CORS(app)
    
    # Health check
    @app.route('/health')
    def health():
        return jsonify({
            'status': 'healthy',
            'service': 'notification-service'
        }), 200
    
    # Root endpoint
    @app.route('/')
    def index():
        return jsonify({
            'service': 'Notification Service',
            'version': '1.0.0',
            'description': 'Asynchronous notification service using RabbitMQ',
            'endpoints': {
                'health': '/health'
            }
        }), 200
    
    return app

if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('PORT', 8004))
    
    print("⚠️  Note: This is the web API. To start the consumer, run 'python src/consumer.py'")
    
    app.run(host='0.0.0.0', port=port, debug=True)
