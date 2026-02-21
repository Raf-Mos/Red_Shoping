import pika
import os

def get_rabbitmq_connection():
    """Create RabbitMQ connection"""
    try:
        credentials = pika.PlainCredentials(
            os.getenv('RABBITMQ_USER', 'guest'),
            os.getenv('RABBITMQ_PASSWORD', 'guest')
        )
        parameters = pika.ConnectionParameters(
            host=os.getenv('RABBITMQ_HOST', 'localhost'),
            port=int(os.getenv('RABBITMQ_PORT', 5672)),
            credentials=credentials,
            heartbeat=600,
            blocked_connection_timeout=300
        )
        
        connection = pika.BlockingConnection(parameters)
        return connection
    except Exception as e:
        print(f"❌ Failed to connect to RabbitMQ: {e}")
        raise

def declare_queue(channel, queue_name):
    """Declare queue"""
    channel.queue_declare(queue=queue_name, durable=True)
    print(f"✅ Queue '{queue_name}' declared")
