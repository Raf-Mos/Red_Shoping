import pika
import json
from flask import current_app

def publish_order_event(event_type, order_data):
    """Publish order event to RabbitMQ"""
    try:
        # Connection parameters
        credentials = pika.PlainCredentials(
            current_app.config['RABBITMQ_USER'],
            current_app.config['RABBITMQ_PASSWORD']
        )
        parameters = pika.ConnectionParameters(
            host=current_app.config['RABBITMQ_HOST'],
            port=current_app.config['RABBITMQ_PORT'],
            credentials=credentials
        )
        
        # Connect to RabbitMQ
        connection = pika.BlockingConnection(parameters)
        channel = connection.channel()
        
        # Declare queue
        queue_name = current_app.config['RABBITMQ_QUEUE']
        channel.queue_declare(queue=queue_name, durable=True)
        
        # Prepare message
        message = {
            'event_type': event_type,
            'order_id': order_data.get('order_id'),
            'user_email': order_data.get('user_email'),
            'total': order_data.get('total'),
            'items': order_data.get('items', [])
        }
        
        # Publish message
        channel.basic_publish(
            exchange='',
            routing_key=queue_name,
            body=json.dumps(message),
            properties=pika.BasicProperties(
                delivery_mode=2,  # Make message persistent
            )
        )
        
        print(f"✅ Published {event_type} event for order {order_data.get('order_id')}")
        
        # Close connection
        connection.close()
        
        return True
    except Exception as e:
        print(f"❌ Failed to publish event: {e}")
        return False
