from flask import Blueprint, request, jsonify, current_app
from models.order import Order
from utils.database import db
from utils.rabbitmq import publish_order_event
import json
import requests

orders_bp = Blueprint('orders', __name__)

@orders_bp.route('/', methods=['GET'])
def get_orders():
    """Get all orders for a user"""
    try:
        user_id = request.headers.get('X-User-Id')
        
        if not user_id:
            return jsonify({
                'success': False,
                'message': 'User ID not provided'
            }), 401
        
        # Get query parameters
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        # Query orders
        pagination = Order.query.filter_by(user_id=user_id)\
            .order_by(Order.created_at.desc())\
            .paginate(page=page, per_page=per_page, error_out=False)
        
        orders = [order.to_dict() for order in pagination.items]
        
        return jsonify({
            'success': True,
            'orders': orders,
            'total': pagination.total,
            'page': page,
            'per_page': per_page,
            'pages': pagination.pages
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500

@orders_bp.route('/<int:order_id>', methods=['GET'])
def get_order(order_id):
    """Get order by ID"""
    try:
        user_id = request.headers.get('X-User-Id')
        
        if not user_id:
            return jsonify({
                'success': False,
                'message': 'User ID not provided'
            }), 401
        
        order = Order.query.filter_by(id=order_id, user_id=user_id).first()
        
        if not order:
            return jsonify({
                'success': False,
                'message': 'Order not found'
            }), 404
        
        return jsonify({
            'success': True,
            'order': order.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500

@orders_bp.route('/', methods=['POST'])
def create_order():
    """Create new order"""
    try:
        user_id = request.headers.get('X-User-Id')
        user_email = request.headers.get('X-User-Email')
        
        if not user_id or not user_email:
            return jsonify({
                'success': False,
                'message': 'User information not provided'
            }), 401
        
        data = request.get_json()
        
        # Validate required fields
        if 'items' not in data or not data['items']:
            return jsonify({
                'success': False,
                'message': 'Order items are required'
            }), 400
        
        # Verify products and calculate total
        total = 0
        items = []
        product_service_url = current_app.config['PRODUCT_SERVICE_URL']
        
        for item in data['items']:
            product_id = item.get('product_id')
            quantity = item.get('quantity', 1)
            
            # Fetch product from Product Service
            try:
                response = requests.get(f"{product_service_url}/api/products/{product_id}")
                if response.status_code != 200:
                    return jsonify({
                        'success': False,
                        'message': f'Product {product_id} not found'
                    }), 404
                
                product = response.json().get('product')
                
                # Check stock
                if product['stock'] < quantity:
                    return jsonify({
                        'success': False,
                        'message': f'Insufficient stock for {product["name"]}'
                    }), 400
                
                # Calculate item total
                item_total = product['price'] * quantity
                total += item_total
                
                items.append({
                    'product_id': product_id,
                    'product_name': product['name'],
                    'quantity': quantity,
                    'price': product['price'],
                    'subtotal': item_total
                })
                
            except requests.RequestException as e:
                return jsonify({
                    'success': False,
                    'message': f'Failed to verify product {product_id}'
                }), 500
        
        # Create order
        order = Order(
            user_id=user_id,
            user_email=user_email,
            items=json.dumps(items),
            total=total,
            status='pending'
        )
        
        db.session.add(order)
        db.session.commit()
        
        # Publish order event to RabbitMQ
        publish_order_event('order_created', {
            'order_id': order.id,
            'user_email': user_email,
            'total': total,
            'items': items
        })
        
        return jsonify({
            'success': True,
            'message': 'Order created successfully',
            'order': order.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500

@orders_bp.route('/<int:order_id>/cancel', methods=['PATCH'])
def cancel_order(order_id):
    """Cancel order"""
    try:
        user_id = request.headers.get('X-User-Id')
        
        if not user_id:
            return jsonify({
                'success': False,
                'message': 'User ID not provided'
            }), 401
        
        order = Order.query.filter_by(id=order_id, user_id=user_id).first()
        
        if not order:
            return jsonify({
                'success': False,
                'message': 'Order not found'
            }), 404
        
        if order.status in ['shipped', 'delivered', 'cancelled']:
            return jsonify({
                'success': False,
                'message': f'Cannot cancel order with status: {order.status}'
            }), 400
        
        order.status = 'cancelled'
        db.session.commit()
        
        # Publish cancel event
        publish_order_event('order_cancelled', {
            'order_id': order.id,
            'user_email': order.user_email,
            'total': order.total
        })
        
        return jsonify({
            'success': True,
            'message': 'Order cancelled successfully',
            'order': order.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500

@orders_bp.route('/<int:order_id>/status', methods=['PATCH'])
def update_order_status(order_id):
    """Update order status (admin only)"""
    try:
        data = request.get_json()
        new_status = data.get('status')
        
        valid_statuses = ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled']
        if new_status not in valid_statuses:
            return jsonify({
                'success': False,
                'message': f'Invalid status. Must be one of: {", ".join(valid_statuses)}'
            }), 400
        
        order = Order.query.get(order_id)
        
        if not order:
            return jsonify({
                'success': False,
                'message': 'Order not found'
            }), 404
        
        order.status = new_status
        db.session.commit()
        
        # Publish status update event
        publish_order_event('order_status_updated', {
            'order_id': order.id,
            'user_email': order.user_email,
            'status': new_status,
            'total': order.total
        })
        
        return jsonify({
            'success': True,
            'message': 'Order status updated successfully',
            'order': order.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500
